//
//  TrackersContainer.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

final class TrackersContainer: Tracker {
    private let appMetricaTracker: AppMetricaTracker
    private let fabricTracker: FabricTracker
    private let amplitudeTracker: AmplitudeTracker
    private let systemLogTracker: SystemLogTracker
    
    init(appMetricaTracker: AppMetricaTracker,
         fabricTracker: FabricTracker,
         amplitudeTracker: AmplitudeTracker,
         systemLogTracker: SystemLogTracker
    ) {
        self.appMetricaTracker = appMetricaTracker
        self.fabricTracker = fabricTracker
        self.amplitudeTracker = amplitudeTracker
        self.systemLogTracker = systemLogTracker
    }
    
    func track(event: Event) {
        appMetricaTracker.track(event: event)
        fabricTracker.track(event: event)
        systemLogTracker.track(event: event)
        amplitudeTracker.track(event: event)
    }
}

