import SwiftUI

// MARK: - 梳状计量（核心图元：一排可数的离散刻度，不是进度条）

struct Comb: View {
    var count: Int = 32
    var filled: Double              // 0…1
    var height: CGFloat = 26
    var tint: Color = T.lime
    /// 预亮的参考区间（索引范围）
    var band: ClosedRange<Int>? = nil
    /// 白色当前游标
    var cursor: Int? = nil
    /// 从第 n 根起为"future placeholder"
    var ghostFrom: Int? = nil

    var body: some View {
        let on = Int((Double(count) * filled).rounded())
        HStack(spacing: 2) {
            ForEach(0..<count, id: \.self) { i in
                Capsule(style: .continuous)
                    .fill(color(i, on: on))
                    .shadow(color: i < on ? tint.opacity(0.75) : .clear, radius: 5)
                    .shadow(color: i < on ? tint.opacity(0.35) : .clear, radius: 12)
            }
        }
        .frame(height: height)
        .animation(.easeOut(duration: 0.45), value: filled)
    }

    private func color(_ i: Int, on: Int) -> Color {
        if let g = ghostFrom, i >= g { return .white.opacity(0.07) }
        if cursor == i { return .white }
        if i < on { return tint }
        if let b = band, b.contains(i) { return tint.opacity(0.26) }
        return .white.opacity(0.26)
    }
}

// MARK: - 读数：数字 + 单位 + 方向 + baseline出处（B 层最高频组件）

struct Readout: View {
    var label: String
    var value: String
    var unit: String? = nil
    var delta: String? = nil
    /// 方向由数值定，颜色由语义定 —— 两件事分开传
    var deltaIsBad: Bool = true
    var baseline: String? = nil
    var size: CGFloat = 32

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).label11()
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value).numeral(size)
                    if let u = unit { Text(u).unitText() }
                }
                Spacer(minLength: 6)
                if let d = delta {
                    Text(d)
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundStyle(deltaIsBad ? T.coral : T.lime)
                }
            }
            if let b = baseline {
                Text(b).font(.system(size: 10.5)).foregroundStyle(T.onD3).lineSpacing(1)
            }
        }
    }
}

// MARK: - 状态 chip

enum ChipTone { case good, warn, off, sky }

struct Chip: View {
    var text: String
    var tone: ChipTone = .good
    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(dot).frame(width: 5, height: 5)
                .shadow(color: tone == .off ? .clear : dot.opacity(0.7), radius: 4)
            Text(text).font(.system(size: 10.5, weight: .medium))
        }
        .padding(.horizontal, 9).padding(.vertical, 4)
        .background(Capsule().fill(.white.opacity(0.13)))
        .foregroundStyle(.white)
    }
    private var dot: Color {
        switch tone { case .good: T.lime; case .warn: T.coral; case .off: T.onD3; case .sky: T.sky }
    }
}

// MARK: - 三栏副读数

struct StatTrio: View {
    struct Item: Identifiable { let id = UUID(); var v: String; var k: String; var hint: String? = nil }
    var items: [Item]
    var divider: Bool = true
    var body: some View {
        VStack(spacing: 0) {
            if divider { Rectangle().fill(T.hairD).frame(height: 1).padding(.bottom, 13) }
            HStack(alignment: .top, spacing: 8) {
                ForEach(items) { it in
                    VStack(alignment: .leading, spacing: 3) {
                        Text(it.v).numeral(16)
                        HStack(spacing: 4) {
                            Text(it.k).font(.system(size: 10)).foregroundStyle(T.onD3)
                            if let h = it.hint {
                                Text(h).font(.system(size: 10, weight: .semibold)).foregroundStyle(T.coral)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.top, 14)
    }
}

// MARK: - Caveat条（C6 · 产品核心特征，和结论同级，带可执行的消解路径）

struct Qualifier: View {
    var head: String
    var body_: String
    var action: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Caveat · \(head)")
                .font(.system(size: 9, weight: .bold)).tracking(1.4)
                .textCase(.uppercase).foregroundStyle(T.sky)
            Text(body_).font(.system(size: 12)).foregroundStyle(.white).lineSpacing(2)
            if let a = action {
                Divider().overlay(T.hairD).padding(.vertical, 3)
                Button {
                    Haptic.tap(); onAction?()
                } label: {
                    HStack(spacing: 6) {
                        Text("↳ \(a)").font(.system(size: 11.5, weight: .medium))
                        Image(systemName: "arrow.right").font(.system(size: 9, weight: .bold))
                    }
                    .foregroundStyle(T.sky)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 11).padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
            .strokeBorder(.white.opacity(0.09), lineWidth: 1))
        .padding(.top, 12)
    }
}

// MARK: - CTA 胶囊 + 旋钮（左文右钮的不对称结构是风格的一部分）

struct CTA: View {
    var title: String
    var dark: Bool = false
    var action: () -> Void
    var body: some View {
        Button { Haptic.tap(); action() } label: {
            HStack(spacing: 14) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(dark ? .white : T.ink)
                Spacer(minLength: 0)
                ZStack {
                    Circle().fill(dark ? T.lime : T.ink).frame(width: 42, height: 42)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(dark ? T.ink : .white)
                }
            }
            .padding(.leading, 22).padding(.trailing, 5)
            .padding(.vertical, 5)
            .background(Capsule().fill(dark ? T.ink : T.lime))
            .shadow(color: (dark ? Color.black : T.lime).opacity(0.35), radius: 14, y: 8)
        }
        .buttonStyle(PressStyle())
    }
}

struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.26, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct GhostButton: View {
    var title: String
    var icon: String? = nil
    var onDark: Bool = true
    var action: () -> Void
    var body: some View {
        Button { Haptic.tap(); action() } label: {
            HStack(spacing: 6) {
                if let i = icon { Image(systemName: i).font(.system(size: 11, weight: .semibold)) }
                Text(title).font(.system(size: 12.5, weight: .medium))
            }
            .padding(.horizontal, 13).padding(.vertical, 8)
            .background(Capsule().fill(onDark ? .white.opacity(0.1) : T.hair2))
            .overlay(Capsule().strokeBorder(onDark ? .white.opacity(0.18) : T.hair, lineWidth: 1))
            .foregroundStyle(onDark ? T.onD2 : T.ink2)
        }
        .buttonStyle(PressStyle())
    }
}

// MARK: - 磨砂图标徽

struct IBadge: View {
    var icon: Ico
    var body: some View {
        ZStack {
            Circle().fill(.white.opacity(0.12))
            Circle().strokeBorder(.white.opacity(0.06), lineWidth: 1)
            Icon(icon, size: 16, weight: 1.7, color: .white)
        }
        .frame(width: 30, height: 30)
    }
}

// MARK: - 卡头

struct CardHead: View {
    var icon: Ico
    var title: String
    var sub: String
    var chip: String? = nil
    var chipTone: ChipTone = .warn
    var trailing: AnyView? = nil
    var body: some View {
        HStack(alignment: .center, spacing: 9) {
            IBadge(icon: icon)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 13, weight: .semibold)).tracking(-0.1)
                Text(sub).font(.system(size: 10.5)).foregroundStyle(T.onD3)
            }
            Spacer(minLength: 6)
            if let c = chip { Chip(text: c, tone: chipTone) }
            if let t = trailing { t }
        }
    }
}

// MARK: - 表情简笔画（连续插值；只挂在Self轨上，绝不表示客观测量）

struct FaceSketch: View {
    /// 0…4 连续
    var level: Double
    var size: CGFloat = 30
    var color: Color = .white
    var lineWidth: CGFloat = 1.7

    var body: some View {
        Canvas { ctx, s in
            let u = s.width / 40
            let bi = lerp([-2, -1, 0, 3, 5], level)
            let bo = lerp([-2, -1, 0, -1, -3], level)
            let m  = lerp([7, 4, 0, -4, -7], level)
            let eo = lerp([0, 0, 0, 0.6, 1.2], level)

            var circle = Path()
            circle.addEllipse(in: CGRect(x: 5 * u, y: 5 * u, width: 30 * u, height: 30 * u))
            ctx.stroke(circle, with: .color(color), lineWidth: lineWidth)

            var brows = Path()
            brows.move(to: CGPoint(x: 11 * u, y: (15 + bi) * u))
            brows.addLine(to: CGPoint(x: 16 * u, y: (15 + bo) * u))
            brows.move(to: CGPoint(x: 29 * u, y: (15 + bi) * u))
            brows.addLine(to: CGPoint(x: 24 * u, y: (15 + bo) * u))
            ctx.stroke(brows, with: .color(color), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            for ex in [15.5, 24.5] {
                var e = Path()
                e.addEllipse(in: CGRect(x: (ex - 1.3) * u, y: (20 - eo * 0.4 - (1.5 - eo * 0.35)) * u,
                                        width: 2.6 * u, height: (1.5 - eo * 0.35) * 2 * u))
                ctx.fill(e, with: .color(color))
            }

            var mouth = Path()
            mouth.move(to: CGPoint(x: 14 * u, y: (27 - m * 0.22) * u))
            mouth.addQuadCurve(to: CGPoint(x: 26 * u, y: (27 - m * 0.22) * u),
                               control: CGPoint(x: 20 * u, y: (27 + m * 0.78) * u))
            ctx.stroke(mouth, with: .color(color), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        }
        .frame(width: size, height: size)
    }

    private func lerp(_ a: [Double], _ t: Double) -> Double {
        let x = max(0, min(Double(a.count - 1), t))
        let i = Int(x), f = x - Double(i)
        return i >= a.count - 1 ? a[a.count - 1] : a[i] + (a[i + 1] - a[i]) * f
    }
}

let faceNames = ["Calm", "Fine", "A bit tense", "Tense", "Very tense"]

// MARK: - 自由刻度环（连续输入，分档输出）

struct DialRing: View {
    @Binding var value: Double      // 1.0…5.0
    var size: CGFloat = 252

    private let gap: Double = 74
    private var start: Double { 90 + gap / 2 }
    private var span: Double { 360 - gap }

    var body: some View {
        let t = (value - 1) / 4
        ZStack {
            Circle()
                .trim(from: 0, to: span / 360)
                .stroke(.white.opacity(0.10), style: StrokeStyle(lineWidth: 26, lineCap: .round))
                .rotationEffect(.degrees(start))

            ForEach(0..<64, id: \.self) { i in
                let f = Double(i) / 64
                if f <= t + 0.001 {
                    Circle()
                        .trim(from: f * span / 360, to: min(t, (f + 1.0 / 64)) * span / 360 + 0.004)
                        .stroke(ramp(f), style: StrokeStyle(lineWidth: 26, lineCap: i == 0 ? .round : .butt))
                        .rotationEffect(.degrees(start))
                }
            }

            ForEach(0..<5, id: \.self) { i in
                let a = Angle.degrees(start + span * Double(i) / 4)
                Rectangle().fill(.white.opacity(0.3)).frame(width: 1, height: 32)
                    .offset(y: -(size / 2 - 13))
                    .rotationEffect(a + .degrees(90))
                Text(faceNames[i])
                    .font(.system(size: 9.5, weight: i == band ? .semibold : .regular))
                    .foregroundStyle(i == band ? .white : T.onD3.opacity(1.3))
                    .offset(x: cos(a.radians) * (size / 2 + 16), y: sin(a.radians) * (size / 2 + 16))
            }

            Circle().fill(.white.opacity(0.04)).frame(width: size - 72, height: size - 72)

            VStack(spacing: 6) {
                FaceSketch(level: value - 1, size: 44)
                Text(faceNames[band]).font(.system(size: 19, weight: .semibold)).tracking(-0.4)
                Text(String(format: "%.1f / 5", value)).font(.system(size: 12)).foregroundStyle(T.onD3)
            }

            // 游标
            Circle().fill(ramp(t)).frame(width: 30, height: 30)
                .overlay(Circle().strokeBorder(T.dark, lineWidth: 3))
                .overlay(Circle().fill(T.dark.opacity(0.5)).frame(width: 9, height: 9))
                .offset(x: cos(Angle.degrees(start + span * t).radians) * size / 2,
                        y: sin(Angle.degrees(start + span * t).radians) * size / 2)
        }
        .frame(width: size, height: size)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0).onChanged { g in
                let c = CGPoint(x: size / 2, y: size / 2)
                var deg = atan2(g.location.y - c.y, g.location.x - c.x) * 180 / .pi
                var rel = deg - start
                while rel < 0 { rel += 360 }
                while rel > 360 { rel -= 360 }
                if rel > span { rel = (rel - span) < (360 - rel) ? span : 0 }
                let nv = 1 + 4 * (rel / span)
                if abs(nv - value) > 0.01 { Haptic.soft() }
                value = nv
                _ = deg
            }
        )
    }

    private var band: Int { max(0, min(4, Int((value - 1).rounded()))) }

    private func ramp(_ t: Double) -> Color {
        let stops: [Color] = [T.lime, Color(hex: 0xCDE86A), Color(hex: 0xFFD86B), T.amber, T.coral]
        let x = max(0, min(3.999, t * 4)); let i = Int(x); let f = x - Double(i)
        return stops[i].mix(stops[i + 1], f)
    }
}

extension Color {
    func mix(_ other: Color, _ t: Double) -> Color {
        let a = UIColor(self), b = UIColor(other)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        a.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        b.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let f = CGFloat(t)
        return Color(.sRGB, red: Double(r1 + (r2 - r1) * f), green: Double(g1 + (g2 - g1) * f),
                     blue: Double(b1 + (b2 - b1) * f), opacity: 1)
    }
}

// MARK: - 质量标记（显式处理，不隐藏）

struct QualityBadge: View {
    var text: String
    var note: String? = nil
    var critical: Bool = false
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(critical ? T.amber : T.onD3)
            VStack(alignment: .leading, spacing: 2) {
                Text(text).font(.system(size: 11.5, weight: .medium))
                if let n = note { Text(n).font(.system(size: 10)).foregroundStyle(T.onD3) }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12).padding(.vertical, 9)
        .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(.white.opacity(0.06)))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
            .strokeBorder(critical ? T.amber.opacity(0.8) : .white.opacity(0.2),
                          style: StrokeStyle(lineWidth: 1, dash: critical ? [5, 4] : [])))
        .foregroundStyle(.white)
    }
}

// MARK: - 分节标题

struct SectionLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold)).tracking(1.6)
            .textCase(.uppercase).foregroundStyle(T.ink3)
    }
}
