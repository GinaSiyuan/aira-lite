import SwiftUI

// MARK: - Aira 自有图标系统
// 全部在 24×24 栅格上手绘，统一 1.8pt 线宽 / 圆头 / 圆角接合。
// 不用 SF Symbols：那套线宽、端点和圆角都跟我们的卡片语言对不上。

enum Ico: String, CaseIterable {
    // 导航
    case home, spark, plan
    // 指标
    case moon, pulse, clock, steps, drop, breath, flame, scale, recover
    // 活动 · 运动型
    case run, walk, bike, strength, swim, rope
    // 活动 · 休闲型
    case meditate, stretch, coffee, dance, read, bath
    // 功能
    case chevron, arrowUp, arrowRight, close, check, plus, minus, bell, user, calendar, info, refresh, ask, lock
}

struct Icon: View {
    var _n: Ico
    var size: CGFloat = 22
    var weight: CGFloat = 1.8
    var color: Color = T.ink

    init(_ n: Ico, size: CGFloat = 22, weight: CGFloat = 1.8, color: Color = T.ink) {
        self._n = n; self.size = size; self.weight = weight; self.color = color
    }

    var body: some View {
        Canvas { ctx, s in
            let u = s.width / 24
            let st = StrokeStyle(lineWidth: weight, lineCap: .round, lineJoin: .round)
            func P(_ build: (inout Path) -> Void) -> Path {
                var p = Path(); build(&p)
                return p.applying(CGAffineTransform(scaleX: u, y: u))
            }
            func stroke(_ p: Path) { ctx.stroke(p, with: .color(color), style: st) }
            func fill(_ p: Path)   { ctx.fill(p, with: .color(color)) }

            switch _n {
            case .home:
                stroke(P { p in
                    p.move(to: .init(x: 3.6, y: 10.4)); p.addLine(to: .init(x: 12, y: 3.6))
                    p.addLine(to: .init(x: 20.4, y: 10.4)); p.addLine(to: .init(x: 20.4, y: 19))
                    p.addQuadCurve(to: .init(x: 18.6, y: 20.6), control: .init(x: 20.4, y: 20.2))
                    p.addLine(to: .init(x: 5.4, y: 20.6))
                    p.addQuadCurve(to: .init(x: 3.6, y: 19), control: .init(x: 3.6, y: 20.2))
                    p.closeSubpath()
                })
                stroke(P { p in
                    p.move(to: .init(x: 9.4, y: 20.6)); p.addLine(to: .init(x: 9.4, y: 14.6))
                    p.addLine(to: .init(x: 14.6, y: 14.6)); p.addLine(to: .init(x: 14.6, y: 20.6))
                })
            case .spark:
                stroke(P { p in
                    p.move(to: .init(x: 12, y: 3)); p.addQuadCurve(to: .init(x: 21, y: 12), control: .init(x: 13.2, y: 10.8))
                    p.addQuadCurve(to: .init(x: 12, y: 21), control: .init(x: 13.2, y: 13.2))
                    p.addQuadCurve(to: .init(x: 3, y: 12), control: .init(x: 10.8, y: 13.2))
                    p.addQuadCurve(to: .init(x: 12, y: 3), control: .init(x: 10.8, y: 10.8))
                })
            case .plan:
                stroke(P { p in
                    p.addRoundedRect(in: .init(x: 3.8, y: 5, width: 16.4, height: 15.2), cornerSize: .init(width: 3.4, height: 3.4))
                    p.move(to: .init(x: 8.4, y: 3.2)); p.addLine(to: .init(x: 8.4, y: 6.6))
                    p.move(to: .init(x: 15.6, y: 3.2)); p.addLine(to: .init(x: 15.6, y: 6.6))
                    p.move(to: .init(x: 7.6, y: 13)); p.addLine(to: .init(x: 9.4, y: 14.8)); p.addLine(to: .init(x: 13, y: 11))
                })
            case .calendar:
                stroke(P { p in
                    p.addRoundedRect(in: .init(x: 3.8, y: 5, width: 16.4, height: 15.2), cornerSize: .init(width: 3.4, height: 3.4))
                    p.move(to: .init(x: 3.8, y: 9.6)); p.addLine(to: .init(x: 20.2, y: 9.6))
                    p.move(to: .init(x: 8.4, y: 3.2)); p.addLine(to: .init(x: 8.4, y: 6.6))
                    p.move(to: .init(x: 15.6, y: 3.2)); p.addLine(to: .init(x: 15.6, y: 6.6))
                })
            case .moon:
                stroke(P { p in
                    p.move(to: .init(x: 20, y: 14.4))
                    p.addCurve(to: .init(x: 9.8, y: 4.1),
                               control1: .init(x: 14.6, y: 16.6), control2: .init(x: 8.2, y: 11.2))
                    p.addCurve(to: .init(x: 20, y: 14.4),
                               control1: .init(x: 5.2, y: 6.4), control2: .init(x: 6.4, y: 19.4))
                })
            case .pulse:
                stroke(P { p in
                    p.move(to: .init(x: 2.6, y: 12)); p.addLine(to: .init(x: 7.4, y: 12))
                    p.addLine(to: .init(x: 9.6, y: 6.6)); p.addLine(to: .init(x: 13.2, y: 17.6))
                    p.addLine(to: .init(x: 15.6, y: 12)); p.addLine(to: .init(x: 21.4, y: 12))
                })
            case .clock:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 3.4, y: 3.4, width: 17.2, height: 17.2))
                    p.move(to: .init(x: 12, y: 7.6)); p.addLine(to: .init(x: 12, y: 12.4))
                    p.addLine(to: .init(x: 15.6, y: 14.4))
                })
            case .steps:
                // 两枚脚印
                stroke(P { p in
                    p.addEllipse(in: .init(x: 3.4, y: 4.2, width: 5.6, height: 8.4))
                    p.addEllipse(in: .init(x: 3.9, y: 13.4, width: 4.6, height: 3.2))
                    p.addEllipse(in: .init(x: 15, y: 8.2, width: 5.6, height: 8.4))
                    p.addEllipse(in: .init(x: 15.5, y: 17.4, width: 4.6, height: 3.2))
                })
            case .drop:
                stroke(P { p in
                    p.move(to: .init(x: 12, y: 3.2))
                    p.addCurve(to: .init(x: 12, y: 20.6),
                               control1: .init(x: 19.6, y: 11), control2: .init(x: 18.4, y: 20.6))
                    p.addCurve(to: .init(x: 12, y: 3.2),
                               control1: .init(x: 5.6, y: 20.6), control2: .init(x: 4.4, y: 11))
                })
            case .breath:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 6.4, y: 6.4, width: 11.2, height: 11.2))
                    p.addEllipse(in: .init(x: 2.6, y: 2.6, width: 18.8, height: 18.8))
                })
            case .flame:
                stroke(P { p in
                    // 外焰
                    p.move(to: .init(x: 12, y: 2.6))
                    p.addCurve(to: .init(x: 18.2, y: 14.4), control1: .init(x: 12.4, y: 7.6), control2: .init(x: 18.2, y: 9.2))
                    p.addCurve(to: .init(x: 5.8, y: 14.4), control1: .init(x: 18.2, y: 20.6), control2: .init(x: 5.8, y: 20.6))
                    p.addCurve(to: .init(x: 9.2, y: 7.6), control1: .init(x: 5.8, y: 10.8), control2: .init(x: 9.2, y: 10.4))
                    p.addCurve(to: .init(x: 12, y: 2.6), control1: .init(x: 9.2, y: 5.2), control2: .init(x: 11, y: 4))
                    // 内焰
                    p.move(to: .init(x: 12, y: 11.4))
                    p.addCurve(to: .init(x: 14.6, y: 16.4), control1: .init(x: 12.2, y: 13.6), control2: .init(x: 14.6, y: 14.2))
                    p.addCurve(to: .init(x: 9.4, y: 16.4), control1: .init(x: 14.6, y: 19), control2: .init(x: 9.4, y: 19))
                    p.addCurve(to: .init(x: 12, y: 11.4), control1: .init(x: 9.4, y: 14.4), control2: .init(x: 11.8, y: 13.6))
                })
            case .recover:
                // 回升弧 + 向上箭头
                stroke(P { p in
                    p.addArc(center: .init(x: 12, y: 13.6), radius: 7.6,
                             startAngle: .degrees(165), endAngle: .degrees(15), clockwise: false)
                    p.move(to: .init(x: 12, y: 19.4)); p.addLine(to: .init(x: 12, y: 7.4))
                    p.move(to: .init(x: 8.2, y: 11.2)); p.addLine(to: .init(x: 12, y: 7.4))
                    p.addLine(to: .init(x: 15.8, y: 11.2))
                })
            case .scale:
                // 体重秤：圆角方 + 表盘弧 + 指针
                stroke(P { p in
                    p.addRoundedRect(in: .init(x: 3.4, y: 4.4, width: 17.2, height: 15.2), cornerSize: .init(width: 4.4, height: 4.4))
                    p.addArc(center: .init(x: 12, y: 14.6), radius: 5.2,
                             startAngle: .degrees(190), endAngle: .degrees(350), clockwise: false)
                    p.move(to: .init(x: 12, y: 14.6)); p.addLine(to: .init(x: 14.8, y: 10.8))
                })
            // ---- 运动型
            case .run:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 13.2, y: 2.8, width: 3.6, height: 3.6))
                    p.move(to: .init(x: 14.6, y: 8)); p.addLine(to: .init(x: 10.2, y: 10.6))
                    p.addLine(to: .init(x: 11.6, y: 14.4)); p.addLine(to: .init(x: 8.6, y: 20.6))
                    p.move(to: .init(x: 11.6, y: 14.4)); p.addLine(to: .init(x: 16, y: 16.4))
                    p.addLine(to: .init(x: 17, y: 20.6))
                    p.move(to: .init(x: 10.2, y: 10.6)); p.addLine(to: .init(x: 5.6, y: 12.6))
                })
            case .walk:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 10.6, y: 2.8, width: 3.6, height: 3.6))
                    p.move(to: .init(x: 12.4, y: 8)); p.addLine(to: .init(x: 12.4, y: 13.8))
                    p.move(to: .init(x: 12.4, y: 13.8)); p.addLine(to: .init(x: 9.6, y: 20.6))
                    p.move(to: .init(x: 12.4, y: 13.8)); p.addLine(to: .init(x: 15.4, y: 20.6))
                    p.move(to: .init(x: 12.4, y: 9.6)); p.addLine(to: .init(x: 8.8, y: 11.8))
                    p.move(to: .init(x: 12.4, y: 9.6)); p.addLine(to: .init(x: 16, y: 11.4))
                })
            case .bike:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 1.6, y: 11.2, width: 9.6, height: 9.6))
                    p.addEllipse(in: .init(x: 12.8, y: 11.2, width: 9.6, height: 9.6))
                    p.move(to: .init(x: 6.4, y: 16)); p.addLine(to: .init(x: 10, y: 8.2))
                    p.addLine(to: .init(x: 15.4, y: 8.2))
                    p.move(to: .init(x: 10, y: 8.2)); p.addLine(to: .init(x: 17.6, y: 16))
                    p.move(to: .init(x: 6.4, y: 16)); p.addLine(to: .init(x: 13.6, y: 11.4))
                    p.move(to: .init(x: 14.6, y: 5.6)); p.addLine(to: .init(x: 17.2, y: 5.6))
                })
            case .strength:
                stroke(P { p in
                    p.move(to: .init(x: 3, y: 9.4)); p.addLine(to: .init(x: 3, y: 14.6))
                    p.move(to: .init(x: 21, y: 9.4)); p.addLine(to: .init(x: 21, y: 14.6))
                    p.addRoundedRect(in: .init(x: 5.2, y: 7.4, width: 3.2, height: 9.2), cornerSize: .init(width: 1.4, height: 1.4))
                    p.addRoundedRect(in: .init(x: 15.6, y: 7.4, width: 3.2, height: 9.2), cornerSize: .init(width: 1.4, height: 1.4))
                    p.move(to: .init(x: 8.4, y: 12)); p.addLine(to: .init(x: 15.6, y: 12))
                })
            case .swim:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 14.6, y: 4.2, width: 3.6, height: 3.6))
                    p.move(to: .init(x: 3.4, y: 13.2)); p.addLine(to: .init(x: 9.6, y: 9.2))
                    p.addLine(to: .init(x: 14.8, y: 11.4))
                    p.move(to: .init(x: 9.6, y: 9.2)); p.addLine(to: .init(x: 11.6, y: 5.4))
                    p.move(to: .init(x: 2.6, y: 18)); p.addQuadCurve(to: .init(x: 8, y: 18), control: .init(x: 5.3, y: 15.8))
                    p.addQuadCurve(to: .init(x: 13.4, y: 18), control: .init(x: 10.7, y: 20.2))
                    p.addQuadCurve(to: .init(x: 18.8, y: 18), control: .init(x: 16.1, y: 15.8))
                    p.addQuadCurve(to: .init(x: 21.6, y: 18.6), control: .init(x: 20.4, y: 19.4))
                })
            case .rope:
                stroke(P { p in
                    p.move(to: .init(x: 6.4, y: 5.2)); p.addLine(to: .init(x: 6.4, y: 17))
                    p.move(to: .init(x: 17.6, y: 5.2)); p.addLine(to: .init(x: 17.6, y: 17))
                    p.addRoundedRect(in: .init(x: 5, y: 17), width: 2.8, height: 3.6)
                    p.addRoundedRect(in: .init(x: 16.2, y: 17), width: 2.8, height: 3.6)
                    p.move(to: .init(x: 6.4, y: 7)); p.addQuadCurve(to: .init(x: 17.6, y: 7), control: .init(x: 12, y: 1.6))
                })
            // ---- 休闲型
            case .meditate:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 10.2, y: 3, width: 3.6, height: 3.6))
                    p.move(to: .init(x: 12, y: 8.2)); p.addLine(to: .init(x: 12, y: 13.4))
                    p.move(to: .init(x: 4.4, y: 11.6)); p.addQuadCurve(to: .init(x: 19.6, y: 11.6), control: .init(x: 12, y: 15.4))
                    p.move(to: .init(x: 6.4, y: 19.6)); p.addQuadCurve(to: .init(x: 17.6, y: 19.6), control: .init(x: 12, y: 14))
                })
            case .stretch:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 6.4, y: 3.2, width: 3.4, height: 3.4))
                    p.move(to: .init(x: 8.1, y: 8.2)); p.addLine(to: .init(x: 8.1, y: 13.6))
                    p.addLine(to: .init(x: 16.6, y: 13.6))
                    p.move(to: .init(x: 8.1, y: 13.6)); p.addLine(to: .init(x: 5.2, y: 20.4))
                    p.move(to: .init(x: 8.1, y: 9.6)); p.addLine(to: .init(x: 14.6, y: 6.6))
                    p.move(to: .init(x: 16.6, y: 13.6)); p.addLine(to: .init(x: 18.8, y: 20.4))
                })
            case .coffee:
                stroke(P { p in
                    p.move(to: .init(x: 4.6, y: 9)); p.addLine(to: .init(x: 16.4, y: 9))
                    p.addLine(to: .init(x: 16.4, y: 15.4))
                    p.addQuadCurve(to: .init(x: 11.6, y: 20), control: .init(x: 16.4, y: 20))
                    p.addLine(to: .init(x: 9.4, y: 20))
                    p.addQuadCurve(to: .init(x: 4.6, y: 15.4), control: .init(x: 4.6, y: 20))
                    p.closeSubpath()
                    p.move(to: .init(x: 16.4, y: 11)); p.addLine(to: .init(x: 18.6, y: 11))
                    p.addQuadCurve(to: .init(x: 18.6, y: 15.6), control: .init(x: 21.2, y: 13.3))
                    p.addLine(to: .init(x: 16.4, y: 15.6))
                    p.move(to: .init(x: 8.4, y: 3.2)); p.addQuadCurve(to: .init(x: 8.4, y: 6.4), control: .init(x: 10, y: 4.8))
                    p.move(to: .init(x: 12.8, y: 3.2)); p.addQuadCurve(to: .init(x: 12.8, y: 6.4), control: .init(x: 14.4, y: 4.8))
                })
            case .dance:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 12.6, y: 2.8, width: 3.4, height: 3.4))
                    p.move(to: .init(x: 14.3, y: 7.8)); p.addLine(to: .init(x: 11.4, y: 13))
                    p.addLine(to: .init(x: 14.6, y: 15.4)); p.addLine(to: .init(x: 13.4, y: 20.6))
                    p.move(to: .init(x: 11.4, y: 13)); p.addLine(to: .init(x: 6.6, y: 20.2))
                    p.move(to: .init(x: 13.4, y: 9.6)); p.addLine(to: .init(x: 18.8, y: 7.4))
                    p.move(to: .init(x: 13.4, y: 9.6)); p.addLine(to: .init(x: 8.2, y: 8.6))
                })
            case .read:
                stroke(P { p in
                    p.move(to: .init(x: 12, y: 7.4)); p.addLine(to: .init(x: 12, y: 19.8))
                    p.move(to: .init(x: 12, y: 7.4))
                    p.addQuadCurve(to: .init(x: 3.6, y: 5.4), control: .init(x: 8, y: 4.4))
                    p.addLine(to: .init(x: 3.6, y: 17.4))
                    p.addQuadCurve(to: .init(x: 12, y: 19.8), control: .init(x: 8, y: 16.6))
                    p.move(to: .init(x: 12, y: 7.4))
                    p.addQuadCurve(to: .init(x: 20.4, y: 5.4), control: .init(x: 16, y: 4.4))
                    p.addLine(to: .init(x: 20.4, y: 17.4))
                    p.addQuadCurve(to: .init(x: 12, y: 19.8), control: .init(x: 16, y: 16.6))
                })
            case .bath:
                stroke(P { p in
                    p.move(to: .init(x: 2.8, y: 12.6)); p.addLine(to: .init(x: 21.2, y: 12.6))
                    p.addLine(to: .init(x: 21.2, y: 14.6))
                    p.addQuadCurve(to: .init(x: 16, y: 19.8), control: .init(x: 21.2, y: 19.8))
                    p.addLine(to: .init(x: 8, y: 19.8))
                    p.addQuadCurve(to: .init(x: 2.8, y: 14.6), control: .init(x: 2.8, y: 19.8))
                    p.closeSubpath()
                    p.move(to: .init(x: 6.6, y: 12.6)); p.addLine(to: .init(x: 6.6, y: 6.6))
                    p.addQuadCurve(to: .init(x: 11, y: 6.6), control: .init(x: 8.8, y: 4.2))
                })
            // ---- 功能
            case .chevron:
                stroke(P { p in p.move(to: .init(x: 9.4, y: 5.6)); p.addLine(to: .init(x: 16, y: 12)); p.addLine(to: .init(x: 9.4, y: 18.4)) })
            case .arrowRight:
                stroke(P { p in
                    p.move(to: .init(x: 4.4, y: 12)); p.addLine(to: .init(x: 19.6, y: 12))
                    p.move(to: .init(x: 13.6, y: 6)); p.addLine(to: .init(x: 19.6, y: 12)); p.addLine(to: .init(x: 13.6, y: 18))
                })
            case .arrowUp:
                stroke(P { p in
                    p.move(to: .init(x: 12, y: 19.6)); p.addLine(to: .init(x: 12, y: 4.4))
                    p.move(to: .init(x: 6, y: 10.4)); p.addLine(to: .init(x: 12, y: 4.4)); p.addLine(to: .init(x: 18, y: 10.4))
                })
            case .close:
                stroke(P { p in
                    p.move(to: .init(x: 6.4, y: 6.4)); p.addLine(to: .init(x: 17.6, y: 17.6))
                    p.move(to: .init(x: 17.6, y: 6.4)); p.addLine(to: .init(x: 6.4, y: 17.6))
                })
            case .check:
                stroke(P { p in p.move(to: .init(x: 5, y: 12.6)); p.addLine(to: .init(x: 9.8, y: 17.4)); p.addLine(to: .init(x: 19, y: 6.8)) })
            case .plus:
                stroke(P { p in
                    p.move(to: .init(x: 12, y: 5)); p.addLine(to: .init(x: 12, y: 19))
                    p.move(to: .init(x: 5, y: 12)); p.addLine(to: .init(x: 19, y: 12))
                })
            case .minus:
                stroke(P { p in p.move(to: .init(x: 5, y: 12)); p.addLine(to: .init(x: 19, y: 12)) })
            case .bell:
                stroke(P { p in
                    p.move(to: .init(x: 6.4, y: 16.6)); p.addLine(to: .init(x: 6.4, y: 10.6))
                    p.addQuadCurve(to: .init(x: 17.6, y: 10.6), control: .init(x: 12, y: 2.6))
                    p.addLine(to: .init(x: 17.6, y: 16.6)); p.addLine(to: .init(x: 19.4, y: 16.6))
                    p.addLine(to: .init(x: 4.6, y: 16.6)); p.closeSubpath()
                    p.move(to: .init(x: 10.2, y: 19)); p.addQuadCurve(to: .init(x: 13.8, y: 19), control: .init(x: 12, y: 21))
                })
            case .user:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 8, y: 3.6, width: 8, height: 8))
                    p.move(to: .init(x: 4, y: 20.4)); p.addQuadCurve(to: .init(x: 20, y: 20.4), control: .init(x: 12, y: 12.6))
                })
            case .info:
                stroke(P { p in
                    p.addEllipse(in: .init(x: 3.4, y: 3.4, width: 17.2, height: 17.2))
                    p.move(to: .init(x: 12, y: 11)); p.addLine(to: .init(x: 12, y: 16.6))
                })
                fill(P { p in p.addEllipse(in: .init(x: 11.1, y: 7.1, width: 1.8, height: 1.8)) })
            case .refresh:
                stroke(P { p in
                    p.addArc(center: .init(x: 12, y: 12), radius: 8,
                             startAngle: .degrees(-50), endAngle: .degrees(230), clockwise: false)
                    p.move(to: .init(x: 17.2, y: 2.6)); p.addLine(to: .init(x: 17.6, y: 8))
                    p.addLine(to: .init(x: 12.4, y: 7.2))
                })
            case .ask:
                stroke(P { p in
                    p.move(to: .init(x: 8.6, y: 8.8))
                    p.addQuadCurve(to: .init(x: 14.2, y: 10.6), control: .init(x: 9.6, y: 5.6))
                    p.addQuadCurve(to: .init(x: 12, y: 14.6), control: .init(x: 13.4, y: 13.4))
                })
                fill(P { p in p.addEllipse(in: .init(x: 11.1, y: 17.4, width: 1.9, height: 1.9)) })
            case .lock:
                stroke(P { p in
                    p.addRoundedRect(in: .init(x: 5.4, y: 10.4, width: 13.2, height: 9.8),
                                     cornerSize: .init(width: 2.6, height: 2.6))
                })
                stroke(P { p in
                    p.move(to: .init(x: 8.2, y: 10.4)); p.addLine(to: .init(x: 8.2, y: 8.2))
                    p.addQuadCurve(to: .init(x: 12, y: 4.6), control: .init(x: 8.2, y: 4.6))
                    p.addQuadCurve(to: .init(x: 15.8, y: 8.2), control: .init(x: 15.8, y: 4.6))
                    p.addLine(to: .init(x: 15.8, y: 10.4))
                })
                fill(P { p in p.addEllipse(in: .init(x: 11, y: 14.2, width: 2, height: 2)) })
            }
        }
        .frame(width: size, height: size)
    }
}

private extension Path {
    mutating func addRoundedRect(in origin: CGPoint, width: CGFloat, height: CGFloat) {
        addRoundedRect(in: .init(x: origin.x, y: origin.y, width: width, height: height),
                       cornerSize: .init(width: 1.2, height: 1.2))
    }
}

// MARK: - 活动插画瓦片（参考"Running / Walking"那组：柔和底色 + 线条图形 + 右上箭头）

struct ActivityTile: View {
    var icon: Ico
    var title: String
    var sub: String
    var tint: Color
    var selected: Bool = false
    var action: () -> Void

    var body: some View {
        Button { Haptic.tap(); action() } label: {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title).font(.system(size: 15, weight: .semibold)).tracking(-0.3)
                        .foregroundStyle(T.ink)
                    Text(sub).font(.system(size: 10.5)).foregroundStyle(T.ink.opacity(0.45))
                        .padding(.top, 2)
                    Spacer(minLength: 8)
                    HStack {
                        Spacer()
                        Icon(icon, size: 46, weight: 1.6, color: T.ink.opacity(0.75))
                            .offset(x: 2, y: 4)
                    }
                }
                .padding(14)
                .frame(height: 124)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(tint)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(selected ? T.ink : .clear, lineWidth: 1.6)
                )

                ZStack {
                    Circle().fill(selected ? T.ink : .white)
                    Icon(selected ? .check : .arrowRight, size: 13, weight: 2,
                         color: selected ? .white : T.ink)
                        .rotationEffect(.degrees(selected ? 0 : -45))
                }
                .frame(width: 26, height: 26)
                .padding(10)
            }
        }
        .buttonStyle(PressStyle())
    }
}
