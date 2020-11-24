//
//  OsLogTracker.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation
import os

final class SystemLogTracker: Tracker {
    
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "YooMetrica")
    
    func track(event: Event) {
        guard event.trackers.contains(.systemLog) else { return }
        
        if event.parameters.isEmpty {
            os_log("Track event: %@", log: log, type: .info, event.name)
        } else {
            let parameters: String
            if let jsonData = try? JSONSerialization.data(withJSONObject: event.parameters, options: [.prettyPrinted]),
                let parametersString = String(data: jsonData, encoding: String.Encoding.utf8) {
                parameters = parametersString
            } else {
                parameters = event.parameters.description
            }
            os_log("Track event: %@, parameters: %@", log: log, type: .info, event.name, parameters)
        }
    }
}
