//
//  EventTableViewFooterHeaderView.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/2/18.
//
//

import Foundation
import UIKit
import SnapKit

class EventTableHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = "eventTableHeader"

    let sideMargins: CGFloat = 15
    let bottomMargins: CGFloat = 5
    let titleFontSize: CGFloat = 17
    let titleViewSize: CGFloat = 20
    let buttonFontSize: CGFloat = 14
    
    var title = UITextView()
    let editButton = UIButton()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    func setLayouts() {
        editButton.setTitleColor(UIColor.gray, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: buttonFontSize)


        title.backgroundColor = UIColor.clear

        title.text = "test"

        title.font = UIFont(name: "SFProText-Bold", size: titleFontSize)
        title.textColor = UIColor(named: "primaryPink")
        title.textContainer.lineFragmentPadding = 0
        title.isEditable = false
        
        title.contentInset = .zero
        title.contentInsetAdjustmentBehavior = .never
        
        title.textContainerInset = .zero
        title.textContainer.lineFragmentPadding = 0
        title.sizeToFit()
        title.layoutManager.usesFontLeading = false
        
        //title.isScrollEnabled = false
        
        self.addSubview(title)
        self.addSubview(editButton)

        title.snp.makeConstraints { make in
            make.left.equalTo(self).offset(sideMargins)
            make.right.equalTo(self)
            make.height.equalTo(titleViewSize)
            make.bottom.equalTo(self)
        }

        editButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-sideMargins)
            make.bottom.equalTo(self).offset(bottomMargins)
        }

    }

    func setMainTitle(_ title: String) {
        self.title.text = title
    }

    func setButtonTitle(_ title: String) {
        editButton.setTitle(title, for: .normal)
    }
}
