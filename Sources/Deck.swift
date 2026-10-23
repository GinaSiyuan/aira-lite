import SwiftUI

// MARK: - 推荐卡堆（ReactBits "Stack" 的 SwiftUI 版）
// 顶卡可拖：右滑接受、左滑跳过；下面两张缩小错位垫底。
// 点卡片展开证据链（渐进披露），底部 ✕ / ✓ 按钮给不爱滑的人留路径。

struct RecDeck: View {
    @EnvironmentObject var app: App
    @State private var dx: CGFloat = 0
    @State private var expanded = false
    @State private var hinting = false

    private var deck: [PlanRec] { app.deck }

    var body: some View {
        VStack(spacing: 0) {
            if deck.isEmpty {
                emptyState
            } else {
                ZStack {
                    // 垫底的牌：错位 + 微旋转，露出多个棱角
                    ForEach(Array(deck.prefix(3).enumerated().reversed()), id: \.element.id) { i, rec in
                        if i == 0 {
                            RecCard(rec: rec, expanded: $expanded)
                                .offset(x: dx)
                                .rotationEffect(.degrees(Double(dx) / 24), anchor: .bottom)
                                .overlay(swipeHints)
                                .onTapGesture { hint() }
                                .gesture(drag(rec))
                                .zIndex(3)
                        } else {
                            RecCard(rec: rec, expanded: .constant(false))
                                .rotationEffect(.degrees(i == 1 ? 2.4 : -2.0), anchor: .bottom)
                                .offset(x: i == 1 ? 7 : -8, y: CGFloat(i) * 9)
                                .opacity(1 - Double(i) * 0.16)
                                .allowsHitTesting(false)
                                .zIndex(Double(3 - i))
                        }
                    }
                }
                .padding(.top, 6)
                .padding(.bottom, CGFloat(min(deck.count - 1, 2)) * 10 + 4)

                // 只留进度点；操作全靠 swipe
                HStack(spacing: 4) {
                    ForEach(Array(stage.enumerated()), id: \.offset) { _, r in
                        Capsule()
                            .fill(r.state == .accepted ? T.lime :
                                  r.state == .skipped ? T.ink3.opacity(0.4) : T.hair)
                            .frame(width: r.state == .pending ? 18 : 10, height: 4)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
            }
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.82), value: deck.count)
    }

    /// 点卡片 → 晃一下并亮出两侧语义，教会 swipe
    private func hint() {
        guard !hinting else { return }
        Haptic.soft()
        hinting = true
        Task { @MainActor in
            withAnimation(.spring(response: 0.26, dampingFraction: 0.6)) { dx = 30 }
            try? await Task.sleep(nanoseconds: 240_000_000)
            withAnimation(.spring(response: 0.26, dampingFraction: 0.6)) { dx = -26 }
            try? await Task.sleep(nanoseconds: 240_000_000)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.72)) { dx = 0 }
            try? await Task.sleep(nanoseconds: 700_000_000)
            withAnimation(.smooth(duration: 0.3)) { hinting = false }
        }
    }

    private var swipeHints: some View {
        HStack {
            HStack(spacing: 5) {
                Icon(.chevron, size: 10, weight: 2.4, color: .white.opacity(0.9))
                    .rotationEffect(.degrees(180))
                Text("跳过").font(.system(size: 11, weight: .bold))
            }
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(Capsule().fill(.black.opacity(0.45)))
            .foregroundStyle(.white)
            .opacity(hinting || dx < -24 ? 1 : 0)
            Spacer()
            HStack(spacing: 5) {
                Text("收进计划").font(.system(size: 11, weight: .bold))
                Icon(.chevron, size: 10, weight: 2.4, color: T.ink)
            }
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(Capsule().fill(T.lime))
            .foregroundStyle(T.ink)
            .opacity(hinting || dx > 24 ? 1 : 0)
        }
        .padding(.horizontal, 12)
        .animation(.smooth(duration: 0.2), value: hinting)
        .animation(.smooth(duration: 0.15), value: dx)
        .allowsHitTesting(false)
    }

    private var stage: [PlanRec] { app.saliva == .reportReady ? app.reportRecs : app.deviceRecs }

    private var emptyState: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().fill(T.lime.opacity(0.5)).frame(width: 44, height: 44)
                Icon(.check, size: 18, weight: 2.4, color: T.ink)
            }
            Text("全部处理完").font(.system(size: 14.5, weight: .semibold))
            Text("\(app.acceptedRecs.count) 条已进计划\(app.skippedCount > 0 ? " · \(app.skippedCount) 条已跳过" : "")")
                .font(.system(size: 11.5)).foregroundStyle(T.ink3)
            if app.skippedCount > 0 {
                Button { app.restoreSkipped() } label: {
                    Text("回看跳过的").font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Capsule().fill(.white))
                        .overlay(Capsule().strokeBorder(T.hair, lineWidth: 1))
                        .foregroundStyle(T.ink)
                        .contentShape(Capsule())
                }
                .buttonStyle(PressStyle())
                .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(T.hair, lineWidth: 1))
    }

    private func drag(_ rec: PlanRec) -> some Gesture {
        DragGesture(minimumDistance: 18)
            .onChanged { g in
                guard abs(g.translation.width) > abs(g.translation.height) * 1.1 else { return }
                dx = g.translation.width
            }
            .onEnded { g in
                let horizontal = abs(g.translation.width) > abs(g.translation.height) * 1.1
                if horizontal && g.translation.width > 96 { fly(1, rec) }
                else if horizontal && g.translation.width < -96 { fly(-1, rec) }
                else { withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) { dx = 0 } }
            }
    }

    private func fly(_ dir: CGFloat, _ rec: PlanRec) {
        withAnimation(.easeOut(duration: 0.26)) { dx = dir * 480 }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 240_000_000)
            app.setRec(rec.id, dir > 0 ? .accepted : .skipped)
            dx = 0; expanded = false
        }
    }
}

// MARK: - 单张推荐卡：默认只给结论，点开才展开证据链（渐进披露）

struct RecCard: View {
    var rec: PlanRec
    @Binding var expanded: Bool

    var body: some View {
        FogCard(tone: rec.saliva ? .cool : .flat, radius: 22, padding: 18) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 10) {
                    if let imp = rec.impact {
                        VStack(spacing: 1) {
                            Text(String(format: "%.1f", imp)).numeral(20).foregroundStyle(rec.tagColor)
                            Text("影响力").font(.system(size: 7.5, weight: .bold)).tracking(1)
                                .foregroundStyle(T.onD3)
                        }
                        .frame(width: 44)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text(rec.tag).font(.system(size: 9, weight: .bold)).tracking(1)
                                .textCase(.uppercase)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(Capsule().fill(rec.tagColor)).foregroundStyle(T.ink)
                            if rec.saliva {
                                HStack(spacing: 3) {
                                    Icon(.drop, size: 9, weight: 2.2, color: T.lime)
                                    Text("生物标志物").font(.system(size: 8, weight: .bold)).tracking(0.8)
                                        .foregroundStyle(T.lime)
                                }
                            }
                        }
                        Text(rec.title).font(.system(size: 17, weight: .semibold)).tracking(-0.4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 0)
                }

                HStack(alignment: .top, spacing: 8) {
                    Icon(.spark, size: 12, weight: 2, color: T.lime).padding(.top, 2)
                    Text(rec.because).font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(expanded ? nil : 2)
                }
                .padding(.top, 12)

                if expanded {
                    VStack(alignment: .leading, spacing: 10) {
                        Rectangle().fill(T.hairD).frame(height: 1)
                        Text("依据").font(.system(size: 8.5, weight: .bold)).tracking(1.4)
                            .foregroundStyle(T.onD3)
                        FlowWrap(rec.evidence) { e in
                            HStack(spacing: 4) {
                                Circle().fill(T.lime).frame(width: 4, height: 4)
                                Text(e).font(.system(size: 10.5, weight: .medium))
                            }
                            .padding(.horizontal, 9).padding(.vertical, 5)
                            .background(Capsule().fill(.white.opacity(0.09)))
                            .overlay(Capsule().strokeBorder(.white.opacity(0.1), lineWidth: 1))
                            .foregroundStyle(.white.opacity(0.85))
                        }
                        HStack(spacing: 7) {
                            Icon(.clock, size: 11, weight: 2, color: T.onD3)
                            Text(rec.timeline).font(.system(size: 11)).foregroundStyle(T.onD2)
                        }
                    }
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                HStack {
                    Text(rec.constraint).font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        .lineLimit(1).minimumScaleFactor(0.85)
                    Spacer()
                    Button {
                        Haptic.soft()
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { expanded.toggle() }
                    } label: {
                        HStack(spacing: 4) {
                            Text(expanded ? "收起" : "为什么").font(.system(size: 10.5, weight: .semibold))
                            Icon(.chevron, size: 8, weight: 2.4, color: T.lime)
                                .rotationEffect(.degrees(expanded ? -90 : 90))
                        }
                        .foregroundStyle(T.lime)
                        .padding(.vertical, 4).padding(.leading, 10)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 9)
            }
        }
        .contentShape(Rectangle())
    }
}

// MARK: - 数据覆盖条："Aira 现在看得见什么"
// 让用户感知：维度在增加，理解在变完整。唾液两项在报告前是锁着的。

struct CoverageStrip: View {
    @EnvironmentObject var app: App

    private var hasSaliva: Bool { app.saliva == .reportReady }
    private var dims: [(String, Bool)] {
        [("睡眠", true), ("HRV", true), ("静息心率", true), ("活动", true),
         ("皮质醇", hasSaliva), ("DHEA", hasSaliva)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("AIRA 现在看得见").font(.system(size: 9, weight: .bold)).tracking(1.4)
                    .foregroundStyle(T.ink3)
                Spacer()
                Text("\(dims.filter(\.1).count) / 6 个信号")
                    .font(.system(size: 10.5, weight: .semibold)).monospacedDigit()
                    .foregroundStyle(hasSaliva ? T.ink : T.ink2)
            }
            HStack(spacing: 5) {
                ForEach(Array(dims.enumerated()), id: \.offset) { _, d in
                    HStack(spacing: 4) {
                        if d.1 {
                            Circle().fill(T.lime).frame(width: 5, height: 5)
                        } else {
                            Icon(.lock, size: 8, weight: 2.2, color: T.ink3)
                        }
                        Text(d.0).font(.system(size: 9.5, weight: d.1 ? .semibold : .regular))
                            .foregroundStyle(d.1 ? T.ink : T.ink3)
                            .lineLimit(1).minimumScaleFactor(0.7)
                    }
                    .padding(.horizontal, 7).padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(d.1 ? Color.white : T.hair2))
                    .overlay(Capsule().strokeBorder(d.1 ? T.hair : .clear, lineWidth: 1))
                }
            }
            Text(hasSaliva
                 ? "唾液结果 10/21 已返回 —— 下面的建议已带上生物标志物证据。"
                 : "目前只基于设备数据。唾液会补上两个激素信号 —— 以及更锋利的建议。")
                .font(.system(size: 10.5)).foregroundStyle(T.ink3).lineSpacing(2.5)
        }
        .padding(13)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(T.hair2.opacity(0.7)))
    }
}

// MARK: - ShinyText（ReactBits）：一道高光从字面扫过

struct ShinyText: View {
    var text: String
    var size: CGFloat = 13
    var weight: Font.Weight = .medium
    var base: Color = .white.opacity(0.55)

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let x = (t * 0.55).truncatingRemainder(dividingBy: 1.6) - 0.3
            Text(text)
                .font(.system(size: size, weight: weight))
                .foregroundStyle(base)
                .overlay(
                    GeometryReader { g in
                        LinearGradient(colors: [.clear, .white.opacity(0.95), .clear],
                                       startPoint: .leading, endPoint: .trailing)
                            .frame(width: g.size.width * 0.5)
                            .offset(x: g.size.width * x)
                    }
                    .mask(Text(text).font(.system(size: size, weight: weight)))
                )
        }
    }
}

// MARK: - CountUp（ReactBits）：数字滚动进场

struct CountUpText: View {
    var value: Int
    var size: CGFloat
    var duration: Double = 0.9
    @State private var shown = 0

    var body: some View {
        Text("\(shown)").numeral(size)
            .contentTransition(.numericText(value: Double(shown)))
            .onAppear {
                shown = max(0, value - 12)
                var step = 0
                Timer.scheduledTimer(withTimeInterval: duration / 12, repeats: true) { timer in
                    step += 1
                    Task { @MainActor in
                        withAnimation(.smooth(duration: duration / 10)) {
                            shown = min(value, max(0, value - 12) + step)
                        }
                    }
                    if step >= 12 { timer.invalidate() }
                }
            }
    }
}
