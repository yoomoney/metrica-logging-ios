struct DebugEvent: Equatable {
    let name: String
    let parameters: [String: AnyHashable]
    
    init(name: String, parameters: [String: AnyHashable] = [:]) {
        self.name = name
        self.parameters = parameters
    }
}

//MARK: - Paratremized initialization
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
