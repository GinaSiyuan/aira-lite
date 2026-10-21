import SwiftUI

// MARK: - 检测 tab（Collection状态机的单一入口）

struct TestingView: View {
    @EnvironmentObject var app: App

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 7) {
                    Circle().fill(app.saliva == .notScheduled ? T.ink3 : T.lime)
                        .frame(width: 6, height: 6)
                    Text(statusLine).font(.system(size: 12.5, weight: .medium)).foregroundStyle(T.ink2)
                    Spacer()
                }
                .padding(.top, 6)

                switch app.saliva {
                case .notScheduled: IntroBlock()
                case .scheduled, .collecting: CollectBlock()
                case .shipped: ShippedBlock()
                case .reportReady: ReadyBlock()
                }

                Color.clear.frame(height: 76)
            }
            .padding(.horizontal, 20)
        }
    }

    private var statusLine: String {
        switch app.saliva {
        case .notScheduled: "Not scheduled"
        case .scheduled:    "Scheduled · tomorrow morning"
        case .collecting:   "Collecting · \(app.points.filter { $0.done }.count) / 5"
        case .shipped:      "Shipped · at the lab"
        case .reportReady:  "Report ready"
        }
    }
}

// MARK: - 未Arrange

private struct IntroBlock: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FogCard(tone: .cool) {
                VStack(alignment: .leading, spacing: 14) {
                    CardHead(icon: .drop, title: "Five tubes, one day", sub: "At home · mailed to the lab", chip: "~15 min", chipTone: .sky)
                    Text("Why five time points")
                        .font(.system(size: 17, weight: .semibold)).tracking(-0.4)
                    Text("Cortisol can differ 10× across one day. The shape is the measurement — tap a point to see what it carries.")
                        .font(.system(size: 13)).foregroundStyle(T.onD2).lineSpacing(3.5)
                    FiveTubesCurve().padding(.top, 4)
                }
            }

            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 12) {
                    CardHead(icon: .info, title: "Avoid on sampling day",
                             sub: "Four things — all of them skew the assay")
                    ForEach(["No biotin (vitamin B7) for 24 h before", "No food or coffee for 30 min before", "No brushing for 10 min before — gum bleeding contaminates the sample", "Don't exercise after waking — first tube within 30 min"], id: \.self) { s in
                        HStack(alignment: .top, spacing: 10) {
                            Icon(.close, size: 10, weight: 2.4, color: T.coral)
                                .frame(width: 18, height: 18)
                                .background(Circle().fill(T.coral.opacity(0.16)))
                                .padding(.top, 1)
                            Text(s).font(.system(size: 13)).foregroundStyle(T.onD2).lineSpacing(2.5)
                        }
                    }
                }
            }

            CTA(title: "Schedule for tomorrow") { app.schedule() }
                .padding(.top, 4)
        }
    }
}

// MARK: - Collection中

private struct CollectBlock: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FogCard {
                VStack(alignment: .leading, spacing: 0) {
                    CardHead(icon: .drop, title: "Today's five tubes", sub: "Oct 15",
                             chip: "\(app.points.filter { $0.done }.count) / 5", chipTone: .good)
                    Comb(count: 5, filled: Double(app.points.filter { $0.done }.count) / 5, height: 22)
                        .padding(.top, 14)
                    Text("Sample at each time point — within 15 minutes is fine.")
                        .font(.system(size: 11)).foregroundStyle(T.onD3).padding(.top, 8)
                }
            }

            VStack(spacing: 9) {
                ForEach(Array(app.points.enumerated()), id: \.element.id) { i, p in
                    Button {
                        guard !p.done else { return }
                        app.activePoint = i; app.stepIndex = 0; app.go(.guidance)
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle().fill(p.done ? T.lime : T.hair2)
                                if p.done {
                                    Icon(.check, size: 14, weight: 2.4, color: T.ink)
                                } else {
                                    Text(p.when).font(.system(size: 9.5, weight: .semibold))
                                        .monospacedDigit().foregroundStyle(T.ink2)
                                }
                            }
                            .frame(width: 42, height: 42)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(p.name).font(.system(size: 14, weight: .semibold))
                                Text(p.hint).font(.system(size: 11.5)).foregroundStyle(T.ink3)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer(minLength: 4)
                            if p.done {
                                Text("Done").font(.system(size: 11.5, weight: .medium)).foregroundStyle(T.ink3)
                            } else {
                                Icon(.chevron, size: 12, weight: 2.2, color: T.ink3)
                            }
                        }
                        .padding(14)
                        .background(RoundedRectangle(cornerRadius: 17, style: .continuous).fill(.white))
                        .overlay(RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .strokeBorder(p.done ? T.lime.opacity(0.9) : T.hair, lineWidth: 1))
                        .foregroundStyle(T.ink)
                    }
                    .buttonStyle(PressStyle())
                }
            }

            Button("Demo: skip ahead to the report") { Haptic.tap(); app.fastForwardToReport() }
                .font(.system(size: 12.5)).foregroundStyle(T.ink3)
                .frame(maxWidth: .infinity).padding(.top, 4)
        }
    }
}

// MARK: - Shipped

private struct ShippedBlock: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 14) {
                    CardHead(icon: .plan, title: "Shipped", sub: "Oct 15 · 18:20", chip: "Processing", chipTone: .off)
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array([("All 5 tubes collected", true), ("Shipped", true), ("Lab processing", false), ("Report generated", false)].enumerated()), id: \.offset) { _, s in
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle().strokeBorder(.white.opacity(0.2), lineWidth: 1.4)
                                        .frame(width: 16, height: 16)
                                    if s.1 {
                                        Circle().fill(T.lime).frame(width: 16, height: 16)
                                        Icon(.check, size: 9, weight: 2.6, color: T.ink)
                                    }
                                }
                                Text(s.0).font(.system(size: 13)).foregroundStyle(s.1 ? .white : T.onD3)
                                Spacer()
                            }
                        }
                    }
                    Text("Results usually arrive in 5–7 business days. Aira will read them together with these weeks of sleep.")
                        .font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(3.5)
                }
            }
            CTA(title: "Demo: report ready") { app.deliverReport() }
        }
    }
}

// MARK: - Report就绪

private struct ReadyBlock: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FogCard(tone: .cool) {
                VStack(alignment: .leading, spacing: 13) {
                    CardHead(icon: .plan, title: "Report ready", sub: "Collected 10/15 · issued 10/21", chip: "Tense", chipTone: .warn)
                    Text("HPA axis: Tense")
                        .font(.system(size: 19, weight: .semibold)).tracking(-0.5)
                    Text("Can't get going in the morning, can't switch off at night — matching what you said about waking tired and falling asleep later.")
                        .font(.system(size: 13.5)).foregroundStyle(T.onD2).lineSpacing(4)
                }
            }
            CTA(title: "Open full report") { app.go(.report) }
            if app.retestScheduled {
                HStack(spacing: 8) {
                    Icon(.check, size: 13, weight: 2.4, color: T.ink)
                        .frame(width: 22, height: 22).background(Circle().fill(T.lime))
                    Text("Re-test scheduled · 10/24 + 10/25, same time points")
                        .font(.system(size: 12.5, weight: .medium)).foregroundStyle(T.ink2)
                    Spacer()
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(T.lime.opacity(0.35)))
            } else {
                Button {
                    Haptic.ok()
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.84)) { app.retestScheduled = true }
                } label: {
                    Text("Collect 2 more days — confirm the state")
                        .font(.system(size: 13, weight: .semibold)).foregroundStyle(T.ink)
                        .frame(maxWidth: .infinity).padding(.vertical, 13)
                        .background(Capsule().fill(.white))
                        .overlay(Capsule().strokeBorder(T.ink.opacity(0.75), lineWidth: 1.2))
                        .contentShape(Capsule())
                }
                .buttonStyle(PressStyle())
            }
        }
    }
}

// MARK: - Collection操作指引（分步，App 不假装能感知Collection过程）

struct GuidanceFlow: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss

    private let steps: [(String, String)] = [
        ("Rinse with water",
         "Rinse for 10 seconds and spit. No brushing, no mouthwash — both skew results."),
        ("Wait 10 minutes",
         "Let your mouth return to baseline. Nothing to eat or drink while you wait."),
        ("Hold the swab for 2 minutes",
         "Under the tongue, don't chew. Saturated is enough — no effort needed."),
        ("Back in the tube, seal it",
         "Drop the swab straight in without touching the tip, press the cap until it clicks."),
        ("Label the time point",
         "Write the time point and the actual clock time — a wrong label makes the result unusable.")
    ]

    var body: some View {
        ZStack(alignment: .top) {
            PageBG()

            // 照片层：占上半屏，向下渐隐进页面底色
            StepPhoto(index: app.stepIndex)
                .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack(spacing: 7) {
                        Circle().fill(T.lime).frame(width: 6, height: 6)
                        Text(app.activePoint.map { app.points[$0].name } ?? "Collection")
                            .font(.system(size: 12, weight: .semibold)).foregroundStyle(T.ink2)
                    }
                    .padding(.horizontal, 11).padding(.vertical, 7)
                    .background(Capsule().fill(.white.opacity(0.85)))
                    Spacer()
                    Button { dismiss() } label: {
                        Icon(.close, size: 13, weight: 2.3, color: T.ink2)
                            .frame(width: 34, height: 34)
                            .background(Circle().fill(.white.opacity(0.9)))
                            .contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                    .accessibilityLabel("Close")
                }
                .padding(.top, 14)

                Spacer()

                // 文案区：对齐 onboarding 的排版（kicker → serif 大标题 → 小字说明）
                VStack(alignment: .leading, spacing: 0) {
                    Text("STEP \(app.stepIndex + 1) OF \(steps.count)")
                        .font(.system(size: 10, weight: .bold)).tracking(1.6)
                        .foregroundStyle(T.ink3)
                    Text(steps[app.stepIndex].0)
                        .font(.system(size: 28, weight: .semibold, design: .serif)).tracking(-0.6)
                        .foregroundStyle(T.ink)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                    Text(steps[app.stepIndex].1)
                        .font(.system(size: 13.5)).foregroundStyle(T.ink2).lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 10)

                    if app.stepIndex == 1 {
                        HStack(spacing: 8) {
                            Icon(.bell, size: 12, weight: 2, color: T.ink)
                            Text("Aira will remind you in 10 minutes")
                                .font(.system(size: 12, weight: .medium)).foregroundStyle(T.ink2)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 9)
                        .background(Capsule().fill(T.lime.opacity(0.45)))
                        .padding(.top, 14)
                    }

                    HStack(spacing: 5) {
                        ForEach(0..<steps.count, id: \.self) { i in
                            Capsule().fill(i <= app.stepIndex ? T.ink : T.ink.opacity(0.12)).frame(height: 3)
                        }
                    }
                    .padding(.top, 20)

                    HStack(spacing: 10) {
                        if app.stepIndex > 0 {
                            Button {
                                Haptic.tap(); withAnimation(.smooth) { app.stepIndex -= 1 }
                            } label: {
                                Icon(.chevron, size: 14, weight: 2.2, color: T.ink)
                                    .rotationEffect(.degrees(180))
                                    .frame(width: 52, height: 52)
                                    .background(Circle().fill(.white))
                                    .overlay(Circle().strokeBorder(T.hair, lineWidth: 1))
                                    .contentShape(Circle())
                            }
                            .buttonStyle(PressStyle())
                        }
                        CTA(title: app.stepIndex == steps.count - 1 ? "Tube done" : "Next") {
                            if app.stepIndex == steps.count - 1 {
                                if let i = app.activePoint { app.completePoint(i) }
                                dismiss()
                            } else {
                                withAnimation(.smooth) { app.stepIndex += 1 }
                            }
                        }
                    }
                    .padding(.top, 16)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 22)
        }
        .animation(.smooth(duration: 0.35), value: app.stepIndex)
    }
}

// MARK: - 步骤照片：Assets/guide1…guide5.png（没有素材时走雾面兜底）

struct StepPhoto: View {
    var index: Int
    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height * 0.62
            ZStack(alignment: .top) {
                if let p = Bundle.main.path(forResource: "guide\(index + 1)", ofType: "png"),
                   let img = UIImage(contentsOfFile: p) {
                    Image(uiImage: img)
                        .resizable().scaledToFill()
                        .frame(width: geo.size.width, height: h, alignment: .top)
                        .clipped()
                } else {
                    ZStack {
                        LinearGradient(colors: [Color(hex: 0xE4E8D8), T.page],
                                       startPoint: .top, endPoint: .bottom)
                        StepArt(index: index)
                    }
                    .frame(height: h)
                }
                // 向页面底色渐隐
                LinearGradient(colors: [.clear, .clear, T.page.opacity(0.65), T.page],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: h)
            }
            .id(index)
            .transition(.opacity)
        }
    }
}
