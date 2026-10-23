import SwiftUI

// MARK: - Design tokens（今天确定的 Design Direction：软壳 + 雾面卡 + 柠檬绿）

enum T {
    static let page      = Color(hex: 0xEDEDEC)
    static let card      = Color.white
    static let ink       = Color(hex: 0x101011)
    static let ink2      = Color(hex: 0x6B6B6E)
    static let ink3      = Color(hex: 0xA1A1A5)
    static let hair      = Color(hex: 0xE6E6E5)
    static let hair2     = Color(hex: 0xF3F3F1)

    static let dark      = Color(hex: 0x0B0B0C)
    static let onD2      = Color.white.opacity(0.58)
    static let onD3      = Color.white.opacity(0.34)
    static let hairD     = Color.white.opacity(0.12)

    static let lime      = Color(hex: 0xDCF55A)
    // 材质层专用：低饱和，只用于渐变底
    static let fogLime   = Color(hex: 0xA8BF4A)
    static let fogWarm   = Color(hex: 0x3A3A33)
    static let fogSky    = Color(hex: 0x5E89A8)
    static let fogViolet = Color(hex: 0x6F5F94)
    static let fogCoral  = Color(hex: 0xA8603F)
    static let fogAmber  = Color(hex: 0x9E7A3A)
    static let lime2     = Color(hex: 0xD6FF3C)
    static let coral     = Color(hex: 0xFF8A5B)
    static let amber     = Color(hex: 0xFFB85C)
    static let sky       = Color(hex: 0x7ACBFF)
    static let violet    = Color(hex: 0xB79BFF)

    static let rShell: CGFloat = 30
    static let rCard:  CGFloat = 22
    static let rSm:    CGFloat = 14
}

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red:   Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8)  & 0xFF) / 255,
                  blue:  Double(hex & 0xFF)         / 255,
                  opacity: 1)
    }
}

// MARK: - Typography
// 规则：数字 600 / -0.04em / tabular；单位降一级灰；状态词在数字之前

extension View {
    func numeral(_ size: CGFloat) -> some View {
        self.font(.system(size: size, weight: .semibold, design: .default))
            .monospacedDigit()
            .tracking(-size * 0.035)
    }
    func unitText() -> some View {
        self.font(.system(size: 12.5, weight: .regular)).foregroundStyle(T.onD2)
    }
    func label11() -> some View { self.font(.system(size: 11)).foregroundStyle(T.onD3) }
    func micro() -> some View {
        self.font(.system(size: 10, weight: .semibold)).tracking(1.5)
            .textCase(.uppercase).foregroundStyle(T.ink3)
    }
}

// MARK: - Fog（四层径向渐变整体模糊 → 光从卡外渗进来）

enum FogTone { case warm, cool, flat, alert }

// MARK: - Dark Frosted Gradient Glass
// ① 多层径向渐变底（深炭灰 / 暖灰 / 低饱和荧光黄绿，黄绿聚在左下向中心扩散）
// ② 半透明深灰磨砂蒙层 —— 让底色漫反射，消掉清晰的色块边界
// ③ Soft vignette + Inner shadow —— 边缘偏暗、内部透光
// 不用高透明玻璃、不用白描边、不用强外阴影、不用过饱和霓虹

struct Fog: View {
    var tone: FogTone = .warm
    var radius: CGFloat = T.rCard

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let m = max(w, h)
            ZStack {
                // ① 渐变底
                Color(hex: 0x151514)
                ZStack {
                    switch tone {
                    case .warm:
                        blob(T.fogLime.opacity(0.92), x: -0.02, y: 1.04, r: m * 1.06, w: w, h: h)
                        blob(T.fogLime.opacity(0.46), x: 0.46, y: 1.16, r: m * 0.84, w: w, h: h)
                        blob(T.fogWarm.opacity(0.80), x: 0.90, y: -0.04, r: m * 0.78, w: w, h: h)
                    case .cool:
                        blob(T.fogSky.opacity(0.82),  x: -0.02, y: 1.04, r: m * 1.06, w: w, h: h)
                        blob(T.fogViolet.opacity(0.52), x: 0.50, y: 1.16, r: m * 0.84, w: w, h: h)
                        blob(T.fogWarm.opacity(0.76), x: 0.90, y: -0.04, r: m * 0.76, w: w, h: h)
                    case .alert:
                        blob(T.fogCoral.opacity(0.86), x: 1.02, y: 1.04, r: m * 1.06, w: w, h: h)
                        blob(T.fogAmber.opacity(0.48), x: 0.52, y: 1.16, r: m * 0.84, w: w, h: h)
                        blob(T.fogWarm.opacity(0.76), x: 0.10, y: -0.04, r: m * 0.76, w: w, h: h)
                    case .flat:
                        blob(T.fogWarm.opacity(0.95), x: 0.22, y: 1.06, r: m * 1.02, w: w, h: h)
                        blob(T.fogLime.opacity(0.30), x: 0.00, y: 1.14, r: m * 0.80, w: w, h: h)
                        blob(T.fogWarm.opacity(0.70), x: 0.90, y: -0.04, r: m * 0.72, w: w, h: h)
                    }
                }
                .blur(radius: 62)

                // ② 深灰磨砂蒙层：朦胧漫反射
                Color(hex: 0x17171A).opacity(0.24)
                    .blendMode(.normal)

                // ③ Soft vignette：边缘偏暗，内部透光
                RadialGradient(colors: [.clear, .clear, Color.black.opacity(0.30)],
                               center: .init(x: 0.40, y: 0.52),
                               startRadius: m * 0.30, endRadius: m * 0.92)

                // ③ Inner shadow
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .inset(by: -14)
                    .stroke(Color.black.opacity(0.42), lineWidth: 20)
                    .blur(radius: 14)
                    .mask(RoundedRectangle(cornerRadius: radius, style: .continuous))

                // 极弱的顶部材质过渡，不是描边
                LinearGradient(colors: [Color.white.opacity(0.035), .clear],
                               startPoint: .top, endPoint: .init(x: 0.5, y: 0.26))
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
        // 材质是纯装饰：巨大的光斑不能变成命中区域
        .allowsHitTesting(false)
    }
    private func blob(_ c: Color, x: CGFloat, y: CGFloat, r: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        RadialGradient(colors: [c, c.opacity(0.42), c.opacity(0)],
                       center: .center, startRadius: 0, endRadius: r)
            .frame(width: r * 2, height: r * 2)
            .position(x: w * x, y: h * y)
    }
}

/// 深色磨砂玻璃卡
struct FogCard<Content: View>: View {
    var tone: FogTone = .warm
    var radius: CGFloat = T.rCard
    var padding: CGFloat = 17
    @ViewBuilder var content: Content
    var body: some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Fog(tone: tone, radius: radius))
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(tone == .alert ? T.amber.opacity(0.55) : Color.white.opacity(0.055),
                                  lineWidth: tone == .alert ? 1.2 : 1)
            )
            .contentShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            // 弱外阴影：只用来托起，不制造硬边
            .shadow(color: .black.opacity(0.16), radius: 20, x: 0, y: 10)
            .foregroundStyle(.white)
    }
}

/// 白色软壳（三重阴影）
struct Shell<Content: View>: View {
    var radius: CGFloat = T.rShell
    var padding: CGFloat = 16
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(T.card)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: Color(hex: 0x101012).opacity(0.04), radius: 1,  x: 0, y: 1)
            .shadow(color: Color(hex: 0x101012).opacity(0.10), radius: 16, x: 0, y: 10)
            .shadow(color: Color(hex: 0x101012).opacity(0.14), radius: 44, x: 0, y: 28)
    }
}

/// 浅色卡（Self类数据专用——属于用户，不属于系统）
struct LiteCard<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: 0xF6F6F4))
            .clipShape(RoundedRectangle(cornerRadius: T.rCard, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: T.rCard, style: .continuous)
                .strokeBorder(T.hair, lineWidth: 1))
            .foregroundStyle(T.ink)
    }
}

// MARK: - 页面底色

struct PageBG: View {
    var body: some View {
        ZStack {
            T.page
            RadialGradient(colors: [Color(hex: 0xF8F8F7), .clear],
                           center: .init(x: 0.5, y: -0.08),
                           startRadius: 0, endRadius: 520)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Haptics

enum Haptic {
    static func tap()  { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func soft() { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }
    static func ok()   { UINotificationFeedbackGenerator().notificationOccurred(.success) }
}

// MARK: - 整屏雾面（Agent 轨道专用：蓝绿渐变 + 磨砂）
// 和 FogCard 同一套配方，只是放大到整屏、把晕开半径拉大，
// 这样卡片浮在上面时不会出现"两种玻璃"的割裂感。

struct FogScreen: View {
    var tone: FogTone = .cool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let m = max(w, h)
            ZStack {
                Color(hex: 0x0E1416)
                ZStack {
                    switch tone {
                    case .cool:
                        blob(Color(hex: 0x2E8C86).opacity(0.95), x: -0.05, y: 0.96, r: m * 0.94, w: w, h: h)
                        blob(Color(hex: 0x3E7FA6).opacity(0.70), x: 0.62,  y: 1.08, r: m * 0.80, w: w, h: h)
                        blob(Color(hex: 0x1F3C4A).opacity(0.85), x: 1.02,  y: 0.08, r: m * 0.78, w: w, h: h)
                        blob(Color(hex: 0x35706B).opacity(0.40), x: 0.10,  y: 0.40, r: m * 0.54, w: w, h: h)
                    case .warm:
                        blob(T.fogLime.opacity(0.88),  x: -0.04, y: 1.02, r: m * 0.96, w: w, h: h)
                        blob(T.fogWarm.opacity(0.80),  x: 0.94,  y: 0.04, r: m * 0.74, w: w, h: h)
                    case .alert:
                        blob(T.fogCoral.opacity(0.84), x: 1.02, y: 1.00, r: m * 0.94, w: w, h: h)
                        blob(T.fogAmber.opacity(0.46), x: 0.46, y: 1.10, r: m * 0.76, w: w, h: h)
                    case .flat:
                        blob(T.fogWarm.opacity(0.92),  x: 0.26, y: 1.04, r: m * 0.94, w: w, h: h)
                        blob(T.fogLime.opacity(0.22),  x: 0.00, y: 1.10, r: m * 0.72, w: w, h: h)
                    }
                }
                .blur(radius: 86)

                Color(hex: 0x12181A).opacity(0.22)

                RadialGradient(colors: [.clear, .clear, Color.black.opacity(0.34)],
                               center: .init(x: 0.42, y: 0.46),
                               startRadius: m * 0.26, endRadius: m * 0.86)
            }
            .clipped()
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
    private func blob(_ c: Color, x: CGFloat, y: CGFloat, r: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        RadialGradient(colors: [c, c.opacity(0.42), c.opacity(0)],
                       center: .center, startRadius: 0, endRadius: r)
            .frame(width: r * 2, height: r * 2)
            .position(x: w * x, y: h * y)
    }
}

// MARK: - 亮一档的磨砂玻璃（浮在 FogScreen 之上：气泡 / 底栏 / 浮层）
// 比 FogCard 亮，靠的是把底层透出来再加一层极淡的白，而不是加白描边。

struct BrightGlass: View {
    var radius: CGFloat = 20
    var level: Double = 1        // 0.7 收敛 … 1.3 更亮
    var corners: RectangleCornerRadii? = nil

    var body: some View {
        shape
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .overlay(shape.fill(Color.white.opacity(0.10 * level)))
            .overlay(
                shape.fill(
                    LinearGradient(colors: [Color.white.opacity(0.10 * level), .clear],
                                   startPoint: .top, endPoint: .bottom)
                )
            )
            .overlay(shape.stroke(Color.white.opacity(0.10), lineWidth: 0.8))
            .compositingGroup()
    }

    private var shape: AnyShape {
        if let c = corners { AnyShape(UnevenRoundedRectangle(cornerRadii: c, style: .continuous)) }
        else { AnyShape(RoundedRectangle(cornerRadius: radius, style: .continuous)) }
    }
}

// MARK: - 中文衬线标题（宋体）

extension Font {
    /// 中文衬线大标题：Songti SC（iOS 内置），替代 design: .serif；中文不收字距
    static func serifZh(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .custom("Songti SC", size: size).weight(weight)
    }
}
