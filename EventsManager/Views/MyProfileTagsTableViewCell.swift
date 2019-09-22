//
//  MyProfileTagsTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/27/18.
//

import UIKit
import Firebase

class MyProfileTagsTableViewCell: UITableViewCell {

    static let identifier = "myProfileTagsTableViewCell"
    
    var navigationController: UINavigationController?

    //constants
    let sideMargins: CGFloat = 20
    let scrollViewHeight: CGFloat = 70
    let tagSpacing: CGFloat = 12

    //view elements
    let tagScrollView = UIScrollView()
    let tagStack = UIStackView()

    var tags: [String] = []

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    /** Sets the basic layout of the cell */
    func setLayouts() {
        self.addSubview(tagScrollView)
        tagScrollView.showsHorizontalScrollIndicator = false
        tagScrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.height.equalTo(scrollViewHeight)
        }
        tagStack.alignment = .center
        tagStack.distribution = .fill
        tagStack.axis = .horizontal
        tagStack.spacing = tagSpacing
        tagScrollView.addSubview(tagStack)
        tagStack.snp.makeConstraints { make in
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
    func configure(with tags: [Int], parentNavigationController: UINavigationController?) {
        self.navigationController = parentNavigationController
        for view in tagStack.arrangedSubviews {
            tagStack.removeArrangedSubview(view)
        }
        for tag in tags {
            let tagButton = EventTagButton()
            tagButton.setTag(with: tag)
            tagButton.addTarget(self, action: #selector(tagButtonPressed(_:)), for: .touchUpInside)
            tagStack.addArrangedSubview(tagButton)
        }
    }
    
    
    /**
     Handler for the pressing action of tag buttons. Should segue to the correct tagview controller.
     - sender: the sender of the action.
     */
    @objc func tagButtonPressed(_ sender: UIButton) {
        let tagViewController = TagViewController()
        if let tagButton = sender as? EventTagButton {
            let tag = tagButton.getTagPk()
            //Ganalytics
            //GoogleAnalytics.trackEvent(category: "button click", action: "tag", label: String(tag))
            Analytics.logEvent("tagButtonPressed", parameters: [
                "tagName": tagButton.titleLabel
                ])
            tagViewController.setup(with: AppData.getEventsAssociatedWith(tag: tag), for: tag)
            navigationController?.pushViewController(tagViewController, animated: true)
        }
    }

}
