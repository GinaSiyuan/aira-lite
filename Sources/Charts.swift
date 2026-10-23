import SwiftUI

// MARK: - Sleep轴（复合核心图形）
// 一条轴同时读出：Duration / Asleep时间 / 分期 / Woke×数 / 清醒Duration / Longest block段

struct SleepAxis: View {
    /// (stage, h)  stage: 0=醒 1=REM 2=浅 3=深
    var seq: [(Int, Double)] = Mock.sleepSeq
    var onset: Double = 24.5          // 00:30
    var baseOnset: Double = 23.6667   // 23:40
    var axis: ClosedRange<Double> = 22.5...31.0

    init(seq: [(Int, Double)] = Mock.sleepSeq, onset: Double = 24.5,
         baseOnset: Double = 23.6667, axis: ClosedRange<Double> = 22.5...31.0) {
        self.seq = seq; self.onset = onset; self.baseOnset = baseOnset; self.axis = axis
    }
    /// 按天构建，和卡上的数字严格一致
    init(day: Mock.Day) {
        self.seq = day.seq
        self.onset = day.onsetHour
        self.baseOnset = day.baseOnsetHour
        self.axis = 22.5...max(31.0, day.wakeHour + 0.4)
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let pl: CGFloat = 4
            let iw = w - pl * 2
            let yTop: CGFloat = 30, bh: CGFloat = 34

            let X: (Double) -> CGFloat = { t in
                pl + iw * CGFloat((t - axis.lowerBound) / (axis.upperBound - axis.lowerBound))
            }
            let longest = longestRun()

            ZStack(alignment: .topLeading) {
                // 分期段（硬边、相邻段不留缝，缝只代表觉醒）
                Canvas { ctx, _ in
                    var t = onset
                    for (lv, d) in seq {
                        let x0 = X(t), x1 = X(t + d)
                        if lv != 0 {
                            let r = CGRect(x: x0, y: yTop, width: x1 - x0, height: bh)
                            ctx.fill(Path(r), with: .color(T.lime.opacity(stageOpacity(lv))))
                        }
                        t += d
                    }
                    // Longest block段描边
                    let lx = X(longest.start), lw = X(longest.start + longest.len) - X(longest.start)
                    let outline = Path(roundedRect: CGRect(x: lx - 1.5, y: yTop - 4,
                                                           width: lw + 3, height: bh + 8),
                                       cornerRadius: 6)
                    ctx.stroke(outline, with: .color(.white.opacity(0.85)), lineWidth: 1.3)
                    // 晚睡桥
                    var bridge = Path()
                    bridge.move(to: CGPoint(x: X(baseOnset), y: yTop + bh / 2))
                    bridge.addLine(to: CGPoint(x: X(onset), y: yTop + bh / 2))
                    ctx.stroke(bridge, with: .color(T.coral), lineWidth: 1.6)
                    var dot = Path()
                    dot.addEllipse(in: CGRect(x: X(baseOnset) - 2.5, y: yTop + bh / 2 - 2.5, width: 5, height: 5))
                    ctx.fill(dot, with: .color(T.coral))
                    // baseline竖虚线
                    var dash = Path()
                    dash.move(to: CGPoint(x: X(baseOnset), y: yTop - 2))
                    dash.addLine(to: CGPoint(x: X(baseOnset), y: yTop + bh + 2))
                    ctx.stroke(dash, with: .color(.white.opacity(0.34)),
                               style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                }

                // 顶部标签
                Text("\(fmt(axis.lowerBound))").font(.system(size: 8)).foregroundStyle(T.onD3)
                    .position(x: X(axis.lowerBound) + 12, y: yTop - 13)
                Text("\(fmt(axis.upperBound))").font(.system(size: 8)).foregroundStyle(T.onD3)
                    .position(x: X(axis.upperBound) - 12, y: yTop - 13)
                Text("最长连续段 \(hm(longest.len))")
                    .font(.system(size: 8.5, weight: .medium)).foregroundStyle(.white)
                    .position(x: X(longest.start + longest.len / 2), y: yTop - 13)

                // Asleep三角 + 单一标注
                Triangle().fill(T.lime).frame(width: 9, height: 7)
                    .position(x: X(onset), y: yTop + bh + 8)
                Text("入睡 \(fmt(onset)) · 比平时晚 \(Int(((onset - baseOnset) * 60).rounded())) 分钟")
                    .font(.system(size: 8.5)).foregroundStyle(T.coral)
                    .position(x: min(w - 70, X(onset) + 62), y: yTop + bh + 22)
            }
        }
        .frame(height: 92)
    }

    private func stageOpacity(_ lv: Int) -> Double { [0, 0.55, 0.28, 1.0][lv] }

    private func longestRun() -> (start: Double, len: Double) {
        var best = (start: onset, len: 0.0)
        var run = 0.0, runStart = onset, t = onset
        for (lv, d) in seq {
            if lv == 0 {
                if run > best.len { best = (runStart, run) }
                run = 0; runStart = t + d
            } else { run += d }
            t += d
        }
        if run > best.len { best = (runStart, run) }
        return best
    }

    private func fmt(_ t: Double) -> String {
        let h = Int(t) % 24, m = Int((t - floor(t)) * 60)
        return String(format: "%02d:%02d", h, m)
    }
    private func hm(_ h: Double) -> String {
        let m = Int((h * 60).rounded())
        return String(format: "%d:%02d", m / 60, m % 60)
    }
}

struct Triangle: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.midX, y: r.minY))
        p.addLine(to: CGPoint(x: r.minX, y: r.maxY))
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - HPA 偏离图（两侧偏离意义相反 → 两种颜色，偏离区即结论）

struct HPADeviation: View {
    var user: [Double] = Mock.hpaUser
    var balanced: [Double] = Mock.hpaBalanced
    var labels: [String] = ["醒来", "+30分", "午餐前", "16–17", "睡前"]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h: CGFloat = 132
            let pl: CGFloat = 6, pt: CGFloat = 16, pb: CGFloat = 30
            let iw = w - pl * 2, ih = h - pt - pb
            let X: (Double) -> CGFloat = { t in pl + iw * CGFloat(t / 4) }
            let Y: (Double) -> CGFloat = { v in pt + ih * CGFloat(1 - v / 7) }

            Canvas { ctx, _ in
                // 采样分段填充
                let N = 120
                var regions: [(sign: Int, pts: [(Double, Double, Double)])] = []
                for k in 0...N {
                    let t = 4.0 * Double(k) / Double(N)
                    let u = interp(user, t), b = interp(balanced, t)
                    let sg = u > b ? 1 : -1
                    if regions.last?.sign != sg { regions.append((sg, [])) }
                    regions[regions.count - 1].pts.append((t, u, b))
                }
                for r in regions where r.pts.count > 2 {
                    var p = Path()
                    p.move(to: CGPoint(x: X(r.pts[0].0), y: Y(r.pts[0].1)))
                    for s in r.pts { p.addLine(to: CGPoint(x: X(s.0), y: Y(s.1))) }
                    for s in r.pts.reversed() { p.addLine(to: CGPoint(x: X(s.0), y: Y(s.2))) }
                    p.closeSubpath()
                    ctx.fill(p, with: .color(r.sign > 0 ? T.coral.opacity(0.32) : T.sky.opacity(0.28)))
                }
                // Balanced参考（虚线）
                var bp = Path()
                for (i, v) in balanced.enumerated() {
                    let pt2 = CGPoint(x: X(Double(i)), y: Y(v))
                    i == 0 ? bp.move(to: pt2) : bp.addLine(to: pt2)
                }
                ctx.stroke(bp, with: .color(.white.opacity(0.42)),
                           style: StrokeStyle(lineWidth: 1.3, dash: [3, 3]))
                // 实测
                var up = Path()
                for (i, v) in user.enumerated() {
                    let pt2 = CGPoint(x: X(Double(i)), y: Y(v))
                    i == 0 ? up.move(to: pt2) : up.addLine(to: pt2)
                }
                ctx.stroke(up, with: .color(T.amber), style: StrokeStyle(lineWidth: 2.3, lineJoin: .round))
                for (i, v) in user.enumerated() {
                    let key = i == user.count - 1
                    var c = Path()
                    let r: CGFloat = key ? 5 : 3.4
                    c.addEllipse(in: CGRect(x: X(Double(i)) - r, y: Y(v) - r, width: r * 2, height: r * 2))
                    ctx.fill(c, with: .color(key ? .white : T.amber))
                }
            }
            .frame(height: h)

            // 轴标签 + Decisive
            ForEach(Array(labels.enumerated()), id: \.offset) { i, s in
                let key = i == labels.count - 1
                Text(s).font(.system(size: 8.5, weight: key ? .semibold : .regular))
                    .foregroundStyle(key ? .white : T.onD3)
                    .position(x: X(Double(i)), y: h - 20)
            }
            Text("1.29").font(.system(size: 9, weight: .semibold)).foregroundStyle(.white)
                .position(x: X(4) - 14, y: Y(user[4]) - 12)
            Text("决定点").font(.system(size: 8)).foregroundStyle(.white.opacity(0.5))
                .position(x: X(4) - 8, y: h - 8)
        }
        .frame(height: 132)
    }

    private func interp(_ a: [Double], _ t: Double) -> Double {
        let i = min(a.count - 2, Int(t)), f = t - Double(i)
        return a[i] + (a[i + 1] - a[i]) * f
    }
}

/// 偏离区的三层解释：人话 → 含义 → 数据口径
struct DeviationLegend: View {
    struct Row { var color: Color; var title: String; var meaning: String; var num: String; var sub: String }
    var rows: [Row]
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Rectangle().fill(.white.opacity(0.42)).frame(width: 14, height: 1.3)
                Text("虚线 = 「平衡」的参考形状").font(.system(size: 9.5)).foregroundStyle(T.onD3)
                Spacer()
            }
            .padding(.bottom, 4)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, r in
                Rectangle().fill(T.hairD).frame(height: 1)
                HStack(alignment: .top, spacing: 9) {
                    RoundedRectangle(cornerRadius: 3).fill(r.color)
                        .frame(width: 12, height: 12).padding(.top, 2)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(r.title).font(.system(size: 12.5, weight: .semibold))
                        Text(r.meaning).font(.system(size: 11)).foregroundStyle(T.onD2).lineSpacing(2.5)
                    }
                    Spacer(minLength: 6)
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(r.num).font(.system(size: 11, weight: .semibold)).foregroundStyle(r.color)
                        Text(r.sub).font(.system(size: 9.5)).foregroundStyle(T.onD3)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

// MARK: - 五状态位置条

struct StateStrip: View {
    var here: Int
    var names = ["耗竭", "平衡", "激活", "紧绷", "过载"]
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<5, id: \.self) { i in
                VStack(spacing: 5) {
                    Capsule().fill(i == here ? T.amber : .white.opacity(0.14))
                        .frame(height: 5)
                        .shadow(color: i == here ? T.amber.opacity(0.6) : .clear, radius: 6)
                    Text(names[i]).font(.system(size: 9, weight: i == here ? .semibold : .regular))
                        .foregroundStyle(i == here ? .white : .white.opacity(0.3))
                }
            }
        }
    }
}

// MARK: - 日带：Activity × Sitting × Energy，重合处一道光柱

struct DayRibbon: View {
    var activity: [(Double, Double)] = Mock.activity
    var sitting: [(Double, Double, Bool)] = Mock.sitting
    var energy: [(Double, Double)] = Mock.energy
    var overlap: ClosedRange<Double> = 13.17...15.83

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h: CGFloat = 160
            let pl: CGFloat = 6, iw = w - pl * 2
            let X: (Double) -> CGFloat = { t in pl + iw * CGFloat((t - 6) / 16) }
            let bandY: CGFloat = 80, bandH: CGFloat = 26
            let eY: (Double) -> CGFloat = { v in 16 + 40 * CGFloat(1 - (v - 1) / 4) }

            ZStack(alignment: .topLeading) {
                // 重合光柱
                LinearGradient(colors: [T.coral.opacity(0), T.coral.opacity(0.24), T.coral.opacity(0.04)],
                               startPoint: .top, endPoint: .bottom)
                    .frame(width: X(overlap.upperBound) - X(overlap.lowerBound), height: bandY + bandH - 6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .position(x: (X(overlap.lowerBound) + X(overlap.upperBound)) / 2,
                              y: 6 + (bandY + bandH - 6) / 2)

                Canvas { ctx, _ in
                    // 精力曲线
                    var p = Path()
                    let pts = energy.map { CGPoint(x: X($0.0), y: eY($0.1)) }
                    p.move(to: pts[0])
                    for i in 1..<pts.count {
                        let cx = (pts[i - 1].x + pts[i].x) / 2
                        p.addCurve(to: pts[i], control1: CGPoint(x: cx, y: pts[i - 1].y),
                                   control2: CGPoint(x: cx, y: pts[i].y))
                    }
                    ctx.stroke(p, with: .color(.white.opacity(0.78)), lineWidth: 2)
                    for (t, v) in energy {
                        let low = v <= 2, r: CGFloat = low ? 5 : 3
                        var c = Path()
                        c.addEllipse(in: CGRect(x: X(t) - r, y: eY(v) - r, width: r * 2, height: r * 2))
                        ctx.fill(c, with: .color(low ? T.coral : .white))
                    }
                    // 日带底
                    ctx.fill(Path(roundedRect: CGRect(x: pl, y: bandY, width: iw, height: bandH),
                                  cornerRadius: 9), with: .color(.white.opacity(0.07)))
                    for (t, v) in activity {
                        let x = X(t - 0.5), wd = X(t + 0.5) - X(t - 0.5)
                        let hh = 6 + v * 20
                        ctx.fill(Path(roundedRect: CGRect(x: x + 1, y: bandY + bandH - hh - 2,
                                                          width: wd - 2, height: hh), cornerRadius: 3),
                                 with: .color(T.lime.opacity(0.25 + v * 0.75)))
                    }
                    for (a, b, hot) in sitting {
                        ctx.fill(Path(roundedRect: CGRect(x: X(a), y: bandY + bandH + 6,
                                                          width: X(b) - X(a), height: 7), cornerRadius: 3.5),
                                 with: .color(hot ? T.coral : .white.opacity(0.26)))
                    }
                }
                .frame(height: h)

                Text("精力 · 自评").font(.system(size: 8.5)).foregroundStyle(T.onD3)
                    .position(x: pl + 26, y: 8)
                Text("自评 1–2").font(.system(size: 8.5)).foregroundStyle(T.coral)
                    .position(x: X(15), y: eY(2) + 16)
                Text("活动 · 久坐").font(.system(size: 8.5)).foregroundStyle(T.onD3)
                    .position(x: pl + 28, y: bandY - 8)
                Text("久坐 2h40m").font(.system(size: 8.5)).foregroundStyle(T.coral)
                    .position(x: X(14.5), y: bandY + bandH + 22)
                ForEach([8, 12, 16, 20], id: \.self) { t in
                    Text("\(t):00").font(.system(size: 8.5)).foregroundStyle(.white.opacity(0.3))
                        .position(x: X(Double(t)), y: h - 4)
                }
            }
        }
        .frame(height: 160)
    }
}

// MARK: - 迷你折线（带baseline虚线）

struct MiniLine: View {
    var data: [Double]
    var baseline: Double? = nil
    var baselineLabel: String = ""
    var tint: Color = T.lime
    var height: CGFloat = 72

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = height
            let all = data + (baseline.map { [$0] } ?? [])
            let mn = (all.min() ?? 0) - 0.25, mx = (all.max() ?? 1) + 0.25
            let X: (Int) -> CGFloat = { i in 4 + (w - 8) * CGFloat(i) / CGFloat(max(1, data.count - 1)) }
            let Y: (Double) -> CGFloat = { v in 8 + (h - 28) * CGFloat(1 - (v - mn) / (mx - mn)) }
            ZStack(alignment: .topLeading) {
                Canvas { ctx, _ in
                    if let b = baseline {
                        var d = Path()
                        d.move(to: CGPoint(x: 4, y: Y(b))); d.addLine(to: CGPoint(x: w - 4, y: Y(b)))
                        ctx.stroke(d, with: .color(.white.opacity(0.34)),
                                   style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    }
                    var area = Path()
                    area.move(to: CGPoint(x: X(0), y: h - 20))
                    for (i, v) in data.enumerated() { area.addLine(to: CGPoint(x: X(i), y: Y(v))) }
                    area.addLine(to: CGPoint(x: X(data.count - 1), y: h - 20))
                    area.closeSubpath()
                    ctx.fill(area, with: .linearGradient(
                        Gradient(colors: [tint.opacity(0.26), tint.opacity(0)]),
                        startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: h - 20)))
                    var line = Path()
                    for (i, v) in data.enumerated() {
                        let p = CGPoint(x: X(i), y: Y(v)); i == 0 ? line.move(to: p) : line.addLine(to: p)
                    }
                    ctx.stroke(line, with: .color(tint), lineWidth: 1.9)
                    for (i, v) in data.enumerated() {
                        var c = Path()
                        c.addEllipse(in: CGRect(x: X(i) - 2.1, y: Y(v) - 2.1, width: 4.2, height: 4.2))
                        ctx.fill(c, with: .color(tint))
                    }
                }
                if let b = baseline {
                    Text("基线 \(baselineLabel)").font(.system(size: 8.5)).foregroundStyle(T.onD3)
                        .position(x: w - 34, y: Y(b) - 7)
                }
            }
        }
        .frame(height: height)
    }
}

// MARK: - 主客观双轨

struct DualTrack: View {
    var device: [Double] = [0.92, 0.72, 0.55, 0.30, 0.28, 0.38, 0.30]
    var selfRep: [Double] = [5, 4, 4, 2, 2, 3, 3]
    var xs = ["8", "10", "12", "14", "16", "18", "20"]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h: CGFloat = 106
            let X: (Int) -> CGFloat = { i in 28 + (w - 42) * CGFloat(i) / CGFloat(device.count - 1) }
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 9).fill(T.lime.opacity(0.10))
                    .overlay(RoundedRectangle(cornerRadius: 9).strokeBorder(T.lime.opacity(0.35), lineWidth: 1))
                    .frame(width: X(4) - X(2) + 18, height: 90)
                    .position(x: (X(3) + X(4)) / 2 - 10, y: 48)
                Canvas { ctx, _ in
                    var p = Path()
                    for (i, v) in device.enumerated() {
                        let pt = CGPoint(x: X(i), y: 12 + 34 * CGFloat(1 - v))
                        i == 0 ? p.move(to: pt) : p.addLine(to: pt)
                    }
                    ctx.stroke(p, with: .color(T.sky), lineWidth: 1.9)
                    for (i, v) in device.enumerated() {
                        var c = Path()
                        c.addEllipse(in: CGRect(x: X(i) - 2.4, y: 12 + 34 * CGFloat(1 - v) - 2.4,
                                                width: 4.8, height: 4.8))
                        ctx.fill(c, with: .color(T.sky))
                    }
                    for (i, v) in selfRep.enumerated() {
                        let r: CGFloat = 2 + CGFloat(v) * 1.2
                        var c = Path()
                        c.addEllipse(in: CGRect(x: X(i) - r, y: 72 - r, width: r * 2, height: r * 2))
                        ctx.fill(c, with: .color(v <= 2 ? T.coral : .white.opacity(0.4)))
                    }
                }
                .frame(height: h)
                Text("设备").font(.system(size: 8.5)).foregroundStyle(T.onD3).position(x: 14, y: 28)
                Text("自评").font(.system(size: 8.5)).foregroundStyle(T.onD3).position(x: 14, y: 72)
                ForEach(Array(xs.enumerated()), id: \.offset) { i, s in
                    Text(s).font(.system(size: 8.5)).foregroundStyle(T.onD3).position(x: X(i), y: h - 4)
                }
            }
        }
        .frame(height: 106)
    }
}

// MARK: - 自测趋势（连续取值 + 表情锚点）

struct SelfTrend: View {
    var data: [Double?] = Mock.selfCheck
    /// 放在浅色底（白壳）上时翻转配色
    var light: Bool = false
    @Binding var selected: Int

    private var line: Color { light ? T.ink.opacity(0.22) : .white.opacity(0.22) }
    private var dotFill: Color { light ? .white : .white.opacity(0.10) }
    private var dotRing: Color { light ? T.hair : .white.opacity(0.22) }
    private var face: Color { light ? T.ink : .white }
    private var axis: Color { light ? T.ink3 : .white.opacity(0.3) }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h: CGFloat = 132
            let pl: CGFloat = 16, iw = w - pl * 2
            let X: (Int) -> CGFloat = { i in pl + iw * CGFloat(i) / CGFloat(data.count - 1) }
            let Y: (Double) -> CGFloat = { v in 26 + 70 * CGFloat(1 - (v - 1) / 4) }
            ZStack(alignment: .topLeading) {
                Canvas { ctx, _ in
                    var p = Path()
                    var started = false
                    for (i, v) in data.enumerated() {
                        guard let v else { continue }
                        let pt = CGPoint(x: X(i), y: Y(v))
                        if !started { p.move(to: pt); started = true } else {
                            let cx = (X(i - 1) + X(i)) / 2
                            p.addCurve(to: pt, control1: CGPoint(x: cx, y: p.currentPoint?.y ?? pt.y),
                                       control2: CGPoint(x: cx, y: pt.y))
                        }
                    }
                    ctx.stroke(p, with: .color(line),
                               style: StrokeStyle(lineWidth: 2, lineCap: .round))
                }
                .frame(height: h)
                ForEach(Array(data.enumerated()), id: \.offset) { i, v in
                    if let v {
                        let on = i == selected
                        Button {
                            Haptic.soft(); selected = i
                        } label: {
                            ZStack {
                                Circle().fill(on ? T.lime : dotFill)
                                    .overlay(Circle().strokeBorder(on ? T.lime : dotRing,
                                                                   lineWidth: on ? 2 : 1))
                                FaceSketch(level: v - 1, size: on ? 20 : 14,
                                           color: on ? T.ink : face, lineWidth: on ? 2 : 1.5)
                            }
                            .frame(width: on ? 32 : 22, height: on ? 32 : 22)
                        }
                        .buttonStyle(.plain)
                        .position(x: X(i), y: Y(v))
                    } else {
                        Circle().strokeBorder(dotRing, style: StrokeStyle(lineWidth: 1.4, dash: [2, 2]))
                            .frame(width: 8, height: 8)
                            .position(x: X(i), y: 26 + 35)
                    }
                }
                Text("紧绷").font(.system(size: 9)).foregroundStyle(axis)
                    .position(x: pl + 12, y: 14)
                Text("平静").font(.system(size: 9)).foregroundStyle(axis)
                    .position(x: pl + 12, y: h - 18)
                Text("10/01").font(.system(size: 9)).foregroundStyle(axis).position(x: pl + 14, y: h - 4)
                Text("10/14").font(.system(size: 9)).foregroundStyle(axis).position(x: w - pl - 14, y: h - 4)
            }
        }
        .frame(height: 132)
    }
}

// MARK: - 点状进度环

struct DotRing: View {
    var progress: Double
    var value: String
    var unit: String
    var size: CGFloat = 104
    var body: some View {
        ZStack {
            ForEach(0..<32, id: \.self) { i in
                Circle()
                    .fill(Double(i) / 32 < progress ? T.lime : .white.opacity(0.22))
                    .frame(width: Double(i) / 32 < progress ? 6 : 4.2,
                           height: Double(i) / 32 < progress ? 6 : 4.2)
                    .offset(y: -size / 2 + 8)
                    .rotationEffect(.degrees(Double(i) / 32 * 360))
            }
            VStack(spacing: 2) {
                Text(value).numeral(19)
                Text(unit).font(.system(size: 9)).foregroundStyle(T.onD3)
            }
        }
        .frame(width: size, height: size)
    }
}
