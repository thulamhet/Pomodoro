//
//  ContentView.swift
//  Pomodoro
//
//  Created by thunc on 18/11/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        DashboardView(
            viewModel: .init(
                config: .init(
                    focusDuration: 600,
                    shortBreakDuration: 10,
                    longBreakDuration: 10,
                    sessionsBeforeLongBreak: 10
                ),
                timerService: TimerService()
            )
        )
    }
}

