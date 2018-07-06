//
//  EventsDiscoveryTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//
//

import UIKit
import SnapKit
import Foundation

class EventCardCell: UITableViewCell {
    static let identifer = "EventsCardCell"
    
    private var events = [Event]()
    
    //Constants
    private let scrollViewHeight:CGFloat = 320 //Should be cardHeight + 2 * cardMargins
    private let eventCardMargins:CGFloat = 10
    private let cardLimit = 10
    
    private var eventsScrollView = UIScrollView()
    private var eventsCardStack = UIStackView()
    
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }
    
    /**
     * Sets the basic view layout of this cell
     */
    func setLayouts(){
        self.backgroundColor = UIColor(named: "tableViewBackground")
        
        eventsCardStack.distribution = .fill
        eventsCardStack.alignment = .center
        eventsCardStack.axis = .horizontal
        eventsCardStack.spacing = eventCardMargins
        
        self.addSubview(eventsScrollView)
        eventsScrollView.addSubview(eventsCardStack)
        
        eventsCardStack.snp.makeConstraints { make in
            make.top.equalTo(eventsScrollView).offset(eventCardMargins)
            make.left.equalTo(eventsScrollView).offset(eventCardMargins)
            make.right.equalTo(eventsScrollView).offset(-eventCardMargins)
            make.bottom.equalTo(eventsScrollView).offset(-eventCardMargins)
        }
        
        eventsScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.height.equalTo(scrollViewHeight)
        }
    }
    
    /**
     * Populate this eventCardCell with an array of events
     * - events: an array of events to populate this cell with
     */
    func configure(with events: [Event]){
        //Clear ealier cards to prevent error happen during reuse of cells
        for card in eventsCardStack.arrangedSubviews {
            card.removeFromSuperview()
        }
        self.events = events
        var count = 0
        for event in events {
            if count >= 10 {
                break
            }
            let card = EventCard()
            card.configure(with: event)
            let cardPressedGesture = UITapGestureRecognizer(target: self, action: #selector(onCardPressed(_:)))
            card.addGestureRecognizer(cardPressedGesture)
            eventsCardStack.addArrangedSubview(card)
            count = count + 1
        }
    }
    
    /**
     * Action Handler for the pressing of a event card. Should segue to a proper event details page
     * - sender: the eventcard that is pressed.
     */
    @objc func onCardPressed(_ sender:UITapGestureRecognizer){
        if let senderCard = sender.view as? EventCard {
            if let event = senderCard.event {
                let detailsViewController = EventDetailViewController()
                detailsViewController.configure(with: event)
                if let tabBarViewController = self.window?.rootViewController as? TabBarViewController {
                    tabBarViewController.discoverNavVC.pushViewController(detailsViewController, animated: true)
                }
            }
        }
    }
    
}
