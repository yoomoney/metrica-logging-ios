//
//  CardTopupEvent.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation

struct CardTopupEvent: Event {
    
    private let amount: Int
    private let currency: String
    private let cardId: String
    
    init(amount: Int, currency: String, cardId: String) {
        self.amount = amount
        self.currency = currency
        self.cardId = cardId
    }
    
    let name = "card.topup"
    
    var parameters: [String : Any] {
        [
            "amount": amount,
            "currency": currency,
            "cardId": cardId
        ]
    }
    
    let trackers: TrackerType = .defaultTrackers
    
}
