//
//  MyProfileHeaderFooterView.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/27/18.
//

import Foundation
import UIKit
import SnapKit

class MyProfileHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = "myProfileHeader"

    let sideMargins: CGFloat = 15
    let bottomMargins: CGFloat = 10
    let buttonBottomMargins: CGFloat = 3
    let titleFontSize: CGFloat = 17

    var title = UILabel()
    let editButton = UIButton()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    func setLayouts() {
        editButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        editButton.titleLabel?.font = UIFont(name: "Dosis-Bold", size: titleFontSize)

        title.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        title.textColor = UIColor.black

        let separator = UIView()
        separator.backgroundColor = UIColor.gray

        self.addSubview(title)
        self.addSubview(editButton)
        self.addSubview(separator)

        separator.snp.makeConstraints { make in
            make.height.equalTo(0.8)
            make.left.equalTo(sideMargins)
            make.right.equalTo(-sideMargins)
            make.bottom.equalTo(self)
        }

        title.snp.makeConstraints { make in
            make.left.equalTo(self).offset(sideMargins)
            make.bottom.equalTo(separator).offset(-bottomMargins)
        }

        editButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-sideMargins)
            make.bottom.equalTo(separator).offset(-buttonBottomMargins)
        }

    }

    func setMainTitle(_ title: String) {
        self.title.text = title
    }

    func setButtonTitle(_ title: String) {
        editButton.setTitle(title, for: .normal)
    }
}
