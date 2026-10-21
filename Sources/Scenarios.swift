import SwiftUI

// MARK: - 主动信号（A2UI）
// Agent 不是等着被问的 chatbot：数据越界时它先开口，而且每类信号有自己的交互形态。
// 1 夜间告警（归因 chips）  2 模式洞察（周历热图）  3 连胜强化（streak）  4 实时轻推（内嵌倒计时）

enum SignalKind: Int { case roughNight = 1, fridayPattern, winStreak, liveNudge, sampleEve }

// MARK: 1 · 夜间告警 —— 脉冲环 + 双读数 + 归因选择

struct AlertSignalCard: View {
    @EnvironmentObject var app: App
    private let options = ["Drinks last night", "Worked late", "Feeling off / sick", "Nothing special"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                PulseRing(color: T.coral)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Overnight signal").font(.system(size: 13, weight: .semibold))
                    Text("07:02 · three signals moved together").font(.system(size: 10.5))
                        .foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Chip(text: "Unusual", tone: .warn)
            }

            HStack(spacing: 8) {
                alertStat("4:12", "Sleep", "↓ 3h16m vs baseline")
                alertStat("31", "HRV ms", "↓ 11 vs 14-day band")
                alertStat("64", "RHR bpm", "↑ 6 overnight")
            }
            .padding(.top, 13)

            Text("This isn't a normal bad night — all three moved the same direction at once. Before I read anything into it: what happened yesterday?")
                .font(.system(size: 13.5)).foregroundStyle(.white.opacity(0.8)).lineSpacing(3.5)
                .padding(.top, 13)

            if let chosen = app.scenarioChoice {
                attribution(chosen)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                FlowWrap(options) { o in
                    Button {
                        Haptic.ok()
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                            app.scenarioChoice = o
                        }
                    } label: {
                        Text(o).font(.system(size: 12.5, weight: .medium))
                            .padding(.horizontal, 13).padding(.vertical, 9)
                            .background(Capsule().fill(.white.opacity(0.10)))
                            .overlay(Capsule().strokeBorder(.white.opacity(0.16), lineWidth: 1))
                            .foregroundStyle(.white)
                            .contentShape(Capsule())
                    }
                    .buttonStyle(PressStyle())
                }
                .padding(.top, 12)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.75))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous)
            .strokeBorder(T.coral.opacity(0.4), lineWidth: 1.2))
        .foregroundStyle(.white)
    }

    @ViewBuilder
    private func alertStat(_ v: String, _ k: String, _ d: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(v).numeral(19).foregroundStyle(T.coral)
            Text(k).font(.system(size: 9.5)).foregroundStyle(.white.opacity(0.5))
            Text(d).font(.system(size: 8.5)).foregroundStyle(.white.opacity(0.35))
                .lineLimit(1).minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(.white.opacity(0.07)))
    }

    @ViewBuilder
    private func attribution(_ choice: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 7) {
                Icon(.check, size: 11, weight: 2.6, color: T.ink)
                    .frame(width: 20, height: 20).background(Circle().fill(T.lime))
                Text(choice).font(.system(size: 12.5, weight: .semibold))
            }
            Text(explain(choice))
                .font(.system(size: 12.5)).foregroundStyle(.white.opacity(0.75)).lineSpacing(3)
            HStack(spacing: 7) {
                Icon(.plan, size: 11, weight: 2, color: T.lime)
                Text("Today adjusted: no intensity · 20-min walk stays · breathing moved to 21:30")
                    .font(.system(size: 11.5, weight: .medium)).foregroundStyle(T.lime)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(T.lime.opacity(0.10)))
        }
    }

    private func explain(_ c: String) -> String {
        switch c {
        case "Drinks last night":
            "That explains the shape — alcohol suppresses REM early and lifts heart rate all night. One night won't move your baseline; I'll exclude today from trend fits."
        case "Worked late":
            "Late cognitive load delays melatonin and keeps the stress axis up. I'll watch whether tonight rebounds on its own before reading more into it."
        case "Feeling off / sick":
            "Elevated RHR + suppressed HRV is also how illness looks before symptoms. Respiratory rate is up 0.8 — I'd take today genuinely easy."
        default:
            "Then it stays an open question. If tonight looks the same, it's a pattern, not an incident — I'll re-check tomorrow at 07:00."
        }
    }
}

/// 呼吸的告警环
struct PulseRing: View {
    var color: Color = T.coral
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let k = (sin(t * 2.4) + 1) / 2
            ZStack {
                Circle().stroke(color.opacity(0.5 - k * 0.4), lineWidth: 1.6)
                    .scaleEffect(1 + k * 0.45)
                Circle().fill(color.opacity(0.16))
                Icon(.pulse, size: 15, weight: 2.1, color: color)
            }
            .frame(width: 34, height: 34)
        }
        .frame(width: 34, height: 34)
    }
}

// MARK: 2 · 模式洞察 —— 四周迷你周历，周五列点亮

struct PatternSignalCard: View {
    @EnvironmentObject var app: App
    private let options = ["Social nights", "Weekly deadline", "Hadn't noticed"]
    private let onset: [[Double]] = [   // 4 周 × 7 天，0=正常 1=很晚
        [0.2, 0.1, 0.3, 0.2, 0.8, 0.5, 0.2],
        [0.1, 0.2, 0.2, 0.3, 0.9, 0.6, 0.1],
        [0.3, 0.1, 0.2, 0.2, 0.7, 0.4, 0.2],
        [0.2, 0.3, 0.1, 0.2, 0.9, 0.5, 0.3]
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                IBadge(icon: .calendar)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Pattern found").font(.system(size: 13, weight: .semibold))
                    Text("4 weeks of sleep onset").font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Chip(text: "Recurring", tone: .sky)
            }

            // 点阵周历：一晚一个点，点越大越亮 = 睡得越晚；周五整列抬出来
            ZStack {
                // 周五列的底色带
                GeometryReader { g in
                    let colW = g.size.width / 7
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(T.amber.opacity(0.12))
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(T.amber.opacity(0.35), lineWidth: 1))
                        .frame(width: colW)
                        .offset(x: colW * 4)
                }
                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) { i, d in
                            Text(d).font(.system(size: 9, weight: .bold))
                                .foregroundStyle(i == 4 ? T.amber : .white.opacity(0.35))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    ForEach(0..<4, id: \.self) { w in
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { d in
                                let v = onset[w][d]
                                Circle()
                                    .fill(d == 4 ? T.amber : Color.white.opacity(0.22 + v * 0.3))
                                    .frame(width: 5 + v * 9, height: 5 + v * 9)
                                    .opacity(d == 4 ? 0.55 + v * 0.45 : 1)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 15)
                            }
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { d in
                            Text(d == 4 ? "+1 h" : " ")
                                .font(.system(size: 8.5, weight: .bold)).monospacedDigit()
                                .foregroundStyle(T.amber)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.top, 13)

            Text("Every Friday for four weeks, you fall asleep about an hour later — and Saturday's recovery pays for it. Is Friday something regular?")
                .font(.system(size: 13.5)).foregroundStyle(.white.opacity(0.8)).lineSpacing(3.5)
                .padding(.top, 13)

            if let chosen = app.scenarioChoice {
                VStack(alignment: .leading, spacing: 9) {
                    Text(chosen == "Hadn't noticed"
                         ? "Worth knowing about, then. Nothing to fix if Fridays matter to you — the cost is one slower Saturday morning."
                         : "Keep it — I won't optimise your life away. One tweak protects Saturday: a 10:30 wind-down alarm on Fridays, and no morning plan items on Saturdays.")
                        .font(.system(size: 12.5)).foregroundStyle(.white.opacity(0.75)).lineSpacing(3)
                    if chosen != "Hadn't noticed" {
                        HStack(spacing: 7) {
                            Icon(.bell, size: 11, weight: 2, color: T.lime)
                            Text("Friday wind-down added · Saturday mornings kept free")
                                .font(.system(size: 11.5, weight: .medium)).foregroundStyle(T.lime)
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(T.lime.opacity(0.10)))
                    }
                }
                .padding(.top, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                FlowWrap(options) { o in
                    Button {
                        Haptic.ok()
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { app.scenarioChoice = o }
                    } label: {
                        Text(o).font(.system(size: 12.5, weight: .medium))
                            .padding(.horizontal, 13).padding(.vertical, 9)
                            .background(Capsule().fill(.white.opacity(0.10)))
                            .overlay(Capsule().strokeBorder(.white.opacity(0.16), lineWidth: 1))
                            .foregroundStyle(.white)
                            .contentShape(Capsule())
                    }
                    .buttonStyle(PressStyle())
                }
                .padding(.top, 12)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.75))
        .foregroundStyle(.white)
    }
}

// MARK: 3 · 连胜强化 —— 不只报喜，给一个"锁住它"的动作

struct WinSignalCard: View {
    @EnvironmentObject var app: App
    @State private var locked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    Circle().fill(T.lime.opacity(0.2))
                    Icon(.flame, size: 16, weight: 2, color: T.lime)
                }
                .frame(width: 34, height: 34)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Five steady nights").font(.system(size: 13, weight: .semibold))
                    Text("Sleep onset · past 5 days").font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Text("STREAK 5").font(.system(size: 9, weight: .bold)).tracking(1)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Capsule().fill(T.lime)).foregroundStyle(T.ink)
            }

            // 入睡点稳稳落在 25 分钟窗里：带状目标区 + 折线
            VStack(spacing: 5) {
                GeometryReader { g in
                    let w = g.size.width, h = g.size.height
                    // 23:30–00:15 映射到 0…1
                    let vals: [Double] = [0.49, 0.40, 0.76, 0.24, 0.56]
                    let X: (Int) -> CGFloat = { i in w * (0.06 + 0.88 * CGFloat(i) / 4) }
                    let Y: (Double) -> CGFloat = { v in h * (0.12 + 0.76 * (1 - v)) }
                    ZStack {
                        // 25 分钟窗（0.2…0.8 区段）
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(T.lime.opacity(0.10))
                            .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .strokeBorder(T.lime.opacity(0.28), style: .init(lineWidth: 1, dash: [3, 3])))
                            .frame(height: h * 0.52)
                            .offset(y: -h * 0.02)
                        Canvas { ctx, sz in
                            var p = Path()
                            for i in 0..<5 {
                                let pt = CGPoint(x: X(i), y: Y(vals[i]))
                                if i == 0 { p.move(to: pt) } else {
                                    let cx = (X(i-1) + X(i)) / 2
                                    p.addCurve(to: pt, control1: .init(x: cx, y: Y(vals[i-1])),
                                               control2: .init(x: cx, y: pt.y))
                                }
                            }
                            ctx.stroke(p, with: .color(T.lime), style: .init(lineWidth: 2, lineCap: .round))
                        }
                        ForEach(0..<5, id: \.self) { i in
                            Circle().fill(T.lime).frame(width: 7, height: 7)
                                .overlay(Circle().strokeBorder(Color(hex: 0x16211C), lineWidth: 1.6))
                                .position(x: X(i), y: Y(vals[i]))
                        }
                        Text("25-min window").font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(T.lime.opacity(0.7))
                            .position(x: w - 44, y: h * 0.16)
                    }
                }
                .frame(height: 64)
                HStack(spacing: 0) {
                    ForEach(Array(["23:52", "23:48", "00:04", "23:41", "23:55"].enumerated()), id: \.offset) { _, t in
                        Text(t).font(.system(size: 8.5, weight: .medium)).monospacedDigit()
                            .foregroundStyle(.white.opacity(0.45))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 14)

            Text("Onset has stayed inside a 25-minute window for five nights — that's the fixed-wake-time work paying off. The morning fog usually follows within a week.")
                .font(.system(size: 13.5)).foregroundStyle(.white.opacity(0.8)).lineSpacing(3.5)
                .padding(.top, 13)

            Button {
                Haptic.ok()
                withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { locked = true }
            } label: {
                HStack(spacing: 7) {
                    Icon(locked ? .check : .lock, size: 12, weight: 2.3, color: T.ink)
                    Text(locked ? "Locked in — weekend wake time pinned" : "Lock it in: keep wake time through the weekend")
                        .font(.system(size: 12.5, weight: .semibold))
                        .lineLimit(1).minimumScaleFactor(0.8)
                }
                .foregroundStyle(T.ink)
                .frame(maxWidth: .infinity).padding(.vertical, 11)
                .background(Capsule().fill(T.lime.opacity(locked ? 0.75 : 1)))
                .contentShape(Capsule())
            }
            .buttonStyle(PressStyle())
            .disabled(locked)
            .padding(.top, 13)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.75))
        .foregroundStyle(.white)
    }
}

// MARK: 4 · 实时轻推 —— 气泡里直接给一个能跑的 2 分钟计时器

struct NudgeSignalCard: View {
    @State private var running = false
    @State private var remain = 120
    @State private var done = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                IBadge(icon: .clock)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Right now · 14:02").font(.system(size: 13, weight: .semibold))
                    Text("Sitting 1 h 48 m · energy trough window").font(.system(size: 10.5))
                        .foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
            }

            Text("You're in the exact window where your afternoon dip bites. Two minutes on your feet now beats coffee at 15:00.")
                .font(.system(size: 13.5)).foregroundStyle(.white.opacity(0.8)).lineSpacing(3.5)
                .padding(.top, 12)

            HStack(spacing: 12) {
                ZStack {
                    Circle().stroke(.white.opacity(0.12), lineWidth: 5)
                    Circle()
                        .trim(from: 0, to: CGFloat(120 - remain) / 120)
                        .stroke(T.lime, style: .init(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text(done ? "✓" : String(format: "%d:%02d", remain / 60, remain % 60))
                        .font(.system(size: 15, weight: .semibold)).monospacedDigit()
                        .foregroundStyle(done ? T.lime : .white)
                }
                .frame(width: 58, height: 58)
                .animation(.linear(duration: 1), value: remain)

                if done {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Done — logged to today").font(.system(size: 13, weight: .semibold))
                        Text("Sitting streak broken at 1 h 50 m").font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                } else {
                    Button {
                        Haptic.ok(); start()
                    } label: {
                        Text(running ? "Standing…" : "Stand up · start 2:00")
                            .font(.system(size: 13, weight: .semibold)).foregroundStyle(T.ink)
                            .padding(.horizontal, 16).padding(.vertical, 11)
                            .background(Capsule().fill(T.lime))
                            .contentShape(Capsule())
                    }
                    .buttonStyle(PressStyle())
                    .disabled(running)
                }
                Spacer(minLength: 0)
            }
            .padding(.top, 13)

            Text("Snoozing moves it to 15:00 — after that the window's gone for today.")
                .font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.35))
                .padding(.top, 10)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.75))
        .foregroundStyle(.white)
    }

    private func start() {
        running = true
        Task { @MainActor in
            // demo 节奏：8 倍速跑完 2 分钟
            while remain > 0 {
                try? await Task.sleep(nanoseconds: 125_000_000)
                remain -= 1
            }
            Haptic.ok()
            withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) { done = true; running = false }
        }
    }
}


// MARK: 5 · 采集日前夜 —— 可勾选的准备清单 + 明早第一管的倒计时感

struct SampleEveCard: View {
    @EnvironmentObject var app: App
    @State private var checks = [false, true, false]
    @State private var decided: String? = nil
    private let items = [
        ("Tubes on the nightstand", "So you don't stand up to find them — first tube is before moving"),
        ("Biotin stopped", "Last dose was 36 h ago — assay-safe"),
        ("Alarm set for 06:40", "First tube 06:45, second 07:15 — the pair defines CAR")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                IBadge(icon: .drop)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Tomorrow is sampling day").font(.system(size: 13, weight: .semibold))
                    Text("First tube 06:45 · within 30 min of waking")
                        .font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                Chip(text: "In 11 h", tone: .sky)
            }

            Text("Everything's set from my side. Three things on yours — tick them off so tomorrow runs itself:")
                .font(.system(size: 13.5)).foregroundStyle(.white.opacity(0.8)).lineSpacing(3.5)
                .padding(.top, 12)

            VStack(spacing: 7) {
                ForEach(Array(items.enumerated()), id: \.offset) { i, it in
                    Button {
                        Haptic.ok()
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) { checks[i].toggle() }
                    } label: {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().strokeBorder(.white.opacity(checks[i] ? 0 : 0.3), lineWidth: 1.5)
                                if checks[i] {
                                    Circle().fill(T.lime)
                                    Icon(.check, size: 10, weight: 2.6, color: T.ink)
                                }
                            }
                            .frame(width: 22, height: 22)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(it.0).font(.system(size: 13, weight: .semibold))
                                    .strikethrough(checks[i], color: .white.opacity(0.4))
                                    .foregroundStyle(.white.opacity(checks[i] ? 0.5 : 1))
                                Text(it.1).font(.system(size: 10.5)).foregroundStyle(.white.opacity(0.4))
                                    .lineLimit(2)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 11).padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(.white.opacity(checks[i] ? 0.04 : 0.08)))
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 11)

            if let d = decided {
                HStack(spacing: 8) {
                    Icon(d == "ready" ? .check : .calendar, size: 12, weight: 2.3, color: T.lime)
                    Text(d == "ready"
                         ? "See you at 06:45 — I'll wake you through each tube."
                         : "Moved to Thursday. Same time points, and biotin stays off.")
                        .font(.system(size: 12, weight: .medium)).foregroundStyle(T.lime)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(T.lime.opacity(0.10)))
                .padding(.top, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                HStack(spacing: 9) {
                    Button {
                        Haptic.ok()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.84)) { decided = "ready" }
                    } label: {
                        Text("I'm ready").font(.system(size: 12.5, weight: .semibold))
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Capsule().fill(T.lime)).foregroundStyle(T.ink)
                            .contentShape(Capsule())
                    }
                    .buttonStyle(PressStyle())
                    Button {
                        Haptic.tap()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.84)) { decided = "push" }
                    } label: {
                        Text("Push one day").font(.system(size: 12.5, weight: .medium))
                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                            .background(Capsule().fill(.white.opacity(0.10)))
                            .overlay(Capsule().strokeBorder(.white.opacity(0.14), lineWidth: 1))
                            .foregroundStyle(.white)
                            .contentShape(Capsule())
                    }
                    .buttonStyle(PressStyle())
                }
                .padding(.top, 12)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrightGlass(radius: 22, level: 0.75))
        .foregroundStyle(.white)
    }
}
