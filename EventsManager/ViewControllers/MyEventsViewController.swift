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
    var scrollEventCalledByDatePickerClicking = false //when user clicks on date picker, it triggers didscroll and sets the datepicker selected date as well. To prevent this, set this to true when user clicks a date, and to false again in scrollviewdidfinishanimations. Only when this is set to false, will the date picker adjust selection based on the position of the tableview.
    
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
        let eventsDateData = EventDateHelper.getEventsFilteredByDate(with: myEvents)
        sectionDates = eventsDateData.0
        eventsOnDate = eventsDateData.1
        
        
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
                    scrollEventCalledByDatePickerClicking = true
                    datePicker.setSelected(date: dateSelected)
                    tableView.scrollToRow(at: IndexPath(row: 0, section: sectionToScrollTo), at: .top, animated: true)
                }
                else {
                    if let nextDate = getNextDate(in: sectionDates, for: dateSelected) {
                        if let sectionToScrollTo = sectionDates.index(of: nextDate) {
                            scrollEventCalledByDatePickerClicking = true
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
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollEventCalledByDatePickerClicking = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            if let sectionOnTop = indexPaths.first?.section,
                let rowOnTop = indexPaths.first?.row{
                if rowOnTop == 0 && !scrollEventCalledByDatePickerClicking{
                    datePicker.setSelected(date: sectionDates[sectionOnTop])
                }
            }
        }
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
