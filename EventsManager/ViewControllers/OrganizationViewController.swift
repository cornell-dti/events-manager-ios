//
//  OrganizationViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 6/19/18.
//
//

import UIKit
import SnapKit

class OrganizationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventCardCellDelegate {

    var organization: Organization?
    var popularEvents = [Event]()
    var tags = [Int]()

    //View Elements

    let scrollView = UIScrollView()
    let contentView = UIView()

    let orgHeaderView = UIView()
    let orgAvatar: UIImageView = UIImageView()
    let orgNameLabel: UILabel = UILabel()
    let orgSettingsButton: UIButton = UIButton()
    let memberButton: UIButton = UIButton()
    let followButton: UIButton = UIButton()

    let orgInfoView = UIView()
    let infoViewEditButton = UIButton()
    let aboutLabel = UILabel()
    let websiteLabel = UILabel()
    let websiteContentLabel = UILabel()
    let emailLabel = UILabel()
    let emailContentLabel = UILabel()
    let bioLabel = UILabel()
    let bioContentLabel = UILabel()

    let popularEventsTableView = UITableView(frame: CGRect(), style: .grouped)

    let tagScrollView = UIScrollView()
    let tagStack = UIStackView()

    //Constants
    let sectionViewPadding: CGFloat = 15
    let orgNameFontSize: CGFloat = 22
    let orgNameToSettingSpacing: CGFloat = 20
    let orgNamePreferredWidth: CGFloat = 250
    let memberToFollowButtonSpacing: CGFloat = 20
    let buttonBorderRadius: CGFloat = 5
    let utilButtonSideLength: CGFloat = 25
    let orgAvatarSideLength: CGFloat = 70
    let rightStackInternalSpacing: CGFloat = 10
    let orgAvatarToRightStackSpacing: CGFloat = 20
    let headerButtonFontSize: CGFloat = 16
    let sectionHeaderFontSize: CGFloat = 20
    let contentFontSize: CGFloat = 16
    let infoViewInnerStackSpacing: CGFloat = 8
    let orgDescriptionPreferredWidth: CGFloat = 300
    let headerHeight: CGFloat = 40
    let popularEventsTableViewHeight: CGFloat = 35 + 320 + 20//HeaderHeight + CardHeight + CardMargins
    let tagLabelFontSize: CGFloat = 22
    let tagScrollViewHeight: CGFloat = 50
    let tagHorizontalSpacing: CGFloat = 8

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }
    
    

    /**
     Allow client to configure the event detail page by passing in an organization object
     */
    public func configure(organization: Organization) {
        memberButton.setTitle(NSLocalizedString("is-member-button", comment: ""), for: .normal)
        followButton.setTitle(NSLocalizedString("follow-button", comment: ""), for: .normal)
        aboutLabel.text = NSLocalizedString("about", comment: "")
        websiteLabel.text = NSLocalizedString("website", comment: "")
        emailLabel.text = NSLocalizedString("email", comment: "")
        bioLabel.text = NSLocalizedString("bio", comment: "")

        orgNameLabel.text = organization.name
        orgAvatar.kf.setImage(with: organization.avatar)
        websiteContentLabel.text = organization.website
        emailContentLabel.text = organization.email
        bioContentLabel.text = organization.description

        //FOR TESTING
        let date1 = "2018-06-20 16:39:57"
        let date2 = "2018-06-20 18:39:57"
        for _ in 1...20 {
            popularEvents.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 166))
        }

        getTags()
        for tag in tags {
            let tagButton = EventTagButton()
            tagButton.setTag(with: tag)
            tagButton.addTarget(self, action: #selector(self.tagButtonPressed(_:)), for: .touchUpInside)
            tagStack.addArrangedSubview(tagButton)
        }
    }
    

    /** Sets all the layout elements in the view */
    public func setLayouts() {

        view.backgroundColor = UIColor(named: "tableViewBackground")
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view.frame.width)
        }

        //headerView
        contentView.addSubview(orgHeaderView)
        orgHeaderView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }

        orgHeaderView.addSubview(orgSettingsButton)
        orgSettingsButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        orgSettingsButton.snp.makeConstraints {make in
            make.height.equalTo(utilButtonSideLength)
            make.width.equalTo(utilButtonSideLength)
            make.top.equalTo(orgHeaderView).offset(sectionViewPadding)
            make.right.equalTo(orgHeaderView).offset(-sectionViewPadding)
        }

        let orgSettingsButtonPlaceHolderView = UIView() //To prevent the label from blocking the button
        orgSettingsButtonPlaceHolderView.snp.makeConstraints {make in
            make.height.equalTo(utilButtonSideLength)
            make.width.equalTo(utilButtonSideLength)
        }
        let rightUpperStack = UIStackView(arrangedSubviews: [orgNameLabel, orgSettingsButtonPlaceHolderView])
        rightUpperStack.axis = .horizontal
        rightUpperStack.alignment = .center
        rightUpperStack.distribution = .fill
        rightUpperStack.spacing = orgNameToSettingSpacing

        orgNameLabel.font = UIFont.boldSystemFont(ofSize: orgNameFontSize)
        orgNameLabel.numberOfLines = 0
        orgNameLabel.preferredMaxLayoutWidth = orgNamePreferredWidth

        let rightLowerStack = UIStackView(arrangedSubviews: [memberButton, followButton])
        rightLowerStack.axis = .horizontal
        rightLowerStack.alignment = .center
        rightLowerStack.distribution = .fill
        rightLowerStack.spacing = memberToFollowButtonSpacing

        memberButton.setTitleColor(UIColor.black, for: .normal)
        memberButton.layer.borderWidth = 1
        memberButton.layer.borderColor = UIColor.black.cgColor
        memberButton.layer.cornerRadius = buttonBorderRadius
        memberButton.titleLabel?.font = UIFont.systemFont(ofSize: headerButtonFontSize)

        followButton.setTitleColor(UIColor.black, for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.layer.cornerRadius = buttonBorderRadius
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: headerButtonFontSize)

        orgAvatar.snp.makeConstraints { make in
            make.width.equalTo(orgAvatarSideLength)
            make.height.equalTo(orgAvatarSideLength)
        }
        orgAvatar.layer.cornerRadius = orgAvatarSideLength/2
        orgAvatar.clipsToBounds = true

        let rightStack = UIStackView(arrangedSubviews: [rightUpperStack, rightLowerStack])
        rightStack.axis = .vertical
        rightStack.alignment = .leading
        rightStack.distribution = .fill
        rightStack.spacing = rightStackInternalSpacing

        let headerStack = UIStackView(arrangedSubviews: [orgAvatar, rightStack])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .fill
        headerStack.spacing = orgAvatarToRightStackSpacing

        orgHeaderView.addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.left.equalTo(orgHeaderView).offset(sectionViewPadding)
            make.right.equalTo(orgHeaderView).offset(-sectionViewPadding)
            make.top.equalTo(orgHeaderView).offset(sectionViewPadding)
            make.bottom.equalTo(orgHeaderView).offset(-sectionViewPadding)
        }

        //Line seperator
        let headerInfoSeparator = UIView()
        contentView.addSubview(headerInfoSeparator)
        headerInfoSeparator.backgroundColor = UIColor.gray
        headerInfoSeparator.snp.makeConstraints {make in
            make.height.equalTo(1)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(orgHeaderView.snp.bottom)
        }

        //InfoView
        contentView.addSubview(orgInfoView)
        orgInfoView.snp.makeConstraints { make in
            make.top.equalTo(headerInfoSeparator.snp.bottom)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }

        orgInfoView.addSubview(infoViewEditButton)
        infoViewEditButton.setImage(#imageLiteral(resourceName: "create"), for: .normal)
        infoViewEditButton.snp.makeConstraints {make in
            make.top.equalTo(orgInfoView).offset(sectionViewPadding)
            make.right.equalTo(orgInfoView).offset(-sectionViewPadding)
            make.width.equalTo(utilButtonSideLength)
            make.height.equalTo(utilButtonSideLength)
        }

        aboutLabel.font = UIFont.boldSystemFont(ofSize: sectionHeaderFontSize)

        let websiteStack = UIStackView(arrangedSubviews: [websiteLabel, websiteContentLabel])
        websiteStack.axis = .horizontal
        websiteStack.distribution = .fill
        websiteStack.alignment = .center
        websiteStack.spacing = 0
        websiteLabel.font = UIFont.boldSystemFont(ofSize: contentFontSize)
        websiteContentLabel.font = UIFont.systemFont(ofSize: contentFontSize)

        let emailStack = UIStackView(arrangedSubviews: [emailLabel, emailContentLabel])
        emailStack.axis = .horizontal
        emailStack.distribution = .fill
        emailStack.alignment = .center
        emailStack.spacing = 0
        emailLabel.font = UIFont.boldSystemFont(ofSize: contentFontSize)
        emailContentLabel.font = UIFont.systemFont(ofSize: contentFontSize)

        let bioStack = UIStackView(arrangedSubviews: [bioLabel, bioContentLabel])
        bioStack.axis = .horizontal
        bioStack.distribution = .fill
        bioStack.alignment = .top
        bioStack.spacing = 0
        bioLabel.font = UIFont.boldSystemFont(ofSize: contentFontSize)
        bioContentLabel.numberOfLines = 0
        bioContentLabel.font = UIFont.systemFont(ofSize: contentFontSize)
        bioContentLabel.preferredMaxLayoutWidth = orgDescriptionPreferredWidth

        let infoViewStack = UIStackView(arrangedSubviews: [aboutLabel, websiteStack, emailStack, bioStack])
        infoViewStack.axis = .vertical
        infoViewStack.distribution = .fill
        infoViewStack.alignment = .leading
        infoViewStack.spacing = infoViewInnerStackSpacing

        orgInfoView.addSubview(infoViewStack)
        infoViewStack.snp.makeConstraints { make in
            make.top.equalTo(orgInfoView).offset(sectionViewPadding)
            make.bottom.equalTo(orgInfoView).offset(-sectionViewPadding)
            make.left.equalTo(orgInfoView).offset(sectionViewPadding)
            make.right.equalTo(orgInfoView).offset(-sectionViewPadding)
        }

        //Line seperator
        let infoUpcomingSeparator = UIView()
        contentView.addSubview(infoUpcomingSeparator)
        infoUpcomingSeparator.backgroundColor = UIColor.gray
        infoUpcomingSeparator.snp.makeConstraints {make in
            make.height.equalTo(1)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(orgInfoView.snp.bottom)
        }

        //popularEventsView
        contentView.addSubview(popularEventsTableView)
        popularEventsTableView.snp.makeConstraints { make in
            make.top.equalTo(infoUpcomingSeparator.snp.bottom)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(popularEventsTableViewHeight)
        }
        popularEventsTableView.backgroundColor = UIColor(named: "tableViewBackground")
        popularEventsTableView.dataSource = self
        popularEventsTableView.delegate = self
        popularEventsTableView.separatorStyle = .none
        popularEventsTableView.register(EventCardCell.self, forCellReuseIdentifier: EventCardCell.identifer)
        popularEventsTableView.register(EventTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EventTableHeaderFooterView.identifier)
        popularEventsTableView.rowHeight = UITableViewAutomaticDimension
        popularEventsTableView.isScrollEnabled = false

        //Line seperator
        let eventsTagsSeparator = UIView()
        contentView.addSubview(eventsTagsSeparator)
        eventsTagsSeparator.backgroundColor = UIColor.gray
        eventsTagsSeparator.snp.makeConstraints {make in
            make.height.equalTo(1)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(popularEventsTableView.snp.bottom)
        }

        //Tag View
        contentView.addSubview(tagScrollView)
        let tagLabel = UILabel()
        tagLabel.text = NSLocalizedString("tag-button", comment: "")
        tagLabel.font = UIFont.boldSystemFont(ofSize: tagLabelFontSize)
        tagStack.insertArrangedSubview(tagLabel, at: 0)
        tagStack.alignment = .center
        tagStack.axis = .horizontal
        tagStack.distribution = .fill
        tagStack.spacing = tagHorizontalSpacing
        tagScrollView.addSubview(tagStack)

        tagStack.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(tagScrollView)
        }
        tagScrollView.snp.makeConstraints {make in
            make.top.equalTo(eventsTagsSeparator.snp.bottom).offset(sectionViewPadding)
            make.left.equalTo(contentView).offset(sectionViewPadding)
            make.right.equalTo(contentView).offset(-sectionViewPadding)
            make.height.equalTo(tagScrollViewHeight)
            make.bottom.equalTo(contentView)
        }

    }

    /**
     Filter out all tags and put it into @self.recommendedTags from the current event datasource.
     */
    func getTags() {
        for event in popularEvents {
            for tag in event.eventTags {
                if !tags.contains(tag) {
                    tags.append(tag)
                }
            }
        }
    }

    //Delegate methods for the popularEventsTableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let popularCardCell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.identifer, for: indexPath) as? EventCardCell {
            popularCardCell.configure(with: popularEvents)
            popularCardCell.delegate = self
            cell = popularCardCell
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UITableViewHeaderFooterView()
        if let popularHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as? EventTableHeaderFooterView {
            popularHeader.setMainTitle(NSLocalizedString("popular-events", comment: "").uppercased())
            popularHeader.setButtonTitle(NSLocalizedString("see-more-button", comment: ""))
            popularHeader.editButton.addTarget(self, action: #selector(popularSeeMoreButtonPressed(_:)), for: .touchUpInside)
            header = popularHeader
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    /**
     Handle the action for user pressing the see more buttons above a popular card stack. Should segue to a event list view controller without filters
     - sender: the button that this action is triggered.
     */
    @objc func popularSeeMoreButtonPressed(_ sender: UIButton) {
        let popularListViewController = EventListViewController()
        navigationController?.pushViewController(popularListViewController, animated: true)
    }

    /*
     * Handler for the pressing action of tag buttons. Should segue to the correct tagview controller.
     * - sender: the sender of the action.
     */
    @objc func tagButtonPressed(_ sender: UIButton) {
        let tagViewController = TagViewController()
        if let tagButton = sender as? EventTagButton {
            let tag = tagButton.getTagPk()
            if let rootViewEventsDiscoveryController = navigationController?.viewControllers.first as? EventsDiscoveryController {
                tagViewController.setup(with: rootViewEventsDiscoveryController.events, for: tag)
                navigationController?.pushViewController(tagViewController, animated: true)
            }
        }
    }

    func push(detailsViewController: EventDetailViewController) {
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
