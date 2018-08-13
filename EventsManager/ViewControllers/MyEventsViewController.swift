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
    
    var myEvents:[Event] = []
    
    //Constants
    let datePickerHeight:CGFloat = 100
    
    let datePicker = MyEventsDatePickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    /* Sets all the layout elements in the view */
    func setLayouts(){
        //For testing
        var date1 = "2018-08-12 16:39:57"
        var date2 = "2018-08-12 18:39:57"
        for _ in 1...20 {
            var date1Date = DateFormatHelper.datetime(from: date1)!
            date1Date = Calendar.current.date(byAdding: .day, value: 1, to: date1Date)!
            date1 = DateFormatHelper.datetime(from: date1Date)
            var date2Date = DateFormatHelper.datetime(from: date2)!
            date2Date = Calendar.current.date(byAdding: .day, value: 1, to: date2Date)!
            date2 = DateFormatHelper.datetime(from: date2Date)
            myEvents.append(Event(id:1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting Meeting Meeting Meeting!", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/arnavg.jpg")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags:["#lololo","#heheh","#oooof"], eventParticipantCount: 166))
        }
        datePicker.configure(with: myEvents)
        
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
