//
//  UnderlinedLabel.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 9/28/19.
//  Copyright © 2019 Jagger Brulato. All rights reserved.
//

import UIKit

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
