//
//  MyEventsDatePickerView.swift
//  EventsManager
//
//  Created by Ethan Hu on 6/5/18.
//
//

import UIKit
import SnapKit

class MyEventsDatePickerView: UIView {
    //Data source
    var events:[Event] = []
    
    //Constants
    let datePickerViewHeight:CGFloat = 100
    let dateFontSize:CGFloat = 18
    let dateButtonSideLength:CGFloat = 45
    let dayToDateMargin:CGFloat = 8
    let dateToDateMargin:CGFloat = 20
    let sideMargins:CGFloat = 15
    let shadowOpacity:Float = 0.2
    let shadowRadius:CGFloat = 2
    let shadowOffset = CGSize(width: 0, height: 2)
    
    //View Elements
    let dateStack = UIStackView()
    let dateScrollView = UIScrollView()
    let contentView = UIView()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    /*
     * View Element setup and positioning for this event card.
     */
    func layoutUI() {
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.addSubview(dateScrollView)
        
        dateScrollView.addSubview(contentView)
        contentView.addSubview(dateStack)
        
        dateScrollView.snp.makeConstraints{ make in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints{ make in
            make.edges.equalTo(dateScrollView)
            make.height.equalTo(datePickerViewHeight)
        }
        
        dateStack.alignment = .center
        dateStack.axis = .horizontal
        dateStack.spacing = dateToDateMargin
        dateStack.distribution = .fillEqually
        dateStack.snp.makeConstraints{ make in
            make.top.equalTo(contentView).offset(sideMargins)
            make.bottom.equalTo(contentView).offset(-sideMargins)
            make.right.equalTo(contentView).offset(-sideMargins)
            make.left.equalTo(contentView).offset(sideMargins)
        }
    }
    
    /**
     Configures the date picker view with events. The date picker view will find the latest event in the list and determines the time range for date picking.
     - events: the list of events that the date picker should be picking from.
     */
    func configure(with events: [Event]){
        self.events = events
        let lastDateInEvents = getLastDate(in: events)
        let today = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
        var numOfDates = (Calendar.current.dateComponents([.day], from: today, to: lastDateInEvents).day ?? 0) + 1
        numOfDates = numOfDates < 1 ? 1 : numOfDates
        for index in 1...numOfDates {
            let individualDateStack = UIStackView()
            let day = UILabel()
            let dateButton = UIButton()
            day.font = UIFont.systemFont(ofSize: dateFontSize)
            day.textColor = UIColor(named: "MyEventsDatePickerSelected")
            dateButton.titleLabel?.font = UIFont.systemFont(ofSize: dateFontSize)
            dateButton.isUserInteractionEnabled = false
            let displayDate = Calendar.current.date(byAdding: .day, value: index - 1, to: today)!
            day.text = DateFormatHelper.dayAbbreviationOfWeek(from: displayDate)
            dateButton.setTitle(DateFormatHelper.day(from: displayDate), for: .normal)
            dateButton.setTitleColor(UIColor(named: "MyEventsDatePickerSelected"), for: .normal)
            
            dateButton.snp.makeConstraints{ make in
                make.width.equalTo(dateButtonSideLength)
                make.height.equalTo(dateButtonSideLength)
            }
            dateButton.layer.cornerRadius = dateButtonSideLength / 2
            dateButton.backgroundColor = UIColor.white
            dateButton.layer.shadowColor = UIColor.gray.cgColor
            dateButton.layer.shadowOpacity = shadowOpacity
            dateButton.layer.shadowRadius = shadowRadius
            dateButton.layer.shadowOffset = shadowOffset
            
            
            individualDateStack.addArrangedSubview(day)
            individualDateStack.addArrangedSubview(dateButton)
            individualDateStack.axis = .vertical
            individualDateStack.alignment = .center
            individualDateStack.distribution = .fill
            individualDateStack.spacing = dayToDateMargin
            dateStack.addArrangedSubview(individualDateStack)
        }
        setSelected(selectedView: dateStack.arrangedSubviews[0] as! UIStackView)
    }
    
    /**
        Set the given date picker stack as the selected one
    */
    func setSelected(selectedView: UIStackView){
        for subView in dateStack.arrangedSubviews {
            if let individualDateStackView = subView as? UIStackView {
                for element in individualDateStackView.arrangedSubviews {
                    if let button = element as? UIButton {
                        if selectedView != subView {
                            button.backgroundColor = UIColor.white
                            button.setTitleColor(UIColor(named: "MyEventsDatePickerSelected"), for: .normal)
                        }
                        else {
                            button.backgroundColor = UIColor(named: "MyEventsDatePickerSelected")
                            button.setTitleColor(UIColor.white, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Returns the correct date corresponding the datepicker user pressed on.
    */
    func getDate(selectedView: UIStackView) -> Date? {
        if let index = dateStack.arrangedSubviews.index(of: selectedView) {
            let today = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
            return Calendar.current.date(byAdding: .day, value: index - 1, to: today)!
        }
        return nil
    }
    
    
    /**
     Find and return the last date
     - events: the list of events that this function should look into and find the last date.
     */
    func getLastDate(in events: [Event]) -> Date{
        var dates:Set<Date> = []
        for event in events {
            let startTime = event.startTime
            let startDateString = DateFormatHelper.date(from: startTime) //convert starttime to yyyy-mm-dd strings to remove time from date
            let startDate = DateFormatHelper.date(from: startDateString) ?? DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
            dates.insert(startDate)
        }
        var latestDate = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
        for date in dates {
            if date > latestDate {
                latestDate = date
            }
        }
        return latestDate
    }

}
