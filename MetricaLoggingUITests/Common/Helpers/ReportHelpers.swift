/* The MIT License
 *
 * Copyright © 2020 NBCO YooMoney LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
