import SwiftUI

// MARK: - Settings：个人资料 / 数据源 / 通知 / 隐私
// 入口：Home 和 Plan 右上角头像。浅色语言，和 onboarding 的卡一致。

struct SettingsSheet: View {
    @EnvironmentObject var app: App
    @Environment(\.dismiss) private var dismiss
    @State private var editing = false

    var body: some View {
        ZStack {
            PageBG()
            VStack(spacing: 0) {
                HStack {
                    Text("Settings").font(.system(size: 18, weight: .semibold)).tracking(-0.4)
                    Spacer()
                    Button { dismiss() } label: {
                        Icon(.close, size: 13, weight: 2.3, color: T.ink2)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(T.hair2))
                            .contentShape(Circle())
                    }
                    .buttonStyle(PressStyle())
                }
                .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 6)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        profileCard
                        connections
                        notifications
                        privacy
                        Text("Aira 0.9 · T0 prototype · Not a medical device")
                            .font(.system(size: 10.5)).foregroundStyle(T.ink3)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 10)
                    }
                    .padding(.horizontal, 20).padding(.top, 10).padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // MARK: Profile

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 13) {
                Avatar(size: 52)
                VStack(alignment: .leading, spacing: 2) {
                    Text(app.nickname.isEmpty ? "Chloe" : app.nickname)
                        .font(.system(size: 17, weight: .semibold)).tracking(-0.3)
                    Text("\(app.age) · \(["Female", "Male", "—"][min(app.sex, 2)]) · \(app.heightCm) cm · \(app.weightKg) kg")
                        .font(.system(size: 11.5)).foregroundStyle(T.ink3)
                }
                Spacer()
                Button {
                    Haptic.tap()
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.85)) { editing.toggle() }
                } label: {
                    Text(editing ? "Done" : "Edit")
                        .font(.system(size: 12.5, weight: .semibold))
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Capsule().fill(editing ? T.lime : T.hair2))
                        .foregroundStyle(T.ink)
                        .contentShape(Capsule())
                }
                .buttonStyle(PressStyle())
            }
            .padding(15)

            if editing {
                VStack(alignment: .leading, spacing: 16) {
                    Rectangle().fill(T.hair).frame(height: 1)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name").font(.system(size: 12, weight: .semibold)).foregroundStyle(T.ink2)
                        TextField("", text: $app.nickname, prompt: Text("Chloe").foregroundStyle(T.ink3))
                            .textFieldStyle(.plain).font(.system(size: 15, weight: .medium))
                            .padding(.horizontal, 13).padding(.vertical, 11)
                            .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(T.hair2))
                    }
                    SlideValue(value: $app.age, range: 16...80, unit: "years old")
                    Segmented(options: ["Female", "Male", "Rather not say"], index: $app.sex)
                    SlideValue(value: $app.heightCm, range: 140...210, unit: "cm")
                    SlideValue(value: $app.weightKg, range: 35...150, unit: "kg")
                }
                .padding(15).padding(.top, 0)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
    }

    // MARK: Connections

    private var connections: some View {
        section("Data sources") {
            row(mark: .appleHealth, title: "Apple Health",
                sub: app.healthGranted ? "Connected · 5 data types" : "Not connected") {
                connectBtn(connected: app.healthGranted) {
                    withAnimation(.smooth) { app.healthGranted = true }
                }
            }
            divider
            row(mark: .oura, title: "Oura Ring", sub: devSub("Oura Ring")) {
                connectBtn(connected: app.devices.contains("Oura Ring")) { toggle("Oura Ring") }
            }
            divider
            row(mark: .whoop, title: "WHOOP", sub: devSub("WHOOP")) {
                connectBtn(connected: app.devices.contains("WHOOP")) { toggle("WHOOP") }
            }
            divider
            row(mark: .garmin, title: "Garmin", sub: devSub("Garmin")) {
                connectBtn(connected: app.devices.contains("Garmin")) { toggle("Garmin") }
            }
        }
    }

    private func devSub(_ n: String) -> String {
        app.devices.contains(n) ? "Connected · syncing nightly" : "Adds its own HRV + sleep staging"
    }
    private func toggle(_ n: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) {
            if app.devices.contains(n) { app.devices.remove(n) } else { app.devices.insert(n) }
        }
    }

    @ViewBuilder
    private func connectBtn(connected: Bool, _ a: @escaping () -> Void) -> some View {
        Button { Haptic.tap(); a() } label: {
            HStack(spacing: 5) {
                if connected { Icon(.check, size: 10, weight: 2.6, color: T.ink) }
                Text(connected ? "Connected" : "Connect")
                    .font(.system(size: 11.5, weight: .semibold))
            }
            .padding(.horizontal, 12).padding(.vertical, 7)
            .background(Capsule().fill(connected ? T.lime : T.hair2))
            .foregroundStyle(T.ink)
            .contentShape(Capsule())
        }
        .buttonStyle(PressStyle())
    }

    // MARK: Notifications

    private var notifications: some View {
        section("Notifications") {
            notifRow(0, .bell, "Sampling reminders", "Time-critical on sampling day")
            divider
            notifRow(1, .spark, "Proactive check-ins", "When Aira needs one thing from you")
            divider
            notifRow(2, .recover, "Weekly read", "Mondays · what moved and what didn't")
        }
    }

    @ViewBuilder
    private func notifRow(_ i: Int, _ icon: Ico, _ t: String, _ sub: String) -> some View {
        HStack(spacing: 12) {
            Icon(icon, size: 16, weight: 1.9, color: T.ink2)
                .frame(width: 34, height: 34)
                .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(T.hair2))
            VStack(alignment: .leading, spacing: 1) {
                Text(t).font(.system(size: 13.5, weight: .medium))
                Text(sub).font(.system(size: 10.5)).foregroundStyle(T.ink3)
            }
            Spacer(minLength: 0)
            Toggle2(on: $app.notifyOn[i], locked: i == 0 && app.saliva == .collecting)
                .accessibilityLabel("\(t) toggle")
                .accessibilityValue(app.notifyOn[i] ? "on" : "off")
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
    }

    // MARK: Privacy

    private var privacy: some View {
        section("Data & privacy") {
            plainRow(.info, "Export my data", "Everything Aira holds, as JSON")
            divider
            plainRow(.close, "Delete account & data", "Removes device data and saliva results")
        }
    }

    @ViewBuilder
    private func plainRow(_ icon: Ico, _ t: String, _ sub: String) -> some View {
        Button { Haptic.tap() } label: {
            HStack(spacing: 12) {
                Icon(icon, size: 15, weight: 2, color: T.ink2)
                    .frame(width: 34, height: 34)
                    .background(RoundedRectangle(cornerRadius: 11, style: .continuous).fill(T.hair2))
                VStack(alignment: .leading, spacing: 1) {
                    Text(t).font(.system(size: 13.5, weight: .medium))
                    Text(sub).font(.system(size: 10.5)).foregroundStyle(T.ink3)
                }
                Spacer(minLength: 0)
                Icon(.chevron, size: 11, weight: 2.2, color: T.ink3)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            .contentShape(Rectangle())
            .foregroundStyle(T.ink)
        }
        .buttonStyle(.plain)
    }

    // MARK: helpers

    private var divider: some View {
        Rectangle().fill(T.hair).frame(height: 1).padding(.leading, 60)
    }

    @ViewBuilder
    private func section<C: View>(_ title: String, @ViewBuilder _ c: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased()).font(.system(size: 10, weight: .bold)).tracking(1.4)
                .foregroundStyle(T.ink3).padding(.leading, 4)
            VStack(spacing: 0) { c() }
                .padding(.vertical, 4)
                .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(.white))
                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(T.hair, lineWidth: 1))
        }
    }

    @ViewBuilder
    private func row<C: View>(mark: SourceMark.Kind, title: String, sub: String,
                              @ViewBuilder trailing: () -> C) -> some View {
        HStack(spacing: 12) {
            SourceMark(kind: mark, size: 34)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 13.5, weight: .medium))
                Text(sub).font(.system(size: 10.5)).foregroundStyle(T.ink3)
            }
            Spacer(minLength: 0)
            trailing()
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
    }
}
