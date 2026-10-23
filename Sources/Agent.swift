import SwiftUI

// MARK: - ① 卡内追问 chips：带上下文前缀，点一下原地展开，不跳转、不进聊天

struct AgentChips: View {
    var subject: String
    var items: [AgentQA]
    @State private var open: UUID? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Image(systemName: "sparkle").font(.system(size: 9, weight: .bold))
                Text("问 Aira · \(subject)")
                    .font(.system(size: 9, weight: .bold)).tracking(1.2).textCase(.uppercase)
            }
            .foregroundStyle(T.onD3)
            .padding(.top, 2)

            ForEach(items) { qa in
                VStack(alignment: .leading, spacing: 0) {
                    Button {
                        Haptic.tap()
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                            open = (open == qa.id) ? nil : qa.id
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("\(subject)：").font(.system(size: 12.5)).foregroundStyle(T.onD3)
                            Text(qa.q).font(.system(size: 12.5)).foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                            Spacer(minLength: 4)
                            Image(systemName: open == qa.id ? "chevron.down" : "chevron.right")
                                .font(.system(size: 9, weight: .bold)).foregroundStyle(T.onD3)
                        }
                        .padding(.horizontal, 12).padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(.white.opacity(open == qa.id ? 0.16 : 0.10)))
                        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .strokeBorder(.white.opacity(open == qa.id ? 0.3 : 0.18), lineWidth: 1))
                    }
                    .buttonStyle(PressStyle())

                    if open == qa.id {
                        HStack(alignment: .top, spacing: 9) {
                            Rectangle().fill(T.lime).frame(width: 2)
                            Text(qa.a).font(.system(size: 12.5)).foregroundStyle(T.onD2).lineSpacing(3.5)
                        }
                        .padding(.leading, 12).padding(.top, 9).padding(.trailing, 4)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
        }
    }
}

// MARK: - ② Agent 主动卡：它提问并要求补充信息，回答后转为"Confirmed"

struct AgentProbeCard: View {
    @Binding var probe: AgentProbe

    var body: some View {
        FogCard(tone: probe.answered == nil ? .cool : .flat) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 9) {
                    ZStack {
                        Circle().fill(T.sky.opacity(0.22))
                        Image(systemName: probe.answered == nil ? "sparkle" : "checkmark")
                            .font(.system(size: 12, weight: .bold)).foregroundStyle(T.sky)
                    }
                    .frame(width: 30, height: 30)
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Aira wants to check something").font(.system(size: 13, weight: .semibold))
                        Text(probe.context).font(.system(size: 10.5)).foregroundStyle(T.onD3)
                    }
                    Spacer()
                    if probe.answered != nil { Chip(text: "Confirmed", tone: .sky) }
                }

                Text(probe.question).font(.system(size: 14)).lineSpacing(3)

                if let a = probe.answered {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 7) {
                            Image(systemName: "quote.opening").font(.system(size: 9)).foregroundStyle(T.onD3)
                            Text(a).font(.system(size: 13, weight: .medium))
                        }
                        Text(probe.resolved).font(.system(size: 12)).foregroundStyle(T.onD2).lineSpacing(3)
                    }
                    .padding(.top, 2)
                } else {
                    FlowChips(items: probe.options) { opt in
                        withAnimation(.spring(response: 0.36, dampingFraction: 0.84)) {
                            probe.answered = opt
                            probe.resolved = Self.resolve(opt)
                        }
                        Haptic.ok()
                    }
                }
            }
        }
    }

    static func resolve(_ opt: String) -> String {
        switch opt {
        case "Nothing missing":   return "Got it. So training really did drop this week — I'll count that toward recovery load instead of treating it as a logging gap."
        case "Yes, let me add": return "Sure. Once you add it I'll recompute this week's volume and recovery load. Until then I'll mark that conclusion as pending."
        default:           return "Noted — 2 sessions this week. I'll flag it if you stay under 3 for two weeks running."
        }
    }
}

/// 自动换行的 chip 组
struct FlowChips: View {
    var items: [String]
    var onTap: (String) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            ForEach(items, id: \.self) { s in
                Button { Haptic.tap(); onTap(s) } label: {
                    Text(s).font(.system(size: 12.5, weight: .medium))
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .background(Capsule().fill(.white.opacity(0.1)))
                        .overlay(Capsule().strokeBorder(.white.opacity(0.09), lineWidth: 1))
                        .foregroundStyle(.white)
                }
                .buttonStyle(PressStyle())
            }
        }
    }
}

// MARK: - ③ 现象 → 归因 → Next（固定模板，在多处复用）

struct AgentInsight: View {
    var phase: String
    var text: String
    var action: String
    var onAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 6) {
                Image(systemName: "sparkle").font(.system(size: 9, weight: .bold))
                Text(phase).font(.system(size: 9, weight: .bold)).tracking(1.4).textCase(.uppercase)
            }
            .foregroundStyle(T.lime)
            Text(text).font(.system(size: 14)).lineSpacing(3.5).foregroundStyle(.white)
            Button { Haptic.tap(); onAction() } label: {
                HStack(spacing: 7) {
                    Text(action).font(.system(size: 11.5, weight: .semibold)).tracking(0.8)
                    Image(systemName: "arrow.right").font(.system(size: 9, weight: .bold))
                }
                .foregroundStyle(T.lime)
            }
            .buttonStyle(.plain)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(T.lime.opacity(0.08)))
        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(T.lime.opacity(0.55), lineWidth: 1))
        .padding(.top, 14)
    }
}

// MARK: - ④ Ask sheet：底部弹出，带上下文 pill

struct AskSheet: View {
    var ctx: AskContext
    @Environment(\.dismiss) private var dismiss
    @State private var opened: Set<UUID> = []
    @State private var typed = ""
    @State private var custom: [AgentQA] = []

    var body: some View {
        ZStack {
            T.dark.ignoresSafeArea()
            Fog(tone: .cool).opacity(0.75).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkle").font(.system(size: 10, weight: .bold))
                            Text("关于：\(ctx.subject)").font(.system(size: 12, weight: .medium))
                        }
                        .padding(.horizontal, 11).padding(.vertical, 6)
                        .background(Capsule().fill(.white.opacity(0.12)))
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark").font(.system(size: 12, weight: .bold))
                                .foregroundStyle(T.onD2)
                                .frame(width: 30, height: 30)
                                .background(Circle().fill(.white.opacity(0.1)))
                        }
                    }
                    .padding(.top, 8)

                    Text("你想了解什么？")
                        .font(.system(size: 24, weight: .semibold)).tracking(-0.6)

                    VStack(alignment: .leading, spacing: 9) {
                        ForEach(custom + ctx.presets) { qa in
                            VStack(alignment: .leading, spacing: 0) {
                                Button {
                                    Haptic.tap()
                                    withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                                        if opened.contains(qa.id) { opened.remove(qa.id) } else { opened.insert(qa.id) }
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Text(qa.q).font(.system(size: 14)).multilineTextAlignment(.leading)
                                        Spacer(minLength: 4)
                                        Image(systemName: opened.contains(qa.id) ? "chevron.down" : "chevron.right")
                                            .font(.system(size: 10, weight: .bold)).foregroundStyle(T.onD3)
                                    }
                                    .padding(.horizontal, 14).padding(.vertical, 13)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .fill(.white.opacity(0.06)))
                                    .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .strokeBorder(.white.opacity(0.07), lineWidth: 1))
                                    .foregroundStyle(.white)
                                }
                                .buttonStyle(PressStyle())
                                if opened.contains(qa.id) {
                                    HStack(alignment: .top, spacing: 10) {
                                        Rectangle().fill(T.sky).frame(width: 2)
                                        Text(qa.a).font(.system(size: 13.5)).foregroundStyle(T.onD2).lineSpacing(4)
                                    }
                                    .padding(.leading, 14).padding(.top, 10)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }
                    }

                    HStack(spacing: 10) {
                        TextField("", text: $typed, prompt: Text("问点别的……").foregroundStyle(T.onD3))
                            .textFieldStyle(.plain)
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 13)
                            .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(.white.opacity(0.06)))
                            .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .strokeBorder(.white.opacity(0.07), lineWidth: 1))
                            .submitLabel(.send)
                            .onSubmit(send)
                        Button(action: send) {
                            Image(systemName: "arrow.up").font(.system(size: 14, weight: .bold))
                                .foregroundStyle(T.ink)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(typed.isEmpty ? Color.white.opacity(0.2) : T.lime))
                        }
                        .disabled(typed.isEmpty)
                    }

                    Text("Aira 基于你已同步的数据作答。不用于医疗诊断。")
                        .font(.system(size: 11)).foregroundStyle(T.onD3).padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func send() {
        guard !typed.isEmpty else { return }
        let q = typed
        withAnimation(.spring(response: 0.36, dampingFraction: 0.84)) {
            let qa = AgentQA(q: q, a: "这需要你还没同步的数据。我手上有睡眠、HRV、静息心率和活动 —— 这些可以聊得很深。激素和代谢的问题，等唾液结果回来我再答。")
            custom.insert(qa, at: 0)
            opened.insert(qa.id)
            typed = ""
        }
        Haptic.ok()
    }
}

// MARK: - Ask Aira 的统一入口按钮（挂在卡片右上）

struct AskButton: View {
    var action: () -> Void
    var body: some View {
        Button { Haptic.tap(); action() } label: {
            HStack(spacing: 5) {
                Image(systemName: "sparkle").font(.system(size: 10, weight: .bold))
                Text("问 Aira").font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Capsule().fill(.white.opacity(0.12)))
            .overlay(Capsule().strokeBorder(.white.opacity(0.08), lineWidth: 1))
            .foregroundStyle(.white)
        }
        .buttonStyle(PressStyle())
    }
}
