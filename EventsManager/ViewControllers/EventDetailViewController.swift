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
    
    //Constants
    let buttonHeight = CGFloat(integerLiteral: 40)
    let buttonImageViewOffSet = CGFloat(integerLiteral: 20)
    let standardEdgeSpacing = CGFloat(integerLiteral: 20)
    let imageViewHeight = CGFloat(integerLiteral: 200)
    let infoStackEdgeSpacing = CGFloat(integerLiteral: 40)
    let iconSideLength = CGFloat(integerLiteral: 20)
    let infoStackIconLabelSpacing = CGFloat(integerLiteral: 15)
    let avatarSpacing = CGFloat(integerLiteral: 5)
    let infoTableSpacing = CGFloat(integerLiteral: 5)
    
    
    
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
        
        let buttonStackBackground = UIView()
        buttonStackBackground.backgroundColor = UIColor.darkSkyBlue
        buttonStackBackground.layer.cornerRadius = buttonHeight / 2
        buttonStackBackground.translatesAutoresizingMaskIntoConstraints = false
        //interested and going buttons
        interestedButton.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(buttonHeight)
        }
        goingButton.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(buttonHeight)
        }
        let buttonStack = UIStackView(arrangedSubviews: [interestedButton, goingButton])
        buttonStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.insertSubview(buttonStackBackground, at: 0)
        buttonStackBackground.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(buttonStack)
        }
        
        //table of info
        let calendarIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        calendarIcon.image = UIImage(named: "magnifyingGlass")
        let calendarStack = UIStackView(arrangedSubviews: [calendarIcon, eventTime])
        calendarStack.alignment = .center
        calendarStack.axis = .horizontal
        calendarStack.distribution = .fill
        calendarStack.spacing = infoStackIconLabelSpacing
        
        let participantIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        participantIcon.image = UIImage(named: "magnifyingGlass")
        let participantImageAndStringStack = UIStackView(arrangedSubviews: [eventParticipants])
        var avatars:[UIImageView] = []
        for _ in event?.avatars ?? []{
            if avatars.count < 3 {  //support maximum 3 avatars, if more than 3, only add first three to the array
                avatars.append(UIImageView(frame:CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength)))
            }
        }
        for index in 0..<avatars.count {
            avatars[index].snp.makeConstraints{ (make) -> Void in
                make.width.equalTo(iconSideLength)
                make.height.equalTo(iconSideLength)
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
        participantImageAndStringStack.spacing = avatarSpacing
        let participantStack = UIStackView(arrangedSubviews: [participantIcon, participantImageAndStringStack])
        participantStack.alignment = .center
        participantStack.axis = .horizontal
        participantStack.distribution = .fill
        participantStack.spacing = infoStackIconLabelSpacing
        
        let organizerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        organizerIcon.image = UIImage(named: "magnifyingGlass")
        let organizerStack = UIStackView(arrangedSubviews: [organizerIcon, eventOrganizer])
        organizerStack.alignment = .center
        organizerStack.axis = .horizontal
        organizerStack.distribution = .fill
        organizerStack.spacing = infoStackIconLabelSpacing
        
        
        let locationIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        locationIcon.image = UIImage(named: "magnifyingGlass")
        let locationStack = UIStackView(arrangedSubviews: [locationIcon, eventLocation])
        locationStack.alignment = .center
        locationStack.axis = .horizontal
        locationStack.distribution = .fill
        locationStack.spacing = infoStackIconLabelSpacing
        
        let infoTableStack = UIStackView(arrangedSubviews: [calendarStack, participantStack, organizerStack, locationStack])
        infoTableStack.alignment = .leading
        infoTableStack.axis = .vertical
        infoTableStack.distribution = .fill
        infoTableStack.spacing = infoTableSpacing
        
        
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
            make.height.equalTo(imageViewHeight)
        }
        
        buttonStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventImage.snp.bottom).offset(-buttonImageViewOffSet)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        
        eventDiscription.numberOfLines = 0
        eventDiscription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(buttonStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        
        infoTableStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventDiscription.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(infoStackEdgeSpacing)
            make.right.equalTo(contentView).offset(-infoStackEdgeSpacing)
            make.bottom.equalTo(contentView).offset(-standardEdgeSpacing)
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
