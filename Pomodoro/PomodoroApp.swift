//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by thunc on 18/11/25.
//

import SwiftUI
import UserNotifications

@main
struct PomodoroApp: App {
    // Persisted flag to ensure we only ask once
    @AppStorage("hasRequestedNotificationPermission") private var hasRequestedNotificationPermission: Bool = false

    // Keep a delegate instance alive for the app’s lifetime
    private let notificationDelegate = NotificationDelegate()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Set delegate so notifications can present while app is in foreground
                    UNUserNotificationCenter.current().delegate = notificationDelegate
                    await requestNotificationPermissionIfNeeded()
                }
        }
    }

    @MainActor
    private func requestNotificationPermissionIfNeeded() async {
        guard !hasRequestedNotificationPermission else { return }
        hasRequestedNotificationPermission = true

        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            if !granted {
                // Optional: guide user to Settings if needed
                print("Notifications not granted")
            }
        } catch {
            // Optional: handle error
            print("Notification auth error: \(error)")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Present notifications while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}
