//
//  SellSuccessEvent.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation

struct SellSuccessEvent: Event {
    
    private let itemId: String
    private let amount: Int
    
    init(itemId: String, amount: Int) {
        self.itemId = itemId
        self.amount = amount
    }
    
    let name = "sell.success"
    
    var parameters: [String : Any] {
        [
            "itemId": itemId,
            "amount": amount
        ]
    }
    
    let trackers: TrackerType = .defaultTrackers
}
