//
//  OnBoardingViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/22/18.
//

import UIKit

class OnBoardingViewController: UIViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate  {
    
    //constants
    let navTitleFontSize:CGFloat = 25
    let navSubtitleFontSize:CGFloat = 15
    let titleToTopSpacing:CGFloat = 10
    let titleToSubtitleSpacing:CGFloat = 5
    let sideSpacing:CGFloat = 5
    
    //datasource
    var organizations:[Organization] = []
    var checkOrganization:[Organization] = []
    
    let searchSegments = [NSLocalizedString("search-segment-events", comment: ""), NSLocalizedString("search-segment-organizations", comment: ""), NSLocalizedString("search-segment-tags", comment: "")];
    let searchSegmentEventIndex = 0
    let searchSegmentOrgIndex = 1
    let searchSegmentTagIndex = 2
    var searchController = UISearchController(searchResultsController: nil)
    
    
    //data source
    var events:[Event] = []
    var filteredEvents:[Event] = []
    var sectionDates:[Date] = [] //valid date sections, sorted from small date to large date, unique
    var eventsOnDate:[[Event]] = [] //array whose row represents index in sectionDates, column represents events on that date
    
    var filteredOrganizations:[Organization] = []
    
    var tags:[String] = []
    var filteredTags:[String] = []
    
    let emptyState = SearchEmtpyStateView()
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    
    var currentSearchScope = SearchOptions.events
    
    //constants
    let headerFontSize:CGFloat = 16


    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func updateDataSource(){
        let eventsDateData = EventDateHelper.getEventsFilteredByDate(with: filteredEvents)
        sectionDates = eventsDateData.0
        eventsOnDate = eventsDateData.1
    }
    
    /** Sets all the layout elements in the view */
    func setLayouts(){
        
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
            events.append(Event(id:1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/arnavg.jpg")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags:["#lololo","#heheh","#oooof"], eventParticipantCount: 166))
            events.append(Event(id:1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/arnavg.jpg")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags:["#lololo","#heheh","#oooof"], eventParticipantCount: 166))
        }
        organizations = [Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org")]
        tags = ["#lololo","#heheh","#oooof"]
        //Setting up data source
        filteredEvents = events
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
            self.navigationController?.navigationBar.prefersLargeTitles = true;
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
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalTo(view)
        }
        
        //empty state
        view.addSubview(emptyState)
        view.bringSubview(toFront: emptyState)
        emptyState.snp.makeConstraints{ make in
            make.edges.equalTo(view)
        }
        if searchBarIsEmpty() {
            enableEmptyState()
            emptyState.setInfoLabel(with: NSLocalizedString("search-empty-state-did-not-search", comment: ""))
        }
    }

    
    
    /**
     Sets the basic layout of the view
     */
    func setLayout() {
        //navigation stuffs
        navigationController?.title = NSLocalizedString("onboarding-interact-title", comment: "")
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true;
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        //Navigation bar height cannot be change in > iOS 11. We require the text to be fit into two lines.
        navigationItem.titleView = setTitle(title: "Interact", subtitle: "Choose some on-campus organizations that you would like to follow. ")
        navigationItem.searchController = searchController
        //searchController.delegate = self
        //searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        definesPresentationContext = true
        
        
        view.backgroundColor = UIColor.white
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        
        //Get navigation Bar Height and Width
        let navigationBarWidth = Int(self.navigationController!.navigationBar.frame.width)
        let navigationBarHeight = Int(self.navigationController!.navigationBar.frame.height)
        
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        
        titleLabel.font = UIFont(name: "Dosis-Bold", size: navTitleFontSize)
        subtitleLabel.font = UIFont(name: "Dosis-Book", size: navSubtitleFontSize)
        titleLabel.textColor = UIColor(named: "primaryPink")
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.numberOfLines = 2
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        
        //Add Title and Subtitle to View
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationBarWidth, height: navigationBarHeight))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleView).offset(titleToTopSpacing)
            make.left.equalTo(titleView).offset(sideSpacing)
            make.right.equalTo(titleView).offset(-sideSpacing)
        }
        
        subtitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(titleToSubtitleSpacing)
            make.left.equalTo(titleView).offset(sideSpacing)
            make.right.equalTo(titleView).offset(-sideSpacing)
        }
        
        return titleView
        
    }
    
    
    /**
     Update the data source based on filtered Events
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
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
            return cell;
        case .tags:
            let cellIdentifier = "tagCell"
            var cell : UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            }
            cell.textLabel?.text = filteredTags[indexPath.row]
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
        tableView.isHidden = false
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
        }
        else {
            currentSearchScope = SearchOptions.fromString(scope)
            var filteredResults:[Any] = []
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
                filteredTags = tags.filter { (tag: String) -> Bool in
                    return tag.lowercased().contains(searchText.lowercased())
                }
                filteredResults = filteredTags
            }
            if !filteredResults.isEmpty {
                disableEmptyState()
            }
            else {
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
}
    
    

