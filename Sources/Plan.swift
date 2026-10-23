import SwiftUI

// MARK: - 活动库

struct Activity: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var sub: String
    var icon: Ico
    var tint: Color
    var kind: Int          // 0 运动型 1 休闲型
    var defaultMin: Int
}

enum Lib {
    static let tintLime  = Color(hex: 0xE9F4C6)
    static let tintBlue  = Color(hex: 0xDCE7F3)
    static let tintPink  = Color(hex: 0xF7DFE4)
    static let tintSand  = Color(hex: 0xF2EADA)
    static let tintMint  = Color(hex: 0xDCEFE5)
    static let tintLilac = Color(hex: 0xE8E3F4)

    static let workout: [Activity] = [
        .init(name: "快走",   sub: "低强度 · 最合适", icon: .walk,     tint: tintLime,  kind: 0, defaultMin: 20),
        .init(name: "跑步",   sub: "中高强度",       icon: .run,      tint: tintPink,  kind: 0, defaultMin: 30),
        .init(name: "骑行",   sub: "中等强度",         icon: .bike,     tint: tintBlue,  kind: 0, defaultMin: 40),
        .init(name: "力量",   sub: "高负荷",         icon: .strength, tint: tintSand,  kind: 0, defaultMin: 45),
        .init(name: "游泳",   sub: "全身 · 低冲击",  icon: .swim,     tint: tintMint,  kind: 0, defaultMin: 30),
        .init(name: "跳绳",   sub: "高强度 · 短时",  icon: .rope,     tint: tintLilac, kind: 0, defaultMin: 10)
    ]
    static let relax: [Activity] = [
        .init(name: "呼吸练习", sub: "睡前 · 最合适", icon: .meditate, tint: tintLime,  kind: 1, defaultMin: 10),
        .init(name: "拉伸",     sub: "久坐之后",       icon: .stretch,  tint: tintMint,  kind: 1, defaultMin: 8),
        .init(name: "散步",     sub: "下午",         icon: .walk,     tint: tintBlue,  kind: 1, defaultMin: 15),
        .init(name: "咖啡", sub: "14:00 之前",     icon: .coffee,   tint: tintSand,  kind: 1, defaultMin: 15),
        .init(name: "跳舞",     sub: "动起来就好",     icon: .dance,    tint: tintPink,  kind: 1, defaultMin: 15),
        .init(name: "阅读",     sub: "代替刷手机",   icon: .read,     tint: tintLilac, kind: 1, defaultMin: 20)
    ]
}

struct Arranged: Identifiable {
    let id = UUID()
    var activity: Activity
    var time: String
    var minutes: Int
    var done: Int = 0
}

// MARK: - Plan

struct PlanView: View {
    @EnvironmentObject var app: App
    @State private var arranging: Activity? = nil
    @State private var seg = 0

    private var hasReport: Bool { app.saliva == .reportReady }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(hasReport ? "唾液生物标志物 × 设备数据" : "来自最近 7 天的设备数据")
                            .font(.system(size: 12.5)).foregroundStyle(T.ink3)
                        Text("你的计划").font(.system(size: 23, weight: .semibold))
                    }
                    Spacer()
                    #if LITE
                    Avatar(size: 40)
                    #else
                    Button { Haptic.tap(); app.sheet = .settings } label: {
                        Avatar(size: 40).contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                    #endif
                }
                .padding(.top, 14)

                // 阶段感知：Aira 现在看得见哪些信号
                CoverageStrip()

                if hasReport { ReportTargetCard() } else { PendingTargetCard() }

                // 推荐卡堆：右滑收进计划，左滑跳过，点卡展开证据链
                HStack {
                    SectionLabel(text: hasReport ? "按影响力排序 · 来自报告"
                                                 : "今天适合你 · 来自设备数据")
                    Spacer()
                    if !app.deck.isEmpty {
                        Text("待处理 \(app.deck.count) 条")
                            .font(.system(size: 10.5, weight: .semibold)).monospacedDigit()
                            .foregroundStyle(T.ink3)
                    }
                }
                .padding(.top, 2)
                RecDeck()

                // 已接受：集中管理，有执行进度，左划移回卡堆
                if !app.acceptedRecs.isEmpty || !app.arranged.isEmpty {
                    SectionLabel(text: "已在计划中 · \(app.acceptedRecs.count + app.arranged.count) 项")
                        .padding(.top, 4)
                    ForEach(app.acceptedRecs) { rec in
                        AcceptedRecRow(rec: rec)
                    }
                    ForEach($app.arranged) { $a in
                        ArrangedRow(item: $a) { remove(a.id) }
                    }
                }

                SectionLabel(text: "自己安排").padding(.top, 4)
                HStack(spacing: 6) {
                    ForEach(Array(["训练", "放松"].enumerated()), id: \.offset) { i, s in
                        Button {
                            Haptic.tap()
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) { seg = i }
                        } label: {
                            HStack(spacing: 6) {
                                Icon(i == 0 ? .run : .meditate, size: 15, weight: 1.9,
                                     color: seg == i ? .white : T.ink2)
                                Text(s).font(.system(size: 13, weight: seg == i ? .semibold : .regular))
                            }
                            .padding(.horizontal, 15).padding(.vertical, 10)
                            .background(Capsule().fill(seg == i ? T.ink : .white))
                            .overlay(Capsule().strokeBorder(seg == i ? .clear : T.hair, lineWidth: 1))
                            .foregroundStyle(seg == i ? .white : T.ink2)
                        }
                        .buttonStyle(PressStyle())
                    }
                    Spacer()
                }

                if seg == 0 {
                    NoteStrip(text: "恢复负荷目前偏高。这周不要加强度 —— 两个低强度选项更合适。")
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 11) {
                        ForEach(seg == 0 ? Lib.workout : Lib.relax) { a in
                            ActivityTile(icon: a.icon, title: a.name, sub: a.sub, tint: a.tint,
                                         selected: app.arranged.contains { $0.activity.name == a.name }) {
                                arranging = a
                            }
                            .frame(width: 158)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 20)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                .padding(.horizontal, -20)

                if hasReport {
                    FogCard(tone: .flat) {
                        VStack(alignment: .leading, spacing: 11) {
                            Text("本轮不做").font(.system(size: 11, weight: .semibold))
                                .tracking(1.2).textCase(.uppercase).foregroundStyle(T.onD3)
                            ForEach(["补剂 —— 现有数据撑不起这个判断",
                                     "加大强度 —— 恢复负荷已经偏高",
                                     "咖啡因 —— 采样时未核实，下一轮再说"], id: \.self) { s in
                                HStack(alignment: .top, spacing: 8) {
                                    Icon(.minus, size: 11, weight: 2, color: T.onD3).padding(.top, 2)
                                    Text(s).font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3)
                                }
                            }
                        }
                    }
                    .padding(.top, 2)
                }

                Button { Haptic.tap(); app.sheet = .ask(AgentKB.plan) } label: {
                    HStack(spacing: 9) {
                        Icon(.ask, size: 15, weight: 2, color: T.ink)
                        Text("问问这份计划").font(.system(size: 14, weight: .medium))
                        Spacer()
                        Icon(.chevron, size: 12, weight: 2, color: T.ink3)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 15)
                    .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.white))
                    .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
                    .foregroundStyle(T.ink)
                }
                .buttonStyle(PressStyle())

                Color.clear.frame(height: 20)
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $arranging) { a in ArrangeSheet(activity: a) }
    }

    private func remove(_ id: UUID) {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            app.arranged.removeAll { $0.id == id }
        }
    }
}

// MARK: - 已接受的推荐行：进度 + 左划移回卡堆

struct AcceptedRecRow: View {
    @EnvironmentObject var app: App
    var rec: PlanRec
    @State private var dx: CGFloat = 0
    @State private var open = false

    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(T.coral.opacity(0.92))
                .overlay(alignment: .trailing) {
                    VStack(spacing: 3) {
                        Icon(.refresh, size: 14, weight: 2.2, color: .white)
                        Text("移回\n卡堆").font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(.white).multilineTextAlignment(.center)
                    }
                    .padding(.trailing, 18)
                }

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(rec.tagColor.opacity(0.3))
                        Icon(rec.saliva ? .drop : .spark, size: 18, weight: 2, color: T.ink)
                    }
                    .frame(width: 44, height: 44)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(rec.title).font(.system(size: 14.5, weight: .semibold)).tracking(-0.2)
                            .lineLimit(1).minimumScaleFactor(0.85)
                        Text(rec.constraint).font(.system(size: 11)).foregroundStyle(T.ink3)
                            .lineLimit(1).minimumScaleFactor(0.85)
                    }
                    Spacer(minLength: 6)
                    HStack(spacing: 3) {
                        ForEach(0..<7, id: \.self) { i in
                            Capsule().fill(i < rec.done ? T.ink : T.hair)
                                .frame(width: 4, height: 16)
                        }
                    }
                    Icon(.chevron, size: 10, weight: 2.2, color: T.ink3)
                        .rotationEffect(.degrees(open ? 90 : 0))
                }

                if open {
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle().fill(T.hair).frame(height: 1).padding(.top, 12)
                        HStack(alignment: .top, spacing: 8) {
                            Icon(.spark, size: 11, weight: 2, color: T.ink2).padding(.top, 2)
                            Text(rec.because).font(.system(size: 12)).foregroundStyle(T.ink2).lineSpacing(3)
                        }
                        .padding(.top, 4)
                        HStack(spacing: 7) {
                            Icon(.clock, size: 11, weight: 2, color: T.ink3)
                            Text(rec.timeline).font(.system(size: 11)).foregroundStyle(T.ink3)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(13)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
            .foregroundStyle(T.ink)
            .contentShape(Rectangle())
            .onTapGesture {
                Haptic.soft()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) { open.toggle() }
            }
            .offset(x: dx)
            .simultaneousGesture(DragGesture(minimumDistance: 16)
                .onChanged { g in
                    guard abs(g.translation.width) > abs(g.translation.height) else { return }
                    if g.translation.width < 0 { dx = max(-110, g.translation.width) }
                }
                .onEnded { g in
                    if g.translation.width < -80 && abs(g.translation.width) > abs(g.translation.height) {
                        app.setRec(rec.id, .pending); dx = 0
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { dx = 0 }
                    }
                })
        }
    }
}

struct NoteStrip: View {
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 9) {
            Icon(.spark, size: 13, weight: 2, color: T.ink)
            Text(text).font(.system(size: 12.5)).foregroundStyle(T.ink2).lineSpacing(3)
            Spacer(minLength: 0)
        }
        .padding(13)
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(T.lime.opacity(0.4)))
    }
}

// MARK: - 目标卡

struct ReportTargetCard: View {
    var body: some View {
        FogCard(tone: .cool) {
            VStack(alignment: .leading, spacing: 11) {
                CardHead(icon: .breath, title: "本轮目标", sub: "来自报告 · 第 01 章",
                         chip: "紧绷", chipTone: .warn)
                Text("从「晚上关不掉」这一端开始。")
                    .font(.system(size: 17, weight: .semibold)).tracking(-0.4)
                Text("这一端更容易撬动 —— 固定起床时间会把入睡点往前拉，早晨那端通常随之好转。反过来几乎不成立。")
                    .font(.system(size: 13)).foregroundStyle(T.onD2).lineSpacing(4)
            }
        }
    }
}

struct PendingTargetCard: View {
    @EnvironmentObject var app: App
    var body: some View {
        FogCard(tone: .flat) {
            VStack(alignment: .leading, spacing: 12) {
                CardHead(icon: .clock, title: "完整计划等唾液结果",
                         sub: "有几件事无论如何都值得做", chip: "检测进行中", chipTone: .off)
                Text("唾液结果回来之前，我分不清早晨和夜晚哪一端更要紧 —— 而两者的干预完全不同。下面这些建议只依赖你已有的设备数据。")
                    .font(.system(size: 13)).foregroundStyle(T.onD2).lineSpacing(4)
                Button { Haptic.tap(); app.sheet = .testing } label: {
                    HStack(spacing: 7) {
                        Text("安排采集").font(.system(size: 12, weight: .semibold)).tracking(0.6)
                        Icon(.arrowRight, size: 12, weight: 2, color: T.lime)
                    }
                    .foregroundStyle(T.lime)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Arrange一个 activity

struct ArrangeSheet: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    var activity: Activity
    @State private var minutes: Int = 20
    @State private var slot: Int = 1

    private let slots = ["早晨 · 07:00", "下午 · 13:30", "傍晚 · 18:00", "睡前 · 22:00"]

    var body: some View {
        ZStack {
            PageBG()
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("安排").font(.system(size: 18, weight: .semibold))
                    Spacer()
                    Button { dismiss() } label: {
                        Icon(.close, size: 13, weight: 2, color: T.ink2)
                            .frame(width: 32, height: 32).background(Circle().fill(T.hair2))
                    }
                }
                .padding(.top, 16)

                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(activity.tint)
                        Icon(activity.icon, size: 40, weight: 1.6, color: T.ink.opacity(0.8))
                    }
                    .frame(width: 92, height: 92)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(activity.name).font(.system(size: 22, weight: .semibold)).tracking(-0.6)
                        Text(activity.sub).font(.system(size: 12.5)).foregroundStyle(T.ink3)
                    }
                    Spacer()
                }
                .padding(.top, 20)

                SectionLabel(text: "时长（分钟）").padding(.top, 24)
                HStack(spacing: 8) {
                    ForEach([10, 15, 20, 30, 45], id: \.self) { m in
                        Button {
                            Haptic.tap()
                            withAnimation(.spring(response: 0.26, dampingFraction: 0.86)) { minutes = m }
                        } label: {
                            Text("\(m)")
                                .font(.system(size: 14, weight: minutes == m ? .semibold : .regular))
                                .frame(maxWidth: .infinity).padding(.vertical, 13)
                                .background(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(minutes == m ? T.ink : .white))
                                .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(minutes == m ? .clear : T.hair, lineWidth: 1))
                                .foregroundStyle(minutes == m ? .white : T.ink2)
                        }
                        .buttonStyle(PressStyle())
                    }
                }
                .padding(.top, 10)

                SectionLabel(text: "时间段").padding(.top, 20)
                VStack(spacing: 8) {
                    ForEach(Array(slots.enumerated()), id: \.offset) { i, s in
                        Button {
                            Haptic.tap()
                            withAnimation(.spring(response: 0.26, dampingFraction: 0.86)) { slot = i }
                        } label: {
                            HStack(spacing: 8) {
                                Text(s).font(.system(size: 14.5, weight: slot == i ? .semibold : .regular))
                                if i == recommended {
                                    Text("Aira 建议").font(.system(size: 10, weight: .semibold))
                                        .padding(.horizontal, 7).padding(.vertical, 3)
                                        .background(Capsule().fill(T.lime)).foregroundStyle(T.ink)
                                }
                                Spacer()
                                if slot == i { Icon(.check, size: 15, weight: 2.2, color: T.ink) }
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(slot == i ? T.lime.opacity(0.4) : .white))
                            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .strokeBorder(slot == i ? T.ink.opacity(0.85) : T.hair, lineWidth: 1))
                            .foregroundStyle(T.ink)
                        }
                        .buttonStyle(PressStyle())
                    }
                }
                .padding(.top, 10)

                NoteStrip(text: reason).padding(.top, 16)

                Spacer()
                CTA(title: "加入计划") {
                    app.arranged.append(.init(activity: activity, time: slots[slot], minutes: minutes))
                    dismiss()
                }
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 20)
        }
        .onAppear { minutes = activity.defaultMin; slot = recommended }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private var recommended: Int {
        if activity.icon == .meditate || activity.icon == .read { return 3 }
        if activity.icon == .coffee || activity.kind == 1 { return 1 }
        return 2
    }
    private var reason: String {
        switch recommended {
        case 3: "睡前 —— 你的问题是晚上关不掉，这个时段收益最大。"
        case 1: "下午 —— 你 13:10–15:50 的久坐时段，正好压在精力低谷上。"
        default: "傍晚 —— 距睡前至少 3 小时，入睡点才不会被推后。"
        }
    }
}

// MARK: - 已Arrange的一项（左划移除）

struct ArrangedRow: View {
    @Binding var item: Arranged
    var onRemove: () -> Void
    @State private var dx: CGFloat = 0

    var body: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(T.coral.opacity(0.92))
                .overlay(alignment: .trailing) {
                    Icon(.close, size: 15, weight: 2.2, color: .white).padding(.trailing, 26)
                }
            HStack(spacing: 13) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous).fill(item.activity.tint)
                    Icon(item.activity.icon, size: 24, weight: 1.7, color: T.ink.opacity(0.8))
                }
                .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.activity.name).font(.system(size: 15, weight: .semibold)).tracking(-0.2)
                    Text("\(item.time) · \(item.minutes) 分钟")
                        .font(.system(size: 11.5)).foregroundStyle(T.ink3)
                }
                Spacer()
                HStack(spacing: 3) {
                    ForEach(0..<7, id: \.self) { i in
                        Capsule().fill(i < item.done ? T.ink : T.hair)
                            .frame(width: 4, height: 16)
                    }
                }
            }
            .padding(13)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
            .foregroundStyle(T.ink)
            .offset(x: dx)
            .simultaneousGesture(DragGesture(minimumDistance: 16)
                .onChanged { g in
                    guard abs(g.translation.width) > abs(g.translation.height) else { return }
                    if g.translation.width < 0 { dx = max(-110, g.translation.width) }
                }
                .onEnded { g in
                    if g.translation.width < -80 && abs(g.translation.width) > abs(g.translation.height) {
                        Haptic.soft(); onRemove()
                    } else { withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { dx = 0 } }
                })
        }
    }
}

// MARK: - 推荐卡

struct SuggestionCard: View {
    @Binding var s: Suggestion
    var body: some View {
        FogCard(tone: s.state == 1 ? .warm : .flat) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(s.title).font(.system(size: 15.5, weight: .semibold)).tracking(-0.3)
                        Text(s.meta).font(.system(size: 11)).foregroundStyle(T.onD3)
                    }
                    Spacer(minLength: 4)
                    if s.state == 1 { Chip(text: "Added", tone: .good) }
                }
                HStack(alignment: .top, spacing: 8) {
                    Icon(.spark, size: 12, weight: 2, color: T.lime).padding(.top, 2)
                    Text(s.because).font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3)
                }
                .padding(.top, 11)
                if s.state == 0 {
                    HStack(spacing: 8) {
                        Button {
                            Haptic.ok()
                            withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { s.state = 1 }
                        } label: {
                            Text("Add to plan").font(.system(size: 12.5, weight: .semibold))
                                .padding(.horizontal, 16).padding(.vertical, 9)
                                .background(Capsule().fill(T.lime)).foregroundStyle(T.ink)
                        }
                        .buttonStyle(PressStyle())
                        Button {
                            Haptic.tap()
                            withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { s.state = 2 }
                        } label: {
                            Text("Not now").font(.system(size: 12.5, weight: .medium))
                                .padding(.horizontal, 16).padding(.vertical, 9)
                                .background(Capsule().fill(.white.opacity(0.1)))
                                .overlay(Capsule().strokeBorder(.white.opacity(0.09), lineWidth: 1))
                                .foregroundStyle(T.onD2)
                        }
                        .buttonStyle(PressStyle())
                        Spacer()
                    }
                    .padding(.top, 14)
                } else {
                    Button { Haptic.tap(); withAnimation(.smooth) { s.state = 0 } } label: {
                        Text("Undo").font(.system(size: 11.5, weight: .medium)).foregroundStyle(T.onD3)
                    }
                    .buttonStyle(.plain).padding(.top, 12)
                }
            }
        }
    }
}

// MARK: - 建议卡（C8 / C9 同一个组件的两种状态）

struct AdviceCard: View {
    @Binding var advice: Advice
    @State private var feelIdx: Int? = nil

    var body: some View {
        FogCard(tone: advice.adopted ? .warm : .flat) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 1) {
                        Text(String(format: "%.1f", advice.impact)).numeral(19)
                            .foregroundStyle(advice.tagColor)
                        Text("IMPACT").font(.system(size: 8, weight: .bold)).tracking(1.1)
                            .foregroundStyle(T.onD3)
                    }
                    .frame(width: 46)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(advice.tag).font(.system(size: 9, weight: .bold)).tracking(1)
                            .textCase(.uppercase)
                            .padding(.horizontal, 7).padding(.vertical, 3)
                            .background(Capsule().fill(advice.tagColor)).foregroundStyle(T.ink)
                        Text(advice.title).font(.system(size: 14.5, weight: .semibold)).tracking(-0.2)
                        Text(advice.constraint).font(.system(size: 11.5)).foregroundStyle(T.onD3)
                    }
                    Spacer(minLength: 0)
                }
                if advice.adopted {
                    VStack(alignment: .leading, spacing: 0) {
                        Rectangle().fill(T.hairD).frame(height: 1).padding(.vertical, 14)
                        Comb(count: 7, filled: Double(advice.done) / 7, height: 22, ghostFrom: advice.done + 1)
                        HStack {
                            Text("Logged \(advice.done) days").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                            Spacer()
                            Text("Not logged today").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        }
                        .padding(.top, 7)
                        Text("How it felt").font(.system(size: 11)).foregroundStyle(T.onD3).padding(.top, 14)
                        HStack(spacing: 6) {
                            ForEach(Array(["No change", "Slightly better", "Clearly better"].enumerated()), id: \.offset) { i, s in
                                Button {
                                    Haptic.tap()
                                    withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) { feelIdx = i }
                                } label: { Chip(text: s, tone: feelIdx == i ? .good : .off) }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 7)
                        Text(feelIdx == 0 ? "No change in the first 3 days is expected. \(advice.timeline)。" : advice.timeline)
                            .font(.system(size: 11.5)).foregroundStyle(T.onD2).lineSpacing(3).padding(.top, 11)
                    }
                } else {
                    HStack(spacing: 9) {
                        Text(advice.timeline).font(.system(size: 11)).foregroundStyle(T.onD3)
                        Spacer()
                        Button {
                            Haptic.ok()
                            withAnimation(.spring(response: 0.36, dampingFraction: 0.84)) {
                                advice.adopted = true; advice.done = 3
                            }
                        } label: {
                            Text("Adopt").font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 15).padding(.vertical, 8)
                                .background(Capsule().fill(T.lime)).foregroundStyle(T.ink)
                        }
                        .buttonStyle(PressStyle())
                    }
                    .padding(.top, 14)
                }
            }
        }
    }
}
