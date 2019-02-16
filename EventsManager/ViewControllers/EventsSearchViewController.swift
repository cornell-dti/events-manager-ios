//
//  SearchViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/8/18.
//

import UIKit

class EventsSearchViewController: UIViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    //data source
    var events: [Event] = []
    var filteredEvents: [Event] = []
    var sectionDates: [Date] = [] //valid date sections, sorted from small date to large date, unique
    var eventsOnDate: [[Event]] = [] //array whose row represents index in sectionDates, column represents events on that date

    var organizations: [Organization] = []
    var filteredOrganizations: [Organization] = []

    var tags: [Int] = []
    var filteredTags: [Int] = []

    var currentSearchScope = SearchOptions.events

    let searchSegments = [NSLocalizedString("search-segment-events", comment: ""), NSLocalizedString("search-segment-organizations", comment: ""), NSLocalizedString("search-segment-tags", comment: "")]
  //  let searchSegmentEventIndex = 0
    let searchSegmentOrgIndex = 1
   // let searchSegmentTagIndex = 2
    var searchController = UISearchController(searchResultsController: nil)

    //constants
    let headerFontSize: CGFloat = 16

    //view element
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    lazy var datePickerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "calendarempty"), style: .plain, target: self, action: #selector(datePickerButtonPressed(_:)))
        button.tintColor = UIColor(named: "primaryPink")
        return button
    }()
    let emptyState = SearchEmtpyStateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }

    /**
     Update the data source based on filtered Events
     */
    func updateDataSource() {
        let eventsDateData = EventDateHelper.getEventsFilteredByDate(with: filteredEvents)
        sectionDates = eventsDateData.0
        eventsOnDate = eventsDateData.1
    }

    /** Sets all the layout elements in the view */
    func setLayouts() {
        navigationItem.rightBarButtonItem = datePickerButton

        //For testing
        var date1 = "2018-09-22 16:39:57"
        var date2 = "2018-09-22 18:39:57"
        for _ in 1...20 {
            var date1Date = DateFormatHelper.datetime(from: date1)!
            date1Date = Calendar.current.date(byAdding: .day, value: 2, to: date1Date)!
            date1 = DateFormatHelper.datetime(from: date1Date)
            var date2Date = DateFormatHelper.datetime(from: date2)!
            date2Date = Calendar.current.date(byAdding: .day, value: 2, to: date2Date)!
            date2 = DateFormatHelper.datetime(from: date2Date)
            events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 166))
//            events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 166))
        }
        organizations = [Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org")]
        tags = [1]
        //Setting up data source
       // filteredEvents = events
        filteredOrganizations = organizations
        filteredTags = tags
        updateDataSource()

        view.backgroundColor = UIColor.white
        //nav bar
        self.title = NSLocalizedString("search-navigation-title", comment: "")
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = searchSegments
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        definesPresentationContext = true
        navigationItem.searchController = searchController
        if #available(iOS 11, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }

        //TableView
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrganizationTableViewCell.self, forCellReuseIdentifier: OrganizationTableViewCell.identifier)
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        //empty state
        view.addSubview(emptyState)
        view.bringSubviewToFront(emptyState)
        emptyState.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        if searchBarIsEmpty() {
            enableEmptyState()
            emptyState.setInfoLabel(with: NSLocalizedString("search-empty-state-did-not-search", comment: ""))
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentSearchScope {
            case .events:
                return sectionDates.count
            case .organization:
                return 1
            case .tags:
                return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSearchScope {
            case .events:
                return eventsOnDate[section].count
            case .organization:
                return filteredOrganizations.count
            case .tags:
                return filteredTags.count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch currentSearchScope {
            case .events:
                return "\(DateFormatHelper.dayOfWeek(from: sectionDates[section])), \(DateFormatHelper.month(from: sectionDates[section])) \(DateFormatHelper.day(from: sectionDates[section]))"
            default:
                return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentSearchScope {
            case .events:
                let cell = tableView.dequeueReusableCell(withIdentifier: EventsDiscoveryTableViewCell.identifer) as! EventsDiscoveryTableViewCell
                let event = eventsOnDate[indexPath.section][indexPath.row]
                cell.configure(event: event)
                return cell
            case .organization:
                let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationTableViewCell.identifier) as! OrganizationTableViewCell
                cell.configure(with: filteredOrganizations[indexPath.row])
                return cell
            case .tags:
                let cellIdentifier = "tagCell"
                var cell: UITableViewCell!
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                }
                cell.textLabel?.text = AppData.getTag(by: filteredTags[indexPath.row]).name
                return cell
        }

    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: headerFontSize)
    }

    /*
     segue to the selected eventsDetailController
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentSearchScope {
            case .events:
                let detailsViewController = EventDetailViewController()
                detailsViewController.configure(with: eventsOnDate[indexPath.section][indexPath.row])
                navigationController?.pushViewController(detailsViewController, animated: true)
            case .organization:
                let orgViewController = OrganizationViewController()
                orgViewController.configure(organization: filteredOrganizations[indexPath.row])
                navigationController?.pushViewController(orgViewController, animated: true)
            case .tags:
                let tagViewController = TagViewController()
                tagViewController.setup(with: events, for: tags[indexPath.row])
                navigationController?.pushViewController(tagViewController, animated: true)

        }

    }

    //search bar stuffs

    func enableEmptyState() {
        emptyState.isHidden = false
        tableView.isHidden = true
    }

    func disableEmptyState() {
        emptyState.isHidden = true
        tableView.isHidden = false
    }

    /**
     Determines if the search controller is active
     */
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String, scope: String) {
        if !isSearching() {
            enableEmptyState()
            emptyState.setInfoLabel(with: NSLocalizedString("search-empty-state-did-not-search", comment: ""))
        } else {
            currentSearchScope = SearchOptions.fromString(scope)
            var filteredResults: [Any] = []
            switch currentSearchScope {
                case .events:
                    filteredEvents = events.filter({ (event: Event) -> Bool in
                        return event.eventName.lowercased().contains(searchText.lowercased())
                    })
                    filteredResults = filteredEvents
                case .organization:
                    filteredOrganizations = organizations.filter({ (organization: Organization) -> Bool in
                        return organization.name.lowercased().contains(searchText.lowercased())
                    })
                    filteredResults = filteredOrganizations
                case .tags:
                    filteredTags = tags.filter { (tag: Int) -> Bool in
                        return AppData.getTag(by: tag).name.lowercased().contains(searchText.lowercased())
                    }
                    filteredResults = filteredTags
            }
            if !filteredResults.isEmpty {
                disableEmptyState()
            } else {
                enableEmptyState()
                emptyState.setInfoLabel(with: NSLocalizedString("search-empty-state-no-result", comment: ""))
            }
            updateDataSource()
            tableView.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    //date picker stuff
    @objc func datePickerButtonPressed(_ sender: UIBarButtonItem) {
        datePickerButton.image = UIImage(named: "calendarfilled")
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePickerMode.date
        picker.timeZone = NSTimeZone.local
        picker.addTarget(self, action: Selector(("dueDateChanged:")), for: UIControlEvents.valueChanged)
        //        let pickerSize : CGSize = picker.sizeThatFits(CGSizeZero)
        picker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        // you probably don't want to set background color as black
        // picker.backgroundColor = UIColor.blackColor()
        self.view.addSubview(picker)
    }
    
    func dueDateChanged(sender:UIDatePicker){
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        //self.myLabel.text = dateFormatter.stringFromDate(dueDate.date)
    }

}
