import SwiftUI

// MARK: - Mock data（前后文一致：同一套数字贯穿 Recap / Report / Plan）

enum Mock {
    // Last night：总 6:24，Asleep 00:30（平时 23:40），3 ×觉醒共 4rated 2钟，Longest block 2:00
    static let sleepSeq: [(Int, Double)] = [
        (2, 0.85), (3, 0.70), (2, 0.45), (0, 0.12), (1, 0.50), (2, 0.70),
        (3, 0.45), (0, 0.25), (2, 0.80), (1, 0.60), (0, 0.33), (2, 0.60), (1, 0.40)
    ]
    static let sleep7: [Double]  = [7.1, 6.9, 6.2, 6.4, 5.7, 6.6, 6.4]
    static let sleepBase        = 7.47          // 7:28
    static let hpaUser: [Double]     = [4.20, 5.53, 2.33, 1.69, 1.29]   // Strained
    static let hpaBalanced: [Double] = [4.00, 6.20, 1.48, 0.79, 0.46]
    static let activity: [(Double, Double)] = [
        (7, 0.62), (8, 0.78), (9, 0.30), (10, 0.22), (11, 0.18), (12, 0.20),
        (13, 0.08), (14, 0.06), (15, 0.07), (16, 0.16), (17, 0.26),
        (18, 0.70), (19, 0.55), (20, 0.30), (21, 0.12)
    ]
    static let sitting: [(Double, Double, Bool)] = [(9.2, 10.1, false), (13.17, 15.83, true), (20.5, 21.5, false)]
    static let energy: [(Double, Double)] = [(8, 5), (10, 4), (12, 4), (14, 2), (16, 2), (18, 3), (20, 3)]
    static let selfCheck: [Double?] = [2.1, 2.8, 3.1, 3.6, 4.2, 3.4, nil, 2.2, 2.9, 3.8, 4.1, 3.3, 2.4, 1.8]

    /// 近 7d（0 = 今天往前第 6 天 … 6 = 昨天）
    struct Day {
        var date: String; var weekday: String
        var sleep: String; var sleepDelta: Int
        var wakeups: Int; var awakeMin: Int
        var longest: String
        var onset: String; var onsetDelta: Int
        var recovery: Int; var recoveryDelta: Int
        var hrv: Int; var rhr: Int
        var steps: String
        var note: String

        /// 由Duration / 觉醒×数 / Longest block段推出的分期序列，保证和卡上的数字一致
        var seq: [(Int, Double)] {
            guard sleep != "—" else { return [] }
            let total = Mock.hm(sleep)
            let longestH = Mock.hm(longest)
            let n = max(1, wakeups)
            let rest = max(0.2, total - longestH)
            let per = rest / Double(n)
            let gap = (Double(awakeMin) / Double(n)) / 60
            // 最长段放在前段，之后交替
            var out: [(Int, Double)] = split(longestH, startDeep: true)
            for i in 0..<n {
                out.append((0, gap))
                out.append(contentsOf: split(per, startDeep: i == 0))
            }
            return out
        }
        private func split(_ len: Double, startDeep: Bool) -> [(Int, Double)] {
            guard len > 0.05 else { return [(2, max(0.05, len))] }
            if len < 0.6 { return [(2, len * 0.6), (1, len * 0.4)] }
            let a = len * 0.38, b = len * 0.27, c = len * 0.2, d = len - a - b - c
            return startDeep ? [(2, a), (3, b), (2, c), (1, d)] : [(2, a), (1, b), (2, c), (3, d)]
        }

        var onsetHour: Double {
            guard onset != "—" else { return 24 }
            let v = Mock.hm(onset)
            return v < 12 ? v + 24 : v
        }
        var baseOnsetHour: Double { onsetHour - Double(onsetDelta) / 60 }
        var wakeHour: Double { onsetHour + Mock.hm(sleep) + Double(awakeMin) / 60 }
    }
    static let hrv14: [Double] = [49, 47, 50, 46, 44, 48, 45, 43, 41, 38, 41, 40, 42, 40]
    static let rhr14: [Double] = [57, 58, 57, 59, 60, 58, 59, 61, 62, 63, 61, 62, 61, 62]

    /// 9/15–9/30：基线良好期（30 天窗口的前段，衬出 10 月的恶化轨迹）
    static let earlier: [Day] = {
        let spec: [(String, String, String, Int, Int, String, String, Int, Int, Int, Int, Int, String)] = [
            ("09/15", "周一", "7:28", 0,  1,  "4:50", "23:40", 0,  42, -5, 51, 56, "9,850"),
            ("09/16", "周二", "7:18", -10, 1, "4:35", "23:42", 2,  44, -3, 50, 57, "10,340"),
            ("09/17", "周三", "7:33", 5,  1,  "5:00", "23:38", -2, 41, -6, 52, 56, "8,920"),
            ("09/18", "周四", "7:12", -16, 1, "4:20", "23:48", 8,  45, -2, 49, 57, "9,480"),
            ("09/19", "周五", "6:56", -32, 2, "3:40", "00:04", 24, 49, 2,  47, 58, "8,350"),
            ("09/20", "周六", "7:41", 13, 1,  "5:05", "23:52", 12, 42, -5, 51, 56, "6,780"),
            ("09/21", "周日", "7:25", -3, 1,  "4:45", "23:44", 4,  43, -4, 50, 57, "7,640"),
            ("09/22", "周一", "7:20", -8, 1,  "4:30", "23:41", 1,  44, -3, 50, 57, "10,120"),
            ("09/23", "周二", "7:15", -13, 1, "4:25", "23:46", 6,  45, -2, 49, 57, "9,760"),
            ("09/24", "周三", "7:30", 2,  1,  "4:55", "23:39", -1, 42, -5, 51, 56, "9,210"),
            ("09/25", "周四", "7:08", -20, 2, "4:00", "23:50", 10, 46, -1, 48, 58, "8,870"),
            ("09/26", "周五", "6:50", -38, 2, "3:30", "00:08", 28, 50, 3,  47, 58, "8,540"),
            ("09/27", "周六", "7:36", 8,  1,  "5:00", "23:55", 15, 43, -4, 51, 56, "5,980"),
            ("09/28", "周日", "7:22", -6, 1,  "4:40", "23:45", 5,  44, -3, 50, 57, "7,320"),
            ("09/29", "周一", "7:14", -14, 1, "4:22", "23:43", 3,  45, -2, 49, 57, "9,930"),
            ("09/30", "周二", "7:26", -2, 1,  "4:48", "23:40", 0,  43, -4, 50, 57, "10,050")
        ]
        return spec.map { d in
            Day(date: d.0, weekday: d.1, sleep: d.2, sleepDelta: d.3, wakeups: d.4, awakeMin: d.4 * 6,
                longest: d.5, onset: d.6, onsetDelta: d.7, recovery: d.8, recoveryDelta: d.9,
                hrv: d.10, rhr: d.11, steps: d.12, note: "一个平稳的基线夜。")
        }
    }()

    // ===== 时间范围聚合：detail 页 7d/30d 切换共用 =====

    /// 最近 n 天（含缺失日）
    static func recent(_ n: Int) -> [Day] { Array(days.suffix(n)) }
    /// 最近 n 天的有效值序列（跳过缺失日）
    static func series(_ n: Int, _ f: (Day) -> Double) -> [Double] {
        recent(n).filter { $0.sleep != "—" }.map(f)
    }
    static func avg(_ n: Int, _ f: (Day) -> Double) -> Double {
        let v = series(n, f)
        return v.isEmpty ? 0 : v.reduce(0, +) / Double(v.count)
    }
    static func avgSleepText(_ n: Int) -> String {
        let h = avg(n) { hm($0.sleep) }
        let m = Int((h * 60).rounded())
        return "\(m / 60):" + String(format: "%02d", m % 60)
    }
    /// 缺失日数量（给"已剔除"文案）
    static func missing(_ n: Int) -> Int { recent(n).filter { $0.sleep == "—" }.count }

    static func hm(_ s: String) -> Double {
        let p = s.split(separator: ":").compactMap { Double($0) }
        guard p.count == 2 else { return 0 }
        return p[0] + p[1] / 60
    }

    static let days: [Day] = earlier + [
        .init(date: "10/01", weekday: "周三", sleep: "7:22", sleepDelta: -6,  wakeups: 1, awakeMin: 7,
              longest: "4:40", onset: "23:35", onsetDelta: -5, recovery: 44, recoveryDelta: -3,
              hrv: 50, rhr: 57, steps: "10,210", note: "这周最平稳的一夜。"),
        .init(date: "10/02", weekday: "周四", sleep: "7:10", sleepDelta: -18, wakeups: 1, awakeMin: 10,
              longest: "4:05", onset: "23:45", onsetDelta: 5, recovery: 46, recoveryDelta: -1,
              hrv: 49, rhr: 57, steps: "9,640", note: "在正常范围内。"),
        .init(date: "10/03", weekday: "周五", sleep: "6:48", sleepDelta: -40, wakeups: 2, awakeMin: 16,
              longest: "3:20", onset: "00:02", onsetDelta: 22, recovery: 50, recoveryDelta: 3,
              hrv: 47, rhr: 58, steps: "8,980", note: "周五开始往后漂。"),
        .init(date: "10/04", weekday: "周六", sleep: "7:35", sleepDelta: 7,   wakeups: 1, awakeMin: 8,
              longest: "4:55", onset: "23:50", onsetDelta: 10, recovery: 43, recoveryDelta: -4,
              hrv: 51, rhr: 56, steps: "6,320", note: "周末补回来了一些。"),
        .init(date: "10/05", weekday: "周日", sleep: "7:04", sleepDelta: -24, wakeups: 2, awakeMin: 13,
              longest: "3:45", onset: "23:58", onsetDelta: 18, recovery: 47, recoveryDelta: 0,
              hrv: 48, rhr: 58, steps: "7,450", note: "仍接近基线。"),
        .init(date: "10/06", weekday: "周一", sleep: "6:58", sleepDelta: -30, wakeups: 2, awakeMin: 15,
              longest: "3:30", onset: "00:00", onsetDelta: 20, recovery: 49, recoveryDelta: 2,
              hrv: 48, rhr: 58, steps: "9,120", note: "新的一周开始。"),
        .init(date: "10/07", weekday: "周二", sleep: "6:50", sleepDelta: -38, wakeups: 2, awakeMin: 17,
              longest: "3:10", onset: "00:05", onsetDelta: 25, recovery: 52, recoveryDelta: 5,
              hrv: 46, rhr: 59, steps: "8,700", note: "趋势开始偏离。"),
        .init(date: "10/08", weekday: "周三", sleep: "7:06", sleepDelta: -22, wakeups: 1, awakeMin: 9,
              longest: "4:10", onset: "23:50", onsetDelta: 10, recovery: 51, recoveryDelta: 4,
              hrv: 47, rhr: 58, steps: "9,140", note: "相对完整的一夜。"),
        .init(date: "10/09", weekday: "周四", sleep: "6:54", sleepDelta: -34, wakeups: 2, awakeMin: 18,
              longest: "3:05", onset: "00:05", onsetDelta: 25, recovery: 55, recoveryDelta: 8,
              hrv: 45, rhr: 59, steps: "7,820", note: "入睡点开始往后滑。"),
        .init(date: "10/10", weekday: "周五", sleep: "—", sleepDelta: 0, wakeups: 0, awakeMin: 0,
              longest: "—", onset: "—", onsetDelta: 0, recovery: 0, recoveryDelta: 0,
              hrv: 0, rhr: 0, steps: "—", note: "该日无记录 —— 已从均值中剔除。"),
        .init(date: "10/11", weekday: "周六", sleep: "6:12", sleepDelta: -76, wakeups: 4, awakeMin: 51,
              longest: "1:40", onset: "00:40", onsetDelta: 60, recovery: 68, recoveryDelta: 21,
              hrv: 38, rhr: 63, steps: "5,410", note: "睡得最碎的一夜。"),
        .init(date: "10/12", weekday: "周日", sleep: "6:36", sleepDelta: -52, wakeups: 3, awakeMin: 35,
              longest: "2:20", onset: "00:20", onsetDelta: 40, recovery: 61, recoveryDelta: 14,
              hrv: 41, rhr: 61, steps: "8,900", note: "略有回弹。"),
        .init(date: "10/13", weekday: "周一", sleep: "6:24", sleepDelta: -64, wakeups: 3, awakeMin: 42,
              longest: "2:00", onset: "00:30", onsetDelta: 50, recovery: 64, recoveryDelta: 17,
              hrv: 40, rhr: 62, steps: "8,260", note: "和你说的「醒来仍疲惫」对得上。"),
        .init(date: "10/14", weekday: "周二", sleep: "6:31", sleepDelta: -57, wakeups: 2, awakeMin: 26,
              longest: "2:45", onset: "00:15", onsetDelta: 35, recovery: 60, recoveryDelta: 13,
              hrv: 42, rhr: 61, steps: "6,180", note: "今天还没结束。")
    ]
    /// 时间维度：窗口长度 + 对应的对比基准（基准必须跟着窗口变，否则 delta None意义）
    enum Range: Int, CaseIterable {
        case d7 = 0, d14, d30
        var title: String { ["7天", "14天", "30天"][rawValue] }
        var days: Int { [7, 14, 30][rawValue] }
        var baselineLabel: String { ["前 28 天基线", "前 14 天", "前 90 天基线"][rawValue] }
        var grain: String { ["按日", "按日", "周均值"][rawValue] }
    }
}

// MARK: - Collection状态机

enum SalivaPhase: Int, Comparable {
    case notScheduled = 0, scheduled, collecting, shipped, reportReady
    static func < (a: SalivaPhase, b: SalivaPhase) -> Bool { a.rawValue < b.rawValue }
}

struct SamplePoint: Identifiable {
    let id = UUID()
    var name: String
    var when: String
    var hint: String
    var done: Bool = false
}

// MARK: - 干预建议

/// V1.1 统一推荐：设备数据阶段 / 唾液报告阶段共用一个模型，
/// 卡堆（接受/跳过）、已接受管理、证据链全部走它。
enum RecState { case pending, accepted, skipped }

struct PlanRec: Identifiable {
    let id = UUID()
    var tag: String
    var tagColor: Color
    var title: String
    /// 为什么给你（指着数据说话）
    var because: String
    /// "From:" 证据 chips —— 用户能看到推荐建立在哪些数据上
    var evidence: [String]
    var constraint: String
    var timeline: String
    /// 报告阶段才有：影响权重
    var impact: Double? = nil
    /// 证据里是否含唾液生物标志物
    var saliva: Bool = false
    var state: RecState = .pending
    var done: Int = 0
}

struct Advice: Identifiable {
    let id = UUID()
    var impact: Double
    var tag: String
    var tagColor: Color
    var title: String
    var constraint: String
    var timeline: String
    var adopted: Bool = false
    /// 执行Log it（7d）
    var done: Int = 0
}

// MARK: - Agent

struct AgentQA: Identifiable {
    let id = UUID()
    var q: String
    var a: String
}

/// Agent 主动卡：它会提问并要求补充信息，回答后卡片转为"Confirmed"
struct AgentProbe: Identifiable {
    let id = UUID()
    var context: String
    var question: String
    var options: [String]
    var answered: String? = nil
    var resolved: String = ""
}

// MARK: - 全局状态

@MainActor
final class App: ObservableObject {
    enum Phase { case welcome, connect, syncing, recap, profile, medical, notify, sampling, firstLog, main, icons }

    @Published var phase: Phase = .welcome
    @Published var tab: Int = 0

    // Onboarding
    @Published var nickname = ""
    @Published var notifyGranted = false
    @Published var notifyOn: [Bool] = [false, false, false]
    @Published var trains = true
    @Published var sessionBand = 1
    @Published var heightCm = 168
    @Published var weightKg = 56
    @Published var profStep = 0
    @Published var age = 32
    @Published var sex = 0
    @Published var years = 2
    @Published var injuries: Set<String> = []
    @Published var meds: Set<String> = []
    @Published var weeklySessions = 3
    @Published var wearHours = 20
    @Published var goals: Set<String> = []
    @Published var context: Set<String> = []
    @Published var feel: Double = 3.2
    @Published var healthGranted = false
    @Published var devices: Set<String> = []
    @Published var syncProgress: Double = 0
    @Published var syncedItems: Int = 0

    // 自测
    @Published var selfSelected: Int = 13
    @Published var todayFeel: Double = 2.7
    @Published var loggedToday = false
    @Published var probeVisible = true
    /// 每日主观打卡 5 items（MVP：Sleep quality / Fatigue / Soreness / Mood / Stress）
    @Published var checkIn: [Double] = [3, 3, 2, 3, 3]
    /// Sleep 的三个主观维度：深度 / 时长 / 连续性
    @Published var sleepDims: [Double] = [3, 3, 3]
    var feelBand: Int { max(0, min(4, Int((todayFeel - 1).rounded()))) }

    // Collection
    @Published var saliva: SalivaPhase = .notScheduled
    @Published var points: [SamplePoint] = [
        .init(name: "C1 · 醒后 30 分钟", when: "06:45", hint: "留在床上，起身活动前先取第一管"),
        .init(name: "C2 · 醒后 45 分钟", when: "07:15", hint: "C1 后 30 分钟 —— 这一对决定 CAR"),
        .init(name: "C3 · 午餐前", when: "11:30", hint: "进食前采样，避免食物干扰"),
        .init(name: "C4 · 16–17 点", when: "16:30", hint: "午后低谷"),
        .init(name: "C5 · 睡前", when: "22:30", hint: "决定性的一管 —— 它决定状态分组")
    ]
    @Published var activePoint: Int? = nil
    @Published var retestScheduled = false

    // A2UI 主动信号场景（demo 注入）
    @Published var scenario: SignalKind? = nil
    @Published var scenarioChoice: String? = nil
    @Published var stepIndex: Int = 0

    // Plan
    @Published var advices: [Advice] = [
        .init(impact: 9.1, tag: "Lifestyle", tagColor: T.sky, title: "Fixed wake time (±30 min)",
              constraint: "Daily · ranks above supplements and exercise", timeline: "~2 weeks to feel it · 6 weeks full effect"),
        .init(impact: 8.4, tag: "Breathwork", tagColor: T.lime, title: "10 min slow breathing before bed",
              constraint: "5×/week · no other evening tasks", timeline: "~2 weeks to feel it"),
        .init(impact: 7.2, tag: "Nutrition", tagColor: T.amber, title: "Lunch carbs under 40 g",
              constraint: "Weekdays · targets the afternoon dip", timeline: "~1 week to notice")
    ]

    // Home
    @Published var dayIndex: Int = Mock.days.count - 1   // 默认今天
    @Published var range: Mock.Range = .d7

    // Agent 线程
    @Published var sent: [String] = []        // 用户已点过的快捷回复（驱动线程推进）
    @Published var unread: Int = 2
    @Published var typing = false

    // Plan空态：根据硬件数据推荐的 activity
    @Published var suggestions: [Suggestion] = [
        .init(title: "Stand 2 min every hour",
              because: "You sat 2 h 40 m straight from 13:10–15:50 — right on the energy trough",
              meta: "Weekdays · start this afternoon"),
        .init(title: "Phone down at 22:30",
              because: "Median sleep onset over 5 days is 00:30 — 50 min later than baseline",
              meta: "Daily · try one week"),
        .init(title: "20-min brisk walk in the afternoon",
              because: "Only 2 workouts this week, and Saturday was your most fragmented night",
              meta: "3×/week · no added intensity")
    ]

    @Published var arranged: [Arranged] = []

    // V1.1 —— 推荐卡堆（按数据阶段切换）
    /// 设备数据阶段：只依赖已同步的可穿戴数据
    @Published var deviceRecs: [PlanRec] = [
        .init(tag: "活动", tagColor: T.sky,
              title: "每小时站立 2 分钟",
              because: "你从 13:10 到 15:50 连续坐了 2 小时 40 分 —— 正好压在精力低谷上。",
              evidence: ["活动 · 7天", "14:00 自评"],
              constraint: "工作日 · 今天下午就开始",
              timeline: "几天内可感知"),
        .init(tag: "睡眠", tagColor: T.violet,
              title: "22:30 放下手机",
              because: "近 5 天入睡点中位数是 00:30 —— 比你的基线晚了 50 分钟。",
              evidence: ["入睡点 · 5天", "基线 28天"],
              constraint: "每天 · 先试一周",
              timeline: "入睡点通常 1–2 周内前移"),
        .init(tag: "活动", tagColor: T.sky,
              title: "下午快走 20 分钟",
              because: "这周只有 2 次运动，而周六是你睡得最碎的一夜。",
              evidence: ["运动 · 7天", "睡眠 10/12"],
              constraint: "每周 3 次 · 不加强度",
              timeline: "一周内可感知")
    ]
    /// 报告阶段：生物标志物 + 硬件数据联合推荐
    @Published var reportRecs: [PlanRec] = [
        .init(tag: "生活方式", tagColor: T.sky,
              title: "固定起床时间（±30 分钟）",
              because: "唯一同时作用于两端的杠杆 —— 晨间上升与夜间关机。定住起床时间，入睡点会自己前移。",
              evidence: ["CAR 32%", "入睡点 · 5天", "AUCg 33.3"],
              constraint: "每天 · 优先级高于补剂和运动",
              timeline: "约 2 周有感 · 6 周完整效果",
              impact: 9.1, saliva: true),
        .init(tag: "呼吸练习", tagColor: T.lime,
              title: "睡前 10 分钟缓慢呼吸",
              because: "你的夜间皮质醇一直降不下来（睡前 1.29，平衡值 0.4）—— 这个练习正好打在这个点上。",
              evidence: ["睡前皮质醇 1.29", "HRV · 14天"],
              constraint: "每周 5 次 · 晚间不安排其他任务",
              timeline: "约 2 周有感",
              impact: 8.4, saliva: true),
        .init(tag: "营养", tagColor: T.amber,
              title: "午餐碳水控制在 40 g 以内",
              because: "14:00–16:00 是你皮质醇最低的窗口 —— 午餐碳水过重会加深这个低谷。",
              evidence: ["16:30 皮质醇 1.69", "14:00 自评"],
              constraint: "工作日 · 针对午后低谷",
              timeline: "约 1 周可感知",
              impact: 7.2, saliva: true)
    ]

    /// 当前阶段的卡堆（待决项）
    var deck: [PlanRec] { (saliva == .reportReady ? reportRecs : deviceRecs).filter { $0.state == .pending } }
    var acceptedRecs: [PlanRec] {
        (deviceRecs + reportRecs).filter { $0.state == .accepted }
    }
    var skippedCount: Int { (saliva == .reportReady ? reportRecs : deviceRecs).filter { $0.state == .skipped }.count }

    func setRec(_ id: UUID, _ st: RecState) {
        func apply(_ arr: inout [PlanRec]) {
            if let i = arr.firstIndex(where: { $0.id == id }) {
                arr[i].state = st
                if st == .accepted { arr[i].done = 0 }
            }
        }
        withAnimation(.spring(response: 0.36, dampingFraction: 0.84)) {
            apply(&deviceRecs); apply(&reportRecs)
        }
        if st == .accepted { Haptic.ok() } else { Haptic.soft() }
    }
    func restoreSkipped() {
        withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
            for i in deviceRecs.indices where deviceRecs[i].state == .skipped { deviceRecs[i].state = .pending }
            for i in reportRecs.indices where reportRecs[i].state == .skipped { reportRecs[i].state = .pending }
        }
        Haptic.tap()
    }

    // Agent
    @Published var probe = AgentProbe(
        context: "Workout log check",
        question: "I only see 2 workouts logged this week. Anything missing?",
        options: ["Nothing missing", "Yes, let me add", "I really didn't train"]
    )


    // 导航：全局只有一个 sheet 路由，避免同层多个 .sheet 互相吞掉
    @Published var sheet: Sheet? = nil
    /// 整屏联合分析态（出Report前唯一一次长任务）
    @Published var analyzing = false

    /// 从一个 sheet 里跳到另一个 sheet。
    /// SwiftUI 的 .sheet(item:) 在已呈现时直接换 item 会被静默吞掉 ——
    /// 必须先收起、等转场结束再呈现，否则二级页点了没反应。
    func go(_ next: Sheet?) {
        Haptic.tap()
        guard sheet != nil, let next else { sheet = next; return }
        sheet = nil
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 420_000_000)
            sheet = next
        }
    }

    /// 实验室回信 → 整屏联合分析 → Report
    func deliverReport() {
        for i in points.indices { points[i].done = true }
        sheet = nil
        withAnimation(.smooth) { analyzing = true }
    }

    func finishAnalyzing() {
        withAnimation(.smooth(duration: 0.5)) {
            analyzing = false; saliva = .reportReady; tab = 1; unread = 1
        }
    }
    var showReport: Bool { get { sheet == .report } set { sheet = newValue ? .report : nil } }
    var showGuidance: Bool { get { sheet == .guidance } set { sheet = newValue ? .guidance : nil } }
    var showTesting: Bool { get { sheet == .testing } set { sheet = newValue ? .testing : nil } }

    var sleepDeltaMin: Int { Int((Mock.sleepBase - 6.4) * 60) }   // 64

    /// 启动参数直达某一屏：./build.sh report / today / plan …（演示与自测用）
    init() {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-start"), i + 1 < args.count else { return }
        switch args[i + 1] {
        case "connect": phase = .connect
        case "connected": phase = .connect; healthGranted = true
        case "profile": phase = .profile
        case "medical": phase = .medical
        case "notify":  phase = .notify
        case "sampling": phase = .sampling
        case "firstLog": phase = .firstLog
        case "recap":   phase = .recap
        case "today":   phase = .main; tab = 0
        case "testing": phase = .main; tab = 0; sheet = .testing
        case "collect": phase = .main; tab = 0; saliva = .scheduled; sheet = .testing
        case "plan":    phase = .main; tab = 2; saliva = .reportReady
        case "report":  phase = .main; tab = 0; saliva = .reportReady; sheet = .report
        // 交互后状态（自测用）
        case "adopted":
            phase = .main; tab = 2; saliva = .reportReady
            for i in reportRecs.indices { reportRecs[i].state = .accepted; reportRecs[i].done = 3 }
        case "answered":
            phase = .main; tab = 0
            probe.answered = "Nothing missing"
            probe.resolved = AgentProbeCard.resolve("Nothing missing")
        case "guide":
            phase = .main; tab = 0; saliva = .scheduled; sheet = .testing
            activePoint = 1; stepIndex = 1; sheet = .guidance
        case "guide1", "guide2", "guide3", "guide4", "guide5":
            phase = .main; tab = 0; saliva = .scheduled; activePoint = 0
            stepIndex = Int(String(args[i + 1].suffix(1)))! - 1; sheet = .guidance
        case "ask":
            phase = .main; tab = 2; saliva = .reportReady; sheet = .ask(AgentKB.plan)
        case "icons":   phase = .icons
        case "settings": phase = .main; tab = 0; healthGranted = true; sheet = .settings
        case "checkin": phase = .main; tab = 0; sheet = .checkIn
        case "nightDetail": phase = .main; tab = 0; sheet = .detail(.night)
        case "recoveryDetail": phase = .main; tab = 0; sheet = .detail(.recovery)
        case "checkin5": phase = .main; tab = 0; sheet = .checkIn  // 手动翻到第 5 步看刻度环
        case "sc1": phase = .main; tab = 1; scenario = .roughNight; unread = 1
        case "sc1a": phase = .main; tab = 1; scenario = .roughNight; scenarioChoice = "Worked late"
        case "sc2": phase = .main; tab = 1; scenario = .fridayPattern; unread = 1
        case "sc3": phase = .main; tab = 1; scenario = .winStreak; unread = 1
        case "sc4": phase = .main; tab = 1; scenario = .liveNudge; unread = 1
        case "sc5": phase = .main; tab = 1; saliva = .scheduled; scenario = .sampleEve; unread = 1
        case "analyzing": phase = .main; tab = 1; analyzing = true
        case "home":    phase = .main; tab = 0
        case "agent":   phase = .main; tab = 1
        case "agentReport": phase = .main; tab = 1; saliva = .reportReady; unread = 1
        case "planEmpty": phase = .main; tab = 2
        case "planLib":
            phase = .main; tab = 2
            for i in suggestions.indices { suggestions[i].state = 2 }
            arranged = [.init(activity: Lib.relax[0], time: "Before bed · 22:00", minutes: 10, done: 3)]
        case "shipped":
            phase = .main; tab = 0; saliva = .shipped; sheet = .testing
            for i in points.indices { points[i].done = true }
        default: break
        }
    }

    /// 演示用：回到初始态
    func reset() {
        nickname = ""; healthGranted = false; notifyGranted = false; notifyOn = [false, false, false]
        devices = []; trains = true; sessionBand = 1
        profStep = 0; meds = []; injuries = []
        syncProgress = 0; syncedItems = 0
        saliva = .notScheduled
        for i in points.indices { points[i].done = false }
        activePoint = nil; stepIndex = 0; retestScheduled = false
        scenario = nil; scenarioChoice = nil
        sent = []; unread = 2; probe.answered = nil; probeVisible = true
        arranged = []; sheet = nil
        for i in suggestions.indices { suggestions[i].state = 0 }
        for i in advices.indices { advices[i].adopted = false; advices[i].done = 0 }
        for i in deviceRecs.indices { deviceRecs[i].state = .pending; deviceRecs[i].done = 0 }
        for i in reportRecs.indices { reportRecs[i].state = .pending; reportRecs[i].done = 0 }
        loggedToday = false; dayIndex = Mock.days.count - 1; range = .d7; tab = 0
        analyzing = false
    }

    func beginSync() {
        phase = .syncing; syncProgress = 0; syncedItems = 0
        Task {
            let items = 4
            for i in 1...items {
                try? await Task.sleep(nanoseconds: 620_000_000)
                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.45)) {
                        syncedItems = i; syncProgress = Double(i) / Double(items)
                    }
                    Haptic.soft()
                }
            }
            try? await Task.sleep(nanoseconds: 450_000_000)
            await MainActor.run { Haptic.ok(); withAnimation(.smooth) { phase = .recap } }
        }
    }

    func schedule() {
        withAnimation(.smooth) { saliva = .scheduled }
        Haptic.ok()
    }

    func completePoint(_ i: Int) {
        points[i].done = true
        if saliva < .collecting { saliva = .collecting }
        if points.allSatisfy({ $0.done }) { withAnimation(.smooth) { saliva = .shipped } }
        Haptic.ok()
    }

    /// Demo 用：直接推进到出Report（走整屏联合分析态）
    func fastForwardToReport() { deliverReport() }

    func adopt(_ id: UUID) {
        guard let i = advices.firstIndex(where: { $0.id == id }) else { return }
        withAnimation(.smooth) { advices[i].adopted = true; advices[i].done = 3 }
        Haptic.ok()
    }
}

enum Sheet: Identifiable, Equatable {
    case testing, guidance, report, checkIn, settings, ask(AskContext), detail(DetailKind), arrange(Activity)
    var id: String {
        switch self {
        case .testing: "testing"; case .guidance: "guidance"; case .report: "report"
        case .checkIn: "checkIn"
        case .settings: "settings"
        case .ask(let c): "ask-\(c.subject)"
        case .detail(let d): "detail-\(d.rawValue)"
        case .arrange(let a): "arrange-\(a.name)"
        }
    }
    static func == (a: Sheet, b: Sheet) -> Bool { a.id == b.id }
}

struct Suggestion: Identifiable {
    let id = UUID()
    var title: String
    var because: String
    var meta: String
    var state: Int = 0        // 0 待定 1 Added 2 已忽略
}

struct AskContext: Identifiable {
    let id = UUID()
    var subject: String
    var presets: [AgentQA]
}

// MARK: - Agent 预设回答（mock，但和上下文严格一致）

enum AgentKB {
    static let sleep = AskContext(subject: "昨夜睡眠", presets: [
        .init(q: "这对我的身体意味着什么？",
              a: "总时长 6:24，比基线少 64 分钟，但更大的问题是整夜断成 5 段，最长一段只有 2 小时。深睡需要长段连续累积 —— 所以才会觉得睡了却没歇着。"),
        .init(q: "为什么我醒来还是累？",
              a: "不是睡少了 —— 是睡碎了。3 次觉醒共 42 分钟，而你的基线是 1.2 次、13 分钟。碎片化会打断深睡累积，而主观疲惫感跟碎片化的相关性比总时长更强。"),
        .init(q: "多久能改善？",
              a: "先把入睡点稳住。固定起床时间通常 1–2 周内就能把入睡点往前拉；碎片化改善得更慢 —— 可测的变化一般出现在第 7–14 天。"),
        .init(q: "偶尔断一天怎么办？",
              a: "一天几乎没有影响。真正会把节律重新带偏的，是连续中断 3 天以上。")
    ])

    static let recovery = AskContext(subject: "恢复负荷", presets: [
        .init(q: "这个 64 是怎么算的？",
              a: "由三个信号共同得出：睡眠 −64 分钟、HRV −8 ms、静息心率 +4 bpm，对照你前 28 天的基线。只有三个信号指向一致时，恢复负荷才会被标记。"),
        .init(q: "是什么引起的？",
              a: "还不能确定。夜间照护和工作冲刺重叠在一起，现有数据分不开它们。唾液皮质醇会有帮助 —— 它能区分 HPA 轴的问题和单纯的睡眠欠债。"),
        .init(q: "需要担心吗？",
              a: "现在还不用。它是一个方向，不是诊断。真正要紧的是它是否持续升高 3 周以上。")
    ])

    static let hpa = AskContext(subject: "HPA 轴", presets: [
        .init(q: "「透支」是什么意思？",
              a: "该启动时启动不了，该停下时停不下来。晨间上升没有出现（CAR 32%，预期 >50%），下午和晚上也始终没降下来（AUCg 33.3，平衡值 22.0）。"),
        .init(q: "和我的睡眠有关系吗？",
              a: "方向上有关：晚上关不掉会让入睡更难，你的入睡点比平时晚了 50 分钟。但只采了一天，我分不清是因果还是巧合。"),
        .init(q: "怎么才能弄清楚？",
              a: "在相同时间点再采 2 天（醒后 +30 分钟和睡前），并记录当天是否有夜间照护。形状在两天里重复出现，才算稳定状态。"),
        .init(q: "DHEA 偏低说明什么？",
              a: "DHEA 2.1 和 0.38 的睾酮/皮质醇比值都指向分解代谢。这是「关不掉」的另一面：警觉得够久，修复那一侧就会被压制。")
    ])

    static let load = AskContext(subject: "今天的负荷", presets: [
        .init(q: "久坐是精力下滑的原因吗？",
              a: "目前只是同时出现。下午本来就有自然的昼夜低谷；久坐可能放大它，也可能只是你那个时段恰好在桌前。要分开它们，需要几天在同一时段有活动的数据。"),
        .init(q: "怎么打断久坐？",
              a: "不用一次全改。在 13:10 设一个站立提醒 —— 每小时 2 分钟就够。目标是打断整块时间，不是增加运动量。恢复负荷偏高时，不要加强度。"),
        .init(q: "8,260 步够吗？",
              a: "对你来说正常（28 天中位数 8,900）。但步数和恢复负荷的相关性很弱，我不会用它下结论。")
    ])

    static let plan = AskContext(subject: "你的计划", presets: [
        .init(q: "为什么起床时间排第一？",
              a: "权重最高（9.1），而且是唯一同时作用于两端的干预 —— 定住起床时间，入睡点会自己前移。"),
        .init(q: "我需要补剂吗？",
              a: "不需要。这一轮不给补剂建议 —— 你的数据还撑不起那个判断，而且行为干预的证据更强。"),
        .init(q: "做不到每天执行怎么办？",
              a: "只在工作日做也可以。只要别连续中断 3 天 —— 那会把刚稳住的节律重新带偏。")
    ])
}
