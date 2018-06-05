//
//  MyEventsDatePickerView.swift
//  EventsManager
//
//  Created by Ethan Hu on 6/5/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit
import SnapKit

class MyEventsDatePickerView: UIView {
    
    //Constants
    let numOfDates = 7;
    let dateFontSize:CGFloat = 18;
    let dayToDateMargin:CGFloat = 5;
    let dateToDateMargin:CGFloat = 8;
    let sideMargins:CGFloat = 10;
    
    //View Elements
    let dateStack = UIStackView()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    /*
     * View Element setup and positioning for this event card.
     */
    func layoutUI() {
        self.addSubview(dateStack)
        let today = Date()
        for index in 1...numOfDates {
            let individualDateStack = UIStackView()
            let day = UILabel()
            let date = UILabel()
            day.font = UIFont.systemFont(ofSize: dateFontSize)
            date.font = UIFont.systemFont(ofSize: dateFontSize)
            let displayDate = Calendar.current.date(byAdding: .day, value: index - 1, to: today)!
            day.text = DateFormatHelper.dayOfWeek(from: displayDate)
            date.text = DateFormatHelper.day(from: displayDate)
        
            individualDateStack.addArrangedSubview(day)
            individualDateStack.addArrangedSubview(date)
            individualDateStack.axis = .vertical
            individualDateStack.alignment = .center
            individualDateStack.distribution = .fill
            individualDateStack.spacing = dayToDateMargin
            dateStack.addArrangedSubview(individualDateStack)
        }
        dateStack.alignment = .center
        dateStack.axis = .horizontal
        dateStack.spacing = dateToDateMargin
        dateStack.distribution = .fillEqually
        dateStack.snp.makeConstraints{ make in
            make.top.equalTo(self).offset(sideMargins)
            make.bottom.equalTo(self).offset(-sideMargins)
            make.right.equalTo(self).offset(-sideMargins)
            make.left.equalTo(self).offset(sideMargins)
        }
        setSelected(selectedView: dateStack.arrangedSubviews[0] as! UIStackView)
    }
    
    /**
        Set the given date as the selected one
    */
    func setSelected(selectedView: UIStackView){
        for subView in dateStack.arrangedSubviews {
            
            if let individualDateStackView = subView as? UIStackView {
                for presumedLabel in individualDateStackView.arrangedSubviews {
                    if let label = presumedLabel as? UILabel {
                        if selectedView != subView {
                            label.textColor = UIColor.black
                            label.font = UIFont.systemFont(ofSize: dateFontSize)
                        }
                        else {
                            label.textColor = UIColor(named: "MyEventsDatePickerSelected")
                            label.font = UIFont.boldSystemFont(ofSize: dateFontSize)
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
            let today = Date()
            return Calendar.current.date(byAdding: .day, value: index - 1, to: today)!
        }
        return nil
    }

}
