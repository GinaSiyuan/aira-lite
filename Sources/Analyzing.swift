import SwiftUI

// MARK: - 出报告时的整屏加载态
// 不是一张卡里的 spinner —— 联合分析是产品里耗时最长、也最需要被看见的一步，
// 所以它占满整屏：文字球 + 正在读什么 + 进度。

struct AnalyzingScreen: View {
    @EnvironmentObject var app: App
    var onDone: () -> Void

    @State private var progress: Double = 0
    @State private var line = 0

    private let lines = [
        "Reading 5 saliva time points",
        "Aligning them with 30 days of sleep",
        "Comparing against your own baseline",
        "Separating what's known from what isn't"
    ]

    var body: some View {
        ZStack {
            FogScreen(tone: .cool)
            DappledLight(tint: T.lime).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                TextSphere(word: "AIRA", count: 84, size: 260, energy: 0.55)

                Text("Joint analysis")
                    .font(.system(size: 22, weight: .semibold)).tracking(-0.5)
                    .foregroundStyle(.white)
                    .padding(.top, 26)

                ZStack {
                    ForEach(Array(lines.enumerated()), id: \.offset) { i, l in
                        Text(l)
                            .font(.system(size: 13.5))
                            .foregroundStyle(.white.opacity(0.62))
                            .opacity(i == line ? 1 : 0)
                            .offset(y: i == line ? 0 : 8)
                    }
                }
                .frame(height: 20)
                .padding(.top, 10)
                .animation(.smooth(duration: 0.45), value: line)

                NeonReveal(progress: progress)
                    .padding(.horizontal, 56).padding(.top, 30)

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 11, weight: .semibold)).monospacedDigit()
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.top, 12)

                Spacer()

                Text("This takes a moment — it's reading both sides against each other,\nnot scoring them separately.")
                    .font(.system(size: 11)).foregroundStyle(.white.opacity(0.34))
                    .multilineTextAlignment(.center).lineSpacing(3)
                    .padding(.bottom, 34)
            }
        }
        .task {
            for i in 1...100 {
                try? await Task.sleep(nanoseconds: 52_000_000)
                withAnimation(.linear(duration: 0.06)) { progress = Double(i) / 100 }
                if i % 25 == 0 && line < lines.count - 1 { line += 1 }
            }
            try? await Task.sleep(nanoseconds: 450_000_000)
            Haptic.ok()
            onDone()
        }
    }
}
