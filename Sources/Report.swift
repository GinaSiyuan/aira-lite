import SwiftUI

// MARK: - Report：Facts → 图 → 趋势 → Caveat（固定四段式，每节都走完）

struct ReportView: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    @State private var chapter = 0

    private let chapters = ["01 HPA 轴", "02 对照你的感受", "03 仍不确定"]

    var body: some View {
        ZStack {
            PageBG()
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        SectionLabel(text: "唾液报告 · 采样 10/15")
                        Text("你的状态：透支")
                            .font(.system(size: 20, weight: .semibold)).tracking(-0.5)
                    }
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").font(.system(size: 12, weight: .bold))
                            .foregroundStyle(T.ink2).frame(width: 32, height: 32)
                            .background(Circle().fill(T.hair2))
                    }
                }
                .padding(.horizontal, 20).padding(.top, 16)

                HStack(spacing: 6) {
                    ForEach(Array(chapters.enumerated()), id: \.offset) { i, c in
                        Button {
                            Haptic.tap(); withAnimation(.smooth) { chapter = i }
                        } label: {
                            Text(c).font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 12).padding(.vertical, 7)
                                .background(Capsule().fill(chapter == i ? T.ink : T.hair2))
                                .foregroundStyle(chapter == i ? .white : T.ink2)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20).padding(.top, 14)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        switch chapter {
                        case 0: HPAChapter()
                        case 1: CrossChapter()
                        default: UncertainChapter()
                        }
                        CTA(title: "生成计划") {
                            app.sheet = nil
                            app.tab = 2
                        }
                        .padding(.top, 6)
                        Color.clear.frame(height: 20)
                    }
                    .padding(.horizontal, 20).padding(.top, 16)
                }
            }
        }
    }
}

// MARK: - 第 01 章

private struct HPAChapter: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ① Facts
            LiteCard {
                VStack(alignment: .leading, spacing: 10) {
                    SectionLabel(text: "事实")
                    Text("10/15 共五次采样：4.20 / 5.53 / 2.33 / 1.69 / 1.29 ng/mL。")
                        .font(.system(size: 14)).lineSpacing(3.5)
                    HStack(spacing: 6) {
                        ForEach(["唾液 · Eurofins", "原始单位：ng/mL"], id: \.self) { s in
                            Text(s).font(.system(size: 10.5)).foregroundStyle(T.ink2)
                                .padding(.horizontal, 9).padding(.vertical, 4)
                                .background(Capsule().fill(.white))
                        }
                    }
                }
            }

            // ② 图 + ③ 趋势 + ④ Caveat
            FogCard(tone: .cool) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 9) {
                        IBadge(icon: .breath)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("HPA 轴").font(.system(size: 13, weight: .semibold))
                            Text("唾液 · 10/15 · 5 个点").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        }
                        Spacer()
                        Chip(text: "调节变慢", tone: .warn)
                    }

                    HStack(alignment: .firstTextBaseline, spacing: 7) {
                        Text("紧绷").font(.system(size: 26, weight: .semibold)).foregroundStyle(T.amber)
                        Text("透支").unitText()
                    }
                    .padding(.top, 12)
                    Text("早上启动不了，晚上关不掉")
                        .font(.system(size: 12.5)).foregroundStyle(T.onD2).padding(.top, 5)

                    HPADeviation().padding(.top, 10)

                    DeviationLegend(rows: [
                        .init(color: T.sky.opacity(0.75), title: "早上启动不了",
                              meaning: "醒后该有的上升没有出现 —— 身体没进入就绪状态，所以头一两个小时发闷。",
                              num: "CAR 32%", sub: "预期 >50%"),
                        .init(color: T.coral.opacity(0.8), title: "全天关不掉",
                              meaning: "该下降的时段始终没降 —— 身体持续警觉，放松和入睡都变得更难。",
                              num: "AUCg 33.3", sub: "平衡值 22.0")
                    ])
                    .padding(.top, 6)

                    Rectangle().fill(T.hairD).frame(height: 1).padding(.vertical, 13)
                    StateStrip(here: 3)

                    Text("透支 = 该启动时启动不了，该停下时停不下来。")
                        .font(.system(size: 12.5, weight: .semibold)).padding(.top, 13)
                    Text("和你说的「醒来疲惫、入睡变晚」对得上。")
                        .font(.system(size: 12)).foregroundStyle(T.onD2).padding(.top, 2)

                    HStack(spacing: 7) {
                        Chip(text: "DHEA 2.1 偏低", tone: .warn)
                        Chip(text: "睾酮/皮质醇 0.38", tone: .off)
                    }
                    .padding(.top, 12)

                    Qualifier(head: "只有一天",
                              body_: "只采了一天。补采「醒后 +30 分钟」与「睡前」两个点，确认这是稳定状态，而不是单日波动。",
                              action: "安排复测") { }

                    AgentChips(subject: "HPA axis", items: Array(AgentKB.hpa.presets.prefix(3)))
                        .padding(.top, 14)
                }
            }
        }
    }
}

// MARK: - 第 02 章 · Felt vs. measured

private struct CrossChapter: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 所有信号同看一眼：线框球，指标是球面端点，偏离的点标橙
            FogCard(tone: .cool) {
                VStack(alignment: .leading, spacing: 4) {
                    CardHead(icon: .pulse, title: "所有信号，一个形状",
                             sub: "拖动旋转 · 琥珀色 = 超出你的区间")
                    WireframeBall(nodes: [
                        .init(name: "睡眠", value: 0.38, warn: true),
                        .init(name: "HRV", value: 0.42, warn: true),
                        .init(name: "静息心率", value: 0.70, warn: false),
                        .init(name: "步数", value: 0.62, warn: false),
                        .init(name: "CAR", value: 0.30, warn: true),
                        .init(name: "夜间皮质醇", value: 0.82, warn: true),
                        .init(name: "DHEA", value: 0.34, warn: true),
                        .init(name: "自评", value: 0.45, warn: false)
                    ], size: 250)
                    .frame(maxWidth: .infinity)
                }
            }

            LiteCard {
                VStack(alignment: .leading, spacing: 10) {
                    SectionLabel(text: "事实")
                    Text("设备：皮质醇在 14:00–16:00 最低。\n自评：5 天里有 4 天，14:00 打了 1–2 分。")
                        .font(.system(size: 14)).lineSpacing(4)
                }
            }

            FogCard(tone: .cool) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 9) {
                        IBadge(icon: .pulse)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("感受 vs 测量").font(.system(size: 13, weight: .semibold))
                            Text("设备 × 自评").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        }
                        Spacer()
                        Chip(text: "5 天中 4 天吻合", tone: .sky)
                    }
                    DualTrack().padding(.top, 12)
                    Text("你在下午和傍晚持续走低 —— 正是你说「感觉垮掉」的那段时间。")
                        .font(.system(size: 13.5)).lineSpacing(3.5).padding(.top, 8)
                    Qualifier(head: "第 5 天不吻合",
                              body_: "那天 14:00 自评 3 分。单日唾液仍无法确认因果。")
                }
            }

            // 归因候选：提出假设，不断言
            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 9) {
                        ZStack {
                            Circle().fill(T.lime.opacity(0.2))
                            Image(systemName: "questionmark").font(.system(size: 12, weight: .bold))
                                .foregroundStyle(T.lime)
                        }
                        .frame(width: 30, height: 30)
                        Text("Aira 的一个假设").font(.system(size: 13, weight: .semibold))
                        Spacer()
                        Chip(text: "未证实", tone: .off)
                    }
                    Text("睡眠变短，和皮质醇有关吗？")
                        .font(.system(size: 17, weight: .semibold)).tracking(-0.4).padding(.top, 12)

                    evidence("支持", T.lime, [
                        "近 7 天每晚少睡 64 分钟",
                        "16:00 皮质醇 1.69 —— 低于常见区间",
                        "5 天里 4 天自评午后垮掉"
                    ])
                    evidence("反对 / 未知", T.coral, [
                        "唾液只采了 1 天",
                        "夜间照护与工作冲刺重叠 —— 分不开",
                        "采样前是否停用生物素未核实"
                    ])

                    Qualifier(head: "如何验证",
                              body_: "在相同时间点再采 2 天，并记录是否有夜间照护。只有重复出现的形状才算稳定。",
                              action: "都加进计划") { }
                }
            }
        }
    }

    @ViewBuilder
    private func evidence(_ title: String, _ c: Color, _ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 9, weight: .bold)).tracking(1.3)
                .textCase(.uppercase).foregroundStyle(c)
            ForEach(items, id: \.self) { s in
                HStack(alignment: .top, spacing: 7) {
                    Text("·").foregroundStyle(T.onD3)
                    Text(s).font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(2.5)
                }
            }
        }
        .padding(.top, 13)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 第 03 章 · Still uncertain（Caveat作为独立一章，不是脚注）

private struct UncertainChapter: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LiteCard {
                VStack(alignment: .leading, spacing: 8) {
                    SectionLabel(text: "这一章为什么存在")
                    Text("因为「尚不可知」和结论同样重要。")
                        .font(.system(size: 17, weight: .semibold)).tracking(-0.4)
                    Text("如果 Aira 把注意事项藏进灰色小字，你会跳过 —— 而我们就是在假装全知。")
                        .font(.system(size: 13)).foregroundStyle(T.ink2).lineSpacing(3.5)
                }
            }

            FogCard(tone: .alert) {
                VStack(alignment: .leading, spacing: 14) {
                    CardHead(icon: .info, title: "时间点与样本量",
                             sub: "影响状态判定", chip: "1 天", chipTone: .warn)
                    HStack(spacing: 5) {
                        ForEach(Array(["C1", "C2", "C3", "C4", "C5"].enumerated()), id: \.offset) { _, s in
                            VStack(spacing: 5) {
                                RoundedRectangle(cornerRadius: 6).fill(T.lime).frame(height: 22)
                                Text(s).font(.system(size: 8.5)).foregroundStyle(T.onD3)
                            }
                        }
                    }
                    Text("五个点都采齐了，可以计算状态。但只有一天 —— 单日数据上「平衡」与「透支」会重叠。")
                        .font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3.5)
                }
            }

            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 13) {
                    SectionLabel(text: "三件我们不下结论的事").foregroundStyle(T.onD3)
                    ForEach(Array([
                        ("夜间照护 vs 工作压力 —— 哪个是主因", "两者重叠；分开它们需要一个只有其中之一的窗口"),
                        ("生物素是否影响了这次检测", "采样前未核实。免疫检测法对生物素敏感"),
                        ("DHEA 偏低是长期还是近期", "只有一次测量，没有基线可比")
                    ].enumerated()), id: \.offset) { i, p in
                        VStack(alignment: .leading, spacing: 4) {
                            if i > 0 { Rectangle().fill(T.hairD).frame(height: 1).padding(.bottom, 9) }
                            Text(p.0).font(.system(size: 13.5, weight: .semibold))
                            Text(p.1).font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(3)
                        }
                    }
                }
            }

            QualityBadge(text: "Apple Health · 模拟数据",
                         note: "本演示使用模拟数据，并非真实检测结果", critical: true)
        }
    }
}
