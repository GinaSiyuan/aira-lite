import SwiftUI

// MARK: - First read
// 同步完 30 天就先给价值：用硬件数据给一份站得住的解读，
// 再讲清"what remains unknown and what saliva adds"——让采样变成用户自己想做的事。
// 风格规则：解读一律走 FogCard（深色雾面），和 Home 的卡片同一套语言。

struct InitialRecapView: View {
    @EnvironmentObject var app: App
    @State private var appear = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        SectionLabel(text: "From synced data · Oct 7 – 13")
                        Text("There's already\nsomething to see")
                            .font(.system(size: 28, weight: .semibold, design: .serif)).tracking(-0.6)
                        Text("No need to wait for saliva — your last 7 days of sleep and heart rate already say part of it.")
                            .font(.system(size: 13.5)).foregroundStyle(T.ink2).lineSpacing(3)
                    }
                    .padding(.top, 18)

                    RecoveryCard()
                    NightCard()

                    // Aira 的第一个判断 —— 和其他雾面卡同一套卡头
                    FogCard(tone: .warm) {
                        VStack(alignment: .leading, spacing: 12) {
                            CardHead(icon: .spark, title: "Aira's first read",
                                     sub: "Device data × your own words")
                            Text("It's not that you slept less — you slept broken.")
                                .font(.system(size: 19, weight: .semibold)).tracking(-0.5)
                            Text("Total is 64 min below baseline, but the night broke into 5 pieces with the longest only 2 hours. Deep sleep accumulates in long blocks — which matches you waking up tired.")
                                .font(.system(size: 13.5)).foregroundStyle(T.onD2).lineSpacing(4)

                            Qualifier(
                                head: "That's as far as I can go",
                                body_: "Sleep and heart rate show recovery load rose, but not why. Night caregiving and a work crunch overlap, and the data can't separate them.",
                                action: nil
                            )
                        }
                    }

                    // 唾液能补上什么 —— 同一张雾面卡语言，不再换白壳
                    FogCard(tone: .flat) {
                        VStack(alignment: .leading, spacing: 13) {
                            CardHead(icon: .drop, title: "What saliva adds",
                                     sub: "Three questions device data can't answer")
                            ForEach(Array([
                                ("Can't get going, or simply short on sleep", "The rise across the two morning points (CAR) tells them apart"),
                                ("How badly you can't switch off at night", "The before-bed tube is the one point where all five states separate"),
                                ("Too much drain, or too little repair", "DHEA and the testosterone/cortisol ratio point to different interventions")
                            ].enumerated()), id: \.offset) { i, p in
                                HStack(alignment: .top, spacing: 11) {
                                    Text("0\(i + 1)").font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(T.lime)
                                        .frame(width: 18, alignment: .leading).padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(p.0).font(.system(size: 13.5, weight: .semibold))
                                        Text(p.1).font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(2.5)
                                    }
                                }
                            }
                        }
                    }

                    Color.clear.frame(height: 8)
                }
                .padding(.horizontal, 20)
                .opacity(appear ? 1 : 0).offset(y: appear ? 0 : 18)
            }
            .scrollIndicators(.hidden)

            VStack(spacing: 10) {
                CTA(title: "Continue") { app.phase = .profile }
                Button("Skip setup, go to Home") { Haptic.tap(); app.phase = .main; app.tab = 0 }
                    .font(.system(size: 13)).foregroundStyle(T.ink3)
            }
            .padding(.horizontal, 20).padding(.top, 10).padding(.bottom, 20)
        }
        .onAppear { withAnimation(.smooth(duration: 0.55)) { appear = true } }
    }
}
