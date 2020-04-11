//
//  EventsDiscoveryTableViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//
//

import UIKit
import Firebase

class EventsDiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventCardCellDelegate {

    //used for refreshing the view controller
    var refreshControl = UIRefreshControl()

    //Constants
    let gAnalyticsScreenName = "discover pg"

    let headerHeight: CGFloat = 35

    let popularEventsSection = 0
    let todayEventsSection = 1
    let tomorrowEventsSection = 2
    let seeAllEventSection = 3
    var cells = [Int: EventCardCell]()

    //View Elements
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    lazy var searchBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(searchButtonPressed(_:)))
        button.tintColor = UIColor(named: "primaryPink")
        return button
    }()
    let loadingViewController = LoadingViewController()

    //Models
    var events = [Event]()
    var popularEvents = [Event]()
    var todayEvents = [Event]()
    var tomorrowEvents = [Event]()
    
    var user = UserData.getLoggedInUser()

    override func viewDidLoad() {
        super.viewDidLoad()

        //data update
        NotificationCenter.default.addObserver(self, selector: #selector(preloadCells), name: .reloadData, object: nil)
        loadingViewController.configure(with: NSLocalizedString("loading", comment: ""))
        _ = AppData.getEvents(startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController), endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController), noConnection: GenericLoadingHelper.noConnection(from: self), updateData: true)
        preloadCells()
        
       // let currentDate = Date()
        //if currentDate.timeIntervalSince(user!.timeSinceNotification) > 604800 { //if a week (or greater) has elapsed -- 604800 seconds
            scheduleNotification()
          //  user?.timeSinceNotification = currentDate
        //}

        setup()
        
        
    }

    /**
     Preload cells, including the popular, today, tomorrow card cells.
     This action is to prevent active loading the cells during user scroll.
     The auto layout work is quite heavy in these card cells (lots of cards per cell), therefore generating it actively causes lagging.
     Since there will be only 3 cells, it is legit to preload cells instead of generating them dynmically during scroll.
     Cells are loaded into the @cells dictionary
    */
    @objc func preloadCells() {

        popularEvents = []
        todayEvents = []
        tomorrowEvents = []

        events = AppData.getEvents(startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: false)
        popularEvents = events.sorted(by: { $0.eventParticipantCount > $1.eventParticipantCount })
        for ev in events {
            if Calendar.current.isDateInToday(ev.startTime) {
                todayEvents.append(ev)
            } else if Calendar.current.isDateInTomorrow(ev.startTime) {
                tomorrowEvents.append(ev)
            }
        }
        todayEvents = todayEvents.sorted(by: { $0.eventParticipantCount > $1.eventParticipantCount })
        tomorrowEvents = tomorrowEvents.sorted(by: { $0.eventParticipantCount > $1.eventParticipantCount })
        todayEvents = (Array(todayEvents.prefix(10))).sorted(by: { $0.startTime.timeIntervalSinceNow < $1.startTime.timeIntervalSinceNow })
        tomorrowEvents = (Array(tomorrowEvents.prefix(10))).sorted(by: { $0.startTime.timeIntervalSinceNow < $1.startTime.timeIntervalSinceNow })

        let popularEventsCell = EventCardCell(style: .default, reuseIdentifier: EventCardCell.identifer)
        let todayEventsCell = EventCardCell(style: .default, reuseIdentifier: EventCardCell.identifer)
        let tomorrowEventsCell = EventCardCell(style: .default, reuseIdentifier: EventCardCell.identifer)
        popularEventsCell.configure(with: popularEvents)
        todayEventsCell.configure(with: todayEvents)
        tomorrowEventsCell.configure(with: tomorrowEvents)
        cells[popularEventsSection] = popularEventsCell
        cells[todayEventsSection] = todayEventsCell
        cells[tomorrowEventsSection] = tomorrowEventsCell
        for (_, cell) in cells {
            cell.delegate = self
        }

        tableView.reloadData()
    }

    /**
    * View initial setups
    */
    func setup() {
        //refresh control
        refreshControl.tintColor = UIColor(named: "primaryPink")
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("loading", comment: ""))
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        //NAVIGATION STUFFS
        navigationItem.rightBarButtonItem = searchBarButton
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
        tableView.register(SeeAllEventsHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: SeeAllEventsHeaderFooterView.identifier)

        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)

        //tableview layout
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }

    }

    @objc func refresh(sender:AnyObject) {
        _ = AppData.getEvents(startLoading: GenericLoadingHelper.voidLoading(), endLoading: {
            self.refreshControl.endRefreshing()
        }, noConnection: GenericLoadingHelper.noConnection(from: self), updateData: true)
    }
    
    //Schedule weekly notification notifying user that events have been added
    func scheduleNotification() {
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        let center = UNUserNotificationCenter.current()
        if let user = UserData.getLoggedInUser() {
            if user.reminderEnabled {
                //n is 7 and Sunday is represented by 1
                let date = Date(timeIntervalSinceNow: 3600)
                let triggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute, .second,], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("notification-weekly-title", comment: "")
                content.body = NSLocalizedString("notification-weekly-body", comment: "")
                content.sound = .default
                let notificationIdentifier = "\(NSLocalizedString("notification-identifier", comment: ""))"
                let request = UNNotificationRequest(identifier: notificationIdentifier,
                                                    content: content, trigger: trigger)
                center.getPendingNotificationRequests(completionHandler: { requests in
                    if !(requests.contains(request)) {
                        center.add(request, withCompletionHandler: { (_) in
                        })
                        Analytics.logEvent("weeklyNotificationAdded", parameters: [:])
                    }
                })
            }
        }
    }

    /**
     Handle the action for user pressing the see more buttons above a popular card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
    */
    @objc func popularSeeMoreButtonPressed(_ sender: UIButton) {
        let popularListViewController = EventListViewController()
        popularListViewController.setup(with: popularEvents, title: NSLocalizedString("popular", comment: ""), withFilterBar: false)
        navigationController?.pushViewController(popularListViewController, animated: true)
    }

    /**
     Handle the action for user pressing the see more buttons above a today card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
     */
    @objc func todaySeeMoreButtonPressed(_ sender: UIButton) {
        let todayListViewController = EventListViewController()
        todayListViewController.setup(with: todayEvents, title: NSLocalizedString("today-events", comment: ""), withFilterBar: false)
        navigationController?.pushViewController(todayListViewController, animated: true)
    }

    /**
     Handle the action for user pressing the see more buttons above a tomorrow card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
     */
    @objc func tomorrowSeeMoreButtonPressed(_ sender: UIButton) {
        let tomorrowListViewController = EventListViewController()
        tomorrowListViewController.setup(with: tomorrowEvents, title: NSLocalizedString("tomorrow-events", comment: ""), withFilterBar: false)
        navigationController?.pushViewController(tomorrowListViewController, animated: true)
    }

    /**
     Handle the action for user pressing the see all events buttons at the bottom of the page. Should segue to a event list view controller with filters
     - sender: the button that this action is triggered.
     */
    @objc func seeAllEventsButtonPressed(_ sender: UIButton) {
        let seeAllEventsListViewController = EventListViewController()
        seeAllEventsListViewController.setup(with: events, title: NSLocalizedString("all-events", comment: ""), withFilterBar: true)
        navigationController?.pushViewController(seeAllEventsListViewController, animated: true)
    }

    /**
     Handles user tap on the search button on top right corner, should segue to the search page.
     */
    @objc func searchButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(EventsSearchViewController(), animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case popularEventsSection: return 1
            case todayEventsSection: return 1
            case tomorrowEventsSection: return 1
            case seeAllEventSection: return 0
            default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = cells[indexPath.section] {
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UITableViewHeaderFooterView()
        switch section {
            case popularEventsSection:
                if let popularHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
                    popularHeader.setMainTitle(NSLocalizedString("popular", comment: "").uppercased())
                    popularHeader.setButtonTitle(NSLocalizedString("see-more-button", comment: ""))
                    popularHeader.editButton.removeTarget(nil, action: nil, for: .allEvents)
                    popularHeader.editButton.addTarget(self, action: #selector(popularSeeMoreButtonPressed(_:)), for: .touchUpInside)
                    header = popularHeader
                }
            case todayEventsSection:
                if let todayHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
                    todayHeader.setMainTitle(NSLocalizedString("today-events", comment: "").uppercased())
                    todayHeader.setButtonTitle(NSLocalizedString("see-more-button", comment: ""))
                    todayHeader.editButton.removeTarget(nil, action: nil, for: .allEvents)
                    todayHeader.editButton.addTarget(self, action: #selector(todaySeeMoreButtonPressed(_:)), for: .touchUpInside)
                    header = todayHeader
                }
            case tomorrowEventsSection:
                if let tomorrowHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
                    tomorrowHeader.setMainTitle(NSLocalizedString("tomorrow-events", comment: "").uppercased())
                    tomorrowHeader.setButtonTitle(NSLocalizedString("see-more-button", comment: ""))
                    tomorrowHeader.editButton.removeTarget(nil, action: nil, for: .allEvents)
                    tomorrowHeader.editButton.addTarget(self, action: #selector(tomorrowSeeMoreButtonPressed(_:)), for: .touchUpInside)
                    header = tomorrowHeader
                }
            case seeAllEventSection:
                if let seeAllEventsHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SeeAllEventsHeaderFooterView.identifier) as? SeeAllEventsHeaderFooterView {
                    seeAllEventsHeader.setButtonTitle(NSLocalizedString("see-all-button", comment: ""))
                    seeAllEventsHeader.editButton.removeTarget(nil, action: nil, for: .allEvents)
                    seeAllEventsHeader.editButton.addTarget(self, action: #selector(seeAllEventsButtonPressed(_:)), for: .touchUpInside)
                    header = seeAllEventsHeader
                }
            default: break
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func push(detailsViewController: EventDetailViewController) {
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
