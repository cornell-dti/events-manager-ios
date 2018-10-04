//
//  PersonalProfileFollowingTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/27/18.
//

import UIKit
import SnapKit
import Kingfisher

class OrganizationTableViewCell: UITableViewCell {

    static let identifier = "organizationTableViewCell"

    //constants
    let avatarSideLength: CGFloat = 60
    let orgNameFontSize: CGFloat = 18
    let topBottomSideMargins: CGFloat = 10
    let leftRightSideMargins: CGFloat = 20

    //view elements
    let orgAvatar = UIImageView()
    let orgName = UILabel()

    //data source
    var org: Organization?

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    /**
     * Sets the basic view layout of this cell
     */
    func setLayouts() {
        self.addSubview(orgAvatar)
        self.addSubview(orgName)
        orgAvatar.layer.cornerRadius = avatarSideLength / 2
        orgAvatar.clipsToBounds = true
        orgAvatar.snp.makeConstraints { make in
            make.left.equalTo(self).offset(leftRightSideMargins)
            make.top.equalTo(self).offset(topBottomSideMargins)
            make.bottom.equalTo(self).offset(-topBottomSideMargins)
            make.width.equalTo(avatarSideLength)
            make.height.equalTo(avatarSideLength)
        }
        orgName.font = UIFont.systemFont(ofSize: orgNameFontSize)
        orgName.snp.makeConstraints { make in
            make.left.equalTo(orgAvatar.snp.right).offset(leftRightSideMargins)
            make.right.equalTo(self).offset(-leftRightSideMargins)
            make.centerY.equalTo(self)
        }
    }

    /**
     Configures the cell
     - org: the organization the cell should be configured with
     */
    func configure(with org: Organization) {
        self.org = org
        orgAvatar.kf.setImage(with: org.avatar)
        orgName.text = org.name
    }

}
