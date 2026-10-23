import SwiftUI

// MARK: - 自动演示：把整条 MVP 流程播一遍
// 右下角常驻一个播放控件；按下后 Aira 自己走完
// Onboarding → Recap → Collection → Report → Plan

struct DemoStep {
    var title: String
    var seconds: Double
    var run: (App) -> Void
}

@MainActor
final class Demo: ObservableObject {
    @Published var playing = false
    @Published var index = 0
    @Published var expanded = false
    private var task: Task<Void, Never>?

    static let steps: [DemoStep] = {
        #if LITE
        return liteSteps
        #else
        return fullSteps
        #endif
    }()

    /// Lite：只走核心闭环 Onboard → Home → Agent 推动采集 → 报告 → Plan
    static let liteSteps: [DemoStep] = [
        .init(title: "欢迎页", seconds: 3.0) { a in
            a.reset(); a.phase = .welcome
        },
        .init(title: "连接数据", seconds: 2.4) { a in
            a.phase = .connect; a.healthGranted = true
        },
        .init(title: "导入 30 天", seconds: 4.0) { a in
            a.beginSync()
        },
        .init(title: "第一份解读", seconds: 4.2) { a in
            a.phase = .recap
        },
        .init(title: "关于你", seconds: 2.6) { a in
            a.phase = .profile; a.nickname = "Chloe"
        },
        .init(title: "训练习惯", seconds: 2.4) { a in
            a.profStep = 1
        },
        .init(title: "首页 · 每日循环", seconds: 3.6) { a in
            a.phase = .main; a.tab = 0; a.sheet = nil
        },
        .init(title: "Aira 发起对话", seconds: 3.6) { a in
            a.tab = 1
        },
        .init(title: "为什么是唾液", seconds: 3.2) { a in
            a.sent = ["为什么是唾液？"]
        },
        .init(title: "安排采集", seconds: 2.6) { a in
            a.sent = ["为什么是唾液？", "安排在明天"]; a.schedule()
        },
        .init(title: "采集步骤", seconds: 3.4) { a in
            a.tab = 0; a.activePoint = 0; a.stepIndex = 1; a.sheet = .guidance
        },
        .init(title: "样本完成", seconds: 2.2) { a in
            a.sheet = nil
            for i in a.points.indices { a.points[i].done = true }
            a.saliva = .shipped
        },
        .init(title: "联合分析", seconds: 6.4) { a in
            a.deliverReport()
        },
        .init(title: "报告", seconds: 4.4) { a in
            a.analyzing = false; a.saliva = .reportReady; a.tab = 1; a.sheet = .report
        },
        .init(title: "计划", seconds: 4.0) { a in
            a.sheet = nil; a.tab = 2
        },
        .init(title: "接受首条建议", seconds: 3.0) { a in
            if let top = a.deck.first { a.setRec(top.id, .accepted) }
        }
    ]

    static let fullSteps: [DemoStep] = [
        .init(title: "欢迎页", seconds: 3.0) { a in
            a.reset(); a.phase = .welcome
        },
        .init(title: "连接数据", seconds: 2.4) { a in
            a.phase = .connect; a.healthGranted = true; a.devices = ["Oura Ring"]
        },
        .init(title: "导入 30 天", seconds: 4.0) { a in
            a.beginSync()
        },
        .init(title: "第一份解读", seconds: 4.2) { a in
            a.phase = .recap
        },
        .init(title: "关于你", seconds: 2.6) { a in
            a.phase = .profile; a.nickname = "Chloe"
        },
        .init(title: "健康背景", seconds: 2.6) { a in
            a.phase = .medical; a.meds = ["生物素（维生素 B7）"]
        },
        .init(title: "Notifications", seconds: 2.4) { a in
            a.phase = .notify
            withAnimation(.smooth) { a.notifyOn = [true, true, false]; a.notifyGranted = true }
        },
        .init(title: "Sampling preview", seconds: 3.0) { a in
            a.phase = .sampling
        },
        .init(title: "First check-in", seconds: 2.4) { a in
            a.phase = .firstLog
        },
        .init(title: "Home", seconds: 3.4) { a in
            a.phase = .main; a.tab = 0; a.loggedToday = true; a.sheet = nil
        },
        .init(title: "Sleep detail", seconds: 3.6) { a in
            a.sheet = .detail(.night)
        },
        .init(title: "Aira thread", seconds: 3.6) { a in
            a.sheet = nil; a.tab = 1
        },
        .init(title: "Ask about saliva", seconds: 3.2) { a in
            a.sent = ["为什么是唾液？"]
        },
        .init(title: "安排采集", seconds: 2.6) { a in
            a.sent = ["为什么是唾液？", "安排在明天"]; a.schedule()
        },
        .init(title: "采集步骤", seconds: 3.0) { a in
            a.tab = 0; a.activePoint = 0; a.stepIndex = 1; a.sheet = .guidance
        },
        .init(title: "样本完成", seconds: 2.2) { a in
            a.sheet = nil
            for i in a.points.indices { a.points[i].done = true }
            a.saliva = .shipped
        },
        .init(title: "联合分析", seconds: 6.4) { a in
            a.deliverReport()
        },
        .init(title: "报告", seconds: 4.4) { a in
            a.analyzing = false; a.saliva = .reportReady; a.tab = 1; a.sheet = .report
        },
        .init(title: "Plan · report stage", seconds: 4.0) { a in
            a.sheet = nil; a.tab = 2
        },
        .init(title: "Accept top action", seconds: 2.8) { a in
            if let top = a.deck.first { a.setRec(top.id, .accepted) }
        },
        .init(title: "Skip one", seconds: 2.4) { a in
            if let top = a.deck.first { a.setRec(top.id, .skipped) }
        },
        .init(title: "Arrange activity", seconds: 3.0) { a in
            a.sheet = .arrange(Lib.relax[0])
        },
        .init(title: "Plan in motion", seconds: 3.4) { a in
            a.sheet = nil
            a.arranged = [.init(activity: Lib.relax[0], time: "Before bed · 22:00", minutes: 10, done: 3)]
            if let i = a.reportRecs.firstIndex(where: { $0.state == .accepted }) { a.reportRecs[i].done = 3 }
        },
        // —— 主动信号场景（A2UI）——
        .init(title: "Signal · rough night", seconds: 4.4) { a in
            a.tab = 1; a.scenarioChoice = nil
            withAnimation(.smooth) { a.scenario = .roughNight }
        },
        .init(title: "…attributed: worked late", seconds: 3.6) { a in
            withAnimation(.smooth) { a.scenarioChoice = "Worked late" }
        },
        .init(title: "Signal · Friday pattern", seconds: 4.2) { a in
            a.scenarioChoice = nil
            withAnimation(.smooth) { a.scenario = .fridayPattern }
        },
        .init(title: "Signal · win streak", seconds: 3.8) { a in
            a.scenarioChoice = nil
            withAnimation(.smooth) { a.scenario = .winStreak }
        },
        .init(title: "Signal · live nudge", seconds: 4.2) { a in
            a.scenarioChoice = nil
            withAnimation(.smooth) { a.scenario = .liveNudge }
        },
        .init(title: "Back home", seconds: 3.0) { a in
            a.scenario = nil; a.tab = 0
        }
    ]

    func toggle(_ app: App) { playing ? stop() : start(app) }

    func start(_ app: App) {
        stop()
        playing = true
        task = Task { @MainActor in
            for (i, s) in Demo.steps.enumerated() {
                guard !Task.isCancelled else { return }
                index = i
                withAnimation(.smooth(duration: 0.5)) { s.run(app) }
                Haptic.soft()
                try? await Task.sleep(nanoseconds: UInt64(s.seconds * 1_000_000_000))
            }
            playing = false
        }
    }

    func stop() { task?.cancel(); task = nil; playing = false }

    func jump(_ i: Int, _ app: App) {
        stop(); index = i
        withAnimation(.smooth(duration: 0.4)) { Demo.steps[i].run(app) }
    }
}

// MARK: - 播放控件
// 右缘停靠的小把手：默认只占 30pt 宽，不压任何 CTA；点开才出完整面板。

struct DemoBar: View {
    @EnvironmentObject var app: App
    @EnvironmentObject var demo: Demo

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            if demo.expanded {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Button { Haptic.tap(); demo.toggle(app) } label: {
                            ZStack {
                                Circle().fill(T.lime)
                                if demo.playing {
                                    HStack(spacing: 3) {
                                        Capsule().fill(T.ink).frame(width: 3.5, height: 12)
                                        Capsule().fill(T.ink).frame(width: 3.5, height: 12)
                                    }
                                } else {
                                    Triangle().fill(T.ink).frame(width: 11, height: 12)
                                        .rotationEffect(.degrees(90)).offset(x: 1)
                                }
                            }
                            .frame(width: 36, height: 36)
                        }
                        .buttonStyle(PressStyle())
                        Text(demo.playing ? Demo.steps[min(demo.index, Demo.steps.count - 1)].title
                                          : "播放完整流程")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(1)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 10).padding(.top, 10)

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(Demo.steps.enumerated()), id: \.offset) { i, s in
                                    Button {
                                        Haptic.tap(); demo.jump(i, app)
                                    } label: {
                                        HStack(spacing: 9) {
                                            Circle()
                                                .fill(i == demo.index ? T.lime : .white.opacity(0.22))
                                                .frame(width: 5, height: 5)
                                            Text("\(i + 1). \(s.title)")
                                                .font(.system(size: 11.5,
                                                              weight: i == demo.index ? .semibold : .regular))
                                                .foregroundStyle(i == demo.index ? .white : .white.opacity(0.55))
                                            Spacer(minLength: 0)
                                        }
                                        .padding(.vertical, 7).padding(.horizontal, 12)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .id(i)
                                }
                            }
                            .padding(.bottom, 6)
                        }
                        .frame(height: 196)
                        .onAppear { proxy.scrollTo(demo.index, anchor: .center) }
                    }
                    // 场景直达：四种主动信号（Lite 不含）
                    #if !LITE
                    VStack(alignment: .leading, spacing: 0) {
                        Text("SIGNALS").font(.system(size: 8, weight: .bold)).tracking(1.4)
                            .foregroundStyle(.white.opacity(0.4))
                            .padding(.horizontal, 12).padding(.bottom, 4)
                        ForEach(Array([(SignalKind.roughNight, "Rough night alert"),
                                       (.fridayPattern, "Friday pattern"),
                                       (.winStreak, "Win streak"),
                                       (.liveNudge, "Live nudge 14:02"),
                                       (.sampleEve, "Sampling eve")].enumerated()), id: \.offset) { _, sc in
                            Button {
                                Haptic.tap(); demo.stop()
                                withAnimation(.smooth) {
                                    app.phase = .main; app.tab = 1
                                    app.scenarioChoice = nil; app.scenario = sc.0; app.sheet = nil
                                }
                            } label: {
                                HStack(spacing: 9) {
                                    Icon(.spark, size: 9, weight: 2.2, color: T.lime)
                                    Text(sc.1).font(.system(size: 11.5))
                                        .foregroundStyle(.white.opacity(0.75))
                                    Spacer(minLength: 0)
                                }
                                .padding(.vertical, 6).padding(.horizontal, 12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 8)
                    #endif
                }
                .frame(width: 198)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(hex: 0x16161A).opacity(0.96))
                )
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(.white.opacity(0.07), lineWidth: 1))
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            // 把手：常驻，但只有一枚小圆钮的高度
            Button {
                Haptic.tap()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.84)) { demo.expanded.toggle() }
            } label: {
                VStack(spacing: 7) {
                    ZStack {
                        Circle().fill(demo.playing ? T.lime : .white.opacity(0.16))
                        if demo.playing {
                            HStack(spacing: 2) {
                                Capsule().fill(T.ink).frame(width: 2.5, height: 9)
                                Capsule().fill(T.ink).frame(width: 2.5, height: 9)
                            }
                        } else {
                            Triangle().fill(demo.expanded ? T.ink : .white)
                                .frame(width: 8, height: 9)
                                .rotationEffect(.degrees(90)).offset(x: 1)
                        }
                    }
                    .frame(width: 26, height: 26)
                    Text("DEMO").font(.system(size: 7, weight: .bold)).tracking(1)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.vertical, 9).padding(.horizontal, 6)
                .background(
                    UnevenRoundedRectangle(topLeadingRadius: 14, bottomLeadingRadius: 14,
                                           bottomTrailingRadius: 0, topTrailingRadius: 0,
                                           style: .continuous)
                        .fill(Color(hex: 0x16161A).opacity(0.92))
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }
}
