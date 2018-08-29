//
//  MyProfileTagsTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/27/18.
//

import UIKit

class MyProfileTagsTableViewCell: UITableViewCell {
    
    static let identifier = "myProfileTagsTableViewCell"
    
    //constants
    let sideMargins:CGFloat = 20
    let scrollViewHeight:CGFloat = 70
    let tagSpacing:CGFloat = 12
    
    //view elements
    let tagScrollView = UIScrollView()
    let tagStack = UIStackView()
    
    var tags:[String] = []

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }
    
    /** Sets the basic layout of the cell */
    func setLayouts() {
        self.addSubview(tagScrollView)
        tagScrollView.showsHorizontalScrollIndicator = false
        tagScrollView.snp.makeConstraints{ make in
            make.edges.equalTo(self)
            make.height.equalTo(scrollViewHeight)
        }
        tagStack.alignment = .center
        tagStack.distribution = .fill
        tagStack.axis = .horizontal
        tagStack.spacing = tagSpacing
        tagScrollView.addSubview(tagStack)
        tagStack.snp.makeConstraints{ make in
            make.top.equalTo(tagScrollView).offset(sideMargins)
            make.left.equalTo(tagScrollView).offset(sideMargins)
            make.right.equalTo(tagScrollView).offset(-sideMargins)
            make.bottom.equalTo(tagScrollView).offset(-sideMargins)

        }
    }
    
    /**
     Populate this cell with tags
     - tags: the tags used to populate this cell
     */
    func configure(with tags: [String]) {
        for view in tagStack.arrangedSubviews {
            tagStack.removeArrangedSubview(view)
        }
        for tag in tags {
            let tagButton = EventTagButton()
            tagButton.setTitle(tag, for: .normal)
            tagStack.addArrangedSubview(tagButton)
        }
    }

}
