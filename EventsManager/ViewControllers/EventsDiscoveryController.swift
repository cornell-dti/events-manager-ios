//
//  EventsDiscoveryTableViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit

class EventsDiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
    
    //Constants
    let headerHeight:CGFloat = 35
    
    let popularEventsSection = 0
    let todayEventsSection = 1
    let tomorrowEventsSection = 2
    let seeAllEventSection = 3
    
    //View Elements
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    
    //Models
    var events = [Event]()
    var popularEvents = [Event]()
    var todayEvents = [Event]()
    var tomorrowEvents = [Event] ()
    
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /**
    * View initial setups
    */
    func setup(){
        //for testing
        let date1 = "2018-06-20 16:39:57"
        let date2 = "2018-06-20 18:39:57"
        for _ in 1...20 {
            events.append(Event(id:1, startTime: DateFormatHelper.date(from: date1)!, endTime: DateFormatHelper.date(from: date2)!, eventName: "Cornell DTI Meeting Meeting Meeting Meeting!", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/jaggerb.JPG")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags:["#lololo","#heheh","#oooof"], eventParticipantCount: 166))
        }
        popularEvents = events
        todayEvents = events
        tomorrowEvents = events
        
        view.backgroundColor = UIColor.white
        
        //NAVIGATION STUFFS
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        
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

    /**
     Handle the action for user pressing the see more buttons above a popular card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
    */
    @objc func popularSeeMoreButtonPressed(_ sender: UIButton){
        let popularListViewController = EventListViewController()
        popularListViewController.setup(with: popularEvents, title: "All Popular Events", withFilterBar: false)
        navigationController?.pushViewController(popularListViewController, animated: true)
    }
    
    /**
     Handle the action for user pressing the see more buttons above a today card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
     */
    @objc func todaySeeMoreButtonPressed(_ sender: UIButton){
        let todayListViewController = EventListViewController()
        todayListViewController.setup(with: popularEvents, title: "Today's Events", withFilterBar: false)
        navigationController?.pushViewController(todayListViewController, animated: true)
    }
    
    /**
     Handle the action for user pressing the see more buttons above a tomorrow card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
     */
    @objc func tomorrowSeeMoreButtonPressed(_ sender: UIButton){
        let tomorrowListViewController = EventListViewController()
        tomorrowListViewController.setup(with: popularEvents, title: "Tomorrow's Events", withFilterBar: false)
        navigationController?.pushViewController(tomorrowListViewController, animated: true)
    }
    
    /**
     Handle the action for user pressing the see all events buttons at the bottom of the page. Should segue to a event list view controller with filters
     - sender: the button that this action is triggered.
     */
    @objc func seeAllEventsButtonPressed(_ sender: UIButton){
        let seeAllEventsListViewController = EventListViewController()
        seeAllEventsListViewController.setup(with: popularEvents, title: "All Events", withFilterBar: true)
        navigationController?.pushViewController(seeAllEventsListViewController, animated: true)
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
        var cell = UITableViewCell()
        switch indexPath.section {
            case popularEventsSection:
                if let popularCardCell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.identifer, for: indexPath) as? EventCardCell {
                    popularCardCell.configure(with: popularEvents)
                    cell = popularCardCell
                }
            case todayEventsSection:
                if let todayCardCell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.identifer, for: indexPath) as? EventCardCell {
                    todayCardCell.configure(with: todayEvents)
                    cell = todayCardCell
                }
            case tomorrowEventsSection:
                if let tomorrowCardCell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.identifer, for: indexPath) as? EventCardCell {
                    tomorrowCardCell.configure(with: tomorrowEvents)
                    cell = tomorrowCardCell
            }
            default: break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    /*
     segue to the selected eventsDetailController
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = EventDetailViewController()
        detailsViewController.configure(with: events[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UITableViewHeaderFooterView()
        switch section {
        case popularEventsSection:
            if let popularHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
                popularHeader.setMainTitle("POPULAR EVENTS")
                popularHeader.setButtonTitle("See More")
                popularHeader.editButton.addTarget(self, action:#selector(popularSeeMoreButtonPressed(_:)), for: .touchUpInside)
                header = popularHeader
            }
        case todayEventsSection:
            if let todayHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
                todayHeader.setMainTitle("TODAY'S EVENTS")
                todayHeader.setButtonTitle("See More")
                todayHeader.editButton.addTarget(self, action:#selector(todaySeeMoreButtonPressed(_:)), for: .touchUpInside)
                header = todayHeader
            }
        case tomorrowEventsSection:
            if let tomorrowHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
                tomorrowHeader.setMainTitle("TOMORROW'S EVENTS")
                tomorrowHeader.setButtonTitle("See More")
                tomorrowHeader.editButton.addTarget(self, action:#selector(tomorrowSeeMoreButtonPressed(_:)), for: .touchUpInside)
                header = tomorrowHeader
            }
        case seeAllEventSection:
            if let seeAllEventsHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: SeeAllEventsHeaderFooterView.identifier) as? SeeAllEventsHeaderFooterView {
                seeAllEventsHeader.setButtonTitle("- See All Events -")
                seeAllEventsHeader.editButton.addTarget(self, action:#selector(seeAllEventsButtonPressed(_:)), for: .touchUpInside)
                header = seeAllEventsHeader
            }
        default: break;
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
