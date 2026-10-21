import SwiftUI

// MARK: - Home

struct HomeView: View {
    @EnvironmentObject var app: App
    private var day: Mock.Day { Mock.days[app.dayIndex] }
    private var isToday: Bool { app.dayIndex == Mock.days.count - 1 }
    private var hasData: Bool { day.sleep != "—" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                // 高优先级问询：独立组件，置顶，可划走（Lite 不含主动信号）
                #if !LITE
                if app.probe.answered == nil && app.probeVisible {
                    ProbeBanner(probe: $app.probe, visible: $app.probeVisible)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)))
                }
                #endif

                TodayPreviewCard()

                if hasData {
                    NightCard(day: day, onOpen: { app.sheet = .detail(.night) })
                    if isToday { DayCard(onOpen: { app.sheet = .detail(.load) }) }
                } else {
                    MissingDayCard(day: day)
                }

                SalivaStatusCard()

                Color.clear.frame(height: 24)
            }
            .padding(.horizontal, 20)
            .animation(.spring(response: 0.38, dampingFraction: 0.86), value: app.probeVisible)
        }

    }
}

// MARK: - 卡片右上角的展开键（不把整张卡包成 Button，避免嵌套按钮互相吞手势）

struct OpenBtn: View {
    var action: () -> Void
    var body: some View {
        Button { Haptic.tap(); action() } label: {
            Icon(.chevron, size: 12, weight: 2.2, color: .white.opacity(0.65))
                .frame(width: 28, height: 28)
                .background(Circle().fill(.white.opacity(0.1)))
                .contentShape(Circle())
        }
        .buttonStyle(PressStyle())
    }
}

// MARK: - Today预览卡：问候 + 头像 + 可擦洗的 7d轨迹（兼做日期选择）

struct TodayPreviewCard: View {
    @EnvironmentObject var app: App
    private var day: Mock.Day { Mock.days[app.dayIndex] }
    private var band: (String, Color) {
        switch day.recovery {
        case ..<45: ("Well recovered", T.lime)
        case ..<58: ("Mild buildup", .white)
        default:    ("Load is high", T.coral)
        }
    }

    var body: some View {
        // 签名结构：白色软壳 → 里面嵌深色雾面卡
        Shell(radius: 32, padding: 16) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tue, Oct 14").font(.system(size: 12.5)).foregroundStyle(T.ink3)
                        Text("Good morning, \(app.nickname.isEmpty ? "Chloe" : app.nickname)").font(.system(size: 21, weight: .semibold)).tracking(-0.6)
                            .foregroundStyle(T.ink)
                    }
                    Spacer(minLength: 12)
                    #if LITE
                    Avatar(size: 48)
                    #else
                    Button { Haptic.tap(); app.sheet = .settings } label: {
                        Avatar(size: 48).contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                    .accessibilityIdentifier("settings-avatar")
                    #endif
                }
                .padding(.horizontal, 4)

                // 内嵌深色雾面卡：今天的主指标
                FogCard(radius: 24, padding: 18) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .top) {
                                HStack(spacing: 10) {
                                    IBadge(icon: .recover)
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Recovery load").font(.system(size: 16, weight: .medium))
                                        Text("Recent · 7-day window").font(.system(size: 10)).foregroundStyle(T.onD3)
                                    }
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 1) {
                                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                                        Text("47").font(.system(size: 19, weight: .semibold)).monospacedDigit()
                                        Text("/ baseline").font(.system(size: 11)).foregroundStyle(T.onD2)
                                    }
                                    Text("prev 28 days").font(.system(size: 10)).foregroundStyle(T.onD3)
                                }
                            }

                            HStack(alignment: .firstTextBaseline, spacing: 5) {
                                CountUpText(value: day.recovery, size: 42).id(day.recovery)
                                Text("/ 100").font(.system(size: 15)).foregroundStyle(T.onD2)
                                Spacer()
                                Text(band.0).font(.system(size: 12.5, weight: .semibold))
                                    .foregroundStyle(band.1)
                            }
                            .padding(.top, 10)

                            HStack {
                                Text("0").font(.system(size: 11)).foregroundStyle(T.onD3)
                                Spacer()
                                Text("100").font(.system(size: 11)).foregroundStyle(T.onD3)
                            }
                            .padding(.top, 8)

                            Comb(count: 34, filled: Double(day.recovery) / 100, height: 30)
                                .padding(.top, 6)

                            // 近 7 天均值（不是单日）：主卡讲"近期"，单日往下看
                            HStack(alignment: .top, spacing: 8) {
                                heroStat(Mock.avgSleepText(7), "", "Sleep · 7-day avg")
                                heroStat("\(Int(Mock.avg(7) { Double($0.hrv) }.rounded()))", "ms", "HRV · 7-day avg")
                                heroStat("\(Int(Mock.avg(7) { Double($0.rhr) }.rounded()))", "bpm", "RHR · 7-day avg")
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.top, 16)
                    .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .onTapGesture { Haptic.tap(); app.sheet = .detail(.recovery) }
                    .overlay(alignment: .topTrailing) {
                        OpenBtn { app.sheet = .detail(.recovery) }.padding(14).padding(.top, 16)
                    }

                // 白壳区：时间窗 + 轨迹
                HStack(spacing: 5) {
                    ForEach(Mock.Range.allCases, id: \.rawValue) { r in
                        Button {
                            Haptic.tap()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) {
                                app.range = r; app.dayIndex = Mock.days.count - 1
                            }
                        } label: {
                            Text(r.title)
                                .font(.system(size: 12, weight: app.range == r ? .semibold : .regular))
                                .padding(.horizontal, 13).padding(.vertical, 7)
                                .background(Capsule().fill(app.range == r ? T.ink : T.hair2))
                                .foregroundStyle(app.range == r ? .white : T.ink2)
                        }
                        .buttonStyle(PressStyle())
                    }
                    Spacer()
                    Text(app.range.grain).font(.system(size: 10.5)).foregroundStyle(T.ink3)
                }
                .padding(.top, 18).padding(.horizontal, 4)

                SleepScrubber().padding(.top, 8)

                // 自测轨：笑脸—苦脸的平滑曲线，点任何一天的脸都能回看
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("How you've felt").font(.system(size: 13.5, weight: .semibold))
                                .foregroundStyle(T.ink)
                            Text(app.loggedToday ? "Logged \(faceNames[app.feelBand]) today"
                                                 : "No check-in yet today")
                                .font(.system(size: 10.5)).foregroundStyle(T.ink3)
                        }
                        Spacer()
                        Button { Haptic.tap(); app.sheet = .checkIn } label: {
                            HStack(spacing: 6) {
                                Icon(app.loggedToday ? .refresh : .plus, size: 12, weight: 2.2, color: .white)
                                Text(app.loggedToday ? "Edit" : "Check in")
                                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Capsule().fill(T.ink))
                            .contentShape(Capsule())
                        }
                        .buttonStyle(PressStyle())
                    }
                    .padding(.horizontal, 4)

                    SelfTrend(light: true, selected: $app.selfSelected)
                }
                .padding(.top, 14)
            }
        }
    }

    @ViewBuilder
    private func heroStat(_ v: String, _ unit: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(v).font(.system(size: 24, weight: .semibold)).tracking(-0.8).monospacedDigit()
                if !unit.isEmpty { Text(unit).font(.system(size: 12)).foregroundStyle(T.onD2) }
            }
            Text(label).font(.system(size: 11.5)).foregroundStyle(T.onD3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Avatar: View {
    var size: CGFloat = 44
    var body: some View {
        ZStack {
            if let p = Bundle.main.path(forResource: "avatar", ofType: "jpg"),
               let img = UIImage(contentsOfFile: p) {
                Image(uiImage: img).resizable().scaledToFill()
            } else {
                LinearGradient(colors: [Color(hex: 0xE4E4E1), Color(hex: 0xC9C9C4)],
                               startPoint: .top, endPoint: .bottom)
                Icon(.user, size: size * 0.5, weight: 1.6, color: .white.opacity(0.95))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(Circle().strokeBorder(.white.opacity(0.9), lineWidth: 2))
        .shadow(color: .black.opacity(0.25), radius: 8, y: 3)
    }
}

struct MiniTile: View {
    var icon: Ico
    var label: String
    var value: String
    var unit: String? = nil
    /// 原始差值（负 = 低于基准）
    var delta: Int
    var unitSuffix: String
    var baseline: String
    /// low是不是坏事
    var lowerIsBad: Bool

    private var bad: Bool { lowerIsBad ? delta < 0 : delta > 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(label).font(.system(size: 11.5)).foregroundStyle(T.onD3)
                Spacer()
                Icon(icon, size: 15, weight: 1.7, color: T.onD3)
            }
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value).font(.system(size: 23, weight: .semibold)).tracking(-0.7).monospacedDigit()
                if let u = unit { Text(u).font(.system(size: 11)).foregroundStyle(T.onD3) }
            }
            .padding(.top, 8)
            HStack(spacing: 5) {
                Icon(delta < 0 ? .arrowUp : .arrowUp, size: 9, weight: 2.4,
                     color: bad ? T.coral : T.lime)
                    .rotationEffect(.degrees(delta < 0 ? 180 : 0))
                Text("\(abs(delta)) \(unitSuffix)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(bad ? T.coral : T.lime)
            }
            .padding(.top, 6)
            Text(baseline).font(.system(size: 9.5)).foregroundStyle(T.onD3.opacity(0.9))
                .lineLimit(1).minimumScaleFactor(0.8).padding(.top, 4)
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(.white.opacity(0.07)))
        .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous)
            .strokeBorder(.white.opacity(0.06), lineWidth: 1))
        .foregroundStyle(.white)
    }
}

// MARK: - Sleep轨迹擦洗器（y 轴有刻度，读数写清楚是什么）

struct SleepScrubber: View {
    @EnvironmentObject var app: App

    private var window: [Int] {
        let n = min(app.range.days, Mock.days.count)
        return Array((Mock.days.count - n)..<Mock.days.count)
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h: CGFloat = 132
            let idx = window
            let vals = idx.map { Mock.days[$0].sleep == "—" ? 0 : Mock.hm(Mock.days[$0].sleep) }
            let pl: CGFloat = 26, pr: CGFloat = 14
            let top: CGFloat = 36, bot: CGFloat = 26
            let X: (Int) -> CGFloat = { i in pl + (w - pl - pr) * CGFloat(i) / CGFloat(max(1, vals.count - 1)) }
            let lo = 4.5, hi = 9.5
            let Y: (Double) -> CGFloat = { v in top + (h - top - bot) * CGFloat(1 - (v - lo) / (hi - lo)) }
            let sel = max(0, idx.firstIndex(of: app.dayIndex) ?? vals.count - 1)
            let d = Mock.days[idx[sel]]

            ZStack(alignment: .topLeading) {
                Canvas { ctx, _ in
                    // y 轴刻度
                    for g in [5.0, 7.0, 9.0] {
                        var p = Path()
                        p.move(to: .init(x: pl, y: Y(g))); p.addLine(to: .init(x: w - pr, y: Y(g)))
                        ctx.stroke(p, with: .color(T.hair), lineWidth: 1)
                        ctx.draw(Text("\(Int(g))h").font(.system(size: 9)).foregroundStyle(T.ink3),
                                 at: .init(x: 12, y: Y(g)))
                    }
                    // baseline
                    var bl = Path()
                    bl.move(to: .init(x: pl, y: Y(Mock.sleepBase))); bl.addLine(to: .init(x: w - pr, y: Y(Mock.sleepBase)))
                    ctx.stroke(bl, with: .color(T.ink3),
                               style: .init(lineWidth: 1, dash: [3, 3]))
                    // 曲线
                    var p = Path(); var started = false
                    for (i, v) in vals.enumerated() where v > 0 {
                        let pt = CGPoint(x: X(i), y: Y(v))
                        if !started { p.move(to: pt); started = true }
                        else {
                            let cx = (X(i - 1) + X(i)) / 2
                            p.addCurve(to: pt, control1: .init(x: cx, y: p.currentPoint?.y ?? pt.y),
                                       control2: .init(x: cx, y: pt.y))
                        }
                    }
                    ctx.stroke(p, with: .color(T.ink), lineWidth: 2)
                    for (i, v) in vals.enumerated() {
                        if v == 0 {
                            var c = Path()
                            c.addEllipse(in: .init(x: X(i) - 3, y: Y(6.8) - 3, width: 6, height: 6))
                            ctx.stroke(c, with: .color(T.ink3),
                                       style: .init(lineWidth: 1, dash: [1.5, 1.5]))
                        }
                    }
                }
                .frame(height: h)

                // 游标
                Rectangle().fill(T.ink.opacity(0.18)).frame(width: 1, height: h - top - bot + 8)
                    .position(x: X(sel), y: top + (h - top - bot) / 2)
                Circle().fill(.white).frame(width: 13, height: 13)
                    .overlay(Circle().strokeBorder(T.ink, lineWidth: 2))
                    .shadow(color: .black.opacity(0.14), radius: 5)
                    .position(x: X(sel), y: Y(max(lo + 0.1, vals[sel] > 0 ? vals[sel] : 6.8)))

                // 读数：说清楚是什么
                VStack(alignment: .leading, spacing: 2) {
                    Text(d.sleep == "—" ? "No data this day" : "Sleep \(d.sleep)")
                        .font(.system(size: 14, weight: .semibold)).tracking(-0.2).foregroundStyle(T.ink)
                    Text(d.sleep == "—" ? "\(d.weekday) \(d.date)"
                         : "\(d.weekday) \(d.date) · Asleep \(d.onset) · Woke \(d.wakeups) ×")
                        .font(.system(size: 10.5)).foregroundStyle(T.ink3)
                }
                .frame(width: w - pl, alignment: .leading)
                .padding(.leading, pl)

                HStack(spacing: 0) {
                    ForEach(Array(idx.enumerated()), id: \.offset) { i, di in
                        if app.range == .d7 || i % 2 == 0 {
                            Text(String(Mock.days[di].date.suffix(2)))
                                .font(.system(size: 9, weight: i == sel ? .semibold : .regular))
                                .foregroundStyle(i == sel ? T.ink : T.ink3)
                                .frame(maxWidth: .infinity)
                        } else {
                            Color.clear.frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, pl - 10)
                .position(x: w / 2, y: h - 10)
            }
            .contentShape(Rectangle())
            // 点一下选那天
            .gesture(SpatialTapGesture().onEnded { g in
                let i = Int(((g.location.x - pl) / (w - pl - pr) * CGFloat(vals.count - 1)).rounded())
                let c = idx[max(0, min(vals.count - 1, i))]
                if c != app.dayIndex { Haptic.soft(); app.dayIndex = c }
            })
            // 横向主导才接管擦洗；竖直动作让给外层 ScrollView
            .simultaneousGesture(DragGesture(minimumDistance: 14).onChanged { g in
                guard abs(g.translation.width) > abs(g.translation.height) * 1.2 else { return }
                let i = Int(((g.location.x - pl) / (w - pl - pr) * CGFloat(vals.count - 1)).rounded())
                let c = idx[max(0, min(vals.count - 1, i))]
                if c != app.dayIndex { Haptic.soft(); app.dayIndex = c }
            })
        }
        .frame(height: 132)
    }
}

// MARK: - 高优先级问询（独立组件 · 置顶 · 可划走）

struct ProbeBanner: View {
    @Binding var probe: AgentProbe
    @Binding var visible: Bool
    @State private var dx: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(T.ink)
                    Icon(.spark, size: 13, weight: 2, color: T.lime)
                }
                .frame(width: 26, height: 26)
                Text("Aira wants to check something").font(.system(size: 12.5, weight: .semibold))
                Spacer()
                Button {
                    Haptic.tap(); withAnimation { visible = false }
                } label: {
                    Icon(.close, size: 12, weight: 2, color: T.ink3)
                        .frame(width: 26, height: 26)
                }
                .buttonStyle(.plain)
            }
            Text(probe.question)
                .font(.system(size: 15, weight: .medium)).lineSpacing(3)
                .padding(.top, 9)
            HStack(spacing: 7) {
                ForEach(probe.options, id: \.self) { o in
                    Button {
                        Haptic.ok()
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                            probe.answered = o; probe.resolved = AgentProbeCard.resolve(o)
                        }
                    } label: {
                        Text(o).font(.system(size: 12.5, weight: .semibold))
                            .padding(.horizontal, 13).padding(.vertical, 9)
                            .background(Capsule().fill(o == probe.options.first ? T.lime : .white))
                            .overlay(Capsule().strokeBorder(o == probe.options.first ? .clear : T.hair, lineWidth: 1))
                            .foregroundStyle(T.ink)
                    }
                    .buttonStyle(PressStyle())
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 12)
            Text("← Swipe left to dismiss")
                .font(.system(size: 10)).foregroundStyle(T.ink3).padding(.top, 10)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous).fill(.white)
                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(T.lime, lineWidth: 1.6))
                .shadow(color: .black.opacity(0.08), radius: 16, y: 6)
        )
        .foregroundStyle(T.ink)
        .offset(x: dx)
        .opacity(1 - Double(min(abs(dx) / 220, 0.9)))
        .simultaneousGesture(DragGesture(minimumDistance: 16)
            .onChanged { g in
                guard abs(g.translation.width) > abs(g.translation.height) else { return }
                if g.translation.width < 0 { dx = g.translation.width }
            }
            .onEnded { g in
                if g.translation.width < -90 && abs(g.translation.width) > abs(g.translation.height) {
                    Haptic.soft(); withAnimation { visible = false }
                } else { withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { dx = 0 } }
            })
    }
}

// MARK: - 缺失日

struct MissingDayCard: View {
    var day: Mock.Day
    var body: some View {
        FogCard(tone: .flat) {
            VStack(alignment: .leading, spacing: 13) {
                CardHead(icon: .info, title: "No data this day",
                         sub: "\(day.date) · \(day.weekday)", chip: "Excluded", chipTone: .off)
                Text("The watch wasn't worn, or didn't sync.").font(.system(size: 14))
                Text("Excluded from the 7-day average — so the \"7-day mean\" is based on 6 days.")
                    .font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3.5)
            }
        }
    }
}

// MARK: - 唾液状态卡（统一进整套色彩语言，不再画风突变）

struct SalivaStatusCard: View {
    @EnvironmentObject var app: App
    var body: some View {
        Button { Haptic.tap(); app.sheet = .testing } label: {
            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 10) {
                        IBadge(icon: .drop)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(title).font(.system(size: 13, weight: .semibold))
                            Text("First saliva test").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        }
                        Spacer(minLength: 6)
                        if app.saliva == .collecting {
                            Chip(text: "\(app.points.filter { $0.done }.count)/5", tone: .good)
                        }
                        Icon(.chevron, size: 13, weight: 2, color: T.onD3)
                    }
                    Text(sub).font(.system(size: 13)).foregroundStyle(T.onD2)
                        .lineSpacing(3).padding(.top, 11)
                    if app.saliva == .collecting || app.saliva == .shipped {
                        Comb(count: 5, filled: Double(app.points.filter { $0.done }.count) / 5, height: 18)
                            .padding(.top, 12)
                    }
                }
            }
        }
        .buttonStyle(PressStyle())
    }
    private var title: String {
        switch app.saliva {
        case .notScheduled: "Saliva · not scheduled"
        case .scheduled:    "Saliva · starts tomorrow"
        case .collecting:   "Saliva · in progress"
        case .shipped:      "Shipped · at the lab"
        case .reportReady:  "Saliva report ready"
        }
    }
    private var sub: String {
        switch app.saliva {
        case .notScheduled: "We still can't say why recovery load is up. Salivary cortisol separates an HPA-axis problem from plain sleep debt."
        case .scheduled:    "First tube within 30 min of waking. Stop biotin supplements starting tonight."
        case .collecting:   "Next tube \(app.points.first(where: { !$0.done })?.when ?? "") · \(app.points.first(where: { !$0.done })?.name ?? "")"
        case .shipped:      "Results usually take 5–7 business days, then we read them against these weeks of sleep."
        case .reportReady:  "HPA axis: Strained. Can't get going in the morning, can't switch off at night."
        }
    }
}

// MARK: - 复合卡：Recovery load

struct RecoveryCard: View {
    @EnvironmentObject var app: App
    var day: Mock.Day = Mock.days[Mock.days.count - 2]   // 默认昨日

    private var level: Double { Double(day.recovery) / 100 }
    private var band: (String, ChipTone) {
        switch day.recovery {
        case ..<45:  ("Well recovered", .good)
        case ..<58:  ("Mild buildup", .off)
        default:     ("Load is high", .warn)
        }
    }

    var body: some View {
        FogCard {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 9) {
                    IBadge(icon: .recover)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Recovery load").font(.system(size: 13, weight: .semibold))
                        Text("\(app.range.title) window · vs \(app.range.baselineLabel)")
                            .font(.system(size: 10.5)).foregroundStyle(T.onD3)
                    }
                    Spacer(minLength: 24)
                }

                // 主分数：强调数字本身，量纲降级到下一行
                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    Text("\(day.recovery)").numeral(46)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("out of 100").font(.system(size: 11)).foregroundStyle(T.onD3)
                        Text(band.0).font(.system(size: 12.5, weight: .semibold))
                            .foregroundStyle(day.recovery >= 58 ? T.coral : T.lime)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("vs baseline").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        Text("+\(day.recoveryDelta)").font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(T.coral).monospacedDigit()
                    }
                }
                .padding(.top, 14)

                // Stress波：高度/频率跟着数值走，比进度条有直面感
                StressTide(level: level, height: 86)
                    .padding(.top, 10)
                    .overlay(alignment: .bottomLeading) {
                        Text("baseline 47").font(.system(size: 9.5)).foregroundStyle(T.onD3)
                    }

                // 三个归因指标：给偏离位置，不给"↑↓"
                VStack(spacing: 0) {
                    Rectangle().fill(T.hairD).frame(height: 1).padding(.top, 12)
                    DevRow(name: "Sleep", value: day.sleep,
                           pos: norm(Mock.hm(day.sleep), lo: 5.5, hi: 8.0), bandLo: 0.58, bandHi: 0.95)
                    DevRow(name: "Heart rate variability", value: "\(day.hrv) ms",
                           pos: norm(Double(day.hrv), lo: 34, hi: 56), bandLo: 0.45, bandHi: 0.9)
                    DevRow(name: "Resting heart rate", value: "\(day.rhr) bpm",
                           pos: norm(Double(day.rhr), lo: 54, hi: 66), bandLo: 0.08, bandHi: 0.58)
                }
            }
        }
    }
    private func norm(_ v: Double, lo: Double, hi: Double) -> Double {
        max(0, min(1, (v - lo) / (hi - lo)))
    }
}

/// 一行：数值 + 它落在Personal baseline band的什么位置（不出箭头，不出"up or down"）
struct DevRow: View {
    var name: String
    var value: String
    var pos: Double
    var bandLo: Double
    var bandHi: Double

    private var inBand: Bool { pos >= bandLo && pos <= bandHi }

    var body: some View {
        HStack(spacing: 12) {
            Text(name).font(.system(size: 12)).foregroundStyle(T.onD2).frame(width: 66, alignment: .leading)
            GeometryReader { g in
                let w = g.size.width
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.08)).frame(height: 6)
                    Capsule().fill(.white.opacity(0.16))
                        .frame(width: w * (bandHi - bandLo), height: 6)
                        .offset(x: w * bandLo)
                    Circle().fill(inBand ? T.lime : T.coral)
                        .frame(width: 9, height: 9)
                        .shadow(color: (inBand ? T.lime : T.coral).opacity(0.8), radius: 5)
                        .offset(x: max(0, min(w - 9, w * pos - 4.5)))
                }
                .frame(height: 10)
                .frame(maxHeight: .infinity)
            }
            .frame(height: 16)
            Text(value).font(.system(size: 12.5, weight: .semibold)).monospacedDigit()
                .frame(width: 58, alignment: .trailing)
        }
        .padding(.vertical, 9)
    }
}

// MARK: - 复合卡：Last night

struct NightCard: View {
    var day: Mock.Day = Mock.days[Mock.days.count - 2]   // 默认昨日
    var compact = false
    var onOpen: (() -> Void)? = nil
    private var deep: String { mins(Mock.hm(day.sleep) * 0.20) }
    private var rem:  String { mins(Mock.hm(day.sleep) * 0.25) }
    private func mins(_ h: Double) -> String {
        let m = Int((h * 60).rounded()); return "\(m / 60)h\(String(format: "%02d", m % 60))m"
    }
    var body: some View {
        FogCard {
            VStack(alignment: .leading, spacing: 0) {
                CardHead(icon: .moon, title: "Last night", sub: "\(day.date) · Apple Watch",
                         chip: day.wakeups >= 3 ? "Fragmented" : "Continuous",
                         chipTone: day.wakeups >= 3 ? .warn : .good,
                         trailing: onOpen.map { f in AnyView(OpenBtn(action: f)) })
                HStack(alignment: .firstTextBaseline) {
                    Text(day.sleep).numeral(36)
                    Spacer()
                    Text("↓ \(abs(day.sleepDelta)) min")
                        .font(.system(size: 12.5, weight: .semibold)).foregroundStyle(T.coral)
                }
                .padding(.top, 13)
                Text("baseline 7:28 · prev 28 days · Excluded 10/10")
                    .font(.system(size: 10.5)).foregroundStyle(T.onD3).padding(.top, 4)
                SleepAxis(day: day).padding(.top, 12)
                StatTrio(items: [
                    .init(v: deep, k: "Deep 20%"),
                    .init(v: rem, k: "REM 25%"),
                    .init(v: "\(day.wakeups) × · \(day.awakeMin)m", k: "Awakenings")
                ])
            }
        }
        // 整卡都是点击区，不只右上角的小键
        .contentShape(RoundedRectangle(cornerRadius: T.rCard, style: .continuous))
        .onTapGesture { if let f = onOpen { Haptic.tap(); f() } }
    }
}

// MARK: - 复合卡：Today

struct DayCard: View {
    var onOpen: (() -> Void)? = nil
    var body: some View {
        FogCard {
            VStack(alignment: .leading, spacing: 0) {
                CardHead(icon: .clock, title: "Yesterday", sub: "Activity × Energy · 10/13",
                         chip: "Afternoon dip", chipTone: .warn,
                         trailing: onOpen.map { f in AnyView(OpenBtn(action: f)) })
                Text("Yesterday's sitting block\nlanded right on your energy low.")
                    .font(.system(size: 15, weight: .semibold)).tracking(-0.3).lineSpacing(4)
                    .padding(.top, 12)
                DayRibbon().padding(.top, 8)
                StatTrio(items: [
                    .init(v: "8,260", k: "Steps"),
                    .init(v: "13:10", k: "Sitting began"),
                    .init(v: "rated 2", k: "Energy at 14:00")
                ])
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: T.rCard, style: .continuous))
        .onTapGesture { if let f = onOpen { Haptic.tap(); f() } }
    }
}
