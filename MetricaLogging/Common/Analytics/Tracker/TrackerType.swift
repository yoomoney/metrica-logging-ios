//
//  TrackerType.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation

public struct TrackerType: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let appMetrica = TrackerType(rawValue: 1)
    public static let fabric = TrackerType(rawValue: 1 << 1)
    public static let systemLog = TrackerType(rawValue: 1 << 2)
    public static let amplitude = TrackerType(rawValue: 1 << 3)
    
    public static let defaultTrackers: TrackerType = [
        .appMetrica,
        .fabric,
        .systemLog,
        .amplitude,
    ]
}
