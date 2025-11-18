//
//  DashboardViewModel.swift
//  Pomodoro
//
//  Created by thunc on 18/11/25.
//

import SwiftUI
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var phase: PomodoroPhase = .focus
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentSessionIndex: Int = 1

    private let config: PomodoroConfig
    private let timerService: TimerServiceProtocol

    init(config: PomodoroConfig, timerService: TimerServiceProtocol) {
        self.config = config
        self.timerService = timerService
        setupForPhase(.focus)
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        Task { [weak self] in
            guard let self else { return }
            await timerService.start(
                duration: remainingSeconds,
                onTick: { [weak self] remaining in
                    self?.remainingSeconds = remaining
                },
                onCompleted: { [weak self] in
                    self?.handleCompletedPhase()
                }
            )
        }
    }

    func pause() {
        Task { [weak self] in
            await self?.timerService.pause()
        }
        isRunning = false
    }

    func resume() {
        Task { [weak self] in
            await self?.timerService.resume()
        }
        isRunning = true
    }

    func reset() {
        Task { [weak self] in
            await self?.timerService.stop()
        }
        currentSessionIndex = 1
        setupForPhase(.focus)
        isRunning = false
    }

    func skip() {
        Task { [weak self] in
            await self?.timerService.stop()
        }
        handleCompletedPhase(skip: true)
    }

    private func setupForPhase(_ phase: PomodoroPhase) {
        self.phase = phase
        switch phase {
        case .focus:
            totalSeconds = config.focusDuration
        case .shortBreak:
            totalSeconds = config.shortBreakDuration
        case .longBreak:
            totalSeconds = config.longBreakDuration
        }
        remainingSeconds = totalSeconds
    }

    private func handleCompletedPhase(skip: Bool = false) {
        switch phase {
        case .focus:
            if !skip { currentSessionIndex += 1 }
            if (currentSessionIndex - 1) % config.sessionsBeforeLongBreak == 0 {
                setupForPhase(.longBreak)
            } else {
                setupForPhase(.shortBreak)
            }
        case .shortBreak, .longBreak:
            setupForPhase(.focus)
        }

        isRunning = false
        // Option: auto start phase mới
        // start()
    }
}
