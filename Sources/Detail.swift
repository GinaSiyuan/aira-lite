import SwiftUI

// MARK: - 二级信息：每张卡都能打开，看更深的层，并且随时能Ask Aira

enum DetailKind: String, Identifiable {
    case recovery, night, load, hrv, sleepTrend
    var id: String { rawValue }

    var title: String {
        switch self {
        case .recovery: "Recovery load"
        case .night:    "Last night · Sleep"
        case .load:     "Today's load & energy"
        case .hrv:      "Heart rate variability"
        case .sleepTrend: "Sleep trend"
        }
    }
    var ask: AskContext {
        switch self {
        case .recovery: AgentKB.recovery
        case .night, .sleepTrend: AgentKB.sleep
        case .load: AgentKB.load
        case .hrv: AgentKB.recovery
        }
    }
}

struct DetailSheet: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    var kind: DetailKind
    var day: Mock.Day
    /// 趋势区的时间范围：近一周 / 近一月（-detail30 为截图直达 30 天态）
    @State private var span = ProcessInfo.processInfo.arguments.contains("-detail30") ? 30 : 7

    var body: some View {
        ZStack {
            PageBG()
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        SectionLabel(text: "\(day.date) · \(day.weekday)")
                        Text(kind.title).font(.system(size: 21, weight: .semibold)).tracking(-0.6)
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Icon(.close, size: 13, weight: 2, color: T.ink2)
                            .frame(width: 32, height: 32).background(Circle().fill(T.hair2))
                    }
                }
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 8)

                // 时间范围：影响下方所有均值与趋势图
                HStack(spacing: 6) {
                    ForEach([7, 30], id: \.self) { n in
                        Button {
                            Haptic.tap()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) { span = n }
                        } label: {
                            Text(n == 7 ? "Last 7 days" : "Last 30 days")
                                .font(.system(size: 12, weight: span == n ? .semibold : .regular))
                                .padding(.horizontal, 13).padding(.vertical, 7)
                                .background(Capsule().fill(span == n ? T.ink : T.hair2))
                                .foregroundStyle(span == n ? .white : T.ink2)
                                .contentShape(Capsule())
                        }
                        .buttonStyle(PressStyle())
                    }
                    Spacer()
                    Text("vs prev 28-day baseline").font(.system(size: 10.5)).foregroundStyle(T.ink3)
                }
                .padding(.horizontal, 20).padding(.bottom, 10)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        switch kind {
                        case .recovery: recoveryBody
                        case .night, .sleepTrend: nightBody
                        case .load: loadBody
                        case .hrv: recoveryBody
                        }

                        // 原始趋势 + Personal baseline band（MVP：不出分，只给偏离）
                        BaselineBand(title: "Personal baseline band", unit: "ms",
                                     series: Mock.series(span) { Double($0.hrv) },
                                     lo: 44, hi: 54, label: "HRV · last \(span) days")
                        BaselineBand(title: "Personal baseline band", unit: "bpm",
                                     series: Mock.series(span) { Double($0.rhr) },
                                     lo: 55, hi: 61, label: "Resting HR · last \(span) days", invert: true)

                        FogCard(tone: .flat, padding: 16) {
                            AgentChips(subject: kind.title, items: kind.ask.presets)
                        }
                        Color.clear.frame(height: 76)
                    }
                    .padding(.horizontal, 20)
                }
                .overlay(alignment: .bottom) { askBar }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    /// 常驻问询条：不占一张卡，贴在底部
    private var askBar: some View {
        HStack(spacing: 10) {
            Icon(.ask, size: 16, weight: 2.1, color: .white)
            Text("More questions? Ask Aira").font(.system(size: 14, weight: .medium)).foregroundStyle(.white)
            Spacer()
            Icon(.arrowRight, size: 14, weight: 2, color: T.lime)
        }
        .padding(.horizontal, 18).padding(.vertical, 15)
        .background(Capsule().fill(T.ink).shadow(color: .black.opacity(0.28), radius: 16, y: 8))
        .padding(.horizontal, 20).padding(.bottom, 14)
        .contentShape(Capsule())
        .onTapGesture { app.go(.ask(kind.ask)) }
    }

    // MARK: 各类的二级内容

    private func n(_ v: Double, _ lo: Double, _ hi: Double) -> Double { max(0, min(1, (v - lo) / (hi - lo))) }

    private var recoveryBody: some View {
        VStack(alignment: .leading, spacing: 15) {
            FogCard {
                VStack(alignment: .leading, spacing: 0) {
                    Text("How this is computed").font(.system(size: 13, weight: .semibold))
                    Text("Only flagged when all three signals deviate together. A single moving signal is ignored — more likely noise.")
                        .font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3.5).padding(.top, 7)
                    // 范围均值：7 天 vs 30 天能看出偏离是在近期发生的
                    VStack(spacing: 0) {
                        DevRow(name: "Sleep · \(span)-day avg", value: Mock.avgSleepText(span),
                               pos: n(Mock.avg(span) { Mock.hm($0.sleep) }, 5.5, 8.0), bandLo: 0.58, bandHi: 0.95)
                        DevRow(name: "HRV · \(span)-day avg",
                               value: "\(Int(Mock.avg(span) { Double($0.hrv) }.rounded())) ms",
                               pos: n(Mock.avg(span) { Double($0.hrv) }, 34, 56), bandLo: 0.45, bandHi: 0.9)
                        DevRow(name: "Resting HR · \(span)-day avg",
                               value: "\(Int(Mock.avg(span) { Double($0.rhr) }.rounded())) bpm",
                               pos: n(Mock.avg(span) { Double($0.rhr) }, 54, 66), bandLo: 0.08, bandHi: 0.58)
                    }
                    .padding(.top, 12)
                    .animation(.smooth(duration: 0.3), value: span)
                    HStack(spacing: 14) {
                        LegendDot(c: T.lime, t: "Within your baseline band")
                        LegendDot(c: T.coral, t: "Outside the band")
                        Spacer()
                    }
                    .padding(.top, 10)
                    Qualifier(head: "Not a diagnosis",
                              body_: "Recovery load is a direction, not a verdict. What matters is whether it stays elevated for 3+ weeks.")
                }
            }
        }
    }

    private var nightBody: some View {
        VStack(alignment: .leading, spacing: 15) {
            FogCard {
                VStack(alignment: .leading, spacing: 0) {
                    Text("The structure of this night").font(.system(size: 13, weight: .semibold))
                    SleepAxis(day: day).padding(.top, 12)
                    StatTrio(items: [
                        .init(v: day.longest, k: "Longest block"),
                        .init(v: "\(day.wakeups) ×", k: "Awakenings"),
                        .init(v: "\(day.awakeMin)m", k: "Awake total")
                    ])
                    Text(day.note).font(.system(size: 12)).foregroundStyle(T.onD2).padding(.top, 12)
                }
            }
            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Duration · last \(span) days").font(.system(size: 13, weight: .semibold))
                        Spacer()
                        Text("avg \(Mock.avgSleepText(span))")
                            .font(.system(size: 11, weight: .semibold)).monospacedDigit()
                            .foregroundStyle(T.lime)
                    }
                    MiniLine(data: Mock.series(span) { Mock.hm($0.sleep) },
                             baseline: Mock.sleepBase, baselineLabel: "7:28", height: 86)
                    if Mock.missing(span) > 0 {
                        Text("\(Mock.missing(span)) day(s) without a record — excluded from the mean.")
                            .font(.system(size: 11)).foregroundStyle(T.onD3)
                    }
                }
            }
            .animation(.smooth(duration: 0.3), value: span)
        }
    }

    private var loadBody: some View {
        FogCard {
            VStack(alignment: .leading, spacing: 0) {
                Text("Activity × Sitting × Energy").font(.system(size: 13, weight: .semibold))
                DayRibbon().padding(.top, 10)
                Qualifier(head: "Co-occurrence only",
                          body_: "Sitting and the energy trough fall in the same window, but that says nothing about cause — the afternoon has a natural circadian dip anyway.")
            }
        }
    }
}

// MARK: - 原始趋势 + Personal baseline band（MVP 明确要求：不出分，只标偏离）

struct BaselineBand: View {
    var title: String
    var unit: String
    var series: [Double]
    var lo: Double
    var hi: Double
    var label: String
    var invert: Bool = false

    var body: some View {
        FogCard(tone: .flat) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(label).font(.system(size: 13, weight: .semibold))
                    Spacer()
                    Text("No score · deviation only").font(.system(size: 10)).foregroundStyle(T.onD3)
                }
                GeometryReader { g in
                    let w = g.size.width, h: CGFloat = 88
                    let mn = min(series.min() ?? lo, lo) - 3
                    let mx = max(series.max() ?? hi, hi) + 3
                    let X: (Int) -> CGFloat = { i in 4 + (w - 8) * CGFloat(i) / CGFloat(series.count - 1) }
                    let Y: (Double) -> CGFloat = { v in 10 + (h - 26) * CGFloat(1 - (v - mn) / (mx - mn)) }
                    ZStack(alignment: .topLeading) {
                        Canvas { ctx, _ in
                            ctx.fill(Path(roundedRect: CGRect(x: 4, y: Y(hi), width: w - 8, height: Y(lo) - Y(hi)),
                                          cornerRadius: 5), with: .color(.white.opacity(0.10)))
                            var p = Path()
                            for (i, v) in series.enumerated() {
                                let pt = CGPoint(x: X(i), y: Y(v))
                                i == 0 ? p.move(to: pt) : p.addLine(to: pt)
                            }
                            ctx.stroke(p, with: .color(.white.opacity(0.8)), lineWidth: 1.8)
                            for (i, v) in series.enumerated() {
                                let out = invert ? v > hi : v < lo
                                var c = Path()
                                let r: CGFloat = out ? 3.6 : 2.2
                                c.addEllipse(in: CGRect(x: X(i) - r, y: Y(v) - r, width: r * 2, height: r * 2))
                                ctx.fill(c, with: .color(out ? T.coral : .white))
                            }
                        }
                        Text("Baseline band \(Int(lo))–\(Int(hi)) \(unit)")
                            .font(.system(size: 9)).foregroundStyle(T.onD3)
                            .position(x: 62, y: Y(hi) - 7)
                    }
                }
                .frame(height: 88)
                .padding(.top, 10)
                HStack(spacing: 14) {
                    LegendDot(c: .white, t: "In band")
                    LegendDot(c: T.coral, t: invert ? "Above band" : "Below band")
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
    }
}

struct LegendDot: View {
    var c: Color; var t: String
    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(c).frame(width: 6, height: 6)
            Text(t).font(.system(size: 10)).foregroundStyle(T.onD3)
        }
    }
}

// MARK: - 每日主观打卡（MVP：5 items）

struct CheckInSheet: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    @State private var step = 0

    // 1 页一问；程度全部用连续控件，不再用文字列表
    private let pages: [(String, String, Ico)] = [
        ("How did you sleep?", "Three feels — not what the watch says, what you say.", .moon),
        ("How's your energy?", "Right now, not this morning.", .flame),
        ("Any soreness?", "Muscles and joints, overall.", .stretch),
        ("And your mood?", "One honest read is enough.", .user),
        ("Where's your stress?", "Drag around the dial.", .breath)
    ]
    private let words: [[String]] = [
        [], 
        ["Drained", "Tired", "OK", "Good", "Fresh"],
        ["Very sore", "Sore", "OK", "Mild", "None"],
        ["Very low", "Low", "OK", "Good", "Bright"],
        []
    ]

    var body: some View {
        ZStack {
            T.dark.ignoresSafeArea()
            Fog(tone: .warm).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Today's check-in").font(.system(size: 20, weight: .semibold)).tracking(-0.5)
                        Text("\(step + 1) of \(pages.count) · 10/14 08:20")
                            .font(.system(size: 11.5)).foregroundStyle(T.onD3)
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Icon(.close, size: 12, weight: 2.3, color: T.onD2)
                            .frame(width: 30, height: 30).background(Circle().fill(.white.opacity(0.1)))
                            .contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                }
                .padding(.top, 14)

                HStack(spacing: 5) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Capsule().fill(i <= step ? T.lime : .white.opacity(0.18)).frame(height: 3)
                    }
                }
                .padding(.top, 16)

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Icon(pages[step].2, size: 34, weight: 1.7, color: .white)
                    Text(pages[step].0)
                        .font(.system(size: 28, weight: .semibold, design: .serif)).tracking(-0.7)
                    Text(pages[step].1).font(.system(size: 12.5)).foregroundStyle(T.onD3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    switch step {
                    case 0:
                        // Sleep：三个维度，三条细刻度条
                        VStack(alignment: .leading, spacing: 24) {
                            dim("Depth", "Shallow", "Deep", $app.sleepDims[0])
                            dim("Length", "Too short", "Enough", $app.sleepDims[1])
                            dim("Continuity", "Broken", "Unbroken", $app.sleepDims[2])
                        }
                        .padding(.top, 30)
                    case 4:
                        // Stress：细条切出来的刻度环，读数在环外
                        TickRing(value: $app.todayFeel)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 14)
                    default:
                        VStack(spacing: 22) {
                            // 大词 + 表情跟着档位走
                            VStack(spacing: 10) {
                                // 这些维度 value 大 = 好 → 表情取反向（5 分才是笑脸）
                                FaceSketch(level: 5 - app.checkIn[step], size: 54,
                                           color: .white, lineWidth: 2.6)
                                Text(words[step][max(0, min(4, Int((app.checkIn[step] - 1).rounded())))])
                                    .font(.system(size: 21, weight: .semibold)).tracking(-0.4)
                                    .foregroundStyle(gaugeTint((app.checkIn[step] - 1) / 4))
                                    .contentTransition(.opacity)
                            }
                            .frame(maxWidth: .infinity)
                            TickBar(value: $app.checkIn[step],
                                    low: words[step][0], high: words[step][4])
                        }
                        .padding(.top, 34)
                    }
                }
                .frame(maxWidth: .infinity)

                Spacer()

                HStack(spacing: 10) {
                    if step > 0 {
                        Button { Haptic.tap(); withAnimation(.smooth) { step -= 1 } } label: {
                            Icon(.chevron, size: 16, weight: 2, color: .white)
                                .rotationEffect(.degrees(180))
                                .frame(width: 52, height: 52)
                                .background(Circle().fill(.white.opacity(0.1)))
                                .overlay(Circle().strokeBorder(.white.opacity(0.09), lineWidth: 1))
                                .contentShape(Circle())
                        }
                        .buttonStyle(PressStyle())
                    }
                    CTA(title: step == pages.count - 1 ? "Finish" : "Next") {
                        if step == pages.count - 1 { app.loggedToday = true; dismiss() }
                        else { withAnimation(.smooth) { step += 1 } }
                    }
                }
                .padding(.bottom, 22)
            }
            .padding(.horizontal, 22)
            .foregroundStyle(.white)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    @ViewBuilder
    private func dim(_ name: String, _ lo: String, _ hi: String, _ v: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text(name).font(.system(size: 13.5, weight: .semibold))
                Spacer()
                Text(String(format: "%.1f", v.wrappedValue))
                    .font(.system(size: 12, weight: .semibold)).monospacedDigit()
                    .foregroundStyle(T.lime)
            }
            TickBar(value: v, low: lo, high: hi)
        }
    }
}
