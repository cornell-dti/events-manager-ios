//
//  EventTagButton.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/5/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit
import SnapKit

class EventTagButton: UIButton {
    //Constants
    let tagHeight = CGFloat(integerLiteral: 40)
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle("    \(title ?? "")    ", for: state)
    }
    
    /**
     * Modifiy the button's styles
     */
    func layoutUI() {
        self.layer.cornerRadius = tagHeight / 2
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(UIColor.black, for: .normal)
        self.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(tagHeight)
        }
    }

}
