import Foundation
import XCTest

final class TrackingLogProviderImpl: TrackingLogProvider {
    
    private var startDate = Date()
    
    private lazy var fileUrl: URL? = {
        let environment = ProcessInfo.processInfo.environment
        guard
            let projectFolderPath = environment[Constants.EnvironmentKey.projectPath],
            let deviceId = environment[Constants.EnvironmentKey.deviceId]
        else {
        	XCTFail(TrackingLogProviderError.canNotGetFilePathFromEnvironment.localizedDescription)
         	return nil
        }
        return URL(fileURLWithPath: projectFolderPath)
            .appendingPathComponent(Constants.Path.logsFolderName, isDirectory: true)
            .appendingPathComponent(deviceId)
            .appendingPathExtension(Constants.Path.fileExtension)
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
        return formatter
    }()
    
    func lastLoggedEvents(maxAmount amount: Int) -> [DebugEvent] {
        let result: [DebugEvent]
        do {
            guard let fileUrl = fileUrl else { throw TrackingLogProviderError.hasNoFilePath }
            var rawString = String(try String(contentsOf: fileUrl).drop { $0 != "\n" })
            if !rawString.hasSuffix("]") {
                rawString.append("]")
            }
            guard
                let data = rawString.data(using: .utf8),
                let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { throw TrackingLogProviderError.canNotParseLogFile }
            result = json
                .suffix(amount)
                .filter {
                    guard
                        let dateString = $0[Constants.timestampKey] as? String,
                        let eventDate = dateFormatter.date(from: dateString)
                    else { return false }
                    return eventDate > startDate
            	}
            	.compactMap { $0[Constants.eventMessageKey] as? String }
            	.map(makeEvent)
        } catch {
            result = []
            XCTFail(error.localizedDescription)
        }
        return result
    }
    
    func lastLoggedEvent(completion: (DebugEvent?) -> Void) {
        completion(lastLoggedEvents(maxAmount: 1).first)
    }
    
    func hasEvent(
        _ event: DebugEvent,
        afterWaiting timeout: Int,
        inLastEventsAmount amount: Int,
        completion: (Bool) -> Void
    ) {
        let reslt = resultWithWaiting(timeout: timeout) {
            self.lastLoggedEvents(maxAmount: amount).contains(event)
        }
        completion(reslt)
    }
    
    func lastEventEqualsTo(_ event: DebugEvent, completion: (Bool) -> Void) {
        completion(lastLoggedEvents(maxAmount: 1).contains(event))
    }
    
    func lastEventsContain(events: [DebugEvent], completion: (Bool) -> Void) {
        completion(lastLoggedEvents(maxAmount: events.count).filter(events.contains).count == events.count)
    }
    
    func lastEventsEqualTo(events: [DebugEvent], completion: (Bool) -> Void) {
        completion(lastLoggedEvents(maxAmount: events.count) == events)
    }
    
    func eventAmount(_ event: DebugEvent, inLastEventsAmount amount: Int, completion: (Int) -> Void) {
        completion(lastLoggedEvents(maxAmount: amount).filter { $0 == event }.count)
    }
    
    func lastEventsHave(
        _ event: DebugEvent,
        expectedAmount: Int,
        inLastEventsAmount amount: Int,
        completion: (Bool) -> Void
    ) {
        eventAmount(event, inLastEventsAmount: amount) {
            completion($0 == expectedAmount)
        }
    }
    
    func resetStartDate() {
        startDate = Date()
    }
}

// MARK: - Helpers
private extension TrackingLogProviderImpl {
    
    func makeEvent(event: String) -> DebugEvent {
        guard let index = event.firstIndex(of: ",") else {
            return DebugEvent(name: makeEventName(string: event), parameters: [:])
        }
        let eventName = makeEventName(string: String(event[..<index]))
        let params = makeParameters(string: String(event[index...]))
        return DebugEvent(name: eventName, parameters: params)
    }
    
    func makeEventName(string: String) -> String {
        string
            .drop { $0 != Constants.parametersSeparator }
            .dropFirst()
            .trimmingCharacters(in: .whitespaces)
    }
    
    func makeParameters(string: String) -> [String: AnyHashable] {
        let jsonString = string
            .drop { $0 != Constants.parametersSeparator }
            .dropFirst()
        guard
            let data = jsonString.data(using: .utf8),
            let params = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyHashable]
        else { return [:] }
        return params
    }
}

private extension TrackingLogProviderImpl {
    enum Constants {
        static let eventMessageKey = "eventMessage"
        static let timestampKey = "timestamp"
        static let parametersSeparator: Character = ":"
        
        enum Path {
            static let fileExtension = "log"
            static let logsFolderName = "Logs"
        }
        
        enum EnvironmentKey {
            static let deviceId = "SIMULATOR_UDID"
            static let projectPath = "PROJECT_FOLDER_PATH"
        }
    }
}
