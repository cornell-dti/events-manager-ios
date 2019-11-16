//
//  Extentions.swift
//  EventsManager
//
//  Created by Ethan Hu on 11/2/19.
//

import Foundation
import UIKit

extension UIStackView {

    func safelyRemoveArrangedSubviews() {

        // Remove all the arranged subviews and save them to an array
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }

        // Deactive all constraints at once
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

/**
 Names for custom notifications. Classes interested in receiving notifications for a particular event should subscribe to the event's corresponding notification. Another class generates notifications for the particular event.
 */
extension Notification.Name {
    static let reloadData = Notification.Name("reloadData")
    static let updatedLocation = Notification.Name("updatedLocation")
    static let updatedOrg = Notification.Name("updatedOrg")
    static let updatedTag = Notification.Name("updatedTag")
    static let updatedEvent = Notification.Name("updatedEvent")
}

extension UILabel {

    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font]

        let labelSize = myText.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return Int(CGFloat(labelSize.height) / self.font.lineHeight)
    }

    func isTruncated() -> Bool {

        if self.countLabelLines() > self.numberOfLines {
            return true
        }
        return false
    }
}
