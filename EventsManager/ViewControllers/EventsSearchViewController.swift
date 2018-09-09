//
//  SearchViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/8/18.
//

import UIKit

class EventsSearchViewController: UIViewController, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    //data source
    var events:[Event] = []
    var filteredEvents:[Event] = []
    var sectionDates:[Date] = [] //valid date sections, sorted from small date to large date, unique
    var eventsOnDate:[[Event]] = [] //array whose row represents index in sectionDates, column represents events on that date
    
    let searchSegments = [NSLocalizedString("search-segment-events", comment: ""), NSLocalizedString("search-segment-organizations", comment: ""), NSLocalizedString("search-segment-tags", comment: "")];
    let searchSegmentEventIndex = 0
    let searchSegmentOrgIndex = 1
    let searchSegmentTagIndex = 2
    var searchController = UISearchController(searchResultsController: nil)
    
    //constants
    let headerFontSize:CGFloat = 16
    
    //view element
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    /**
     Update the data source based on filtered Events
     */
    func updateDataSource(){
        let eventsDateData = EventDateHelper.getEventsFilteredByDate(with: filteredEvents)
        sectionDates = eventsDateData.0
        eventsOnDate = eventsDateData.1
    }
    
    /** Sets all the layout elements in the view */
    func setLayouts(){
        
        //For testing
        var date1 = "2018-08-12 16:39:57"
        var date2 = "2018-08-12 18:39:57"
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
        //Setting up data source
        filteredEvents = events
        updateDataSource()
        
        view.backgroundColor = UIColor.white
        //nav bar
        self.title = NSLocalizedString("search-navigation-title", comment: "")
        searchController.delegate = self
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
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalTo(view)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsOnDate[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(DateFormatHelper.dayOfWeek(from: sectionDates[section])), \(DateFormatHelper.month(from: sectionDates[section])) \(DateFormatHelper.day(from: sectionDates[section]))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsDiscoveryTableViewCell.identifer) as! EventsDiscoveryTableViewCell
        let event = eventsOnDate[indexPath.section][indexPath.row]
        cell.configure(event: event)
        return cell
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
        let detailsViewController = EventDetailViewController()
        detailsViewController.configure(with: eventsOnDate[indexPath.section][indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    //search bar stuffs
    
    /**
     Determines if the search controller is active
     */
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        filteredEvents = events.filter({ (event: Event) -> Bool in
            return event.eventName.lowercased().contains(searchText.lowercased())
        })
        updateDataSource()
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("executed********")
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    
    
}
