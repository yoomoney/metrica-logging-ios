//
//  BuySuccessEvent.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation

struct BuySuccessEvent: Event {
    
    private let fromCard: Bool
    private let itemId: String
    
    init(fromCard: Bool, itemId: String) {
        self.fromCard = fromCard
        self.itemId = itemId
    }
    
    let name = "buy.success"
    
    var parameters: [String : Any] {
        [
            "fromCard": fromCard,
            "itemId": itemId
        ]
    }
    
    let trackers: TrackerType = .defaultTrackers
    
}
