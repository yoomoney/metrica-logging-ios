//
//  Event.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

protocol Event {
    var name: String { get }
    var parameters: [String: Any] { get }
    var trackers: TrackerType { get }
}
