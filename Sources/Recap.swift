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
                        SectionLabel(text: "来自已同步数据 · 10月7日 – 13日")
                        Text("数据里已经\n能看出一些东西了")
                            .font(.serifZh(27))
                        Text("不用等唾液 —— 最近 7 天的睡眠和心率，已经能说出一部分。")
                            .font(.system(size: 13.5)).foregroundStyle(T.ink2).lineSpacing(3)
                    }
                    .padding(.top, 18)

                    RecoveryCard()
                    NightCard()

                    // Aira 的第一个判断 —— 和其他雾面卡同一套卡头
                    FogCard(tone: .warm) {
                        VStack(alignment: .leading, spacing: 12) {
                            CardHead(icon: .spark, title: "Aira 的第一个判断",
                                     sub: "设备数据 × 你自己的话")
                            Text("不是睡少了 —— 是睡碎了。")
                                .font(.system(size: 19, weight: .semibold)).tracking(-0.5)
                            Text("总时长比基线少 64 分钟，但更关键的是整夜断成 5 段，最长一段只有 2 小时。深睡需要长段连续累积 —— 这正对上你醒来仍然疲惫。")
                                .font(.system(size: 13.5)).foregroundStyle(T.onD2).lineSpacing(4)

                            Qualifier(
                                head: "我只能说到这里",
                                body_: "睡眠和心率只能显示恢复负荷升高了 —— 说不了为什么。夜间照护和工作冲刺重叠在一起，数据分不开它们。",
                                action: nil
                            )
                        }
                    }

                    // 唾液能补上什么 —— 同一张雾面卡语言，不再换白壳
                    FogCard(tone: .flat) {
                        VStack(alignment: .leading, spacing: 13) {
                            CardHead(icon: .drop, title: "唾液能补上什么",
                                     sub: "三个设备数据答不了的问题")
                            ForEach(Array([
                                ("是「启动不了」，还是单纯没睡够", "清晨两个点之间的上升幅度（CAR）能把它们区分开"),
                                ("晚上到底有多难「关机」", "睡前那一管，是五种状态唯一能分开的点"),
                                ("是消耗太多，还是修复太少", "DHEA 与睾酮/皮质醇比值，指向完全不同的干预")
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
                CTA(title: "继续") { app.phase = .profile }
                Button("跳过设置，直接进首页") { Haptic.tap(); app.phase = .main; app.tab = 0 }
                    .font(.system(size: 13)).foregroundStyle(T.ink3)
            }
            .padding(.horizontal, 20).padding(.top, 10).padding(.bottom, 20)
        }
        .onAppear { withAnimation(.smooth(duration: 0.55)) { appear = true } }
    }
}
