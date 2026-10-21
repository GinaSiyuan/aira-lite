import SwiftUI

// MARK: - Agent 线程（中间 tab · 产品主干）
// 它不是问答框，是一条被 Agent 主导的旅程线：
// Agent 主动发起 → 用卡片说话 → 要求确认 → 推进到下一个阶段。

enum ThreadItem: Identifiable {
    case agentText(String)
    case agentLead(String)              // 加粗的结论句
    case agentCard(AnyView)
    case agentQualifier(String, String, String?)   // head, body, action
    case user(String)
    case replies([String])
    case stageMark(String)
    case typing
    case deepThink(String)
    case signal(SignalKind)

    var id: String {
        switch self {
        case .agentText(let s):      "t\(s.hashValue)"
        case .agentLead(let s):      "l\(s.hashValue)"
        case .agentCard:             "c\(UUID().uuidString)"
        case .agentQualifier(let h, _, _): "q\(h.hashValue)"
        case .user(let s):           "u\(s.hashValue)"
        case .replies(let a):        "r\(a.joined().hashValue)"
        case .stageMark(let s):      "s\(s.hashValue)"
        case .typing:                "typing"
        case .deepThink(let c):      "dt\(c.hashValue)"
        case .signal(let k):         "sig\(k.rawValue)"
        }
    }
}

struct AgentThreadView: View {
    @EnvironmentObject var app: App
    @State private var typed = ""
    @FocusState private var focus: Bool

    var body: some View {
        VStack(spacing: 0) {
            header
            ContextStrip()
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Color.clear.frame(height: 1).id("top")
                        let list = items
                        ForEach(Array(list.enumerated()), id: \.offset) { i, item in
                            row(item, prev: i > 0 ? list[i - 1] : nil)
                                .padding(.top, gap(item, prev: i > 0 ? list[i - 1] : nil))
                        }
                        Color.clear.frame(height: 10).id("bottom")
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                }
                .scrollIndicators(.hidden)
                .animation(.spring(response: 0.42, dampingFraction: 0.86), value: app.sent.count)
                // iMessage 行为：进入会话永远停在最新一条
                .onAppear { proxy.scrollTo("bottom", anchor: .bottom) }
                .onChange(of: app.sent.count) { _, _ in
                    withAnimation(.smooth) { proxy.scrollTo("bottom", anchor: .bottom) }
                }
                .onChange(of: app.saliva) { _, _ in
                    withAnimation(.smooth) { proxy.scrollTo("bottom", anchor: .bottom) }
                }
                // 主动信号是最新事件 —— 追加在底部并滚过去
                .onChange(of: app.scenario) { _, new in
                    if new != nil { withAnimation(.smooth) { proxy.scrollTo("bottom", anchor: .bottom) } }
                }
            }
            composer
        }
        .overlay(alignment: .top) {
            DappledLight(tint: Color(hex: 0x7FD6C8)).frame(height: 240).allowsHitTesting(false)
        }
    }

    // MARK: 头 —— iMessage 的联系人头：头像居中、名字在下、状态一行

    private var header: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle().fill(.white.opacity(0.10))
                Circle().strokeBorder(.white.opacity(0.18), lineWidth: 1)
                Circle().fill(T.lime).frame(width: 16, height: 16).offset(x: 7, y: -7).blur(radius: 7)
                Icon(.spark, size: 20, weight: 1.9, color: T.lime)
            }
            .frame(width: 46, height: 46)

            HStack(spacing: 4) {
                Text("Aira").font(.system(size: 13.5, weight: .semibold)).foregroundStyle(.white)
                Icon(.chevron, size: 9, weight: 2.2, color: .white.opacity(0.4))
            }
            Text(stageLine).font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.42))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6).padding(.bottom, 12)
        .overlay(alignment: .topTrailing) {
            Button { app.go(.testing) } label: {
                Icon(.drop, size: 16, weight: 1.9, color: .white.opacity(0.8))
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(.white.opacity(0.10)))
                    .contentShape(Circle())
            }
            .buttonStyle(PressStyle())
            .accessibilityLabel("Collection")
            .padding(.trailing, 16).padding(.top, 8)
        }
        .background(
            Rectangle().fill(.clear).background(.ultraThinMaterial.opacity(0.0))
        )
    }

    private var stageLine: String {
        switch app.saliva {
        case .notScheduled: "Tracking · recovery load, 7d"
        case .scheduled:    "Tracking · collection starts tomorrow"
        case .collecting:   "Tracking · collecting \(app.points.filter { $0.done }.count)/5"
        case .shipped:      "Tracking · waiting on the lab"
        case .reportReady:  "Tracking · report and plan"
        }
    }

    // MARK: 行距 —— 同一侧连发贴紧，换人说话才拉开（iMessage 的节奏）

    private func side(_ i: ThreadItem?) -> Int {
        switch i {
        case .user: 1
        case .none: -1
        case .stageMark: -1
        default: 0
        }
    }
    private func gap(_ item: ThreadItem, prev: ThreadItem?) -> CGFloat {
        guard let prev else { return 0 }
        if case .stageMark = item { return 18 }
        if case .stageMark = prev { return 10 }
        return side(item) == side(prev) ? 3 : 14
    }
    private func isTail(_ item: ThreadItem, prev: ThreadItem?) -> Bool { true }

    // MARK: 行

    @ViewBuilder
    private func row(_ item: ThreadItem, prev: ThreadItem?) -> some View {
        let grouped = prev != nil && side(item) == side(prev)

        switch item {
        case .stageMark(let s):
            Text(s)
                .font(.system(size: 10.5, weight: .semibold))
                .foregroundStyle(.white.opacity(0.38))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 2)

        case .agentText(let s):
            bubble(grouped: grouped) { Text(s).font(.system(size: 15, weight: .regular)).lineSpacing(3.5) }

        case .agentLead(let s):
            bubble(grouped: grouped) {
                Text(s).font(.system(size: 15, weight: .semibold)).lineSpacing(3.5)
            }

        case .agentCard(let v):
            v.frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 28).padding(.leading, 2)

        case .agentQualifier(let h, let b, let a):
            Qualifier(head: h, body_: b, action: a) {
                if a?.contains("Arrange") == true { app.schedule(); send("Schedule for tomorrow") }
            }
            .padding(.top, -12)
            .padding(.trailing, 34)

        case .user(let s):
            HStack {
                Spacer(minLength: 52)
                Text(s).font(.system(size: 15))
                    .padding(.horizontal, 15).padding(.vertical, 10)
                    .background(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 19,
                            bottomLeadingRadius: 19,
                            bottomTrailingRadius: grouped ? 19 : 5,
                            topTrailingRadius: 19, style: .continuous)
                        .fill(T.lime)
                    )
                    .foregroundStyle(T.ink)
            }

        case .replies(let opts):
            // iMessage 的建议回复：靠右、胶囊、点一下即发出
            VStack(alignment: .trailing, spacing: 6) {
                ForEach(opts, id: \.self) { o in
                    Button { tapReply(o) } label: {
                        Text(o).font(.system(size: 13.5, weight: .medium))
                            .padding(.horizontal, 15).padding(.vertical, 9)
                            .background(BrightGlass(radius: 18, level: 0.9))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(PressStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 4)

        case .typing:
            bubble(grouped: grouped) {
                HStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle().fill(.white.opacity(0.55)).frame(width: 6, height: 6)
                            .scaleEffect(app.typing ? 1 : 0.6)
                            .animation(.easeInOut(duration: 0.55).repeatForever()
                                .delay(Double(i) * 0.14), value: app.typing)
                    }
                }
                .frame(height: 10)
            }

        case .signal(let k):
            Group {
                switch k {
                case .roughNight:    AlertSignalCard()
                case .fridayPattern: PatternSignalCard()
                case .winStreak:     WinSignalCard()
                case .liveNudge:     NudgeSignalCard()
                case .sampleEve:     SampleEveCard()
                }
            }
            .padding(.trailing, 20)

        case .deepThink(let caption):
            VStack(spacing: 12) {
                TextSphere(word: "AIRA", count: 56, size: 170, energy: 0.5)
                ShinyText(text: caption, size: 12.5)
                    .multilineTextAlignment(.center)
                NeonReveal(progress: 0.62).padding(.horizontal, 30)
            }
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(BrightGlass(radius: 24, level: 0.65))
        }
    }

    @ViewBuilder
    private func bubble<C: View>(grouped: Bool, @ViewBuilder _ c: () -> C) -> some View {
        HStack {
            c()
                .padding(.horizontal, 15).padding(.vertical, 11)
                .background(
                    BrightGlass(corners: .init(
                        topLeading: 19,
                        bottomLeading: grouped ? 19 : 5,
                        bottomTrailing: 19,
                        topTrailing: 19))
                )
                .foregroundStyle(.white)
            Spacer(minLength: 44)
        }
    }

    // MARK: 输入区

    private var composer: some View {
        VStack(spacing: 8) {
            if !contextChips.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        if let p = primaryChip {
                            Button { tapReply(p) } label: {
                                HStack(spacing: 6) {
                                    Icon(.spark, size: 11, weight: 2.2, color: T.ink)
                                    Text(p).font(.system(size: 12.5, weight: .semibold))
                                }
                                .padding(.horizontal, 13).padding(.vertical, 8)
                                .background(Capsule().fill(T.lime))
                                .foregroundStyle(T.ink)
                                .contentShape(Capsule())
                            }
                            .buttonStyle(PressStyle())
                        }
                        ForEach(contextChips.filter { !app.sent.contains($0) }, id: \.self) { c in
                            Button { tapReply(c) } label: {
                                Text(c).font(.system(size: 12.5))
                                    .padding(.horizontal, 13).padding(.vertical, 8)
                                    .background(Capsule().fill(.white.opacity(0.10)))
                                    .overlay(Capsule().strokeBorder(.white.opacity(0.10), lineWidth: 1))
                                    .foregroundStyle(.white.opacity(0.82))
                                    .contentShape(Capsule())
                            }
                            .buttonStyle(PressStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            HStack(spacing: 10) {
                Button { Haptic.tap(); app.go(.checkIn) } label: {
                    Icon(.plus, size: 17, weight: 2, color: .white.opacity(0.75))
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(.white.opacity(0.10)))
                        .contentShape(Circle())
                }
                .buttonStyle(PressStyle())

                HStack(spacing: 8) {
                    TextField("", text: $typed,
                              prompt: Text("Message").foregroundStyle(.white.opacity(0.38)))
                        .textFieldStyle(.plain).font(.system(size: 15))
                        .foregroundStyle(.white)
                        .focused($focus)
                        .submitLabel(.send)
                        .onSubmit { if !typed.isEmpty { send(typed); typed = "" } }
                    Button {
                        if !typed.isEmpty { send(typed); typed = "" }
                    } label: {
                        Icon(.arrowUp, size: 14, weight: 2.4, color: typed.isEmpty ? .white.opacity(0.3) : T.ink)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(typed.isEmpty ? .white.opacity(0.10) : T.lime))
                            .contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                    .disabled(typed.isEmpty)
                    .accessibilityLabel("Send")
                }
                .padding(.leading, 15).padding(.trailing, 5)
                .padding(.vertical, 5)
                .background(Capsule().fill(.white.opacity(0.09)))
                .overlay(Capsule().strokeBorder(.white.opacity(0.13), lineWidth: 1))
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    /// 建议条：第一条是当前阶段的主行动（高亮），后面是追问
    private var primaryChip: String? {
        switch app.saliva {
        case .notScheduled: app.sent.contains("Schedule for tomorrow") ? nil : "Schedule for tomorrow"
        case .reportReady:  app.sent.contains("Open full report") ? nil : "Open full report"
        default: nil
        }
    }
    private var contextChips: [String] {
        switch app.saliva {
        case .notScheduled: ["Why saliva?", "What's wrong with my sleep?", "Show me Home"]
        case .scheduled, .collecting: ["What should I avoid?", "What if I miss a time point?", "Progress?"]
        case .shipped: ["How long will it take?", "What can I do meanwhile?"]
        case .reportReady: ["What does Strained mean?", "Why these three?"]
        }
    }

    private func tapReply(_ s: String) {
        Haptic.tap(); send(s)
    }

    private func send(_ s: String) {
        guard !app.sent.contains(s) else { return }
        withAnimation(.smooth) { app.sent.append(s); app.unread = 0 }
        if s == "Schedule for tomorrow" { app.schedule() }
        if s == "Open full report" { app.go(.report) }
        if s == "Show me Home" { app.tab = 0 }
    }

    // MARK: 线程内容（由状态生成，保证前后文一致）

    private var items: [ThreadItem] {
        var out: [ThreadItem] = []

        out.append(.stageMark("Tue, Oct 14"))
        out.append(.agentText("Your data is in. I looked at the last 7 days."))
        out.append(.agentCard(AnyView(NightCard(compact: true).environmentObject(app))))
        out.append(.agentLead("It's not that you slept less — you slept broken."))
        out.append(.agentText("Total is 64 min below baseline, but the night broke into 5 pieces and the longest was only 2 hours. Deep sleep accumulates in long blocks — which matches you waking up tired."))

        if app.saliva == .notScheduled {
            out.append(.agentQualifier("That's as far as I can go",
                "Sleep and heart rate only show recovery load went up — not why. Night caregiving and a work crunch fell in the same window, and the data can't separate them.",
                nil))
            out.append(.agentText("Salivary cortisol can separate them — the morning rise tells us whether this is the HPA axis itself or plain sleep debt."))
        }

        for s in app.sent { out.append(contentsOf: exchange(for: s)) }

        if app.saliva >= .scheduled && app.saliva < .reportReady {
            out.append(.stageMark("Collection"))
            switch app.saliva {
            case .scheduled:
                out.append(.agentText("Scheduled for tomorrow. First tube within 30 min of waking — I'll remind you at your usual wake time."))
                out.append(.agentText("Stop biotin (vitamin B7) supplements starting tonight — it interferes with the assay."))
            case .collecting:
                let n = app.points.filter { $0.done }.count
                out.append(.agentText("\(n) done. Next up: \(app.points.first(where: { !$0.done })?.name ?? "") at \(app.points.first(where: { !$0.done })?.when ?? "")."))
            case .shipped:
                out.append(.agentText("All five tubes are in and shipped. Results usually take 5–7 business days."))
                out.append(.agentText("I'll keep watching your sleep meanwhile. If onset steadies, we'll be able to tell which changes came from the intervention."))
            default: break
            }
        }

        if app.saliva == .reportReady {
            out.append(.stageMark("Report"))
            if !app.sent.contains("Open full report") {
                out.append(.deepThink("Running joint analysis on your saliva result and 30 days of wearable data"))
            }
            out.append(.agentText("The report is in."))
            out.append(.agentLead("You're Strained — can't get going when you should, can't stop when you should."))
            out.append(.agentCard(AnyView(HPAMiniCard())))
            out.append(.agentText("The morning rise that should be there didn't happen (CAR 32%, expected >50%), and the afternoon and evening never came down (AUCg 33.3 vs 22.0 for Balanced). Both ends match what you told me."))
            out.append(.agentQualifier("Only one day",
                "Only one day sampled. Balanced and Strained overlap on single-day data — add the +30 min and before-bed points to confirm.", nil))
            out.append(.agentText("I drafted three, ranked by impact. The first one works on both ends at once."))
            out.append(.agentCard(AnyView(PlanHandoffCard())))
        }

        // 主动信号：最新事件，追加在线程末尾
        if let sc = app.scenario {
            out.append(.stageMark(scStage(sc)))
            out.append(contentsOf: scLead(sc))
            out.append(.signal(sc))
            if app.scenarioChoice != nil, case .roughNight = sc {
                out.append(.agentText("I've tagged today accordingly. If tonight rebounds, this stays an incident, not a trend — I'll check at 07:00 and won't bother you unless it repeats."))
            }
        }

        if app.typing { out.append(.typing) }
        return out
    }

    private func scStage(_ k: SignalKind) -> String {
        switch k {
        case .roughNight: "Wed, Oct 15 · 07:02"
        case .fridayPattern: "Mon, Oct 20 · weekly read"
        case .winStreak: "Sun, Oct 19 · 09:10"
        case .liveNudge: "Today · 14:02"
        case .sampleEve: "Tue, Oct 14 · 19:45"
        }
    }
    private func scLead(_ k: SignalKind) -> [ThreadItem] {
        switch k {
        case .roughNight:
            [.agentText("Morning. Before you look at Home — last night was an outlier and I'd rather you hear it from me with context.")]
        case .fridayPattern:
            [.agentText("Weekly read is in. One thing stood out that single days can't show:")]
        case .winStreak:
            [.agentText("Something worth seeing before the week starts:")]
        case .liveNudge:
            []
        case .sampleEve:
            [.agentText("Quick one before the evening gets away:")]
        }
    }

    private func exchange(for s: String) -> [ThreadItem] {
        var out: [ThreadItem] = [.user(s)]
        switch s {
        case "Schedule for tomorrow":
            out.append(.agentText("Done. First tube at 06:45 tomorrow — I'll remind you. The step-by-step guide lives under Collection."))
        case "Why saliva?":
            out.append(.agentText("Saliva is the only easy way to measure free cortisol — most of what's in blood is protein-bound and doesn't reflect current regulation. Saliva also lets you sample 5× a day; blood doesn't."))
            out.append(.agentText("Cortisol is strongly circadian — 10× between morning and night in the same person. One reading proves nothing; the daily shape does."))
        case "What's wrong with my sleep?":
            out.append(.agentText("Duration is 64 min short, but fragmentation matters more: 3 awakenings totalling 42 min, against a baseline of 1.2 and 13 min. The longest unbroken block is 2 hours — deep sleep can't accumulate."))
        case "Show me Home":
            out.append(.agentText("Sure. Home is organised by day — you can scrub back through the week."))
        case "What should I avoid?":
            out.append(.agentText("Three things: no food or coffee 30 min before, no brushing 10 min before, no exercise after waking. The time point matters more than precision — within 15 minutes is fine."))
        case "What if I miss a time point?":
            out.append(.agentText("Write the actual clock time on the label, not the planned one. I compute CAR from the real time — a wrong label makes it incomparable."))
        case "Progress?":
            out.append(.agentText("\(app.points.filter { $0.done }.count) of 5 done. Next tube \(app.points.first(where: { !$0.done })?.when ?? "—")."))
        case "How long will it take?":
            out.append(.agentText("5–7 business days. You'll hear from me the moment it lands."))
        case "What can I do meanwhile?":
            out.append(.agentText("Start with a fixed wake time. It doesn't depend on saliva, and it helps us attribute changes once the report lands."))
        case "What does Strained mean?":
            out.append(.agentText("Can't get going when you should, can't stop when you should. The morning side means your body hasn't entered a ready state; the evening side means it stays on alert, which makes falling asleep harder."))
        case "Why these three?":
            out.append(.agentText("Fixed wake time carries the highest weight (9.1) and is the only one acting on both ends — set the wake time and sleep onset drifts earlier on its own. The other two target the evening end and the afternoon trough."))
            out.append(.agentText("No supplement advice this round — the data can't support that call yet."))
        case "Open full report":
            out.append(.agentText("Opened. Chapter three is entirely about what still can't be known this round."))
        default:
            out.append(.agentText("That needs data you haven't synced yet. I have sleep, HRV, resting heart rate and activity — happy to go deeper on those. For hormones or metabolism, I'd rather wait for saliva."))
        }
        return out
    }
}

// MARK: - 线程里用的 HPA 精简卡

struct HPAMiniCard: View {
    @EnvironmentObject var app: App
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 9) {
                IBadge(icon: .breath)
                VStack(alignment: .leading, spacing: 1) {
                    Text("HPA axis").font(.system(size: 13, weight: .semibold))
                    Text("Saliva · 10/15").font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Chip(text: "Slower regulation", tone: .warn)
            }
            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Text("Tense").numeral(25).foregroundStyle(T.amber)
                Text("Strained").font(.system(size: 12.5)).foregroundStyle(.white.opacity(0.55))
            }
            .padding(.top, 11)
            HPADeviation().padding(.top, 8)
            Rectangle().fill(.white.opacity(0.12)).frame(height: 1).padding(.vertical, 12)
            StateStrip(here: 3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.7))
        .foregroundStyle(.white)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onTapGesture { app.go(.report) }
    }
}


// MARK: - 上下文感知条：Aira 此刻正读着的数据，点一下直达对应模块

struct ContextStrip: View {
    @EnvironmentObject var app: App

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                chip(icon: .recover, label: "Recovery", value: "60 · high", warn: true) {
                    app.go(.detail(.recovery))
                }
                chip(icon: .moon, label: "Sleep", value: "6:31 ↓64m", warn: true) {
                    app.go(.detail(.night))
                }
                chip(icon: .pulse, label: "HRV", value: "42 ms", warn: false) {
                    app.go(.detail(.recovery))
                }
                if app.saliva == .reportReady {
                    chip(icon: .drop, label: "HPA", value: "Strained", warn: true) {
                        app.go(.report)
                    }
                } else {
                    chip(icon: .drop, label: "Saliva", value: salivaShort, warn: false) {
                        app.go(.testing)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 10)
    }

    private var salivaShort: String {
        switch app.saliva {
        case .notScheduled: "not scheduled"
        case .scheduled: "tomorrow"
        case .collecting: "\(app.points.filter { $0.done }.count)/5"
        case .shipped: "at the lab"
        case .reportReady: "ready"
        }
    }

    @ViewBuilder
    private func chip(icon: Ico, label: String, value: String, warn: Bool,
                      _ action: @escaping () -> Void) -> some View {
        Button { Haptic.tap(); action() } label: {
            HStack(spacing: 6) {
                Icon(icon, size: 12, weight: 2, color: warn ? T.amber : T.lime)
                Text(label).font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.5))
                Text(value).font(.system(size: 10.5, weight: .semibold)).monospacedDigit()
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.horizontal, 11).padding(.vertical, 7)
            .background(BrightGlass(radius: 15, level: 0.8))
            .contentShape(Capsule())
        }
        .buttonStyle(PressStyle())
    }
}

// MARK: - 线程里的 Plan 衔接卡：报告出来后，把三条建议递到手边

struct PlanHandoffCard: View {
    @EnvironmentObject var app: App

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 9) {
                IBadge(icon: .plan)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Three actions drafted").font(.system(size: 13, weight: .semibold))
                    Text("Swipe to accept or skip, over in Plan")
                        .font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
            }
            VStack(spacing: 7) {
                ForEach(Array(app.reportRecs.enumerated()), id: \.element.id) { i, r in
                    HStack(spacing: 9) {
                        Text(String(format: "%.1f", r.impact ?? 0))
                            .font(.system(size: 12, weight: .bold)).monospacedDigit()
                            .foregroundStyle(r.tagColor)
                            .frame(width: 26, alignment: .leading)
                        Text(r.title).font(.system(size: 12.5, weight: .medium))
                            .foregroundStyle(.white.opacity(0.88))
                            .lineLimit(1).minimumScaleFactor(0.85)
                        Spacer(minLength: 4)
                        if r.state == .accepted {
                            Icon(.check, size: 11, weight: 2.6, color: T.lime)
                        }
                    }
                    .padding(.horizontal, 11).padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .fill(.white.opacity(0.07)))
                }
            }
            .padding(.top, 11)

            Button {
                Haptic.tap()
                withAnimation(.spring(response: 0.32, dampingFraction: 0.84)) { app.tab = 2 }
            } label: {
                HStack(spacing: 7) {
                    Text("Review in Plan").font(.system(size: 12.5, weight: .semibold))
                    Icon(.arrowRight, size: 12, weight: 2.2, color: T.ink)
                }
                .foregroundStyle(T.ink)
                .frame(maxWidth: .infinity).padding(.vertical, 11)
                .background(Capsule().fill(T.lime))
                .contentShape(Capsule())
            }
            .buttonStyle(PressStyle())
            .padding(.top, 12)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.7))
        .foregroundStyle(.white)
    }
}
