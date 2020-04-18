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
    let topMargins: CGFloat = 12
    let titleFontSize: CGFloat = 17
    let buttonFontSize: CGFloat = 14
    let subtitleFontSize: CGFloat = 10
    let subtitleSpacing: CGFloat = 90
    
    var scrollable = UIScrollView()
    var title = UILabel()
    var subtitle = UILabel()
    let editButton = UIButton()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    func setLayouts() {
        editButton.setTitleColor(UIColor.gray, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: buttonFontSize)
        
        title.font = UIFont(name: "SFProText-Bold", size: titleFontSize)
        title.textColor = UIColor(named: "primaryPink")
        title.textAlignment = .center
        
        subtitle.font = UIFont(name: "SFProText-Light", size: subtitleFontSize)
        subtitle.textColor = UIColor(named: "primaryPink")
        subtitle.textAlignment = .center


        scrollable.backgroundColor = .clear
        
        self.addSubview(scrollable)
        self.addSubview(editButton)
        scrollable.addSubview(title)
        scrollable.addSubview(subtitle)

        scrollable.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)

            make.height.equalTo(scrollable.contentSize.height)
            make.top.equalTo(self)
            make.bottom.equalTo(self).offset(bottomMargins)
        }
        
        title.snp.makeConstraints { make in
            make.left.equalTo(scrollable).offset(sideMargins)
            make.right.equalTo(scrollable)
            make.top.equalTo(scrollable).offset(topMargins)
            make.bottom.equalTo(scrollable)
        }
        
        subtitle.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-subtitleSpacing)
            make.top.equalTo(scrollable).offset(topMargins)
            make.bottom.equalTo(scrollable)
        }

        editButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-sideMargins)
            make.bottom.equalTo(self).offset(bottomMargins)
        }

    }

    func setMainTitle(_ title: String) {
        self.title.text = title
    }

    func setSubTitle(_ subtitle: String) {
        self.subtitle.text = subtitle
    }
    
    func setButtonTitle(_ title: String) {
        editButton.setTitle(title, for: .normal)
    }
}
