//
//  EventCard.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/23/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit
import SnapKit

//The view class for the event card in details page.
class EventCard: UIView {
    
    var event:Event?
    
    //View Elements
    var eventPicture = UIImageView()
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    var eventNameLabel = UILabel()
    var eventTimeLocationLabel = UILabel()
    var eventParticipantCountLabel = UILabel()
    
    //Constants
    let cardWidth:CGFloat = 300
    let cardHeight:CGFloat = 250
    let eventPicHeight:CGFloat = 150
    let eventDateFontSize:CGFloat = 22
    let eventInfoFontSize:CGFloat = 14
    let eventinfoSpacing:CGFloat = 4
    let eventDateSpacing:CGFloat = 8
    let bottomStackPaddingSpacing:CGFloat = 15
    let eventBottomStackHeight:CGFloat = 100
    let shadowOpacity:Float = 0.3
    let shadowRadius:CGFloat = 2
    let shadowOffset = CGSize(width: 1, height: 1)

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    /**
     * Populate the event card with an event object
     * - event: The event object that this card should populate with
     */
    func configure(with event:Event) {
        self.event = event
        monthLabel.text = DateFormatHelper.month(from: event.startTime)
        dayLabel.text = DateFormatHelper.day(from: event.startTime)
        eventNameLabel.text = event.eventName
        eventTimeLocationLabel.text = "\(DateFormatHelper.hourMinute(from: event.startTime)) - \(DateFormatHelper.hourMinute(from: event.endTime)) | \(event.eventLocation)"
        eventParticipantCountLabel.text = "\(event.eventParticipantCount) Going"
        eventPicture.kf.setImage(with: event.eventImage)
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
        
        
        self.snp.makeConstraints { make in
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardHeight)
        }
        eventPicture.snp.makeConstraints { make in
            make.width.equalTo(cardWidth)
            make.height.equalTo(eventPicHeight)
        }
        
        let eventInfoStack = UIStackView(arrangedSubviews: [eventNameLabel, eventTimeLocationLabel, eventParticipantCountLabel])
        eventInfoStack.alignment = .leading
        eventInfoStack.distribution = .fill
        eventInfoStack.axis = .vertical
        eventInfoStack.spacing = eventinfoSpacing
        
        for eventInfoLabelView in eventInfoStack.arrangedSubviews {
            if let eventInfoLabel = eventInfoLabelView as? UILabel {
                eventInfoLabel.font = UIFont.systemFont(ofSize: eventInfoFontSize)
            }
        }
        
        monthLabel.font = UIFont.boldSystemFont(ofSize: eventDateFontSize)
        dayLabel.font = UIFont.boldSystemFont(ofSize: eventDateFontSize)
        let eventDateStack = UIStackView(arrangedSubviews: [monthLabel, dayLabel])
        eventDateStack.alignment = .center
        eventDateStack.distribution = .fill
        eventDateStack.axis = .vertical
        eventDateStack.spacing = eventDateSpacing
        
        //the first element is a place holder to create a spacing to the left.
        let bottomStack = UIStackView(arrangedSubviews: [UIView(), eventDateStack, eventInfoStack])
        bottomStack.alignment = .center
        bottomStack.distribution = .fill
        bottomStack.axis = .horizontal
        bottomStack.spacing = bottomStackPaddingSpacing
        
        let cardStack = UIStackView(arrangedSubviews: [eventPicture, bottomStack])
        cardStack.alignment = .leading
        cardStack.distribution = .fill
        cardStack.axis = .vertical
        
        self.addSubview(cardStack)
        cardStack.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
