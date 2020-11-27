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

struct DebugEvent: Equatable {
    let name: String
    let parameters: [String: AnyHashable]
    
    init(name: String, parameters: [String: AnyHashable] = [:]) {
        self.name = name
        self.parameters = parameters
    }
}

//MARK: - Parametrized initialization
extension DebugEvent {
    init(_ type: MetricsName, params: Parameter...) {
        name = type.rawValue
        parameters = params.reduce(into: [:]) {
            guard let rawValue = $1.rawValue else { return }
            $0.merge([rawValue.0: rawValue.1]) { $1 }
        }
    }
}
 
//MARK: - Eevents` names
extension DebugEvent {
    enum MetricsName: String, CustomStringConvertible {
        case buySuccess = "buy.success"
        case sellSuccess = "sell.success"
        case balanceUpdate = "balance.update"
        case openMainScreen = "openScreen.main"
        case cardTopup = "card.topup"
        
        var description: String {
            rawValue
        }
    }
}

//MARK: - Events` parameters
extension DebugEvent {
    enum Parameter {
        case fromCard(Bool)
        case itemId(String)
		case amount(Int)
        case account(String)
        case currency(String)
        case cardId(String)
        
        var rawValue: (String, AnyHashable)? {
            guard
                let reflection = Mirror(reflecting: self).children.first,
                let label = reflection.label,
                let value = reflection.value as? AnyHashable
            else { return nil }
            return (label, value)
        }
    }
}
