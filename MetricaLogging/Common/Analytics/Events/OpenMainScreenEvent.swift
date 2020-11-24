//
//  OpenMainScreenEvent.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation

struct OpenMainScreenEvent: Event {
        
    let name = "openScreen.main"
    
    var parameters: [String : Any] = [:]
    
    let trackers: TrackerType = .systemLog
    
}
