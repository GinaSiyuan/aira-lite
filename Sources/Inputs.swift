import SwiftUI

/// 程度 → 颜色：好的一端黄绿，中段琥珀，坏的一端珊瑚红
/// p ∈ 0…1 为"坏→好"的位置
func gaugeTint(_ goodness: Double) -> Color {
    let g = max(0, min(1, goodness))
    // hue 0.015(红) → 0.10(橙) → 0.21(黄绿)
    return Color(hue: 0.015 + 0.195 * g, saturation: 0.78, brightness: 0.95)
}

// MARK: - TickBar：许多细条组成的程度条（连续拖动，分档读出）
// 替代纯文字选项：程度本来就是连续量。

struct TickBar: View {
    @Binding var value: Double          // 1…5
    var low: String
    var high: String
    var ticks: Int = 28
    var dark = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { g in
                let w = g.size.width
                let f = (value - 1) / 4
                HStack(spacing: 3) {
                    ForEach(0..<ticks, id: \.self) { i in
                        let p = Double(i) / Double(ticks - 1)
                        let on = p <= f
                        Capsule()
                            .fill(on ? gaugeTint(p) : (dark ? .white.opacity(0.16) : T.ink.opacity(0.12)))
                            .frame(height: on ? 30 : 22)
                            .frame(maxHeight: .infinity, alignment: .center)
                    }
                }
                .frame(width: w, height: 34)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0).onChanged { gv in
                    let p = max(0, min(1, gv.location.x / w))
                    let v = 1 + p * 4
                    if abs(v - value) > 0.02 {
                        if Int(v * 4) != Int(value * 4) { Haptic.soft() }
                        value = v
                    }
                })
            }
            .frame(height: 34)
            HStack {
                Text(low).font(.system(size: 10.5))
                    .foregroundStyle(dark ? .white.opacity(0.4) : T.ink3)
                Spacer()
                Text(high).font(.system(size: 10.5))
                    .foregroundStyle(dark ? .white.opacity(0.4) : T.ink3)
            }
        }
    }
}

// MARK: - TickRing：细长条切出来的刻度环（表圈式）
// 中心只放表情，读数放环外 —— 文字不再被环挡住。

struct TickRing: View {
    @Binding var value: Double          // 1…5
    var size: CGFloat = 230
    private let ticks = 56
    private let startDeg = 135.0        // 270° 弧
    private let sweep = 270.0

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                ForEach(0..<ticks, id: \.self) { i in
                    let p = Double(i) / Double(ticks - 1)
                    let on = p <= (value - 1) / 4
                    Capsule()
                        .fill(on ? gaugeTint(1 - p) : .white.opacity(0.14))
                        .frame(width: on ? 4 : 3, height: on ? 26 : 18)
                        .offset(y: -size / 2 + 16)
                        .rotationEffect(.degrees(startDeg + p * sweep + 90))
                }
                FaceSketch(level: value - 1, size: size * 0.26, color: .white, lineWidth: 2.4)
            }
            .frame(width: size, height: size * 0.82)
            .contentShape(Circle().scale(1.1))
            .gesture(DragGesture(minimumDistance: 0).onChanged { g in
                let c = CGPoint(x: size / 2, y: size * 0.41)
                // 以"正上方"为 0°、顺时针增长的角度
                var phi = atan2(g.location.x - c.x, -(g.location.y - c.y)) * 180 / .pi
                if phi < 0 { phi += 360 }
                let rel = (phi - 225 + 360).truncatingRemainder(dividingBy: 360)
                guard rel <= sweep + 20 else { return }
                let p = max(0, min(1, rel / sweep))
                let v = 1 + p * 4
                if Int(v * 6) != Int(value * 6) { Haptic.soft() }
                value = v
            })

            // 读数在环外，永不遮挡
            VStack(spacing: 3) {
                Text(stressWords[max(0, min(4, Int((value - 1).rounded())))])
                    .font(.system(size: 19, weight: .semibold)).tracking(-0.3)
                    .foregroundStyle(gaugeTint(1 - (value - 1) / 4))
                    .contentTransition(.opacity)
                Text(String(format: "%.1f / 5", value))
                    .font(.system(size: 12)).monospacedDigit()
                    .foregroundStyle(.white.opacity(0.45))
            }
        }
    }
    private var stressWords: [String] { ["Calm", "Fine", "A bit tense", "Tense", "Very tense"] }
}

// MARK: - RulerPick：横向标尺选数（年龄这类离散量比滑杆顺手得多）

struct RulerPick: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var unit: String
    @State private var base: Int? = nil

    private let step: CGFloat = 14      // 每格宽

    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(value)")
                    .font(.system(size: 40, weight: .semibold, design: .serif)).tracking(-1.2)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(value)))
                Text(unit).font(.system(size: 14)).foregroundStyle(T.ink3)
            }
            GeometryReader { g in
                let w = g.size.width
                ZStack {
                    // 刻度带
                    HStack(spacing: 0) {
                        ForEach(Array(range), id: \.self) { v in
                            VStack(spacing: 4) {
                                Capsule()
                                    .fill(v == value ? T.ink : T.ink.opacity(v % 5 == 0 ? 0.35 : 0.15))
                                    .frame(width: v == value ? 3 : 2,
                                           height: v == value ? 34 : (v % 5 == 0 ? 26 : 16))
                                if v % 10 == 0 {
                                    Text("\(v)").font(.system(size: 9)).monospacedDigit()
                                        .foregroundStyle(T.ink3)
                                        .fixedSize()
                                } else {
                                    Color.clear.frame(height: 11)
                                }
                            }
                            .frame(width: step)
                        }
                    }
                    .frame(width: CGFloat(range.count) * step)
                    .offset(x: w / 2 - (CGFloat(value - range.lowerBound) + 0.5) * step)
                    .animation(.interactiveSpring(response: 0.22, dampingFraction: 0.9), value: value)

                    // 中心指针
                    Capsule().fill(T.lime).frame(width: 4, height: 44).offset(y: -6)
                        .allowsHitTesting(false)
                }
                .frame(height: 58)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 2)
                    .onChanged { gv in
                        if base == nil { base = value }
                        let dv = -Int((gv.translation.width / step).rounded())
                        let nv = max(range.lowerBound, min(range.upperBound, (base ?? value) + dv))
                        if nv != value { Haptic.soft(); value = nv }
                    }
                    .onEnded { _ in base = nil })
            }
            .frame(height: 58)
            .mask(
                LinearGradient(colors: [.clear, .black, .black, .black, .clear],
                               startPoint: .leading, endPoint: .trailing)
            )
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
    }
}

// MARK: - 全天五管曲线：皮质醇形态上的 5 个采样点（替代干巴列表）

struct FiveTubesCurve: View {
    @EnvironmentObject var app: App
    @State private var sel = 0
    private let xs: [Double] = [0.06, 0.16, 0.44, 0.70, 0.94]
    private let ys: [Double] = [0.52, 0.92, 0.46, 0.30, 0.14]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { g in
                let w = g.size.width, h = g.size.height
                ZStack {
                    Canvas { ctx, s in
                        var p = Path()
                        let pts = xs.enumerated().map { CGPoint(x: s.width * xs[$0.offset],
                                                                y: s.height * (1 - ys[$0.offset]) * 0.82 + 6) }
                        for (i, pt) in pts.enumerated() {
                            if i == 0 { p.move(to: pt) } else {
                                let cx = (pts[i-1].x + pt.x) / 2
                                p.addCurve(to: pt, control1: .init(x: cx, y: pts[i-1].y),
                                           control2: .init(x: cx, y: pt.y))
                            }
                        }
                        ctx.stroke(p, with: .color(T.lime.opacity(0.9)),
                                   style: .init(lineWidth: 2.2, lineCap: .round))
                    }
                    ForEach(0..<5, id: \.self) { i in
                        let pt = CGPoint(x: w * xs[i], y: h * (1 - ys[i]) * 0.82 + 6)
                        Button {
                            Haptic.soft()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) { sel = i }
                        } label: {
                            ZStack {
                                if sel == i {
                                    Circle().fill(T.lime.opacity(0.22)).frame(width: 34, height: 34)
                                }
                                Circle().fill(sel == i ? T.lime : Color(hex: 0x1E2A22))
                                    .overlay(Circle().strokeBorder(sel == i ? .clear : T.lime.opacity(0.7), lineWidth: 1.6))
                                    .frame(width: sel == i ? 20 : 14, height: sel == i ? 20 : 14)
                                Text("\(i + 1)").font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(sel == i ? T.ink : .white.opacity(0.8))
                            }
                            .contentShape(Circle().scale(2))
                        }
                        .buttonStyle(.plain)
                        .position(pt)
                    }
                }
            }
            .frame(height: 104)

            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { i in
                    Text(app.points[i].when)
                        .font(.system(size: 9.5, weight: sel == i ? .bold : .regular)).monospacedDigit()
                        .foregroundStyle(sel == i ? T.lime : .white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 2)

            // 选中点的说明：一次只讲一件事
            VStack(alignment: .leading, spacing: 3) {
                Text(app.points[sel].name).font(.system(size: 13.5, weight: .semibold))
                Text(app.points[sel].hint).font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(.white.opacity(0.07)))
            .padding(.top, 12)
            .animation(.smooth(duration: 0.25), value: sel)
        }
    }
}
