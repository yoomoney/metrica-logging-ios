import Foundation
import XCTest

enum Helper {
    static func XCTFailOnError(closure: () throws -> Void) {
        do {
            try closure()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

enum Report {
    static func step(_ description: String, closure: () throws -> Void) {
        XCTContext.runActivity(named: "Шаг: \(description)") { _ in
            Helper.XCTFailOnError {
                try closure()
            }
        }
    }
    static func test(_ testId: String, _ testName: String, closure: () throws -> Void) {
        XCTContext.runActivity(named: "\(testId): \(testName)") { _ in
            Helper.XCTFailOnError {
                try closure()
            }
        }
    }
}

enum Matchers {
    static func checkThat(_ description: String, _ existence: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяем, что \(description)") { _ in
            XCTAssertTrue(existence, "Условие \"\(description)\" не выполнилось", file: file, line: line)
        }
    }
    static func checkThat<T>(_ description: String, _ value: T, _ eqvivValue: T,
                             file: StaticString = #file, line: UInt = #line) where T: Equatable {
        XCTContext.runActivity(named: "Проверяем, что \(description)") { _ in
            XCTAssertEqual(value, eqvivValue, file: file, line: line)
        }
    }
}
