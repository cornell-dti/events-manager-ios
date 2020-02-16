//
//  EventsDiscoveryTableViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//
//

import UIKit
import Firebase

class ForYouViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventCardCellDelegate {

    //used for refreshing the view controller
    var refreshControl = UIRefreshControl()

    //Constants
    let gAnalyticsScreenName = "for you pg"

    let headerHeight: CGFloat = 35

    //View Elements
    let tableView = UITableView(frame: CGRect(), style: .grouped)

    //Models
    let labelEventsPair = UserData.getRecommendedLabelAndEvents()
    var user = UserData.getLoggedInUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = UIColor(named: "primaryPink")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setup()
        user?.timeSinceNotification = Date()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentDate = Date()
        if currentDate.timeIntervalSince(user!.timeSinceNotification) > 604800 { //if a week (or greater) has elapsed -- 604800 seconds
            scheduleNotification()
            user?.timeSinceNotification = currentDate
        }
    }

    /**
     * View initial setups
     */
    func setup() {

        view.backgroundColor = UIColor.white

        //NAVIGATION STUFFS
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }

        //Tableview stuffs
        tableView.backgroundColor = UIColor(named: "tableViewBackground")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.register(EventCardCell.self, forCellReuseIdentifier: EventCardCell.identifer)
        tableView.register(EventTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EventTableHeaderFooterView.identifier)

        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)

        //tableview layout
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }

    }

    //Schedule weekly tailored notification
    func scheduleNotification() {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        let center = UNUserNotificationCenter.current()
        if let user = UserData.getLoggedInUser() {
            if user.reminderEnabled {
                var forYouEvents = [[Event]]()
                for pair in labelEventsPair {
                    if !pair.1.isEmpty {
                        forYouEvents.append(pair.1) //append the event array
                    }
                }
                if (!forYouEvents.isEmpty) {
                    var triggerDate = DateComponents()
                    //n is 7 and Sunday is represented by 1
                    triggerDate.day = 2
                    triggerDate.hour = 17
                    triggerDate.minute = 00
                    let firstEvent = forYouEvents[0][0] //first event in labelEventsPair array, for initialization purposes
                    var max = 0
                    var mostPopularEvent = firstEvent
                    for eventArray in forYouEvents {
                        for event in eventArray {
                            if event.eventParticipantCount > max && event.startTime.timeIntervalSince(Calendar.current.nextDate(after: Date(), matching: triggerDate, matchingPolicy: .nextTime)!) > 0 {
                                max = event.eventParticipantCount
                                mostPopularEvent = event
                            }
                        }
                    }
                    let content = UNMutableNotificationContent()
                    content.title = NSLocalizedString("notification-weekly-title", comment: "")
                    content.body = "\(mostPopularEvent.eventName)\(NSLocalizedString("notification-weekly-body", comment: ""))"
                    content.sound = .default
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                                repeats: false)
                    let notificationIdentifier = "\(NSLocalizedString("notification-identifier", comment: ""))\(mostPopularEvent.id)"
                    let request = UNNotificationRequest(identifier: notificationIdentifier,
                                                        content: content, trigger: trigger)
                    center.getPendingNotificationRequests(completionHandler: { requests in
                        if !(requests.contains(request)) {
                            center.add(request, withCompletionHandler: { (_) in
                            })
                            Analytics.logEvent("tailoredNotificationAdded", parameters: [
                                "notificationName": mostPopularEvent.eventName
                            ])
                        }
                    })
                }
            }
        }
            
    }

    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return labelEventsPair.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.identifer) as? EventCardCell {
            cell.selectionStyle = .none
            cell.configure(with: labelEventsPair[indexPath.section].1)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as! EventTableHeaderFooterView
        header.setMainTitle(labelEventsPair[section].0)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func push(detailsViewController: EventDetailViewController) {
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
