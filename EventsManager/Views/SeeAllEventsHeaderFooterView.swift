//
//  SeeAllEventsHeaderFooterView.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/2/18.
//
//

import Foundation
import UIKit
import SnapKit

class SeeAllEventsHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = "seeAllEventsHeader"
    
    let sideMargins:CGFloat = 15
    let bottomMargins:CGFloat = 5
    let buttonFontSize:CGFloat = 16
    
    let editButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
    }
    
    func setLayouts(){
        editButton.setTitleColor(self.tintColor, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        
        self.addSubview(editButton)
        
        
        editButton.snp.makeConstraints{ make in
            make.right.equalTo(self).offset(-sideMargins)
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
        }
        
    }
    
    func setButtonTitle(_ title:String) {
        editButton.setTitle(title, for: .normal)
    }
}

