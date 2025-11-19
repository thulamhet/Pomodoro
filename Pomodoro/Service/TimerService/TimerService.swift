//
//  TimerService.swift
//  Pomodoro
//
//  Created by thunc on 18/11/25.
//

protocol TimerServiceProtocol {
    func start(duration: Int, onTick: @escaping (Int) -> Void, onCompleted: @escaping () -> Void) async
    func pause() async
    func resume() async
    func stop() async
}

actor TimerService: TimerServiceProtocol {
    private var remainingSeconds: Int = 0
    private var isRunning = false
    private var task: Task<Void, Never>?

    func start(duration: Int,
               onTick: @escaping (Int) -> Void,
               onCompleted: @escaping () -> Void) async {
        await stop()
        remainingSeconds = duration
        isRunning = true

        task = Task {
            while remainingSeconds > 0 && !Task.isCancelled {
                // Sleep for 1 second (in nanoseconds)
                try? await Task.sleep(nanoseconds: 1_000_000_0)
                if !isRunning { continue }
                remainingSeconds -= 1

                // Capture actor state before hopping to MainActor
                let currentRemaining = remainingSeconds
                await MainActor.run {
                    onTick(currentRemaining)
                }
            }

            if !Task.isCancelled && remainingSeconds == 0 {
                await MainActor.run {
                    onCompleted()
                }
            }
        }
    }

    func pause() async {
        isRunning = false
    }

    func resume() async {
        isRunning = true
    }

    func stop() async {
        task?.cancel()
        task = nil
        isRunning = false
    }
}
