//
//  SearchEmtpyStateView.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/9/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit

class SearchEmtpyStateView: UIView {

    //constants
    let searchIconSideLength: CGFloat = 40
    let searchLabelFontSize: CGFloat = 18
    let stackSpacing: CGFloat = 10

    let searchIconView = UIImageView(image: #imageLiteral(resourceName: "magnifyingGlass"))
    let infoLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
    }

    /** Set the info label of the empty state*/
    func setInfoLabel(with text: String) {
        infoLabel.text = text
    }

    /** Sets the basic layout of the cell */
    func setLayouts() {
        searchIconView.snp.makeConstraints { make in
            make.width.equalTo(searchIconSideLength)
            make.height.equalTo(searchIconSideLength)
        }
        searchIconView.contentMode = .scaleToFill
        searchIconView.clipsToBounds = true
        searchIconView.tintColor = UIColor.gray
        infoLabel.font = UIFont.boldSystemFont(ofSize: searchLabelFontSize)
        infoLabel.textColor = UIColor.gray
        let stackView = UIStackView(arrangedSubviews: [searchIconView, infoLabel])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = stackSpacing
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
