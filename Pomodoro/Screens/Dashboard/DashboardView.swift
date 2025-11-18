//
//  DasboardView.swift
//  Pomodoro
//
//  Created by thunc on 18/11/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(titleForPhase(viewModel.phase))
                .font(.title)
            
            Text(formatTime(viewModel.remainingSeconds))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()

            // Progress
            ProgressView(value: Double(viewModel.totalSeconds - viewModel.remainingSeconds),
                         total: Double(viewModel.totalSeconds))
                .padding(.horizontal, 40)

            Text("Session \(viewModel.currentSessionIndex)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 16) {
                if viewModel.isRunning {
                    Button("Pause") {
                        viewModel.pause()
                    }
                } else {
                    Button("Start") {
                        viewModel.start()
                    }
                }

                Button("Skip") {
                    viewModel.skip()
                }

                Button("Reset") {
                    viewModel.reset()
                }
            }
        }
        .padding()
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func titleForPhase(_ phase: PomodoroPhase) -> String {
        switch phase {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
}
