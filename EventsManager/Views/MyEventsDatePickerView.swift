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
    var dates:[Date] = []
    
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
    func configure(with dates:[Date]){
        self.dates = dates
        let lastDateInEvents = getLastDate(in: dates)
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
        setSelected(date: getFirstDate(in: dates))
    }
    
    /**
     Set the given date picker stack as the selected one
     */
    func setSelected(date: Date){
        let today = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
        if let indexOfSelectedStack = Calendar.current.dateComponents([.day], from: today, to: date).day{
            if(indexOfSelectedStack >= 0 && indexOfSelectedStack < dateStack.arrangedSubviews.count) {
                for (index,subView) in dateStack.arrangedSubviews.enumerated() {
                    if let individualDateStackView = subView as? UIStackView {
                        for element in individualDateStackView.arrangedSubviews {
                            if let button = element as? UIButton {
                                if index != indexOfSelectedStack {
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
        }
    }
    
    /**
     Returns the correct date corresponding the datepicker user pressed on.
    */
    func getDate(selectedView: UIStackView) -> Date? {
        if let index = dateStack.arrangedSubviews.index(of: selectedView) {
            let today = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
            return Calendar.current.date(byAdding: .day, value: index, to: today)!
        }
        return nil
    }
    
    
    /**
     Find and return the first date
     - dates: the array of dates to search the first date in
     - returns: the first date if the array is not empty; today if the array is empty
     */
    func getFirstDate(in dates: [Date]) -> Date{
        if dates.count > 0 {
            return dates.sorted()[0]
        }
        return DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
    }
    
    
    /**
     Find and return the last date
     - dates
     - returns: the last date
     */
    func getLastDate(in dates: [Date]) -> Date{
        var latestDate = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
        for date in dates {
            if date > latestDate {
                latestDate = date
            }
        }
        return latestDate
    }

}
