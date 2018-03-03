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
    
    var event:Event?
    
    let startTime = UILabel()
    let endTime = UILabel()
    let eventName = UILabel()
    let eventLocation = UILabel()
    let eventParticipant = UILabel()
    var avatars: [UIImageView] = [UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)),UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))]
    
    
    
    
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
        
        for index in 0..<avatars.count {
            avatars[index].snp.makeConstraints{ (make) -> Void in
                make.width.equalTo(20.0)
                make.height.equalTo(20.0)
            }
            avatars[index].layer.cornerRadius = avatars[index].frame.height/2
            avatars[index].clipsToBounds = true
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
        
        
        let eventParticipantStack:UIStackView = UIStackView(arrangedSubviews: avatars)
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
        for index in 0..<avatars.count {
            if index < (event?.avatars.count) ?? 0 {
                avatars[index].kf.setImage(with: event?.avatars[index])
            }
        }
    }

}
