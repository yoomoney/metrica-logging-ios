//
//  BalanceUpdateEvent.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import Foundation

struct BalanceUpdateEvent: Event {
    
    enum Account: String, CustomStringConvertible {
        var description: String {
            rawValue
        }
        
        case current = "Текущий"
        case euro = "Euro"
        case usd = "USD"
    }
    
    private let account: Account
    
    init(account: Account) {
        self.account = account
    }
    
    let name = "balance.update"
    
    var parameters: [String : Any] {
        [
            "account": account.description
        ]
    }
    
    let trackers: TrackerType = .defaultTrackers
    
}
