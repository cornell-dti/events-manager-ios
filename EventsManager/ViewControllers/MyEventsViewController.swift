//
//  MyEventsViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit
import SnapKit

class MyEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var myEvents:[Event] = [] //all my events
    var sectionDates:[Date] = [] //valid date sections, sorted from small date to large date, unique
    var eventsOnDate:[[Event]] = [] //array whose row represents index in sectionDates, column represents events on that date
    
    //Constants
    let datePickerHeight:CGFloat = 100
    let headerFontSize:CGFloat = 16
    
    let datePicker = MyEventsDatePickerView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    /* Sets all the layout elements in the view */
    private func setLayouts(){
        
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
            myEvents.append(Event(id:1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/arnavg.jpg")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags:["#lololo","#heheh","#oooof"], eventParticipantCount: 166))
            myEvents.append(Event(id:1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/arnavg.jpg")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags:["#lololo","#heheh","#oooof"], eventParticipantCount: 166))
        }
        //Setting up data source
        var sectionDateSet = getUniqueDates(in: myEvents)
        sectionDateSet = removePastDates(from: sectionDateSet)
        sectionDates = sectionDateSet.sorted()
        for date in sectionDates {
            eventsOnDate.append(getEvents(on: date, for: myEvents))
        }
        assert(sectionDates.count == eventsOnDate.count, "MyEventsVC: num of date sections doesn't match num of date section index keys in eventsOnDate")
        
        
        //Nav Bar and date picker
        let navigationBar = navigationController!.navigationBar
        navigationBar.backgroundColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(),for: .default)
        navigationBar.shadowImage = UIImage()
        
        datePicker.configure(with: sectionDates)
        
        view.backgroundColor = UIColor.white
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.height.equalTo(datePickerHeight)
        }
        
        for date in datePicker.dateStack.arrangedSubviews {
            let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDatePressed(_:)))
            date.addGestureRecognizer(dateTapGesture)
            date.isUserInteractionEnabled = true
        }
        
        //TableView
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(datePicker.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        view.bringSubview(toFront: datePicker)
    
    }
    
    /**
     Event Handler for pressing dates on the date picker. Should highlight the selected date and filter the events in myevents.
    */
    @objc func onDatePressed(_ sender:UITapGestureRecognizer){
        if let individualDateStack = sender.view as? UIStackView {
            if let dateSelected = datePicker.getDate(selectedView: individualDateStack) {
                let dateSelectedWithoutTime = DateFormatHelper.date(from: DateFormatHelper.date(from: dateSelected))! //strip time off(if exist)
                if let sectionToScrollTo = sectionDates.index(of: dateSelectedWithoutTime) {
                    datePicker.setSelected(date: dateSelected)
                    tableView.scrollToRow(at: IndexPath(row: 0, section: sectionToScrollTo), at: .top, animated: true)
                }
                else {
                    if let nextDate = getNextDate(in: sectionDates, for: dateSelected) {
                        if let sectionToScrollTo = sectionDates.index(of: nextDate) {
                            datePicker.setSelected(date: nextDate)
                            tableView.scrollToRow(at: IndexPath(row: 0, section: sectionToScrollTo), at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Gets the next date after a specified date in an sorted array of dates.
     Precondition: The sortedDates array must be sorted ascendingly.
     - sortedDates: the sorted date array
     - date: the date to search
     - returns: the date itself if it is in the sortedDate array; the first date greater than the date if the date is not in the sorted array; nil if there is no date greater than the given date in the sorted array
     */
    private func getNextDate(in sortedDates: [Date], for date: Date) -> Date? {
        if sortedDates.index(of: date) != nil {
            return date
        }
        for dateInList in sortedDates {
            if dateInList > date {
                return dateInList
            }
        }
        return nil
    }
    
    /**
     Get all unique dates
     - events: the array of events this function should search dates from
     - returns: a set of dates, retrieved from @events
     */
    private func getUniqueDates(in events: [Event]) -> Set<Date> {
        var dates:Set<Date> = []
        for event in events {
            let startTime = event.startTime
            let startDateString = DateFormatHelper.date(from: startTime) //convert starttime to yyyy-mm-dd strings to remove time from date
            let startDate = DateFormatHelper.date(from: startDateString) ?? DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
            dates.insert(startDate)
        }
        return dates
    }
    
    /**
     Removes dates prior to today
     - dates: the set of dates to perform the operation on
     - returns: a set of dates without dates prior to today
     */
    private func removePastDates(from dates: Set<Date>) -> Set<Date> {
        var dates = dates
        let today = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
        for date in dates {
            if date < today {
                dates.remove(date)
            }
        }
        return dates
    }
    
    /**
     Gets events whose start time is on a given date
     - date
     - events
     - returns: array of events on that date
     */
    private func getEvents(on date:Date, for events: [Event]) -> [Event] {
        var eventsOnDate:[Event] = []
        let dateString = DateFormatHelper.date(from: date)
        for event in events {
            let eventDateString = DateFormatHelper.date(from: event.startTime)
            if dateString == eventDateString {
                eventsOnDate.append(event)
            }
        }
        return eventsOnDate
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
