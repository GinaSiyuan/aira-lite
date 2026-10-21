import SwiftUI

// MARK: - Report：Facts → 图 → 趋势 → Caveat（固定四段式，每节都走完）

struct ReportView: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    @State private var chapter = 0

    private let chapters = ["01 HPA axis", "02 vs. how you felt", "03 Still uncertain"]

    var body: some View {
        ZStack {
            PageBG()
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        SectionLabel(text: "Saliva report · collected 10/15")
                        Text("Your state: Strained")
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
                        CTA(title: "Build the plan") {
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
                    SectionLabel(text: "Facts")
                    Text("Five samples on 10/15: 4.20 / 5.53 / 2.33 / 1.69 / 1.29 ng/mL.")
                        .font(.system(size: 14)).lineSpacing(3.5)
                    HStack(spacing: 6) {
                        ForEach(["Saliva · Eurofins", "Original units: ng/mL"], id: \.self) { s in
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
                            Text("HPA axis").font(.system(size: 13, weight: .semibold))
                            Text("Saliva · 10/15 · 5 points").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        }
                        Spacer()
                        Chip(text: "Slower regulation", tone: .warn)
                    }

                    HStack(alignment: .firstTextBaseline, spacing: 7) {
                        Text("Tense").numeral(27).foregroundStyle(T.amber)
                        Text("Strained").unitText()
                    }
                    .padding(.top, 12)
                    Text("Can't get going in the morning, can't switch off at night")
                        .font(.system(size: 12.5)).foregroundStyle(T.onD2).padding(.top, 5)

                    HPADeviation().padding(.top, 10)

                    DeviationLegend(rows: [
                        .init(color: T.sky.opacity(0.75), title: "Can't get going in the morning",
                              meaning: "The rise that should follow waking didn't happen — your body hasn't entered a ready state, so the first hour or two feels dull.",
                              num: "CAR 32%", sub: "expected >50%"),
                        .init(color: T.coral.opacity(0.8), title: "Can't switch off all day",
                              meaning: "The hours that should drop never did — your body stays on alert, so unwinding and falling asleep get harder.",
                              num: "AUCg 33.3", sub: "Balanced 22.0")
                    ])
                    .padding(.top, 6)

                    Rectangle().fill(T.hairD).frame(height: 1).padding(.vertical, 13)
                    StateStrip(here: 3)

                    Text("Strained = can't start when you should, can't stop when you should.")
                        .font(.system(size: 12.5, weight: .semibold)).padding(.top, 13)
                    Text("Matches what you said about waking tired and falling asleep later.")
                        .font(.system(size: 12)).foregroundStyle(T.onD2).padding(.top, 2)

                    HStack(spacing: 7) {
                        Chip(text: "DHEA 2.1 low", tone: .warn)
                        Chip(text: "Testosterone/cortisol 0.38", tone: .off)
                    }
                    .padding(.top, 12)

                    Qualifier(head: "Only one day",
                              body_: "Only one day sampled. Add the +30 min and before-bed points to confirm this is a stable state, not a one-day swing.",
                              action: "Schedule a re-test") { }

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
                    CardHead(icon: .pulse, title: "All signals, one shape",
                             sub: "Drag to rotate · amber = outside your band")
                    WireframeBall(nodes: [
                        .init(name: "Sleep", value: 0.38, warn: true),
                        .init(name: "HRV", value: 0.42, warn: true),
                        .init(name: "RHR", value: 0.70, warn: false),
                        .init(name: "Steps", value: 0.62, warn: false),
                        .init(name: "CAR", value: 0.30, warn: true),
                        .init(name: "Evening cortisol", value: 0.82, warn: true),
                        .init(name: "DHEA", value: 0.34, warn: true),
                        .init(name: "Self-report", value: 0.45, warn: false)
                    ], size: 250)
                    .frame(maxWidth: .infinity)
                }
            }

            LiteCard {
                VStack(alignment: .leading, spacing: 10) {
                    SectionLabel(text: "Facts")
                    Text("Device: cortisol is lowest 14:00–16:00.\nSelf-report: 4 of 5 days rated 1–2 at 14:00.")
                        .font(.system(size: 14)).lineSpacing(4)
                }
            }

            FogCard(tone: .cool) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 9) {
                        IBadge(icon: .pulse)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Felt vs. measured").font(.system(size: 13, weight: .semibold))
                            Text("Device × self-report").font(.system(size: 10.5)).foregroundStyle(T.onD3)
                        }
                        Spacer()
                        Chip(text: "4 of 5 days match", tone: .sky)
                    }
                    DualTrack().padding(.top, 12)
                    Text("You run low in the afternoon and evening — exactly when you said you feel the slump.")
                        .font(.system(size: 13.5)).lineSpacing(3.5).padding(.top, 8)
                    Qualifier(head: "Day 5 didn't match",
                              body_: "That day was rated 3 at 14:00. One day of saliva still can't confirm the cause.")
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
                        Text("A hypothesis from Aira").font(.system(size: 13, weight: .semibold))
                        Spacer()
                        Chip(text: "Unconfirmed", tone: .off)
                    }
                    Text("Is the short sleep related to cortisol?")
                        .font(.system(size: 17, weight: .semibold)).tracking(-0.4).padding(.top, 12)

                    evidence("Supports", T.lime, [
                        "64 min less sleep per night over 7 days",
                        "Cortisol 1.69 at 16:00 — below the usual range",
                        "Self-reported afternoon slump on 4 of 5 days"
                    ])
                    evidence("Against / unknown", T.coral, [
                        "Saliva sampled on only 1 day",
                        "Night caregiving and a work crunch overlap — inseparable",
                        "Biotin use before testing was never verified"
                    ])

                    Qualifier(head: "How to verify",
                              body_: "Collect 2 more days at the same time points and log whether there was night caregiving. Only a repeated shape counts as stable.",
                              action: "Add both to the plan") { }
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
                    SectionLabel(text: "Why this chapter exists")
                    Text("Because \"not yet known\" matters as much as the conclusion.")
                        .font(.system(size: 17, weight: .semibold)).tracking(-0.4)
                    Text("If Aira buried caveats in grey fine print you'd skip them — and we'd be pretending to know everything.")
                        .font(.system(size: 13)).foregroundStyle(T.ink2).lineSpacing(3.5)
                }
            }

            FogCard(tone: .alert) {
                VStack(alignment: .leading, spacing: 14) {
                    CardHead(icon: .info, title: "Time points and sample size",
                             sub: "Affects the state call", chip: "1 day", chipTone: .warn)
                    HStack(spacing: 5) {
                        ForEach(Array(["C1", "C2", "C3", "C4", "C5"].enumerated()), id: \.offset) { _, s in
                            VStack(spacing: 5) {
                                RoundedRectangle(cornerRadius: 6).fill(T.lime).frame(height: 22)
                                Text(s).font(.system(size: 8.5)).foregroundStyle(T.onD3)
                            }
                        }
                    }
                    Text("All five points were collected, so a state can be computed. But it's one day — and Balanced and Strained overlap on single-day data.")
                        .font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3.5)
                }
            }

            FogCard(tone: .flat) {
                VStack(alignment: .leading, spacing: 13) {
                    SectionLabel(text: "Three things we're not concluding").foregroundStyle(T.onD3)
                    ForEach(Array([
                        ("Night caregiving vs. work stress — which dominates", "They overlap; separating them needs a window with only one present"),
                        ("Whether biotin affected this assay", "Not verified before collection. Immunoassays are biotin-sensitive"),
                        ("Whether low DHEA is chronic or recent", "One measurement, no baseline to compare")
                    ].enumerated()), id: \.offset) { i, p in
                        VStack(alignment: .leading, spacing: 4) {
                            if i > 0 { Rectangle().fill(T.hairD).frame(height: 1).padding(.bottom, 9) }
                            Text(p.0).font(.system(size: 13.5, weight: .semibold))
                            Text(p.1).font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(3)
                        }
                    }
                }
            }

            QualityBadge(text: "Apple Health · Mock data",
                         note: "This demo uses mock data, not real results", critical: true)
        }
    }
}
