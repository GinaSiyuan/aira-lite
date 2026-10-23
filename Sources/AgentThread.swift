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
        case .notScheduled: "追踪中 · 恢复负荷 7 天"
        case .scheduled:    "追踪中 · 明天开始采集"
        case .collecting:   "追踪中 · 已采 \(app.points.filter { $0.done }.count)/5"
        case .shipped:      "追踪中 · 等待实验室"
        case .reportReady:  "追踪中 · 报告与计划"
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
                if a?.contains("安排") == true { app.schedule(); send("安排在明天") }
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
                              prompt: Text("发消息").foregroundStyle(.white.opacity(0.38)))
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
        case .notScheduled: app.sent.contains("安排在明天") ? nil : "安排在明天"
        case .reportReady:  app.sent.contains("打开完整报告") ? nil : "打开完整报告"
        default: nil
        }
    }
    private var contextChips: [String] {
        switch app.saliva {
        case .notScheduled: ["为什么是唾液？", "我的睡眠哪里有问题？", "带我看首页"]
        case .scheduled, .collecting: ["采样日要避免什么？", "错过时间点怎么办？", "进度如何？"]
        case .shipped: ["要等多久？", "等待期间我能做什么？"]
        case .reportReady: ["「透支」是什么意思？", "为什么是这三件事？"]
        }
    }

    private func tapReply(_ s: String) {
        Haptic.tap(); send(s)
    }

    private func send(_ s: String) {
        guard !app.sent.contains(s) else { return }
        withAnimation(.smooth) { app.sent.append(s); app.unread = 0 }
        if s == "安排在明天" { app.schedule() }
        if s == "打开完整报告" { app.go(.report) }
        if s == "带我看首页" { app.tab = 0 }
    }

    // MARK: 线程内容（由状态生成，保证前后文一致）

    private var items: [ThreadItem] {
        var out: [ThreadItem] = []

        out.append(.stageMark("10月14日 周二"))
        out.append(.agentText("你的数据进来了。我看了最近 7 天。"))
        out.append(.agentCard(AnyView(NightCard(compact: true).environmentObject(app))))
        out.append(.agentLead("不是睡少了 —— 是睡碎了。"))
        out.append(.agentText("总时长比基线少 64 分钟，但整夜断成 5 段，最长一段只有 2 小时。深睡需要长段连续累积 —— 这正对上你醒来仍然疲惫。"))

        if app.saliva == .notScheduled {
            out.append(.agentQualifier("我只能说到这里",
                "睡眠和心率只能显示恢复负荷升高了 —— 说不了为什么。夜间照护和工作冲刺落在同一个窗口里，数据分不开它们。",
                nil))
            out.append(.agentText("唾液皮质醇能把它们分开 —— 晨间上升会告诉我们：这是 HPA 轴本身的问题，还是单纯的睡眠欠债。"))
        }

        for s in app.sent { out.append(contentsOf: exchange(for: s)) }

        if app.saliva >= .scheduled && app.saliva < .reportReady {
            out.append(.stageMark("采集"))
            switch app.saliva {
            case .scheduled:
                out.append(.agentText("已安排在明天。醒后 30 分钟内取第一管 —— 我会在你平时的起床时间提醒你。"))
                out.append(.agentText("今晚开始停用生物素（维生素 B7）补剂 —— 它会干扰检测。"))
            case .collecting:
                let n = app.points.filter { $0.done }.count
                out.append(.agentText("已完成 \(n) 管。下一管：\(app.points.first(where: { !$0.done })?.name ?? "")，\(app.points.first(where: { !$0.done })?.when ?? "")。"))
            case .shipped:
                out.append(.agentText("五管全部收齐并寄出了。结果通常需要 5–7 个工作日。"))
                out.append(.agentText("等待期间我会继续盯着你的睡眠。如果入睡点稳定下来，我们就能分清哪些变化来自干预本身。"))
            default: break
            }
        }

        if app.saliva == .reportReady {
            out.append(.stageMark("报告"))
            if !app.sent.contains("打开完整报告") {
                out.append(.deepThink("正在把你的唾液结果与 30 天可穿戴数据做联合分析"))
            }
            out.append(.agentText("报告出来了。"))
            out.append(.agentLead("你的状态是「透支」—— 该启动时启动不了，该停下时停不下来。"))
            out.append(.agentCard(AnyView(HPAMiniCard())))
            out.append(.agentText("该出现的晨间上升没有出现（CAR 32%，预期 >50%），下午和晚上也始终没降下来（AUCg 33.3，平衡值 22.0）。两端都和你说的对得上。"))
            out.append(.agentQualifier("只有一天",
                "只采了一天。单日数据上「平衡」与「透支」会重叠 —— 补采「醒后 +30 分钟」和「睡前」两个点来确认。", nil))
            out.append(.agentText("我起草了三条行动，按影响力排序。第一条同时作用于两端。"))
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
        case "安排在明天":
            out.append(.agentText("好了。明天 06:45 第一管 —— 我会提醒你。分步指引就在「采集」里。"))
        case "为什么是唾液？":
            out.append(.agentText("唾液是测量游离皮质醇唯一方便的途径 —— 血液里的大部分皮质醇被蛋白结合着，反映不了当下的调节状态。而且唾液一天能采 5 次，血液做不到。"))
            out.append(.agentText("皮质醇有很强的昼夜节律 —— 同一个人早晚能差 10 倍。单次读数说明不了什么，一整天的形状才说明问题。"))
        case "我的睡眠哪里有问题？":
            out.append(.agentText("时长少了 64 分钟，但碎片化更关键：3 次觉醒共 42 分钟，而你的基线是 1.2 次、13 分钟。最长连续段只有 2 小时 —— 深睡累积不起来。"))
        case "带我看首页":
            out.append(.agentText("好。首页按天组织 —— 你可以往回拖着看这一周。"))
        case "采样日要避免什么？":
            out.append(.agentText("三件事：采样前 30 分钟不进食不喝咖啡，前 10 分钟不刷牙，醒来后先别运动。时间点比精确更重要 —— 前后 15 分钟内都有效。"))
        case "错过时间点怎么办？":
            out.append(.agentText("在标签上写实际时刻，不要写计划时刻。我按真实时间计算 CAR —— 标错了反而没法比。"))
        case "进度如何？":
            out.append(.agentText("已完成 \(app.points.filter { $0.done }.count)/5。下一管 \(app.points.first(where: { !$0.done })?.when ?? "—")。"))
        case "要等多久？":
            out.append(.agentText("5–7 个工作日。结果一到我马上告诉你。"))
        case "等待期间我能做什么？":
            out.append(.agentText("先固定起床时间。它不依赖唾液结果，而且等报告落地后，也方便我们归因哪些变化来自干预。"))
        case "「透支」是什么意思？":
            out.append(.agentText("该启动时启动不了，该停下时停不下来。早晨那端意味着身体没有进入就绪状态；夜晚那端意味着持续警觉 —— 这会让入睡更难。"))
        case "为什么是这三件事？":
            out.append(.agentText("固定起床时间权重最高（9.1），而且是唯一同时作用于两端的 —— 定住起床时间，入睡点会自己前移。另外两条分别针对夜晚那端和午后低谷。"))
            out.append(.agentText("这一轮不给补剂建议 —— 现有数据还撑不起那个判断。"))
        case "打开完整报告":
            out.append(.agentText("打开了。第三章整章都在讲这一轮还无法断言的事。"))
        default:
            out.append(.agentText("这需要你还没同步的数据。我手上有睡眠、HRV、静息心率和活动 —— 这些可以聊得很深。激素和代谢的问题，我更想等唾液结果。"))
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
                    Text("HPA 轴").font(.system(size: 13, weight: .semibold))
                    Text("唾液 · 10/15").font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Chip(text: "调节变慢", tone: .warn)
            }
            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Text("紧绷").font(.system(size: 24, weight: .semibold)).foregroundStyle(T.amber)
                Text("透支").font(.system(size: 12.5)).foregroundStyle(.white.opacity(0.55))
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
                chip(icon: .recover, label: "恢复", value: "60 · 偏高", warn: true) {
                    app.go(.detail(.recovery))
                }
                chip(icon: .moon, label: "睡眠", value: "6:31 ↓64分", warn: true) {
                    app.go(.detail(.night))
                }
                chip(icon: .pulse, label: "HRV", value: "42 ms", warn: false) {
                    app.go(.detail(.recovery))
                }
                if app.saliva == .reportReady {
                    chip(icon: .drop, label: "HPA", value: "透支", warn: true) {
                        app.go(.report)
                    }
                } else {
                    chip(icon: .drop, label: "唾液", value: salivaShort, warn: false) {
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
        case .notScheduled: "未安排"
        case .scheduled: "明天"
        case .collecting: "\(app.points.filter { $0.done }.count)/5"
        case .shipped: "实验室中"
        case .reportReady: "已出"
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
                    Text("已起草 3 条行动").font(.system(size: 13, weight: .semibold))
                    Text("到「计划」里滑动卡片，接受或跳过")
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
                    Text("去计划里处理").font(.system(size: 12.5, weight: .semibold))
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
