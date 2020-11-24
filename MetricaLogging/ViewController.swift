//
//  ViewController.swift
//  MetricaLogging
//
//  Created by Станислав В. Зеликсон on 25.11.2020.
//  Copyright © 2020 yoomoney. All rights reserved.
//

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

