//
//  MyEventsViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit
import SnapKit

class MyEventsViewController: UIViewController {
    
    
    let datePicker = MyEventsDatePickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    /* Sets all the layout elements in the view */
    func setLayouts(){
        view.backgroundColor = UIColor.white
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(view)
            make.left.equalTo(view)
        }
        
        for date in datePicker.dateStack.arrangedSubviews {
            let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDatePressed(_:)))
            date.addGestureRecognizer(dateTapGesture)
            date.isUserInteractionEnabled = true
        }
    }
    
    /**
     Event Handler for pressing dates on the date picker. Should highlight the selected date and filter the events in myevents.
    */
    @objc func onDatePressed(_ sender:UITapGestureRecognizer){
        if let individualDateStack = sender.view as? UIStackView {
            datePicker.setSelected(selectedView: individualDateStack)
        }
    }

   
}
