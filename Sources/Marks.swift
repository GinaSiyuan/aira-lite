import SwiftUI

// MARK: - 数据源徽标
// 不用位图：接入方只需要被认出来，线条/色块就够，而且能跟着状态换色。

struct SourceMark: View {
    enum Kind { case appleHealth, oura, whoop, garmin }
    var kind: Kind
    var size: CGFloat = 46

    var body: some View {
        Group {
            if let name = assetName,
               let path = Bundle.main.path(forResource: name, ofType: "png"),
               let img = UIImage(contentsOfFile: path) {
                // 真实 App Store 图标
                Image(uiImage: img).resizable().scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                        .strokeBorder(.black.opacity(0.08), lineWidth: 0.6))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.26, style: .continuous).fill(tile)
                    RoundedRectangle(cornerRadius: size * 0.26, style: .continuous)
                        .strokeBorder(.black.opacity(0.06), lineWidth: 0.8)
                    glyph
                }
            }
        }
        .frame(width: size, height: size)
    }

    private var assetName: String? {
        switch kind {
        case .appleHealth: "appicon_health"
        case .oura: "appicon_oura"
        case .whoop: "appicon_whoop"
        case .garmin: "appicon_garmin"
        }
    }

    private var tile: Color {
        switch kind {
        case .appleHealth: .white
        case .oura:        Color(hex: 0x16161A)
        case .whoop:       Color(hex: 0x16161A)
        case .garmin:      Color(hex: 0x0B3D63)
        }
    }

    @ViewBuilder private var glyph: some View {
        switch kind {
        case .appleHealth:
            Heart()
                .fill(LinearGradient(colors: [Color(hex: 0xFF4B6E), Color(hex: 0xFF2D55)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: size * 0.5, height: size * 0.46)
        case .oura:
            // 戒指：外圈 + 内圈，侧面一道高光
            ZStack {
                Circle().strokeBorder(.white.opacity(0.92), lineWidth: size * 0.11)
                Circle().strokeBorder(.white.opacity(0.22), lineWidth: 0.8)
                    .padding(size * 0.11)
            }
            .frame(width: size * 0.56, height: size * 0.56)
        case .whoop:
            // 腕带：一条环起来的带子
            Capsule().strokeBorder(Color(hex: 0xE8403A), lineWidth: size * 0.1)
                .frame(width: size * 0.5, height: size * 0.6)
                .overlay(
                    Capsule().fill(Color(hex: 0xE8403A))
                        .frame(width: size * 0.22, height: size * 0.12)
                        .offset(y: -size * 0.3)
                )
        case .garmin:
            Circle().strokeBorder(.white, lineWidth: size * 0.09)
                .frame(width: size * 0.5, height: size * 0.5)
        }
    }

    var title: String {
        switch kind {
        case .appleHealth: "Apple Health"
        case .oura: "Oura Ring"
        case .whoop: "WHOOP"
        case .garmin: "Garmin"
        }
    }
}

struct Heart: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width, h = r.height
        p.move(to: CGPoint(x: w / 2, y: h))
        p.addCurve(to: CGPoint(x: 0, y: h * 0.3),
                   control1: CGPoint(x: w * 0.1, y: h * 0.78),
                   control2: CGPoint(x: 0, y: h * 0.56))
        p.addArc(center: CGPoint(x: w * 0.25, y: h * 0.3), radius: w * 0.25,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addArc(center: CGPoint(x: w * 0.75, y: h * 0.3), radius: w * 0.25,
                 startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addCurve(to: CGPoint(x: w / 2, y: h),
                   control1: CGPoint(x: w, y: h * 0.56),
                   control2: CGPoint(x: w * 0.9, y: h * 0.78))
        p.closeSubpath()
        return p
    }
}

// MARK: - 采样盒：一张"会出结果"的检测单简笔
// 画的是物件本身（管 + 单子），不是抽象图标 —— 用户要先认出盒子里是什么。

struct SampleKitMark: View {
    var size: CGFloat = 54
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(Color(hex: 0xF4F4F1))
            Canvas { ctx, s in
                let w = s.width, h = s.height
                let ink = Color(hex: 0x101011)
                // 检测单
                var sheet = Path(roundedRect: .init(x: w * 0.16, y: h * 0.14,
                                                    width: w * 0.46, height: h * 0.72),
                                 cornerRadius: w * 0.05)
                ctx.fill(sheet, with: .color(.white))
                ctx.stroke(sheet, with: .color(ink), lineWidth: 1.4)
                // 单子上的行
                for i in 0..<3 {
                    var l = Path()
                    let y = h * (0.30 + Double(i) * 0.13)
                    l.move(to: .init(x: w * 0.24, y: y))
                    l.addLine(to: .init(x: w * (i == 2 ? 0.42 : 0.54), y: y))
                    ctx.stroke(l, with: .color(ink.opacity(0.35)), lineWidth: 1.2)
                }
                // 单子上的小曲线 = 结果
                var curve = Path()
                curve.move(to: .init(x: w * 0.24, y: h * 0.72))
                curve.addCurve(to: .init(x: w * 0.54, y: h * 0.70),
                               control1: .init(x: w * 0.33, y: h * 0.58),
                               control2: .init(x: w * 0.42, y: h * 0.80))
                ctx.stroke(curve, with: .color(Color(hex: 0x9FBF2E)), lineWidth: 2)
                sheet = Path()
                // 采样管
                var tube = Path(roundedRect: .init(x: w * 0.66, y: h * 0.22,
                                                   width: w * 0.17, height: h * 0.58),
                                cornerRadius: w * 0.085)
                ctx.fill(tube, with: .color(.white))
                ctx.stroke(tube, with: .color(ink), lineWidth: 1.4)
                // 管里的液面
                var fill = Path(roundedRect: .init(x: w * 0.685, y: h * 0.54,
                                                   width: w * 0.12, height: h * 0.23),
                                cornerRadius: w * 0.06)
                ctx.fill(fill, with: .color(Color(hex: 0xDCF55A)))
                // 管盖
                var cap = Path(roundedRect: .init(x: w * 0.645, y: h * 0.16,
                                                  width: w * 0.21, height: h * 0.10),
                               cornerRadius: w * 0.03)
                ctx.fill(cap, with: .color(ink))
                tube = Path(); fill = Path(); cap = Path()
            }
            .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - 报告简笔：一张带结论条和建议行的单子

struct ReportMark: View {
    var size: CGFloat = 54
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.24, style: .continuous)
                .fill(Color(hex: 0xF4F4F1))
            Canvas { ctx, s in
                let w = s.width, h = s.height
                let ink = Color(hex: 0x101011)
                let sheet = Path(roundedRect: .init(x: w * 0.20, y: h * 0.14,
                                                    width: w * 0.60, height: h * 0.72),
                                 cornerRadius: w * 0.06)
                ctx.fill(sheet, with: .color(.white))
                ctx.stroke(sheet, with: .color(ink), lineWidth: 1.4)
                // 结论条
                let bar = Path(roundedRect: .init(x: w * 0.28, y: h * 0.26,
                                                  width: w * 0.30, height: h * 0.07),
                               cornerRadius: h * 0.035)
                ctx.fill(bar, with: .color(Color(hex: 0xFFB85C)))
                // 五档位置条
                for i in 0..<5 {
                    let x = w * (0.28 + Double(i) * 0.09)
                    let on = i == 3
                    let seg = Path(roundedRect: .init(x: x, y: h * 0.44,
                                                      width: w * 0.07, height: h * 0.035),
                                   cornerRadius: h * 0.02)
                    ctx.fill(seg, with: .color(on ? Color(hex: 0xDCF55A) : ink.opacity(0.16)))
                }
                // 建议行：勾 + 文字线
                for i in 0..<2 {
                    let y = h * (0.58 + Double(i) * 0.13)
                    var tick = Path()
                    tick.move(to: .init(x: w * 0.28, y: y + h * 0.02))
                    tick.addLine(to: .init(x: w * 0.31, y: y + h * 0.05))
                    tick.addLine(to: .init(x: w * 0.36, y: y - h * 0.01))
                    ctx.stroke(tick, with: .color(Color(hex: 0x6C8F18)),
                               style: .init(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
                    var l = Path()
                    l.move(to: .init(x: w * 0.41, y: y + h * 0.02))
                    l.addLine(to: .init(x: w * 0.72, y: y + h * 0.02))
                    ctx.stroke(l, with: .color(ink.opacity(0.3)), lineWidth: 1.2)
                }
            }
            .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - 既往史图标（部位 / 药物）
// 参照病历列表的做法：一个部位一个图，比纯文字 pill 更容易扫读。

enum MedGlyph {
    case back, knee, shoulder, achilles, none
    case pill, capsule, hormone, inhaler, biotin
}

struct MedIcon: View {
    var glyph: MedGlyph
    var size: CGFloat = 40
    var active: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
                .fill(active ? T.lime.opacity(0.55) : Color(hex: 0xF2F2EF))
            Canvas { ctx, s in draw(&ctx, s) }
                .frame(width: size * 0.56, height: size * 0.56)
        }
        .frame(width: size, height: size)
    }

    private func draw(_ ctx: inout GraphicsContext, _ s: CGSize) {
        let w = s.width, h = s.height
        let c = Color(hex: 0x101011)
        let lw: CGFloat = 1.6
        func stroke(_ p: Path, _ col: Color = Color(hex: 0x101011), _ width: CGFloat = 1.6) {
            ctx.stroke(p, with: .color(col), style: .init(lineWidth: width, lineCap: .round, lineJoin: .round))
        }
        switch glyph {
        case .back:
            // 脊柱：一列椎骨
            var spine = Path()
            spine.move(to: .init(x: w * 0.5, y: h * 0.06))
            spine.addCurve(to: .init(x: w * 0.5, y: h * 0.94),
                           control1: .init(x: w * 0.78, y: h * 0.34),
                           control2: .init(x: w * 0.26, y: h * 0.66))
            stroke(spine, c, 2)
            for i in 0..<4 {
                var v = Path()
                let t = 0.18 + Double(i) * 0.21
                v.move(to: .init(x: w * (0.28 + (i % 2 == 0 ? 0.1 : 0.0)), y: h * t))
                v.addLine(to: .init(x: w * (0.72 + (i % 2 == 0 ? 0.0 : -0.1)), y: h * t))
                stroke(v, c.opacity(0.55), 1.4)
            }
        case .knee:
            var up = Path()
            up.move(to: .init(x: w * 0.34, y: h * 0.04))
            up.addLine(to: .init(x: w * 0.34, y: h * 0.42))
            stroke(up, c, 2.4)
            var low = Path()
            low.move(to: .init(x: w * 0.62, y: h * 0.58))
            low.addLine(to: .init(x: w * 0.62, y: h * 0.96))
            stroke(low, c, 2.4)
            var joint = Path()
            joint.addEllipse(in: .init(x: w * 0.28, y: h * 0.38, width: w * 0.44, height: h * 0.26))
            stroke(joint, c, 1.6)
        case .shoulder:
            var arm = Path()
            arm.move(to: .init(x: w * 0.12, y: h * 0.34))
            arm.addQuadCurve(to: .init(x: w * 0.68, y: h * 0.30),
                             control: .init(x: w * 0.40, y: h * 0.06))
            stroke(arm, c, 2)
            var down = Path()
            down.move(to: .init(x: w * 0.68, y: h * 0.30))
            down.addLine(to: .init(x: w * 0.76, y: h * 0.92))
            stroke(down, c, 2)
            var ball = Path()
            ball.addEllipse(in: .init(x: w * 0.54, y: h * 0.18, width: w * 0.30, height: h * 0.30))
            stroke(ball, c, 1.5)
        case .achilles:
            var foot = Path()
            foot.move(to: .init(x: w * 0.30, y: h * 0.06))
            foot.addLine(to: .init(x: w * 0.30, y: h * 0.62))
            foot.addQuadCurve(to: .init(x: w * 0.92, y: h * 0.88),
                              control: .init(x: w * 0.34, y: h * 0.90))
            stroke(foot, c, 2)
            var band = Path()
            band.move(to: .init(x: w * 0.14, y: h * 0.26))
            band.addLine(to: .init(x: w * 0.14, y: h * 0.70))
            stroke(band, Color(hex: 0x9FBF2E), 2.4)
        case .none:
            var ring = Path()
            ring.addEllipse(in: .init(x: w * 0.10, y: h * 0.10, width: w * 0.80, height: h * 0.80))
            stroke(ring, c.opacity(0.5), 1.6)
            var tick = Path()
            tick.move(to: .init(x: w * 0.30, y: h * 0.52))
            tick.addLine(to: .init(x: w * 0.44, y: h * 0.66))
            tick.addLine(to: .init(x: w * 0.70, y: h * 0.36))
            stroke(tick, c, 2)
        case .pill:
            var round = Path()
            round.addEllipse(in: .init(x: w * 0.08, y: h * 0.08, width: w * 0.84, height: h * 0.84))
            stroke(round, c, 1.8)
            var cut = Path()
            cut.move(to: .init(x: w * 0.5, y: h * 0.10))
            cut.addLine(to: .init(x: w * 0.5, y: h * 0.90))
            stroke(cut, c.opacity(0.5), 1.4)
        case .capsule:
            var cap = Path(roundedRect: .init(x: w * 0.06, y: h * 0.28,
                                              width: w * 0.88, height: h * 0.44),
                           cornerRadius: h * 0.22)
            stroke(cap, c, 1.8)
            let half = Path(roundedRect: .init(x: w * 0.06, y: h * 0.28,
                                               width: w * 0.44, height: h * 0.44),
                            cornerRadius: h * 0.22)
            ctx.fill(half, with: .color(Color(hex: 0x9FBF2E).opacity(0.55)))
            cap = Path()
        case .hormone:
            var flask = Path()
            flask.move(to: .init(x: w * 0.34, y: h * 0.08))
            flask.addLine(to: .init(x: w * 0.34, y: h * 0.42))
            flask.addLine(to: .init(x: w * 0.12, y: h * 0.86))
            flask.addLine(to: .init(x: w * 0.88, y: h * 0.86))
            flask.addLine(to: .init(x: w * 0.66, y: h * 0.42))
            flask.addLine(to: .init(x: w * 0.66, y: h * 0.08))
            stroke(flask, c, 1.7)
            var liq = Path()
            liq.move(to: .init(x: w * 0.22, y: h * 0.66))
            liq.addLine(to: .init(x: w * 0.12, y: h * 0.86))
            liq.addLine(to: .init(x: w * 0.88, y: h * 0.86))
            liq.addLine(to: .init(x: w * 0.78, y: h * 0.66))
            liq.closeSubpath()
            ctx.fill(liq, with: .color(Color(hex: 0x9FBF2E).opacity(0.5)))
        case .inhaler:
            var body_ = Path(roundedRect: .init(x: w * 0.22, y: h * 0.26,
                                                width: w * 0.40, height: h * 0.68),
                             cornerRadius: w * 0.10)
            stroke(body_, c, 1.7)
            var top = Path(roundedRect: .init(x: w * 0.30, y: h * 0.06,
                                              width: w * 0.24, height: h * 0.22),
                           cornerRadius: w * 0.06)
            stroke(top, c, 1.6)
            var air = Path()
            air.move(to: .init(x: w * 0.68, y: h * 0.40))
            air.addLine(to: .init(x: w * 0.92, y: h * 0.32))
            stroke(air, c.opacity(0.5), 1.4)
            body_ = Path(); top = Path()
        case .biotin:
            var cap = Path(roundedRect: .init(x: w * 0.14, y: h * 0.14,
                                              width: w * 0.72, height: h * 0.72),
                           cornerRadius: w * 0.26)
            stroke(cap, Color(hex: 0xC27C1E), 1.8)
            ctx.draw(Text("B7").font(.system(size: w * 0.34, weight: .bold))
                .foregroundStyle(Color(hex: 0xC27C1E)),
                     at: .init(x: w * 0.5, y: h * 0.52))
            cap = Path()
        }
    }
}

// MARK: - 等高线场：首屏的"填满"层
// 一组随时间起伏的等高线 —— 生理节律的视觉隐喻，也刚好能铺满整屏而不喧宾夺主。

struct LineField: View {
    var lines: Int = 16
    var tint: Color = T.lime
    var amplitude: Double = 1

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate * 0.22
            Canvas { ctx, s in
                let w = Double(s.width), h = Double(s.height)
                for i in 0..<lines {
                    let fi = Double(i) / Double(lines - 1)
                    let baseY = h * (0.10 + fi * 0.84)
                    var p = Path()
                    var x: Double = -10
                    while x <= w + 10 {
                        let u = x / w
                        let env = sin(u * .pi)                 // 两端收窄，中间鼓起
                        let y = baseY
                            + sin(u * 4.6 + t + fi * 2.4) * 16 * env * amplitude
                            + sin(u * 9.1 - t * 0.7 + fi * 1.1) * 6 * env * amplitude
                        if x < 0 { p.move(to: .init(x: x, y: y)) } else { p.addLine(to: .init(x: x, y: y)) }
                        x += 6
                    }
                    let a = 0.05 + 0.16 * sin(fi * .pi)
                    ctx.stroke(p, with: .color(tint.opacity(a)), lineWidth: 1)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
