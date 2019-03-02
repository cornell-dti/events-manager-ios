//
//  PinkClickableButton.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 3/2/19.
//  Copyright © 2019 Jagger Brulato. All rights reserved.
//

import UIKit
import SnapKit

class PinkClickableButton: UIButton {
    //Constants
    let headerButtonFontSize: CGFloat = 16
    let shadowOpacity: Float = 0.6
    let shadowRadius: CGFloat = 5
    let shadowOffset = CGSize(width: 1.5, height: 1.5)
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    /**
     * Modifiy the button's styles
     */
    func layoutUI() {
        self.backgroundColor = UIColor.white
        self.tintColor = UIColor(named: "primaryPink")
        self.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowColor = UIColor.gray.cgColor
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: headerButtonFontSize)
    }
    
    func changeColor() {
        if self.backgroundColor == UIColor.white {
            self.backgroundColor = UIColor(named: "primaryPink")
            self.setTitleColor(UIColor.white, for: .normal)
            self.tintColor = UIColor.white
        }
        else {
            self.backgroundColor = UIColor.white
            self.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
            self.tintColor = UIColor(named: "primaryPink")
        }
    }
}
