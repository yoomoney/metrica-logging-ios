enum TrackingLogProviderError: Error {
    case canNotParseLogFile
    case canNotMakeEvent
    case canNotGetFilePathFromEnvironment
    case hasNoFilePath
}

protocol TrackingLogProvider {
    
    /// Reset log initial date to current date. Events before date will not read from system log
    func resetStartDate()
    
    /// Take last events with given amount after initial date
    /// - Parameter maxAmount: Amount of events to give from system log
    /// - Returns: Array of DebugEvent instances
    func lastLoggedEvents(maxAmount: Int) -> [DebugEvent]
    
    /// Take last event with given amount after initial date
    /// - Returns: DebugEvent instances
    func lastLoggedEvent(completion: (DebugEvent?) -> Void)
    
    /// Check existence of given event after waiting given time
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    ///   - afterWaiting: Time interval to waiting for event
    ///   - inLastEventsAmount: Amount of events to give from system log
    /// - Returns: Result of finding for given event after waiting
    func hasEvent(
        _ event: DebugEvent,
        afterWaiting timeout: Int,
        inLastEventsAmount amount: Int,
        completion: (Bool) -> Void
    )
    
    /// Check that last event is equal to given event. Service get events after initial date
    /// - Parameter event: DebugEvent to compare with
    /// - Returns: Comparing result of last event and given event
    func lastEventEqualsTo(_ event: DebugEvent, completion: (Bool) -> Void)
    
    /// Check that last events contain given events without order. Service get events after initial date
    /// - Parameter events: Array of events to find
    /// - Returns: Comparing result of last events and given events
    func lastEventsContain(events: [DebugEvent], completion: (Bool) -> Void)
    
    /// Check that last events equal to given events with the same order. Service get events after initial date
    /// - Parameter events: Array of events to find
    /// - Returns: Comparing result of last events and given events
    func lastEventsEqualTo(events: [DebugEvent], completion: (Bool) -> Void)
    
    /// Get event amount in last events with given quantity
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    ///   - amount: Amount of events to give from system log
    /// - Returns:
    func eventAmount(_ event: DebugEvent, inLastEventsAmount amount: Int, completion: (Int) -> Void)
    
    /// Compare that system log contains expected amount of given event
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    ///   - expectedAmount: Expected amount of event
    ///   - amount: expected amount of event
    /// - Returns: Comparing result that given event amount equal with expected amount
    func lastEventsHave(
        _ event: DebugEvent,
        expectedAmount: Int,
        inLastEventsAmount amount: Int,
        completion: (Bool) -> Void
    )
}

extension TrackingLogProvider {
    
    /// Take last events after initial date
    /// - Returns: Array of DebugEvent instances
    func lastLoggedEvents() -> [DebugEvent] {
        lastLoggedEvents(maxAmount: Int.max)
    }
    
    /// Check existence of given event after initial date
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    /// - Returns: Result of finding for given event
    func hasEvent(_ event: DebugEvent, completion: (Bool) -> Void) {
        hasEvent(event, afterWaiting: 0, inLastEventsAmount: Int.max, completion: completion)
    }
    
    /// Check existence of given event
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    ///   - inLastEventsAmount: Amount of events to give from system log
    /// - Returns: Result of finding for given event after waiting
    func hasEvent(_ event: DebugEvent, inLastEventsAmount amount: Int, completion: (Bool) -> Void) {
        hasEvent(event, afterWaiting: 0, inLastEventsAmount: amount, completion: completion)
    }
    
    /// Check existence of given event after waiting given time
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    ///   - afterWaiting: Time interval to waiting for event
    /// - Returns: Result of finding for given event after waiting
    func hasEvent(_ event: DebugEvent, afterWaiting timeout: Int, completion: (Bool) -> Void) {
        hasEvent(event, afterWaiting: timeout, inLastEventsAmount: Int.max, completion: completion)
    }
    
    /// Get event amount in last events
    /// - Parameter event: DebugEvent to find in log
    /// - Returns: Amount of given event
    func eventAmount(_ event: DebugEvent, completion: (Int) -> Void) {
        eventAmount(event, inLastEventsAmount: Int.max, completion: completion)
    }
    
    /// Compare that system log contains expected amount of given event
    /// - Parameters:
    ///   - event: DebugEvent to find in log
    ///   - expectedAmount: Expected amount of event
    /// - Returns: Comparing result that given event amount equal with expected amount
    func lastEventsHave(_ event: DebugEvent, expectedAmount: Int, completion: (Bool) -> Void) {
        lastEventsHave(event, expectedAmount: expectedAmount, inLastEventsAmount: Int.max, completion: completion)
    }
}
