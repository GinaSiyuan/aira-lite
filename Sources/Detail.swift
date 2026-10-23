import SwiftUI

// MARK: - 二级信息：每张卡都能打开，看更深的层，并且随时能Ask Aira

enum DetailKind: String, Identifiable {
    case recovery, night, load, hrv, sleepTrend
    var id: String { rawValue }

    var title: String {
        switch self {
        case .recovery: "恢复负荷"
        case .night:    "昨夜 · 睡眠"
        case .load:     "今天的负荷与精力"
        case .hrv:      "心率变异性"
        case .sleepTrend: "睡眠趋势"
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
                            Text(n == 7 ? "近 7 天" : "近 30 天")
                                .font(.system(size: 12, weight: span == n ? .semibold : .regular))
                                .padding(.horizontal, 13).padding(.vertical, 7)
                                .background(Capsule().fill(span == n ? T.ink : T.hair2))
                                .foregroundStyle(span == n ? .white : T.ink2)
                                .contentShape(Capsule())
                        }
                        .buttonStyle(PressStyle())
                    }
                    Spacer()
                    Text("对比前 28 天基线").font(.system(size: 10.5)).foregroundStyle(T.ink3)
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
                        BaselineBand(title: "个人基线区间", unit: "ms",
                                     series: Mock.series(span) { Double($0.hrv) },
                                     lo: 44, hi: 54, label: "HRV · 近 \(span) 天")
                        BaselineBand(title: "个人基线区间", unit: "bpm",
                                     series: Mock.series(span) { Double($0.rhr) },
                                     lo: 55, hi: 61, label: "静息心率 · 近 \(span) 天", invert: true)

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
            Text("还有问题？问 Aira").font(.system(size: 14, weight: .medium)).foregroundStyle(.white)
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
                    Text("它是怎么计算的").font(.system(size: 13, weight: .semibold))
                    Text("只有三个信号一起偏离时才会标记。单个信号的波动会被忽略 —— 那更可能是噪声。")
                        .font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3.5).padding(.top, 7)
                    // 范围均值：7 天 vs 30 天能看出偏离是在近期发生的
                    VStack(spacing: 0) {
                        DevRow(name: "睡眠 · \(span) 天均值", value: Mock.avgSleepText(span),
                               pos: n(Mock.avg(span) { Mock.hm($0.sleep) }, 5.5, 8.0), bandLo: 0.58, bandHi: 0.95)
                        DevRow(name: "HRV · \(span) 天均值",
                               value: "\(Int(Mock.avg(span) { Double($0.hrv) }.rounded())) ms",
                               pos: n(Mock.avg(span) { Double($0.hrv) }, 34, 56), bandLo: 0.45, bandHi: 0.9)
                        DevRow(name: "静息心率 · \(span) 天均值",
                               value: "\(Int(Mock.avg(span) { Double($0.rhr) }.rounded())) bpm",
                               pos: n(Mock.avg(span) { Double($0.rhr) }, 54, 66), bandLo: 0.08, bandHi: 0.58)
                    }
                    .padding(.top, 12)
                    .animation(.smooth(duration: 0.3), value: span)
                    HStack(spacing: 14) {
                        LegendDot(c: T.lime, t: "在你的基线区间内")
                        LegendDot(c: T.coral, t: "超出区间")
                        Spacer()
                    }
                    .padding(.top, 10)
                    Qualifier(head: "不是诊断",
                              body_: "恢复负荷是一个方向，不是结论。要紧的是它是否持续升高 3 周以上。")
                }
            }
        }
    }

    private var nightBody: some View {
        VStack(alignment: .leading, spacing: 15) {
            FogCard {
                VStack(alignment: .leading, spacing: 0) {
                    Text("这一夜的结构").font(.system(size: 13, weight: .semibold))
                    SleepAxis(day: day).padding(.top, 12)
                    StatTrio(items: [
                        .init(v: day.longest, k: "最长连续段"),
                        .init(v: "\(day.wakeups) 次", k: "觉醒"),
                        .init(v: "\(day.awakeMin)分", k: "清醒总计")
                    ])
                    Text(day.note).font(.system(size: 12)).foregroundStyle(T.onD2).padding(.top, 12)
                }
            }
            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("时长 · 近 \(span) 天").font(.system(size: 13, weight: .semibold))
                        Spacer()
                        Text("均值 \(Mock.avgSleepText(span))")
                            .font(.system(size: 11, weight: .semibold)).monospacedDigit()
                            .foregroundStyle(T.lime)
                    }
                    MiniLine(data: Mock.series(span) { Mock.hm($0.sleep) },
                             baseline: Mock.sleepBase, baselineLabel: "7:28", height: 86)
                    if Mock.missing(span) > 0 {
                        Text("有 \(Mock.missing(span)) 天无记录 —— 已从均值中剔除。")
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
                Text("活动 × 久坐 × 精力").font(.system(size: 13, weight: .semibold))
                DayRibbon().padding(.top, 10)
                Qualifier(head: "只是同时出现",
                          body_: "久坐和精力低谷落在同一时段，但这说明不了因果 —— 下午本来就有自然的昼夜低谷。")
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
                    Text("不打分 · 只看偏离").font(.system(size: 10)).foregroundStyle(T.onD3)
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
                        Text("基线区间 \(Int(lo))–\(Int(hi)) \(unit)")
                            .font(.system(size: 9)).foregroundStyle(T.onD3)
                            .position(x: 62, y: Y(hi) - 7)
                    }
                }
                .frame(height: 88)
                .padding(.top, 10)
                HStack(spacing: 14) {
                    LegendDot(c: .white, t: "区间内")
                    LegendDot(c: T.coral, t: invert ? "高于区间" : "低于区间")
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
        ("昨晚睡得怎么样？", "三个感受 —— 不听手表的，听你的。", .moon),
        ("现在精力如何？", "此刻的状态，不是早上的。", .flame),
        ("有酸痛吗？", "肌肉和关节，整体感觉。", .stretch),
        ("心情呢？", "诚实的一个读数就够。", .user),
        ("压力在哪个档？", "沿着表盘拖动。", .breath)
    ]
    private let words: [[String]] = [
        [], 
        ["耗尽", "疲惫", "还行", "不错", "充沛"],
        ["很酸痛", "酸痛", "还行", "轻微", "没有"],
        ["很低落", "低落", "还行", "不错", "明朗"],
        []
    ]

    var body: some View {
        ZStack {
            T.dark.ignoresSafeArea()
            Fog(tone: .warm).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("今天的打卡").font(.system(size: 20, weight: .semibold))
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
                        .font(.serifZh(27))
                    Text(pages[step].1).font(.system(size: 12.5)).foregroundStyle(T.onD3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Group {
                    switch step {
                    case 0:
                        // Sleep：三个维度，三条细刻度条
                        VStack(alignment: .leading, spacing: 24) {
                            dim("深度", "浅", "深", $app.sleepDims[0])
                            dim("时长", "太短", "足够", $app.sleepDims[1])
                            dim("连续性", "断断续续", "完整", $app.sleepDims[2])
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
                    CTA(title: step == pages.count - 1 ? "完成" : "下一步") {
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
