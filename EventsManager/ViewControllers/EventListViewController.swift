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
    var events: [Event] = []
    var sectionDates: [Date] = [] //valid date sections, sorted from small date to large date, unique
    var eventsOnDate: [[Event]] = [] //array whose row represents index in sectionDates, column represents events on that date

    //Constants
    let headerFontSize: CGFloat = 16
    
    //let datePicker = MyEventsDatePickerView()
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    
    func setup(with events: [Event], title: String, withFilterBar: Bool) {
        navigationItem.title = title
        let eventsDateData = EventDateHelper.getEventsFilteredByDate(with: events)
        sectionDates = eventsDateData.0
        eventsOnDate = eventsDateData.1
    
        //TableView
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
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
