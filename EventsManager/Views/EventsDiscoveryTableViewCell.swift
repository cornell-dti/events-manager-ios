//
//  EventsDiscoveryTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Foundation

class EventsDiscoveryTableViewCell: UITableViewCell {
    static let identifer = "EventsDiscoveryCell"
    
    private var event:Event?
    
    private let startTime = UILabel()
    private let endTime = UILabel()
    private let eventName = UILabel()
    private let eventLocation = UILabel()
    private let eventParticipant = UILabel()
    private var avatars: [UIImageView] = []
    private var eventParticipantStack:UIStackView = UIStackView()
    
    
    
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //define label properties
        startTime.textColor = UIColor.gray
        endTime.textColor = UIColor.gray
        startTime.textAlignment = .center
        endTime.textAlignment = .center
        let timeFont = UIFont.systemFont(ofSize: 13)
        startTime.font = timeFont
        endTime.font = timeFont
        
        eventName.numberOfLines = 0
        eventName.font = UIFont.boldSystemFont(ofSize: 16)
        
        eventLocation.font = UIFont.systemFont(ofSize: 15)
        
        eventParticipant.font = UIFont.systemFont(ofSize: 13)
        eventParticipant.textColor = UIColor.gray
        
        startTime.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(80)
        }
        endTime.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(80)
        }
        
        let eventTimeStack:UIStackView = UIStackView(arrangedSubviews: [startTime, endTime])
        eventTimeStack.axis = .vertical
        eventTimeStack.distribution = .fill
        eventTimeStack.alignment = .center
        eventTimeStack.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(80)
        }
        
        let eventInfoStack:UIStackView = UIStackView(arrangedSubviews: [eventName, eventLocation])
        eventInfoStack.axis = .vertical
        eventTimeStack.distribution = .fill
        eventTimeStack.alignment = .leading
        
        eventParticipantStack.addArrangedSubview(eventParticipant)
        eventParticipantStack.axis = .horizontal
        eventParticipantStack.distribution = .fill
        eventParticipantStack.alignment = .center
        eventParticipantStack.spacing = 4.0
        
        let eventRightStack:UIStackView = UIStackView(arrangedSubviews: [eventInfoStack, eventParticipantStack])
        eventRightStack.axis = .vertical
        eventRightStack.distribution = .fill
        eventRightStack.alignment = .leading
        eventRightStack.spacing = 6
        
        let eventStack:UIStackView = UIStackView(arrangedSubviews: [eventTimeStack, eventRightStack])
        eventStack.axis = .horizontal
        eventStack.distribution = .fill
        eventStack.alignment = .center
        eventStack.spacing = 8.0
        
        
        contentView.addSubview(eventStack)
        
        eventStack.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
        }
    }
    
    func configure(event:Event){
        self.event = event
        updateUI()
    }
    
    func updateUI(){
        startTime.text = event?.startTime
        endTime.text = event?.endTime
        eventLocation.text = event?.eventLocation
        eventName.text = event?.eventName
        eventParticipant.text = event?.eventParticipant
        for imageView in avatars {
            imageView.removeFromSuperview()
        }
        avatars = []
        
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
            print(index)
            avatars[index].kf.setImage(with: event?.avatars[index])
        }
        
        for index in (0...avatars.count - 1).reversed() {
            eventParticipantStack.insertArrangedSubview(avatars[index], at: 0)
        }
        
    }

}
