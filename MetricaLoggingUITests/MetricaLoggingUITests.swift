//
//  MetricaLoggingUITests.swift
//  MetricaLoggingUITests
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

import XCTest

class MetricaLoggingUITests: XCTestCase {
    
    private let logProvider: TrackingLogProvider? = TrackingLogProviderImpl()

    override func setUp() {
        logProvider?.resetStartDate()
        continueAfterFailure = false
    }


    func testExample() {
        let app = XCUIApplication()
        app.launch()
        
        let openScreenEvent = DebugEvent(.openMainScreen)
        let buySuccessEvent = DebugEvent(.buySuccess, params: .fromCard(true), .itemId("12345"))
        let sellSuccessEvent = DebugEvent(.sellSuccess, params: .amount(500), .itemId("12345"))
        
        logProvider?.lastLoggedEvent { event in
            Matchers.checkThat("отправлен ивент открытия экрана", event, openScreenEvent)
        }
        
        let myTable = app.tables.matching(identifier: "MainTableView")
       
        myTable.cells.element(matching: .cell, identifier: "simpleCell-0").tap()
        logProvider?.lastLoggedEvent { event in
            Matchers.checkThat("отправлен ивент успеха покупки", event, buySuccessEvent)
        }
        
        logProvider?.lastEventsEqualTo(events: [openScreenEvent, buySuccessEvent]) { result in
            Matchers.checkThat("список последних ивентов совпадает с ожидаемым", result)
        }
        
        myTable.cells.element(matching: .cell, identifier: "simpleCell-1").tap()
        logProvider?.hasEvent(sellSuccessEvent, afterWaiting: 20) { result in
            Matchers.checkThat("отправлено асинхронное событие продажи", result)
        }
        
        //etc
    }
}
