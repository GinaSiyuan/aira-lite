import SwiftUI

// MARK: - 引导页外壳
// 固定结构：细进度条 → 返回 → 大标题 → 可滚内容 → 常驻 CTA。
// CTA 不随内容滚走：每一屏都只有一个"下一步"。

struct OnbShell<C: View>: View {
    var step: Int
    var total: Int
    var title: String
    var sub: String
    var cta: String
    var ctaEnabled: Bool = true
    var skip: (String, () -> Void)? = nil
    var onBack: (() -> Void)? = nil
    var onNext: () -> Void
    @ViewBuilder var content: C

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                if let b = onBack {
                    Button { Haptic.tap(); b() } label: {
                        Icon(.chevron, size: 13, weight: 2.2, color: T.ink)
                            .rotationEffect(.degrees(180))
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(.white))
                            .overlay(Circle().strokeBorder(T.hair, lineWidth: 1))
                            .contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                }
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        Capsule().fill(T.hair)
                        Capsule().fill(T.ink)
                            .frame(width: g.size.width * CGFloat(step + 1) / CGFloat(total))
                    }
                }
                .frame(height: 3)
                Text("\(step + 1)/\(total)")
                    .font(.system(size: 11, weight: .semibold)).monospacedDigit()
                    .foregroundStyle(T.ink3)
            }
            .padding(.top, 8)
            .animation(.smooth(duration: 0.4), value: step)

            Text(title).font(.serifZh(27))
                .fixedSize(horizontal: false, vertical: true).padding(.top, 22)
            if !sub.isEmpty {
                Text(sub).font(.system(size: 13.5)).foregroundStyle(T.ink2).lineSpacing(3.5)
                    .fixedSize(horizontal: false, vertical: true).padding(.top, 8)
            }

            ScrollView { content.padding(.top, 20).padding(.bottom, 10) }
                .scrollIndicators(.hidden)

            VStack(spacing: 10) {
                CTA(title: cta) { onNext() }
                    .disabled(!ctaEnabled).opacity(ctaEnabled ? 1 : 0.35)
                if let s = skip {
                    Button(s.0) { Haptic.tap(); s.1() }
                        .font(.system(size: 13)).foregroundStyle(T.ink3)
                }
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 22).padding(.bottom, 20)
    }
}

// MARK: - 1 Welcome
// 首屏只做一件事：让人相信这套东西能看见身体里正在发生什么。
// 所以主角是活的数据本身 —— 等高线在跑、曲线在画、状态条落在某一格上。

struct WelcomeView: View {
    @EnvironmentObject var app: App
    @State private var appear = false

    var body: some View {
        ZStack {
            FogScreen(tone: .warm)
            LineField(lines: 18, tint: T.lime, amplitude: 1).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("A I R A")
                        .font(.system(size: 12, weight: .bold)).tracking(4)
                        .foregroundStyle(.white.opacity(0.9))
                    Spacer()
                    Text("抢先体验")
                        .font(.system(size: 10, weight: .semibold)).tracking(0.6)
                        .padding(.horizontal, 9).padding(.vertical, 5)
                        .background(Capsule().fill(.white.opacity(0.10)))
                        .overlay(Capsule().strokeBorder(.white.opacity(0.14), lineWidth: 1))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .padding(.top, 4)

                Spacer(minLength: 6)

                WelcomeHero()
                    .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 20)

                Spacer(minLength: 6)

                Text("压力不是\n一种感觉。")
                    .font(.serifZh(36))
                    .foregroundStyle(.white)
                Text("它有形状。")
                    .font(.serifZh(36, .medium))
                    .foregroundStyle(T.lime)

                Text("Aira 把睡眠、心率与唾液皮质醇放在一起解读 —— 说清你的身体正处于什么状态，以及哪些还无法断言。")
                    .font(.system(size: 12.5)).foregroundStyle(.white.opacity(0.58)).lineSpacing(3.5)
                    .padding(.top, 10)

                Spacer(minLength: 8)

                VStack(spacing: 13) {
                    valueRow(index: 0, title: "你的可穿戴设备",
                             sub: "Apple Health、Oura、WHOOP · 近 30 天") {
                        // 扇形散开，像随手摆在桌上
                        ZStack {
                            SourceMark(kind: .whoop, size: 30)
                                .rotationEffect(.degrees(10)).offset(x: 26, y: 3)
                            SourceMark(kind: .oura, size: 31)
                                .rotationEffect(.degrees(-3)).offset(x: 2, y: -4)
                            SourceMark(kind: .appleHealth, size: 33)
                                .rotationEffect(.degrees(-9)).offset(x: -20, y: 4)
                        }
                        .frame(width: 88, alignment: .center)
                    }
                    valueRow(index: 1, title: "一次唾液采样",
                             sub: "一天五管，在家完成") {
                        SampleKitMark(size: 40).rotationEffect(.degrees(-5))
                            .frame(width: 88, alignment: .center)
                    }
                    valueRow(index: 2, title: "一份联合解读",
                             sub: "你的状态、你的计划，以及仍未知的问题") {
                        ReportMark(size: 40).rotationEffect(.degrees(4))
                            .frame(width: 88, alignment: .center)
                    }
                }

                CTA(title: "开始使用") { Haptic.ok(); app.phase = .connect }
                    .padding(.top, 16)
                    .opacity(appear ? 1 : 0)
                Text("Aira 不是医疗器械，仅用于健康生活指导。")
                    .font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.32))
                    .padding(.top, 10).frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 22).padding(.bottom, 16)
        }
        .onAppear { withAnimation(.smooth(duration: 0.7)) { appear = true } }
    }

    @ViewBuilder
    private func valueRow<L: View>(index: Int, title: String, sub: String,
                                   @ViewBuilder leading: () -> L) -> some View {
        HStack(spacing: 14) {
            leading()
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13.5, weight: .semibold)).foregroundStyle(.white)
                Text(sub).font(.system(size: 11)).foregroundStyle(.white.opacity(0.48))
                    .lineLimit(1).minimumScaleFactor(0.85)
            }
            Spacer(minLength: 0)
        }
        .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 14)
        .animation(.smooth.delay(0.18 + Double(index) * 0.09), value: appear)
    }
}

// MARK: - 首屏主视觉：一张真的在跑的读数卡
// 用的是产品里真实存在的图元（皮质醇曲线 + 五状态条 + 读数），不是装饰插画。

struct WelcomeHero: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
                    Circle().fill(T.lime).frame(width: 6, height: 6)
                    Text("皮质醇 · 单日曲线")
                        .font(.system(size: 9, weight: .bold)).tracking(1.4)
                        .foregroundStyle(.white.opacity(0.55))
                    Spacer()
                    Text("ng/mL").font(.system(size: 9)).foregroundStyle(.white.opacity(0.35))
                }
                CortisolSketch().frame(height: 70).padding(.top, 10)
                HStack(spacing: 4) {
                    ForEach(Array(["耗竭", "平衡", "激活", "紧绷", "过载"].enumerated()), id: \.offset) { i, s in
                        VStack(spacing: 5) {
                            Capsule().fill(i == 3 ? T.lime : .white.opacity(0.16))
                                .frame(height: 3)
                            Text(s).font(.system(size: 7.5, weight: i == 3 ? .bold : .regular))
                                .foregroundStyle(i == 3 ? .white : .white.opacity(0.3))
                                .lineLimit(1).minimumScaleFactor(0.7)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(14)
            .background(BrightGlass(radius: 20, level: 0.6))
            .padding(.trailing, 56)

            VStack(alignment: .trailing, spacing: 7) {
                floatChip("48", "ms", "HRV")
                floatChip("6:31", "", "睡眠")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(y: 20)
        }
        .frame(height: 168)
    }

    private func floatChip(_ v: String, _ unit: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(v).font(.system(size: 16, weight: .semibold)).monospacedDigit().tracking(-0.5)
                if !unit.isEmpty { Text(unit).font(.system(size: 9)).foregroundStyle(.white.opacity(0.5)) }
                Icon(.arrowUp, size: 8, weight: 2.4, color: T.coral)
                    .rotationEffect(.degrees(180))
            }
            Text(label).font(.system(size: 9)).foregroundStyle(.white.opacity(0.45))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10).padding(.vertical, 7)
        .background(BrightGlass(radius: 14, level: 1.1))
    }
}

/// 一天里的皮质醇形态：早峰没冲起来、晚上压不下去
struct CortisolSketch: View {
    private let pts: [Double] = [0.46, 0.62, 0.34, 0.26, 0.22]
    private let ideal: [Double] = [0.52, 0.92, 0.42, 0.22, 0.08]

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, s in
                let w = s.width, h = s.height
                let X: (Int) -> CGFloat = { i in w * CGFloat(i) / CGFloat(pts.count - 1) }
                let Y: (Double) -> CGFloat = { v in h * CGFloat(1 - v) * 0.86 + 4 }

                func curve(_ vals: [Double]) -> Path {
                    var p = Path()
                    for (i, v) in vals.enumerated() {
                        let pt = CGPoint(x: X(i), y: Y(v))
                        if i == 0 { p.move(to: pt) } else {
                            let cx = (X(i - 1) + X(i)) / 2
                            p.addCurve(to: pt, control1: .init(x: cx, y: p.currentPoint?.y ?? pt.y),
                                       control2: .init(x: cx, y: pt.y))
                        }
                    }
                    return p
                }
                ctx.stroke(curve(ideal), with: .color(.white.opacity(0.26)),
                           style: .init(lineWidth: 1.4, dash: [3, 3]))
                ctx.stroke(curve(pts), with: .color(T.lime), style: .init(lineWidth: 2.2, lineCap: .round))

                let k = (sin(t * 0.7) * 0.5 + 0.5) * Double(pts.count - 1)
                let i0 = min(pts.count - 2, Int(k)), f = k - Double(i0)
                let y = pts[i0] + (pts[i0 + 1] - pts[i0]) * f
                let px = X(i0) + (X(i0 + 1) - X(i0)) * f
                var halo = Path()
                halo.addEllipse(in: .init(x: px - 9, y: Y(y) - 9, width: 18, height: 18))
                ctx.fill(halo, with: .color(T.lime.opacity(0.25)))
                var dot = Path()
                dot.addEllipse(in: .init(x: px - 4, y: Y(y) - 4, width: 8, height: 8))
                ctx.fill(dot, with: .color(.white))
            }
        }
    }
}

// MARK: - 2 连接数据源
// 先连设备再问问题：问卷之前就能看到东西，用户才愿意继续填。

struct ConnectView: View {
    @EnvironmentObject var app: App
    private let optional: [SourceMark.Kind] = [.oura, .whoop, .garmin]

    var body: some View {
        OnbShell(step: 0, total: Self.onbTotal,
                 title: "连接你的数据",
                 sub: "只读权限。Aira 会导入最近 30 天数据，让你的第一份解读一开始就有基线可对比。",
                 cta: app.healthGranted ? "导入最近 30 天" : "连接 Apple Health",
                 onBack: { app.phase = .welcome },
                 onNext: {
                     if app.healthGranted { app.beginSync() }
                     else { withAnimation(.smooth) { app.healthGranted = true }; Haptic.ok() }
                 }) {
            VStack(spacing: 14) {
                HStack(spacing: 13) {
                    SourceMark(kind: .appleHealth, size: 48)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Apple Health").font(.system(size: 15, weight: .semibold))
                        Text(app.healthGranted ? "已连接 · 5 类数据" : "必须连接 —— 信号的来源")
                            .font(.system(size: 11.5)).foregroundStyle(app.healthGranted ? T.ink2 : T.ink3)
                    }
                    Spacer(minLength: 0)
                    if app.healthGranted {
                        Icon(.check, size: 15, weight: 2.4, color: T.ink)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(T.lime))
                    }
                }
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(app.healthGranted ? T.ink.opacity(0.85) : T.hair, lineWidth: 1.2))

                if app.healthGranted {
                    VStack(spacing: 0) {
                        ForEach(Array(Self.types.enumerated()), id: \.offset) { i, t in
                            HStack(spacing: 12) {
                                Icon(t.0, size: 17, weight: 1.8, color: T.ink2)
                                    .frame(width: 32, height: 32)
                                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(T.hair2))
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(t.1).font(.system(size: 13.5, weight: .medium))
                                    Text(t.2).font(.system(size: 11)).foregroundStyle(T.ink3)
                                }
                                Spacer(minLength: 0)
                                Icon(.check, size: 13, weight: 2.2, color: T.ink3)
                            }
                            .padding(.vertical, 9).padding(.horizontal, 14)
                            if i < Self.types.count - 1 {
                                Rectangle().fill(T.hair).frame(height: 1).padding(.leading, 58)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
                    .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(T.hair, lineWidth: 1))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                VStack(alignment: .leading, spacing: 9) {
                    Text("添加可穿戴设备（可选）")
                        .font(.system(size: 12.5, weight: .semibold)).foregroundStyle(T.ink2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 9) {
                        ForEach(Array(optional.enumerated()), id: \.offset) { _, k in
                            let name = SourceMark(kind: k).title
                            let on = app.devices.contains(name)
                            Button {
                                Haptic.tap()
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
                                    if on { app.devices.remove(name) } else { app.devices.insert(name) }
                                }
                            } label: {
                                VStack(spacing: 7) {
                                    SourceMark(kind: k, size: 38)
                                    Text(name)
                                        .font(.system(size: 10.5, weight: on ? .semibold : .regular))
                                        .foregroundStyle(on ? T.ink : T.ink3)
                                        .lineLimit(1).minimumScaleFactor(0.8)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 13)
                                .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(.white))
                                .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous)
                                    .strokeBorder(on ? T.ink.opacity(0.85) : T.hair, lineWidth: on ? 1.4 : 1))
                            }
                            .buttonStyle(PressStyle())
                        }
                    }
                }
                .padding(.top, 2)

                HStack(alignment: .top, spacing: 9) {
                    Icon(.info, size: 13, weight: 1.8, color: T.ink3).padding(.top, 1)
                    Text("没有手表？iPhone 自带的睡眠和步数也可用 —— Aira 只是会在据此得出的每个结论里，标注精度较低。")
                        .font(.system(size: 11.5)).foregroundStyle(T.ink3).lineSpacing(3)
                }
                .padding(.top, 2)
            }
        }
    }

    static var onbTotal: Int {
        #if LITE
        return 3          // Connect → About you（含训练页）→ 既往史
        #else
        return 4
        #endif
    }

    static let types: [(Ico, String, String)] = [
        (.moon,  "睡眠分析", "时长、分期、觉醒次数"),
        (.pulse, "心率变异性", "恢复状况的核心信号"),
        (.pulse, "静息心率", "与 HRV 一起读，从不单看"),
        (.steps, "步数与活动", "负荷侧的证据"),
        (.breath,"呼吸频率", "疾病的旁证")
    ]
}

// MARK: - 3 回读 30 天

struct SyncingView: View {
    @EnvironmentObject var app: App
    private let items = ["睡眠分析 · 30 天",
                         "心率变异性 · 30 天",
                         "静息心率 · 30 天",
                         "步数与活动 · 30 天"]

    var body: some View {
        ZStack {
            FogScreen(tone: .warm)
            LineField(lines: 14, tint: T.lime, amplitude: 1.3).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                TextSphere(word: "AIRA", count: 58, size: 180, energy: 0.3)
                Text("正在读取你最近 30 天的数据")
                    .font(.serifZh(21))
                    .foregroundStyle(.white).padding(.top, 18)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(items.enumerated()), id: \.offset) { i, s in
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().strokeBorder(.white.opacity(0.2), lineWidth: 1.4)
                                    .frame(width: 16, height: 16)
                                if i < app.syncedItems {
                                    Circle().fill(T.lime).frame(width: 16, height: 16)
                                    Icon(.check, size: 9, weight: 2.6, color: T.ink)
                                }
                            }
                            Text(s).font(.system(size: 13))
                                .foregroundStyle(i < app.syncedItems ? .white : .white.opacity(0.35))
                            Spacer()
                        }
                    }
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BrightGlass(radius: 22, level: 0.6))
                .padding(.top, 24)

                NeonReveal(progress: app.syncProgress).padding(.horizontal, 28).padding(.top, 22)
                Spacer()
                Text("数据只在你的设备与 Aira 的加密存储之间流动。")
                    .font(.system(size: 11)).foregroundStyle(.white.opacity(0.34))
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 26)
        }
    }
}

// MARK: - 5 About you
// 只问会改变结论的东西：称呼、年龄、生理性别、训练习惯。
// 年龄和训练年限是连续量 —— 用拖动，不用 +/- 点二十下。

struct ProfileView: View {
    @EnvironmentObject var app: App
    @FocusState private var focus: Bool

    // 两步：基础信息一页收齐，训练习惯单独一页（有分支展开）
    private var titles: [String] {
        ["先认识一下你", "你平时训练吗？"]
    }
    private var subs: [String] {
        ["称呼、年龄与出生性别 —— 它们决定你的结果对照哪一组参考区间。",
         "训练负荷会改变恢复数据的解读方式 —— 也决定计划敢对你提出多少要求。"]
    }

    private var lastStep: Int { 1 }   // 两版一致：基础页 + 训练页
    private func finish() { app.phase = .medical }

    var body: some View {
        OnbShell(step: 1, total: ConnectView.onbTotal,
                 title: titles[app.profStep], sub: subs[app.profStep],
                 cta: app.profStep < lastStep ? "继续" : (lastStep == 0 ? "开始" : "没问题"),
                 ctaEnabled: app.profStep != 0 || !app.nickname.trimmingCharacters(in: .whitespaces).isEmpty,
                 onBack: {
                     if app.profStep > 0 { withAnimation(.smooth) { app.profStep -= 1 } }
                     else { app.phase = .recap }
                 },
                 onNext: {
                     if app.profStep < lastStep { withAnimation(.smooth) { app.profStep += 1 } }
                     else { finish() }
                 }) {
            Group {
                switch app.profStep {
                case 0:
                    // 基础三项同页：姓名 / 年龄标尺 / 生理性别
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 9) {
                            FieldLabel("Aira 该怎么称呼你？")
                            TextField("", text: $app.nickname,
                                      prompt: Text("Chloe").foregroundStyle(T.ink3))
                                .textFieldStyle(.plain)
                                .font(.serifZh(21))
                                .focused($focus)
                                .padding(.horizontal, 17).padding(.vertical, 15)
                                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.white))
                                .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(focus ? T.ink : T.hair, lineWidth: focus ? 1.5 : 1))
                        }
                        VStack(alignment: .leading, spacing: 9) {
                            FieldLabel("年龄", hint: "参考区间随年龄段变化")
                            RulerPick(value: $app.age, range: 13...90, unit: "岁")
                        }
                        VStack(alignment: .leading, spacing: 9) {
                            FieldLabel("出生性别", hint: "皮质醇与 DHEA 的区间不同")
                            Segmented(options: ["女", "男", "不便透露"], index: $app.sex)
                            if app.sex == 2 {
                                HStack(alignment: .top, spacing: 8) {
                                    Icon(.info, size: 12, weight: 1.9, color: T.ink3).padding(.top, 1)
                                    Text("Aira 将使用更宽的合并区间 —— 结论会带稍大的不确定性。")
                                        .font(.system(size: 11.5)).foregroundStyle(T.ink3).lineSpacing(3)
                                }
                                .transition(.opacity)
                            }
                        }
                        .animation(.smooth(duration: 0.25), value: app.sex)
                    }
                    .padding(.top, 6)

                default:
                    VStack(alignment: .leading, spacing: 16) {
                        Text("每周训练几次？").font(.system(size: 13, weight: .semibold))
                        HStack(spacing: 9) {
                            freq("不练", 0); freq("1–2 次", 1)
                        }
                        HStack(spacing: 9) {
                            freq("3–4 次", 2); freq("5 次以上", 3)
                        }
                        if app.sessionBand > 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("练了多久了？").font(.system(size: 13, weight: .semibold))
                                    .padding(.top, 8)
                                RulerPick(value: $app.years, range: 0...30, unit: "年")
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.top, 10)
                    .animation(.spring(response: 0.3, dampingFraction: 0.86), value: app.sessionBand)
                }
            }
            .transition(.opacity)
        }
    }

    @ViewBuilder
    private func bigChoice(_ t: String, on: Bool, _ a: @escaping () -> Void) -> some View {
        Button { Haptic.tap(); withAnimation(.spring(response: 0.26, dampingFraction: 0.86)) { a() } } label: {
            HStack {
                Text(t).font(.system(size: 16, weight: on ? .semibold : .regular))
                Spacer()
                ZStack {
                    Circle().strokeBorder(on ? Color.clear : T.hair, lineWidth: 1.5)
                    if on { Circle().fill(T.ink); Icon(.check, size: 11, weight: 2.6, color: .white) }
                }
                .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 18).padding(.vertical, 18)
            .background(RoundedRectangle(cornerRadius: 19, style: .continuous).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 19, style: .continuous)
                .strokeBorder(on ? T.ink.opacity(0.85) : T.hair, lineWidth: on ? 1.4 : 1))
            .foregroundStyle(T.ink)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressStyle())
    }

    @ViewBuilder
    private func freq(_ t: String, _ i: Int) -> some View {
        let on = app.sessionBand == i
        Button {
            Haptic.tap()
            withAnimation(.spring(response: 0.26, dampingFraction: 0.86)) {
                app.sessionBand = i; app.trains = i > 0
            }
        } label: {
            VStack(spacing: 5) {
                Icon(i == 0 ? .moon : .run, size: 18, weight: 1.9, color: on ? .white : T.ink2)
                Text(t).font(.system(size: 14, weight: on ? .semibold : .medium))
            }
            .frame(maxWidth: .infinity).padding(.vertical, 17)
            .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(on ? T.ink : .white))
            .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous)
                .strokeBorder(on ? Color.clear : T.hair, lineWidth: 1))
            .foregroundStyle(on ? .white : T.ink)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressStyle())
    }
}

struct FieldLabel: View {
    var text: String
    var hint: String? = nil
    init(_ t: String, hint: String? = nil) { text = t; self.hint = hint }
    var body: some View {
        HStack(spacing: 7) {
            Text(text).font(.system(size: 14, weight: .semibold))
            if let h = hint {
                Text(h).font(.system(size: 11)).foregroundStyle(T.ink3)
                    .lineLimit(1).minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
        }
    }
}

/// 可拖动的数值条：连续量就该连续地选
struct SlideValue: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("\(value)").font(.system(size: 30, weight: .semibold)).monospacedDigit().tracking(-1)
                Text(unit).font(.system(size: 13)).foregroundStyle(T.ink3)
                Spacer()
            }
            GeometryReader { g in
                let w = g.size.width
                let f = CGFloat(value - range.lowerBound) / CGFloat(range.count - 1)
                ZStack(alignment: .leading) {
                    Capsule().fill(T.hair).frame(height: 6)
                    Capsule().fill(T.ink).frame(width: max(6, w * f), height: 6)
                    Circle().fill(.white)
                        .frame(width: 26, height: 26)
                        .overlay(Circle().strokeBorder(T.ink, lineWidth: 2))
                        .shadow(color: .black.opacity(0.14), radius: 5, y: 2)
                        .offset(x: max(0, min(w - 26, w * f - 13)))
                }
                .frame(height: 26)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0).onChanged { gv in
                    let p = max(0, min(1, gv.location.x / w))
                    let v = range.lowerBound + Int((p * CGFloat(range.count - 1)).rounded())
                    if v != value { Haptic.soft(); value = v }
                })
            }
            .frame(height: 26)
        }
        .padding(.horizontal, 16).padding(.vertical, 13)
        .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
    }
}

struct Segmented: View {
    var options: [String]
    @Binding var index: Int
    @Namespace private var ns
    var body: some View {
        HStack(spacing: 3) {
            ForEach(Array(options.enumerated()), id: \.offset) { i, o in
                Button {
                    Haptic.tap()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.84)) { index = i }
                } label: {
                    Text(o).font(.system(size: 13.5, weight: index == i ? .semibold : .regular))
                        .lineLimit(1).minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background {
                            if index == i {
                                RoundedRectangle(cornerRadius: 13, style: .continuous).fill(T.ink)
                                    .matchedGeometryEffect(id: "seg", in: ns)
                            }
                        }
                        .foregroundStyle(index == i ? .white : T.ink2)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
    }
}

// MARK: - 6 既往史
// 病历式的行：一个条目一张图 + 一句"它会怎么影响结论"。
// 比一堆 pill tag 好扫读，也让人看见每一项都有用，不是在凑表单。

struct MedicalView: View {
    @EnvironmentObject var app: App

    private let injuries: [(MedGlyph, String, String)] = [
        (.back,     "下背部", "限制运动侧的负荷上限"),
        (.knee,     "膝盖",   "用低冲击训练替代跑步"),
        (.shoulder, "肩部",   "影响过头与推举的容量"),
        (.achilles, "跟腱",   "排除爆发式动作与冲刺")
    ]
    private let meds: [(MedGlyph, String, String)] = [
        (.hormone, "皮质类固醇",          "直接抬高测得的皮质醇"),
        (.pill,    "避孕药 / 激素类","改变所使用的参考区间"),
        (.biotin,  "生物素（维生素 B7）",      "干扰唾液检测"),
        (.capsule, "抗抑郁药",          "可能抹平晨间上升"),
        (.inhaler, "吸入性激素",         "采样前需要漱口")
    ]

    var body: some View {
        OnbShell(step: 2, total: ConnectView.onbTotal,
                 title: "有什么需要我们知道的吗？",
                 sub: "每一项都会改变结果的解读方式。不适用的直接跳过。",
                 cta: "继续",
                 skip: ("都不适用", {
                     app.injuries = []; app.meds = []
                     #if LITE
                     app.phase = .main
                     #else
                     app.phase = .notify
                     #endif
                 }),
                 onBack: { app.phase = .profile },
                 onNext: {
                     #if LITE
                     app.phase = .main     // Lite：既往史是最后一步，直接进 Daily loop
                     #else
                     app.phase = .notify
                     #endif
                 }) {
            VStack(alignment: .leading, spacing: 22) {
                group("伤病史", rows: injuries, selection: $app.injuries)
                group("用药与补剂", rows: meds, selection: $app.meds)

                if app.meds.contains("生物素（维生素 B7）") {
                    HStack(alignment: .top, spacing: 11) {
                        MedIcon(glyph: .biotin, size: 34, active: true)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("我们会调整你的采样日").font(.system(size: 13, weight: .semibold))
                            Text("首管前需停用生物素 48 小时，否则检测值会偏高。Aira 会自动绕开安排。")
                                .font(.system(size: 11.5)).foregroundStyle(T.ink2).lineSpacing(3)
                        }
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(T.lime.opacity(0.45)))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.86), value: app.meds)
        }
    }

    @ViewBuilder
    private func group(_ title: String,
                       rows: [(MedGlyph, String, String)],
                       selection: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text(title).font(.system(size: 14, weight: .semibold))
                Spacer()
                if !selection.wrappedValue.isEmpty {
                    Text("已选 \(selection.wrappedValue.count) 项")
                        .font(.system(size: 11, weight: .medium)).foregroundStyle(T.ink3)
                }
            }
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { i, r in
                    let on = selection.wrappedValue.contains(r.1)
                    Button {
                        Haptic.tap()
                        withAnimation(.spring(response: 0.26, dampingFraction: 0.86)) {
                            if on { selection.wrappedValue.remove(r.1) }
                            else { selection.wrappedValue.insert(r.1) }
                        }
                    } label: {
                        HStack(spacing: 12) {
                            MedIcon(glyph: r.0, size: 40, active: on)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(r.1).font(.system(size: 14, weight: on ? .semibold : .medium))
                                Text(r.2).font(.system(size: 11)).foregroundStyle(T.ink3)
                                    .lineLimit(1).minimumScaleFactor(0.85)
                            }
                            Spacer(minLength: 0)
                            ZStack {
                                RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .fill(on ? T.ink : Color.clear)
                                RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .strokeBorder(on ? Color.clear : T.hair, lineWidth: 1.4)
                                if on { Icon(.check, size: 11, weight: 2.6, color: .white) }
                            }
                            .frame(width: 22, height: 22)
                        }
                        .padding(.horizontal, 13).padding(.vertical, 10)
                        .contentShape(Rectangle())
                        .foregroundStyle(T.ink)
                    }
                    .buttonStyle(.plain)
                    if i < rows.count - 1 {
                        Rectangle().fill(T.hair).frame(height: 1).padding(.leading, 65)
                    }
                }
            }
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
        }
    }
}

// MARK: - 7 通知
// 不讲"我们想给你发通知"，直接把三条真通知摆出来，让人自己判断值不值得开。

struct NotifyPermView: View {
    @EnvironmentObject var app: App

    private let cats: [(Ico, String, String, String, String)] = [
        (.bell,  "Sampling reminders", "Recommended for sampling day timing",
         "Tube 2 of 5 · in 4 minutes", "Stay seated — this pair defines your morning rise."),
        (.spark, "Proactive check-ins", "When Aira needs one thing from you",
         "Aira", "I only see 2 workouts this week — anything missing?"),
        (.recover, "Weekly read", "Mondays: what moved and what didn't",
         "Your week", "Sleep onset steadied by 22 min. Recovery load still high.")
    ]

    var body: some View {
        OnbShell(step: 3, total: 4,
                 title: "What Aira can send",
                 sub: "All optional, all off by default. Flip on only what you want — each shows exactly what it looks like.",
                 cta: "Continue",
                 onBack: { app.phase = .medical },
                 onNext: {
                     app.notifyGranted = app.notifyOn.contains(true)
                     app.phase = .firstLog
                 }) {
            VStack(spacing: 16) {
                ForEach(Array(cats.enumerated()), id: \.offset) { i, c in
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 11) {
                            ZStack {
                                Circle().fill(app.notifyOn[i] ? T.lime.opacity(0.55) : T.hair2)
                                Icon(c.0, size: 17, weight: 1.9, color: T.ink)
                            }
                            .frame(width: 38, height: 38)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(c.1).font(.system(size: 14, weight: .semibold))
                                Text(c.2).font(.system(size: 11)).foregroundStyle(T.ink3)
                            }
                            Spacer(minLength: 0)
                            Toggle2(on: $app.notifyOn[i])
                                .accessibilityLabel("\(c.1) toggle")
                        }

                        // 样例常显：开 = 实色，关 = 灰度预览（让用户先看到会收到什么）
                        HStack(alignment: .top, spacing: 10) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(T.ink)
                                .frame(width: 26, height: 26)
                                .overlay(Icon(.spark, size: 13, weight: 2, color: T.lime))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(c.3).font(.system(size: 11.5, weight: .semibold))
                                Text(c.4).font(.system(size: 11.5)).foregroundStyle(T.ink2)
                                    .fixedSize(horizontal: false, vertical: true).lineSpacing(2)
                            }
                            Spacer(minLength: 0)
                            Text(app.notifyOn[i] ? "now" : "PREVIEW")
                                .font(.system(size: 9, weight: .semibold)).tracking(0.5)
                                .foregroundStyle(T.ink3)
                        }
                        .padding(11)
                        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(T.hair2))
                        .saturation(app.notifyOn[i] ? 1 : 0)
                        .opacity(app.notifyOn[i] ? 1 : 0.55)
                        .padding(.top, 11)
                    }
                    .padding(14)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
                    .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(app.notifyOn[i] ? T.ink.opacity(0.7) : T.hair, lineWidth: 1))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.86), value: app.notifyOn)
        }
    }
}

struct Toggle2: View {
    @Binding var on: Bool
    var locked: Bool = false
    var body: some View {
        Button {
            guard !locked else { Haptic.soft(); return }
            Haptic.tap()
            withAnimation(.spring(response: 0.26, dampingFraction: 0.78)) { on.toggle() }
        } label: {
            ZStack(alignment: on ? .trailing : .leading) {
                Capsule().fill(on ? T.ink : T.hair)
                Circle().fill(.white).frame(width: 20, height: 20).padding(2)
                    .shadow(color: .black.opacity(0.14), radius: 3, y: 1)
            }
            .frame(width: 46, height: 26)
            .opacity(locked ? 0.55 : 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 8 采样流程预览

struct SamplingPreviewView: View {
    @EnvironmentObject var app: App
    var body: some View {
        OnbShell(step: 3, total: 4,
                 title: "How the saliva test works",
                 sub: "Five tubes across one ordinary day, at home. Then back to the lab in the prepaid box.",
                 cta: "Got it",
                 onBack: { app.phase = .notify },
                 onNext: { app.phase = .firstLog }) {
            VStack(spacing: 14) {
                FogCard(tone: .cool) {
                    VStack(alignment: .leading, spacing: 10) {
                        CardHead(icon: .drop, title: "One day, five points",
                                 sub: "The shape is the measurement", chip: "~15 min", chipTone: .sky)
                        FiveTubesCurve().padding(.top, 2)
                    }
                }

                HStack(alignment: .top, spacing: 13) {
                    SampleKitMark(size: 42)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Mailing it back").font(.system(size: 13.5, weight: .semibold))
                        Text("All five tubes into the return box with the cold pack, prepaid label on top, any carrier. Within 24 hours.")
                            .font(.system(size: 11.5)).foregroundStyle(T.ink2).lineSpacing(3)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(T.lime.opacity(0.4)))

                HStack(alignment: .top, spacing: 9) {
                    Icon(.info, size: 13, weight: 1.8, color: T.ink3).padding(.top, 1)
                    Text("Nothing to memorize — on the day, Aira walks you through each tube with photos, at its time point.")
                        .font(.system(size: 11.5)).foregroundStyle(T.ink3).lineSpacing(3)
                }
            }
        }
    }
}

// MARK: - 9 首次打卡

struct FirstLogView: View {
    @EnvironmentObject var app: App
    @State private var show = false
    var body: some View {
        ZStack {
            FogScreen(tone: .warm)
            LineField(lines: 12, tint: T.lime, amplitude: 0.8).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                Text("Last thing:\nhow do you feel?")
                    .font(.system(size: 32, weight: .semibold, design: .serif))
                    .tracking(-0.8)
                    .foregroundStyle(.white)
                Text("A watch measures heart rate. It can't measure how you feel. Aira's strongest calls come from days where both sides agree — and its caveats from the days they don't.")
                    .font(.system(size: 13.5)).foregroundStyle(.white.opacity(0.58)).lineSpacing(4)
                    .padding(.top, 14)

                HStack(spacing: 9) {
                    ForEach(Array([(Ico.moon, "Sleep"), (.flame, "Fatigue"), (.stretch, "Soreness"),
                                   (.user, "Mood"), (.breath, "Stress")].enumerated()), id: \.offset) { _, p in
                        VStack(spacing: 6) {
                            Icon(p.0, size: 17, weight: 1.8, color: .white)
                                .frame(width: 42, height: 42)
                                .background(Circle().fill(.white.opacity(0.12)))
                            Text(p.1).font(.system(size: 9.5)).foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .padding(.top, 26)

                Text("About 20 seconds. Aira only asks once a day.")
                    .font(.system(size: 11.5)).foregroundStyle(.white.opacity(0.4))
                    .padding(.top, 18)

                Spacer()
                CTA(title: "Do your first check-in") { Haptic.tap(); show = true }
                Button("Skip for now") { Haptic.tap(); app.phase = .main }
                    .font(.system(size: 13)).foregroundStyle(.white.opacity(0.45))
                    .frame(maxWidth: .infinity).padding(.top, 14)
            }
            .padding(.horizontal, 24).padding(.bottom, 24)
        }
        .sheet(isPresented: $show, onDismiss: { app.phase = .main }) { CheckInSheet() }
    }
}

/// 简易流式换行
struct FlowWrap<Data: RandomAccessCollection, C: View>: View where Data.Element: Hashable {
    var data: Data
    @ViewBuilder var content: (Data.Element) -> C
    init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> C) {
        self.data = data; self.content = content
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(rows(), id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { content($0) }
                    Spacer(minLength: 0)
                }
            }
        }
    }
    private func rows() -> [[Data.Element]] {
        var out: [[Data.Element]] = []; var cur: [Data.Element] = []; var n = 0
        for d in data {
            let w = "\(d)".count
            if n + w > 16 && !cur.isEmpty { out.append(cur); cur = []; n = 0 }
            cur.append(d); n += w
        }
        if !cur.isEmpty { out.append(cur) }
        return out
    }
}
