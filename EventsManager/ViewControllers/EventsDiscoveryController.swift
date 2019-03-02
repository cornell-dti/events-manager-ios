//
//  EventsDiscoveryTableViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//
//

import UIKit

class EventsDiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventCardCellDelegate {
    
    //used for refreshing the view controller
    var refreshControl = UIRefreshControl()

    //Constants
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

    //Models
    var events = [Event]()
    var popularEvents = [Event]()
    var todayEvents = [Event]()
    var tomorrowEvents = [Event] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = UIColor(named: "primaryPink")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        preloadCells()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /**
     Preload cells, including the popular, today, tomorrow card cells.
     This action is to prevent active loading the cells during user scroll.
     The auto layout work is quite heavy in these card cells (lots of cards per cell), therefore generating it actively causes lagging.
     Since there will be only 3 cells, it is legit to preload cells instead of generating them dynmically during scroll.
     Cells are loaded into the @cells dictionary
    */
    func preloadCells() {
        
        //for testing
        let date1 = "2019-03-02 16:39:57"
        let date2 = "2019-03-02 18:39:57"
        let date3 = "2019-03-02 20:39:57"
        let date4 = "2019-03-03 00:39:57"
        let date5 = "2019-03-03 23:39:57"
        let date6 = "2019-03-06 08:39:57"
        let date7 = "2019-03-06 12:39:57"
        events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 186))
        events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date2)!, endTime: DateFormatHelper.datetime(from: date3)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 170))
        events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date3)!, endTime: DateFormatHelper.datetime(from: date4)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 176))
        events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date4)!, endTime: DateFormatHelper.datetime(from: date5)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 160))
        events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date6)!, endTime: DateFormatHelper.datetime(from: date7)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 160))
        for _ in 6...20 {
            events.append(Event(id: 2, startTime: DateFormatHelper.datetime(from: date3)!, endTime: DateFormatHelper.datetime(from: date4)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [2], eventParticipantCount: 186))
        }
        popularEvents = events.sorted(by: { $0.eventParticipantCount > $1.eventParticipantCount })
        popularEvents = Array(popularEvents.prefix(10))
        for ev in events {
            if (Calendar.current.isDateInToday(ev.startTime)) {
                todayEvents.append(ev)
            }
            else if (Calendar.current.isDateInTomorrow(ev.startTime)){
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
    }

    /**
    * View initial setups
    */
    func setup() {

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

        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)

        //tableview layout
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }

    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
