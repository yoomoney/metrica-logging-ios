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

import UIKit

class ViewController: UITableViewController {
    
    private let tracker: Tracker = TrackersContainer(
        appMetricaTracker: AppMetricaTracker(),
        fabricTracker: FabricTracker(),
        amplitudeTracker: AmplitudeTracker(),
        systemLogTracker: SystemLogTracker()
    )
    
    private lazy var trackAsyncSellAction = {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) {
            self.tracker.track(event: SellSuccessEvent(itemId: "12345", amount: 500))
        }
    }
    
    private lazy var actions: [(title: String, action: ()->())] = [
        ("buySomething", { self.tracker.track(event: BuySuccessEvent(fromCard: true, itemId: "12345")) } ),
        ("sellSomething", trackAsyncSellAction),
        ("checkBalance", { self.tracker.track(event: BalanceUpdateEvent(account: .current)) } ),
        ("topupItem", { self.tracker.track(event: CardTopupEvent(amount: 140, currency: "rub", cardId: "1283 7612 3142 4534")) } ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.simpleCellIdentifier)
        tableView.accessibilityIdentifier = "MainTableView"
        tracker.track(event: OpenMainScreenEvent())
    }
}

//MARK: - UITableViewDelegate
extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let action = actions[indexPath.row].action
        action()
    }
}

//MARK: - UITableViewDataSource
extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.simpleCellIdentifier, for: indexPath)
        cell.textLabel?.text = actions[indexPath.row].title
        cell.accessibilityIdentifier = "\(Constants.simpleCellIdentifier)-\(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actions.count
    }
}

private extension ViewController {
    enum Constants {
        static let simpleCellIdentifier = "simpleCell"
    }
}

