//
//  EventsDiscoveryTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//
//

import UIKit
import SnapKit
import Kingfisher
import Foundation

class EventsDiscoveryTableViewCell: UITableViewCell {
    static let identifer = "EventsDiscoveryCell"

    private var event:Event?

    private let sideSpacing:CGFloat = 15
    private let eventInfoFontSize:CGFloat = 13
    private let eventNameFontSize:CGFloat = 15
    private let lineSpacingLeftStack:CGFloat = 12
    private let lineSpacingRightStack:CGFloat = 9
    private let iconSideLength:CGFloat = 18
    private let separatorHeight:CGFloat = 15
    private let leftToRightStackSpacing:CGFloat = 8
    private let eventParticipantCountAndLocationStackInnerSpacing:CGFloat = 6

    private let startTime = UILabel()
    private let endTime = UILabel()
    private let eventName = UILabel()
    private let eventLocation = UILabel()
    private let eventParticipantCount = UILabel()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //define label properties
        startTime.textColor = UIColor.gray
        endTime.textColor = UIColor.gray
        startTime.textAlignment = .center
        endTime.textAlignment = .center
        startTime.font = UIFont.systemFont(ofSize: eventInfoFontSize)
        endTime.font = UIFont.systemFont(ofSize: eventInfoFontSize)

        eventName.numberOfLines = 0
        eventName.font = UIFont.boldSystemFont(ofSize: eventNameFontSize)

        eventLocation.font = UIFont.systemFont(ofSize: eventInfoFontSize)
        eventLocation.textColor = UIColor.gray

        eventParticipantCount.font = UIFont.systemFont(ofSize: eventInfoFontSize)
        eventParticipantCount.textColor = UIColor.gray

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
        eventTimeStack.spacing = lineSpacingLeftStack
        eventTimeStack.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(80)
        }

        let eventParticipantCountAndLocationStack = UIStackView()
        eventParticipantCountAndLocationStack.alignment = .center
        eventParticipantCountAndLocationStack.distribution = .fill
        eventParticipantCountAndLocationStack.axis = .horizontal
        eventParticipantCountAndLocationStack.spacing = eventParticipantCountAndLocationStackInnerSpacing
        let eventParticipantIcon = UIImageView(image: #imageLiteral(resourceName: "person"))
        eventParticipantIcon.snp.makeConstraints { make in
            make.width.equalTo(iconSideLength)
            make.height.equalTo(iconSideLength)
        }
        eventParticipantCountAndLocationStack.addArrangedSubview(eventParticipantIcon)
        eventParticipantCountAndLocationStack.addArrangedSubview(eventParticipantCount)
        let eventParticipantSeparator = UIView()
        eventParticipantSeparator.backgroundColor = UIColor.gray
        eventParticipantCountAndLocationStack.addArrangedSubview(eventParticipantSeparator)
        eventParticipantSeparator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(separatorHeight)
        }
        eventParticipantCountAndLocationStack.addArrangedSubview(eventLocation)

        let eventInfoStack:UIStackView = UIStackView(arrangedSubviews: [eventName, eventParticipantCountAndLocationStack])
        eventInfoStack.axis = .vertical
        eventInfoStack.distribution = .fill
        eventInfoStack.alignment = .leading
        eventInfoStack.spacing = lineSpacingRightStack

        let eventStack:UIStackView = UIStackView(arrangedSubviews: [eventTimeStack, eventInfoStack])
        eventStack.axis = .horizontal
        eventStack.distribution = .fill
        eventStack.alignment = .center
        eventStack.spacing = leftToRightStackSpacing

        contentView.addSubview(eventStack)

        eventStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(sideSpacing)
            make.left.equalTo(contentView).offset(sideSpacing)
            make.right.equalTo(contentView).offset(-sideSpacing)
            make.bottom.equalTo(contentView).offset(-sideSpacing)
        }
    }

    func configure(event:Event) {
        self.event = event
        updateUI()
    }

    func updateUI() {
        startTime.text = DateFormatHelper.hourMinute(from: event?.startTime ?? Date())
        endTime.text = DateFormatHelper.hourMinute(from: event?.endTime ?? Date())
        eventLocation.text = event?.eventLocation
        eventName.text = event?.eventName
        eventParticipantCount.text = String(event?.eventParticipantCount ?? 0)
    }

}
