//
//  TagViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/9/18.
//
//

import UIKit

//Displays the events as a list, with a optional filter bar at the top.
class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var myEvents: [Event] = [] //all my events
    var sectionDates: [Date] = [] //valid date sections, sorted from small date to large date, unique
    var eventsOnDate: [[Event]] = [] //array whose row represents index in sectionDates, column represents events on that date

    //Constants
    let headerFontSize: CGFloat = 16
    
    //let datePicker = MyEventsDatePickerView()
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    
    /* Sets all the layout elements in the view */
    private func setLayouts() {
        
        //For testing
        var date1 = "2019-01-22 16:39:57"
        var date2 = "2019-01-22 18:39:57"
        for _ in 1...20 {
            var date1Date = DateFormatHelper.datetime(from: date1)!
            date1Date = Calendar.current.date(byAdding: .day, value: 2, to: date1Date)!
            date1 = DateFormatHelper.datetime(from: date1Date)
            var date2Date = DateFormatHelper.datetime(from: date2)!
            date2Date = Calendar.current.date(byAdding: .day, value: 2, to: date2Date)!
            date2 = DateFormatHelper.datetime(from: date2Date)
            myEvents.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 166))
            myEvents.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 166))
        }
        //Setting up data source
        let eventsDateData = EventDateHelper.getEventsFilteredByDate(with: myEvents)
        sectionDates = eventsDateData.0
        eventsOnDate = eventsDateData.1
        
        //TableView
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
    }
    
    func setup(with events: [Event], title: String, withFilterBar: Bool) {
        navigationItem.title = title
    }
    
    //TABLEVIEW DELEGATE METHODS
    
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

}
