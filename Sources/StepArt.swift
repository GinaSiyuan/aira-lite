import SwiftUI

// MARK: - 采集步骤场景插画
// 没有实拍素材时的正式视觉（不是兜底数字）：大幅线稿 + 柠檬点缀，
// 和 SampleKitMark / MedIcon 同一套手绘语言。Assets/guideN.png 存在时自动让位。

struct StepArt: View {
    var index: Int

    var body: some View {
        GeometryReader { g in
            let w = g.size.width, h = g.size.height
            ZStack {
                // 衬底光晕
                RadialGradient(colors: [T.lime.opacity(0.35), T.lime.opacity(0.08), .clear],
                               center: .init(x: 0.5, y: 0.46),
                               startRadius: 0, endRadius: min(w, h) * 0.52)
                Canvas { ctx, s in
                    draw(&ctx, s)
                }
                .frame(width: min(w, h) * 0.62, height: min(w, h) * 0.62)
                .offset(y: -h * 0.04)
            }
        }
        .allowsHitTesting(false)
    }

    private func draw(_ ctx: inout GraphicsContext, _ s: CGSize) {
        let w = s.width, h = s.height
        let ink = T.ink
        func stroke(_ p: Path, _ c: Color = T.ink, _ lw: CGFloat = 3) {
            ctx.stroke(p, with: .color(c), style: .init(lineWidth: lw, lineCap: .round, lineJoin: .round))
        }
        func fill(_ p: Path, _ c: Color) { ctx.fill(p, with: .color(c)) }

        switch index {
        case 0:
            // 玻璃杯 + 水面 + 上升气泡：漱口
            var cup = Path()
            cup.move(to: .init(x: w * 0.30, y: h * 0.18))
            cup.addLine(to: .init(x: w * 0.36, y: h * 0.86))
            cup.addQuadCurve(to: .init(x: w * 0.64, y: h * 0.86), control: .init(x: w * 0.50, y: h * 0.93))
            cup.addLine(to: .init(x: w * 0.70, y: h * 0.18))
            stroke(cup)
            var water = Path()
            water.move(to: .init(x: w * 0.335, y: h * 0.46))
            water.addCurve(to: .init(x: w * 0.665, y: h * 0.46),
                           control1: .init(x: w * 0.44, y: h * 0.40),
                           control2: .init(x: w * 0.56, y: h * 0.52))
            stroke(water, T.ink, 2.4)
            var wfill = water
            wfill.addLine(to: .init(x: w * 0.645, y: h * 0.84))
            wfill.addQuadCurve(to: .init(x: w * 0.355, y: h * 0.84), control: .init(x: w * 0.5, y: h * 0.90))
            wfill.closeSubpath()
            fill(wfill, T.lime.opacity(0.45))
            for (bx, by, r) in [(0.45, 0.30, 0.035), (0.56, 0.24, 0.025), (0.50, 0.12, 0.03)] {
                var b = Path()
                b.addEllipse(in: .init(x: w * bx - w * r, y: h * by - w * r, width: w * r * 2, height: w * r * 2))
                stroke(b, ink.opacity(0.5), 2)
            }
        case 1:
            // 表盘 + 10 分钟扇形：等待
            var face = Path()
            face.addEllipse(in: .init(x: w * 0.14, y: h * 0.14, width: w * 0.72, height: w * 0.72))
            stroke(face)
            var wedge = Path()
            let c = CGPoint(x: w * 0.5, y: h * 0.14 + w * 0.36)
            wedge.move(to: c)
            wedge.addArc(center: c, radius: w * 0.30,
                         startAngle: .degrees(-90), endAngle: .degrees(-30), clockwise: false)
            wedge.closeSubpath()
            fill(wedge, T.lime.opacity(0.65))
            for i in 0..<12 {
                let a = Double(i) / 12 * 2 * .pi
                var t = Path()
                t.move(to: .init(x: c.x + cos(a) * w * 0.33, y: c.y + sin(a) * w * 0.33))
                t.addLine(to: .init(x: c.x + cos(a) * w * 0.36, y: c.y + sin(a) * w * 0.36))
                stroke(t, ink.opacity(0.55), 2)
            }
            var hand = Path()
            hand.move(to: c); hand.addLine(to: .init(x: c.x, y: c.y - w * 0.26))
            stroke(hand, ink, 3.4)
            var hand2 = Path()
            hand2.move(to: c)
            hand2.addLine(to: .init(x: c.x + w * 0.15, y: c.y - w * 0.255))
            stroke(hand2, ink, 2.6)
            var dot = Path()
            dot.addEllipse(in: .init(x: c.x - 4, y: c.y - 4, width: 8, height: 8))
            fill(dot, ink)
        case 2:
            // 唇形轮廓 + 舌下采样棒：含棒 2 分钟
            var lips = Path()
            lips.move(to: .init(x: w * 0.14, y: h * 0.40))
            lips.addQuadCurve(to: .init(x: w * 0.50, y: h * 0.30), control: .init(x: w * 0.30, y: h * 0.26))
            lips.addQuadCurve(to: .init(x: w * 0.86, y: h * 0.40), control: .init(x: w * 0.70, y: h * 0.26))
            lips.addQuadCurve(to: .init(x: w * 0.50, y: h * 0.62), control: .init(x: w * 0.72, y: h * 0.62))
            lips.addQuadCurve(to: .init(x: w * 0.14, y: h * 0.40), control: .init(x: w * 0.28, y: h * 0.62))
            stroke(lips)
            var swab = Path()
            swab.move(to: .init(x: w * 0.54, y: h * 0.46))
            swab.addLine(to: .init(x: w * 0.78, y: h * 0.88))
            stroke(swab, ink, 3.4)
            var tip = Path()
            tip.addEllipse(in: .init(x: w * 0.50, y: h * 0.40, width: w * 0.09, height: w * 0.09))
            fill(tip, T.lime)
            stroke(tip, ink, 2)
            var t2 = Path()
            t2.move(to: .init(x: w * 0.30, y: h * 0.78))
            t2.addQuadCurve(to: .init(x: w * 0.44, y: h * 0.82), control: .init(x: w * 0.37, y: h * 0.84))
            stroke(t2, ink.opacity(0.45), 2.2)
        case 3:
            // 管 + 棒投入 + 咔哒盖
            var tube = Path(roundedRect: .init(x: w * 0.36, y: h * 0.30, width: w * 0.24, height: h * 0.60),
                            cornerRadius: w * 0.10)
            stroke(tube)
            var liq = Path(roundedRect: .init(x: w * 0.395, y: h * 0.66, width: w * 0.17, height: h * 0.20),
                           cornerRadius: w * 0.07)
            fill(liq, T.lime.opacity(0.5))
            var swab = Path()
            swab.move(to: .init(x: w * 0.47, y: h * 0.34))
            swab.addLine(to: .init(x: w * 0.62, y: h * 0.06))
            stroke(swab, ink, 3.2)
            var cap = Path(roundedRect: .init(x: w * 0.30, y: h * 0.16, width: w * 0.20, height: h * 0.10),
                           cornerRadius: w * 0.03)
            fill(cap, ink)
            // 咔哒线
            for a in [-0.5, 0.0, 0.5] {
                var k = Path()
                let cx = w * 0.70, cy = h * 0.22
                k.move(to: .init(x: cx + a * 10, y: cy - 12))
                k.addLine(to: .init(x: cx + a * 16, y: cy - 24))
                stroke(k, T.fogLime, 2.4)
            }
        case 4:
            // 管身标签 + 笔
            var tube = Path(roundedRect: .init(x: w * 0.16, y: h * 0.34, width: w * 0.52, height: h * 0.26),
                            cornerRadius: h * 0.10)
            stroke(tube)
            var label = Path(roundedRect: .init(x: w * 0.22, y: h * 0.39, width: w * 0.30, height: h * 0.16),
                             cornerRadius: 4)
            fill(label, .white)
            stroke(label, ink, 2)
            var line1 = Path()
            line1.move(to: .init(x: w * 0.25, y: h * 0.455))
            line1.addLine(to: .init(x: w * 0.44, y: h * 0.455))
            stroke(line1, T.fogLime, 2.6)
            var line2 = Path()
            line2.move(to: .init(x: w * 0.25, y: h * 0.51))
            line2.addLine(to: .init(x: w * 0.38, y: h * 0.51))
            stroke(line2, ink.opacity(0.4), 2)
            var cap2 = Path(roundedRect: .init(x: w * 0.68, y: h * 0.37, width: w * 0.10, height: h * 0.20),
                            cornerRadius: 4)
            fill(cap2, ink)
            // 笔
            var pen = Path()
            pen.move(to: .init(x: w * 0.52, y: h * 0.86))
            pen.addLine(to: .init(x: w * 0.84, y: h * 0.18))
            stroke(pen, ink, 4)
            var nib = Path()
            nib.move(to: .init(x: w * 0.52, y: h * 0.86))
            nib.addLine(to: .init(x: w * 0.475, y: h * 0.95))
            stroke(nib, T.fogLime, 4)
        default:
            break
        }
    }
}
