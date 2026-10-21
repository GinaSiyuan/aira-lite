import SwiftUI

@main
struct AiraT0App: SwiftUI.App {
    @StateObject private var app = App()
    @StateObject private var demo = Demo()
    var body: some Scene {
        WindowGroup {
            Root().environmentObject(app).environmentObject(demo)
                .preferredColorScheme(.light)
        }
    }
}

struct Root: View {
    @EnvironmentObject var app: App
    @EnvironmentObject var demo: Demo
    var body: some View {
        ZStack {
            PageBG()
            switch app.phase {
            case .welcome:  WelcomeView()
            case .connect:  ConnectView()
            case .syncing:  SyncingView()
            case .recap:    InitialRecapView()
            case .profile:  ProfileView()
            case .medical:  MedicalView()
            case .notify:   NotifyPermView()
            case .sampling: SamplingPreviewView()
            case .firstLog: FirstLogView()
            case .main:    MainShell()
            case .icons:   IconGallery()
            }
        }
        .animation(.smooth(duration: 0.42), value: app.phase)
        .overlay {
            if app.analyzing {
                AnalyzingScreen { app.finishAnalyzing() }
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .overlay(alignment: .trailing) {
            DemoBar().offset(y: -120)
        }
        .onAppear {
            // 把步骤插画导出为正式 PNG 资产（guide1-5.png）：
            // `simctl launch booted com.aira.t0 -exportguides` 后从 app 容器 Documents 取回
            if ProcessInfo.processInfo.arguments.contains("-exportguides") {
                let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                for i in 0..<5 {
                    let view = ZStack {
                        LinearGradient(colors: [Color(hex: 0xE9EDDD), Color(hex: 0xDDE2CE)],
                                       startPoint: .top, endPoint: .bottom)
                        StepArt(index: i)
                    }
                    .frame(width: 512, height: 640)
                    let r = ImageRenderer(content: view)
                    r.scale = 2
                    if let img = r.uiImage, let data = img.pngData() {
                        try? data.write(to: docs.appendingPathComponent("guide\(i + 1).png"))
                    }
                }
                print("GUIDES EXPORTED to \(docs.path)")
            }
            // 自动演示：./build.sh 后 `simctl launch booted com.aira.t0 -demoplay`
            if ProcessInfo.processInfo.arguments.contains("-demoplay") {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 800_000_000)
                    demo.start(app)
                }
            }
        }

    }
}

// MARK: - 主壳：Home / Agent / Plan —— Agent 居中，是主入口

struct MainShell: View {
    @EnvironmentObject var app: App
    var body: some View {
        ZStack {
            // Agent 轨道整屏换底：蓝绿渐变磨砂，一直铺到底栏下面
            if app.tab == 1 { FogScreen(tone: .cool).transition(.opacity) }

            VStack(spacing: 0) {
                Group {
                    switch app.tab {
                    case 0: HomeView()
                    case 1: AgentThreadView()
                    default: PlanView()
                    }
                }
                .frame(maxHeight: .infinity)
                .transition(.opacity)

                TabBar(tab: $app.tab, unread: app.unread)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(item: $app.sheet) { s in
            switch s {
            case .testing:      TestingSheet()
            case .guidance:     GuidanceFlow()
            case .report:       ReportView()
            case .checkIn:      CheckInSheet()
            case .settings:     SettingsSheet()
            case .ask(let c):   AskSheet(ctx: c)
            case .detail(let d): DetailSheet(kind: d, day: Mock.days[app.dayIndex])
            case .arrange(let a): ArrangeSheet(activity: a)
            }
        }
    }
}

/// 检测流程从 Home 的状态卡进，不占 tab 位
struct TestingSheet: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            PageBG()
            VStack(spacing: 0) {
                HStack {
                    Text("Saliva collection").font(.system(size: 18, weight: .semibold)).tracking(-0.4)
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").font(.system(size: 12, weight: .bold))
                            .foregroundStyle(T.ink2).frame(width: 32, height: 32)
                            .background(Circle().fill(T.hair2))
                    }
                }
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 4)
                TestingView()
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

struct TabBar: View {
    @Binding var tab: Int
    var unread: Int = 0

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            item(0, .home, "Home")

            // 中间：Aira —— 主入口。在磨砂栏上用柠檬实心才压得住
            Button {
                Haptic.tap()
                withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) { tab = 1 }
            } label: {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        Circle().fill(tab == 1 ? T.lime : Color.white.opacity(0.14))
                        if tab == 1 {
                            Circle().fill(T.lime).frame(width: 44, height: 44)
                                .blur(radius: 14).opacity(0.55)
                        }
                        Icon(.spark, size: 22, weight: 2, color: tab == 1 ? T.ink : .white)
                    }
                    .frame(width: 50, height: 50)

                    if unread > 0 && tab != 1 {
                        Circle().fill(T.coral).frame(width: 8, height: 8).offset(x: -2, y: 2)
                    }
                }
                .frame(width: 84, height: 54)
                .contentShape(Rectangle())
            }
            .buttonStyle(PressStyle())
            .accessibilityLabel("Aira")

            item(2, .plan, "Plan")
        }
        .padding(.horizontal, 6)
        .frame(height: 66)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous).fill(Color(hex: 0x14181A))
                Fog(tone: .flat, radius: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .opacity(0.9)
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .strokeBorder(.white.opacity(0.08), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.22), radius: 22, y: 10)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 4)
    }

    @ViewBuilder
    private func item(_ i: Int, _ icon: Ico, _ label: String) -> some View {
        Button {
            Haptic.tap()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) { tab = i }
        } label: {
            VStack(spacing: 4) {
                Icon(icon, size: 21, weight: tab == i ? 2.1 : 1.7,
                     color: tab == i ? .white : .white.opacity(0.42))
                Text(label)
                    .font(.system(size: 10, weight: tab == i ? .semibold : .regular))
                    .foregroundStyle(tab == i ? .white : .white.opacity(0.42))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 顶部问候

struct Greeting: View {
    var title: String
    var sub: String
    var badge: String? = nil
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(sub).font(.system(size: 12.5)).foregroundStyle(T.ink3)
                Text(title).font(.system(size: 22, weight: .semibold)).tracking(-0.6)
            }
            Spacer()
            if let b = badge {
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle").font(.system(size: 9, weight: .semibold))
                    Text(b).font(.system(size: 10.5, weight: .medium))
                }
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Capsule().fill(T.hair2))
                .foregroundStyle(T.ink2)
            }
        }
    }
}
