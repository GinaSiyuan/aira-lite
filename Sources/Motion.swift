import SwiftUI

// MARK: - Orbital：Agent 的"deep think"
// 只在重节点出现：同步回读、Report generated、Joint analysis。日常回话不用它。

struct OrbitalThinking: View {
    var label: String = "Aira"
    var caption: String = ""
    var size: CGFloat = 150
    @State private var t: Double = 0

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60)) { tl in
            let now = tl.date.timeIntervalSinceReferenceDate
            ZStack {
                // 核心球：呼吸
                let pulse = 1 + 0.05 * sin(now * 1.7)
                Circle()
                    .fill(RadialGradient(colors: [T.lime.opacity(0.95), T.lime2.opacity(0.35), .clear],
                                         center: .init(x: 0.38, y: 0.32),
                                         startRadius: 0, endRadius: size * 0.42))
                    .frame(width: size * 0.5, height: size * 0.5)
                    .scaleEffect(pulse)
                    .blur(radius: 2)
                Circle()
                    .fill(T.ink)
                    .frame(width: size * 0.34, height: size * 0.34)
                    .scaleEffect(pulse)
                    .overlay(
                        Icon(.spark, size: size * 0.15, weight: 2, color: T.lime)
                            .scaleEffect(pulse)
                    )

                // 两道倾斜轨道
                ForEach(0..<2, id: \.self) { ring in
                    Ellipse()
                        .strokeBorder(.white.opacity(0.08), lineWidth: 1)
                        .frame(width: size * (ring == 0 ? 0.92 : 0.74),
                               height: size * (ring == 0 ? 0.36 : 0.28))
                        .rotationEffect(.degrees(ring == 0 ? -22 : 28))
                }

                // 沿轨道跑的字母
                let chars = Array(label.uppercased())
                ForEach(Array(chars.enumerated()), id: \.offset) { i, c in
                    let p = (now * 0.55 + Double(i) / Double(chars.count)).truncatingRemainder(dividingBy: 1)
                    let a = p * 2 * .pi
                    let rx = size * 0.46, ry = size * 0.18
                    let tilt = -22.0 * .pi / 180
                    let x0 = cos(a) * rx, y0 = sin(a) * ry
                    let x = x0 * cos(tilt) - y0 * sin(tilt)
                    let y = x0 * sin(tilt) + y0 * cos(tilt)
                    let front = sin(a) > 0
                    Text(String(c))
                        .font(.system(size: size * 0.11, weight: .bold, design: .rounded))
                        .foregroundStyle(front ? .white : .white.opacity(0.3))
                        .scaleEffect(front ? 1 : 0.8)
                        .offset(x: x, y: y)
                }

                // 轨道上的小卫星
                ForEach(0..<3, id: \.self) { i in
                    let p = (now * 0.33 + Double(i) / 3).truncatingRemainder(dividingBy: 1)
                    let a = p * 2 * .pi
                    let rx = size * 0.37, ry = size * 0.14
                    let tilt = 28.0 * .pi / 180
                    let x0 = cos(a) * rx, y0 = sin(a) * ry
                    Circle()
                        .fill(sin(a) > 0 ? T.lime : T.lime.opacity(0.3))
                        .frame(width: 5, height: 5)
                        .offset(x: x0 * cos(tilt) - y0 * sin(tilt),
                                y: x0 * sin(tilt) + y0 * cos(tilt))
                }
            }
            .frame(width: size, height: size)
        }
        .overlay(alignment: .bottom) {
            if !caption.isEmpty {
                Text(caption).font(.system(size: 12)).foregroundStyle(T.onD2)
                    .offset(y: 22)
            }
        }
    }
}

// MARK: - Stress波：波动程度随Stress指标变化
// 低压 = 几乎平直的长波；高压 = 高频、高振幅、多层叠加

struct StressTide: View {
    /// 0…1
    var level: Double
    var height: CGFloat = 112
    var tint: Color = T.lime

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 40)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, s in
                let w = s.width, h = s.height
                let layers = 4
                for k in 0..<layers {
                    let kf = Double(k) / Double(layers - 1)
                    // Stress越高：频率越高、振幅越大、相位越乱
                    let amp: Double = (3 + level * 20) * (1 - kf * 0.45)
                    let freq: Double = (1.1 + level * 2.6) + kf * 0.5
                    let speed: Double = 0.35 + level * 1.5 + kf * 0.2
                    let yBase: Double = Double(h) * (0.30 + kf * 0.42)
                    var p = Path()
                    var px: Double = 0
                    let wd = Double(w)
                    while px <= wd {
                        let u: Double = px / wd
                        let a1: Double = sin(u * 6.2831853 * freq + t * speed + Double(k))
                        let a2: Double = sin(u * 6.2831853 * freq * 1.9 + t * speed * 1.4)
                        let y: Double = Double(yBase) + a1 * amp + a2 * amp * 0.35 * level
                        let pt = CGPoint(x: px, y: y)
                        if px == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                        px += 3
                    }
                    let a = 0.9 - kf * 0.55
                    ctx.stroke(p, with: .color(tint.opacity(a)),
                               style: .init(lineWidth: k == 0 ? 2.2 : 1.3, lineCap: .round))
                }
            }
        }
        .frame(height: height)
        .drawingGroup()
    }
}

// MARK: - 线框球：把各项指标作为球面端点（Report用）

struct WireframeBall: View {
    struct Node { var name: String; var value: Double; var warn: Bool }
    var nodes: [Node]
    var size: CGFloat = 230
    @State private var drag: Double = 0

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 50)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate * 0.16 + drag
            Canvas { ctx, s in
                let c = CGPoint(x: s.width / 2, y: s.height / 2)
                let R = min(s.width, s.height) * 0.38

                // 经线纬线
                for i in 0..<7 {
                    let lat = (Double(i) / 6 - 0.5) * .pi * 0.92
                    var p = Path()
                    for j in 0...64 {
                        let lon = Double(j) / 64 * 2 * .pi + t
                        let pt = project(lat: lat, lon: lon, R: R, c: c)
                        if j == 0 { p.move(to: pt.0) } else { p.addLine(to: pt.0) }
                    }
                    ctx.stroke(p, with: .color(.white.opacity(0.10)), lineWidth: 0.8)
                }
                for i in 0..<10 {
                    let lon0 = Double(i) / 10 * 2 * .pi + t
                    var p = Path()
                    for j in 0...40 {
                        let lat = (Double(j) / 40 - 0.5) * .pi
                        let pt = project(lat: lat, lon: lon0, R: R, c: c)
                        if j == 0 { p.move(to: pt.0) } else { p.addLine(to: pt.0) }
                    }
                    ctx.stroke(p, with: .color(.white.opacity(0.07)), lineWidth: 0.8)
                }

                // 指标端点
                var pts: [(CGPoint, Bool, Bool, Double, String)] = []
                for (i, n) in nodes.enumerated() {
                    let lat = (Double(i) / Double(max(1, nodes.count - 1)) - 0.5) * .pi * 0.72
                    let lon = Double(i) / Double(nodes.count) * 2 * .pi * 1.7 + t
                    let (pt, front) = project(lat: lat, lon: lon, R: R * (0.72 + 0.3 * n.value), c: c)
                    pts.append((pt, front, n.warn, n.value, n.name))
                }
                // 连线
                for i in 0..<pts.count {
                    for j in (i + 1)..<pts.count where j - i <= 2 {
                        var p = Path()
                        p.move(to: pts[i].0); p.addLine(to: pts[j].0)
                        ctx.stroke(p, with: .color(.white.opacity(pts[i].1 && pts[j].1 ? 0.22 : 0.07)),
                                   lineWidth: 0.9)
                    }
                }
                for (pt, front, warn, _, name) in pts {
                    let r: CGFloat = front ? 5 : 3
                    var dot = Path()
                    dot.addEllipse(in: .init(x: pt.x - r, y: pt.y - r, width: r * 2, height: r * 2))
                    let col: Color = warn ? T.coral : T.lime
                    ctx.fill(dot, with: .color(front ? col : col.opacity(0.35)))
                    if front {
                        var halo = Path()
                        halo.addEllipse(in: .init(x: pt.x - r * 2.4, y: pt.y - r * 2.4,
                                                  width: r * 4.8, height: r * 4.8))
                        ctx.fill(halo, with: .color(col.opacity(0.16)))
                        ctx.draw(Text(name).font(.system(size: 9, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85)),
                                 at: .init(x: pt.x, y: pt.y - 15))
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .contentShape(Rectangle())
        .gesture(DragGesture().onChanged { g in drag = Double(g.translation.width) * 0.012 })
    }

    private func project(lat: Double, lon: Double, R: CGFloat, c: CGPoint) -> (CGPoint, Bool) {
        let x = cos(lat) * sin(lon)
        let y = sin(lat)
        let z = cos(lat) * cos(lon)
        let tilt = -0.32
        let y2 = y * cos(tilt) - z * sin(tilt)
        let z2 = y * sin(tilt) + z * cos(tilt)
        return (CGPoint(x: c.x + CGFloat(x) * R, y: c.y + CGFloat(y2) * R), z2 > 0)
    }
}

// MARK: - Neon reveal：加载条（授权回读等长任务）

struct NeonReveal: View {
    var progress: Double
    var height: CGFloat = 5
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 40)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            GeometryReader { g in
                let w = g.size.width
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.12))
                    Capsule()
                        .fill(LinearGradient(colors: [T.lime2, T.lime, .white, T.lime],
                                             startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(height, w * progress))
                        .shadow(color: T.lime.opacity(0.9), radius: 10)
                        .shadow(color: T.lime.opacity(0.5), radius: 22)
                    // 扫过的高光
                    Capsule().fill(.white.opacity(0.85))
                        .frame(width: 26, height: height)
                        .blur(radius: 6)
                        .offset(x: max(0, w * progress - 26) * CGFloat((sin(t * 1.6) + 1) / 2))
                        .opacity(progress > 0.02 && progress < 1 ? 1 : 0)
                        .mask(Capsule().frame(width: max(height, w * progress)).frame(maxWidth: .infinity, alignment: .leading))
                }
            }
        }
        .frame(height: height)
    }
}

// MARK: - Dappled light：舒缓氛围（Agent 顶部 / Unwind类场景）

struct DappledLight: View {
    var tint: Color = T.lime
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 24)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate * 0.12
            Canvas { ctx, s in
                for i in 0..<9 {
                    let fi = Double(i)
                    let x = (sin(t * (0.5 + fi * 0.07) + fi * 2.1) * 0.5 + 0.5) * s.width
                    let y = (cos(t * (0.4 + fi * 0.05) + fi * 1.3) * 0.5 + 0.5) * s.height
                    let r = 26 + 34 * (sin(t + fi) * 0.5 + 0.5)
                    var p = Path()
                    p.addEllipse(in: .init(x: x - r, y: y - r * 0.72, width: r * 2, height: r * 1.44))
                    ctx.fill(p, with: .color(tint.opacity(0.055)))
                }
            }
            .blur(radius: 18)
        }
        .allowsHitTesting(false)
    }
}

// MARK: - 文字球：AIRA 的字母悬浮环绕成一个球
// 字母用 Fibonacci 球面分布 → 绕 y 轴转 → 用 z 做景深（透明度 / 字号 / 模糊）。
// 背面的字不剔除，继续绘制但压暗，这样球心才是"空"的、能看穿。

struct TextSphere: View {
    var word: String = "AIRA"
    /// 球面上一共放多少个字（会循环取 word 的字母）
    var count: Int = 72
    var size: CGFloat = 240
    var speed: Double = 0.42
    var tint: Color = T.lime
    /// 0…1，越高越"紧张"：转速与抖动略增
    var energy: Double = 0.5

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60)) { tl in
            let now = tl.date.timeIntervalSinceReferenceDate
            let yaw = now * speed * (0.75 + energy * 0.6)
            Canvas { ctx, s in
                let c = CGPoint(x: s.width / 2, y: s.height / 2)
                let R = min(s.width, s.height) * 0.40
                let chars = Array(word.uppercased())
                let tilt = -0.26

                struct P { var pt: CGPoint; var z: Double; var ch: Character; var r: Double }
                var pts: [P] = []
                for i in 0..<count {
                    // Fibonacci 球面：均匀、不结块
                    let yv = 1 - (Double(i) / Double(count - 1)) * 2
                    let rad = sqrt(max(0, 1 - yv * yv))
                    let theta = Double(i) * 2.399963229728653 + yaw
                    // 轻微呼吸，让球不像死的刚体
                    let br = 1 + 0.035 * sin(now * 1.3 + Double(i) * 0.4) * (0.4 + energy)
                    let x = cos(theta) * rad
                    let z = sin(theta) * rad
                    let y2 = yv * cos(tilt) - z * sin(tilt)
                    let z2 = yv * sin(tilt) + z * cos(tilt)
                    pts.append(P(pt: CGPoint(x: c.x + CGFloat(x) * R * br,
                                             y: c.y + CGFloat(y2) * R * br),
                                 z: z2, ch: chars[i % chars.count], r: rad))
                }
                // 先远后近
                for p in pts.sorted(by: { $0.z < $1.z }) {
                    let d = (p.z + 1) / 2                    // 0 背面 … 1 正面
                    let fs = size * (0.040 + 0.042 * d)
                    let op = 0.16 + 0.84 * pow(d, 1.5)
                    let col = d > 0.62 ? Color.white : tint
                    var txt = ctx
                    if d < 0.45 { txt.addFilter(.blur(radius: (0.45 - d) * 7)) }
                    txt.draw(Text(String(p.ch))
                        .font(.system(size: fs, weight: d > 0.6 ? .bold : .medium, design: .rounded))
                        .foregroundStyle(col.opacity(op)),
                             at: p.pt)
                }
            }
            .frame(width: size, height: size)
            .background(
                // 球心的光：字在它前面飘，所以球是"发光的空心"
                RadialGradient(colors: [tint.opacity(0.30), tint.opacity(0.06), .clear],
                               center: .center, startRadius: 0, endRadius: size * 0.42)
                    .blur(radius: 18)
            )
        }
        .frame(width: size, height: size)
    }
}
