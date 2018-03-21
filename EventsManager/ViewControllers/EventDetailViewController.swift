//
//  EventDetailViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/20/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit
import Kingfisher

class EventDetailViewController: UIViewController {
    
    
    var event:Event?
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var eventImage:UIImageView = UIImageView()
    var interestedButton:UIButton = UIButton()
    var goingButton:UIButton = UIButton()
    var eventDiscription:UILabel = UILabel()
    var eventTime = UILabel()
    var eventParticipants = UILabel()
    var eventOrganizer = UILabel()
    var eventLocation = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    /* Sets all the layout elements in the details view */
    func setLayouts(){
        navigationItem.title = event?.eventName ?? ""
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.white
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view.frame.width)
        }
        
        //interested and going buttons
        interestedButton.backgroundColor = UIColor.darkSkyBlue
        goingButton.backgroundColor = UIColor.darkSkyBlue
        let buttonStack = UIStackView(arrangedSubviews: [interestedButton, goingButton])
        buttonStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        //table of info
        let calendarIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        calendarIcon.image = UIImage(named: "magnifyingGlass")
        let calendarStack = UIStackView(arrangedSubviews: [calendarIcon, eventTime])
        calendarStack.alignment = .center
        calendarStack.axis = .horizontal
        calendarStack.distribution = .fill
        calendarStack.spacing = 15
        
        let participantIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        participantIcon.image = UIImage(named: "magnifyingGlass")
        let participantImageAndStringStack = UIStackView(arrangedSubviews: [eventParticipants])
        var avatars:[UIImageView] = []
        for _ in event?.avatars ?? []{
            if avatars.count < 3 {  //support maximum 3 avatars, if more than 3, only add first three to the array
                avatars.append(UIImageView(frame:CGRect(x: 0, y: 0, width: 20, height: 20)))
            }
        }
        for index in 0..<avatars.count {
            avatars[index].snp.makeConstraints{ (make) -> Void in
                make.width.equalTo(20.0)
                make.height.equalTo(20.0)
            }
            avatars[index].layer.cornerRadius = avatars[index].frame.height/2
            avatars[index].clipsToBounds = true
            avatars[index].kf.setImage(with: event?.avatars[index])
        }
        for index in (0...avatars.count - 1).reversed() {
            participantImageAndStringStack.insertArrangedSubview(avatars[index], at: 0)
        }
        participantImageAndStringStack.axis = .horizontal
        participantImageAndStringStack.distribution = .fill
        participantImageAndStringStack.alignment = .center
        participantImageAndStringStack.spacing = 5.0
        let participantStack = UIStackView(arrangedSubviews: [participantIcon, participantImageAndStringStack])
        participantStack.alignment = .center
        participantStack.axis = .horizontal
        participantStack.distribution = .fill
        participantStack.spacing = 15
        
        let organizerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        organizerIcon.image = UIImage(named: "magnifyingGlass")
        let organizerStack = UIStackView(arrangedSubviews: [organizerIcon, eventOrganizer])
        organizerStack.alignment = .center
        organizerStack.axis = .horizontal
        organizerStack.distribution = .fill
        organizerStack.spacing = 15
        
        
        let locationIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        locationIcon.image = UIImage(named: "magnifyingGlass")
        let locationStack = UIStackView(arrangedSubviews: [locationIcon, eventLocation])
        locationStack.alignment = .center
        locationStack.axis = .horizontal
        locationStack.distribution = .fill
        locationStack.spacing = 15
        
        let infoTableStack = UIStackView(arrangedSubviews: [calendarStack, participantStack, organizerStack, locationStack])
        infoTableStack.alignment = .leading
        infoTableStack.axis = .vertical
        infoTableStack.distribution = .fill
        infoTableStack.spacing = 5
        
        
        //Add three dividers between the elements of infoTableStack
        for index in stride(from: 1, through: 5, by: 2){
            let divider = UIView()
            divider.backgroundColor = UIColor.lightGray
            infoTableStack.insertArrangedSubview(divider, at: index)
            divider.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(infoTableStack)
                make.right.equalTo(infoTableStack)
                make.height.equalTo(1)
            }
        }
        
        
        contentView.addSubview(eventImage)
        contentView.addSubview(buttonStack)
        contentView.addSubview(eventDiscription)
        contentView.addSubview(infoTableStack)
        
        
        //Constraints for UI elements
        eventImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(200)
        }
        
        buttonStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventImage.snp.bottom)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        eventDiscription.numberOfLines = 0
        eventDiscription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(buttonStack.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
        
        infoTableStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventDiscription.snp.bottom).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
}
    
    /* Allow client to configure the event detail page by passing in an event object*/
    func configure(with event:Event){
        self.event = event
        
        eventImage.kf.setImage(with: event.eventImage)
        interestedButton.setTitle("INTERESTED", for: .normal)
        goingButton.setTitle("GOING", for: .normal)
        
        eventDiscription.text = event.eventDiscription
        eventTime.text = "From \(event.startTime) to \(event.endTime)"
        eventOrganizer.text = event.eventOrganizer
        eventLocation.text = event.eventLocation
        eventParticipants.text = event.eventParticipant
        
    }

}
