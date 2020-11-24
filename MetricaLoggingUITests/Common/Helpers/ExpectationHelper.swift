import Foundation

func resultWithWaiting(timeout: Int, conditionClosure: @escaping () -> Bool) -> Bool {
    let semaphore = DispatchSemaphore(value: 0)
    var isWaitingForResult = true
    
    func waitForCondition(_ conditionClosure: @escaping () -> Bool) {
        if conditionClosure() {
            semaphore.signal()
        } else if isWaitingForResult {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                waitForCondition(conditionClosure)
            }
        }
    }
    waitForCondition {
        conditionClosure()
    }
    
    let result = semaphore.wait(timeout: .now() + .seconds(timeout)) == .success
    isWaitingForResult = false
    return result
}
