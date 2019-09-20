//
//  MyProfileViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit
import Kingfisher

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, MyProfileSettingsTableViewCellDelegate {

    //constants
    let gAnalyticsScreenName = "my profile pg"
    
    let sectionCount = 3
    let followingOrganizationsSetion = 0
    let followingTagsSection = 1
    let followingTagRowCount = 1
    let follwingOrganizationRowLimit = 3
    let settingsSection = 2
    let settingsRowCount = 1

    let headerHeight: CGFloat = 55
    let topBarHeight: CGFloat = 90
    let personalAvatarSideLength: CGFloat = 60
    let settingsButtonSideLength: CGFloat = 30
    let topBarSideMargins: CGFloat = 20
    let userNameFontSize: CGFloat = 18
    let shadowOpacity: Float = 0.2
    let shadowRadius: CGFloat = 2
    let shadowOffset = CGSize(width: 0, height: 2)
    let scrollingAnimationDuration = 0.3
    let animationDuration = 0.3
    let reminderTimePickerHeight: CGFloat = 160
    let toolBarHeigt: CGFloat = 35

    //view elements
    let topBar = UIView()
    let userAvatar = UIImageView()
    let userName = UILabel()
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    let reminderTimePickerContainerView = UIView()
    let reminderTimePicker = UIPickerView()
    let reminderTimePickerToolBar = UIToolbar()
    let settingsCell = MyProfileSettingsTableViewCell()

    //data source
    var user: User?
    var showingAllFollowingOrganizations = false

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
        user = UserData.getLoggedInUser()
        tableView.reloadData()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        if UserData.didLogin() {
            configure(with: UserData.getLoggedInUser()!)
        }
    }

    /**
      Configures the personal profile view controller with a user model
     */
    func configure(with user: User) {
        self.user = user
        userAvatar.kf.setImage(with: user.avatar)
        userName.text = user.name
        tableView.reloadData()
    }

    /* Sets all the layout elements in the details view */
    func setLayouts() {
        //top bar
        view.addSubview(topBar)
        view.backgroundColor = UIColor.white
        topBar.addSubview(userAvatar)
        topBar.addSubview(userName)
        userAvatar.layer.cornerRadius = personalAvatarSideLength/2
        userAvatar.clipsToBounds = true
        userName.font = UIFont.boldSystemFont(ofSize: userNameFontSize)

        topBar.backgroundColor = UIColor.white
        topBar.layer.shadowColor = UIColor.gray.cgColor
        topBar.layer.shadowOpacity = shadowOpacity
        topBar.layer.shadowRadius = shadowRadius
        topBar.layer.shadowOffset = shadowOffset

        topBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.height.equalTo(topBarHeight)
        }
        userAvatar.snp.makeConstraints { make in
            make.left.equalTo(topBar).offset(topBarSideMargins)
            make.height.equalTo(personalAvatarSideLength)
            make.width.equalTo(personalAvatarSideLength)
            make.centerY.equalTo(topBar)
        }
        userName.snp.makeConstraints { make in
            make.left.equalTo(userAvatar.snp.right).offset(topBarSideMargins)
            make.centerY.equalTo(topBar)
            make.right.equalTo(topBar).offset(-topBarSideMargins)
        }
        //tableview
        view.addSubview(tableView)
        view.bringSubviewToFront(topBar)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrganizationTableViewCell.self, forCellReuseIdentifier: OrganizationTableViewCell.identifier)
        tableView.register(MyProfileHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: MyProfileHeaderFooterView.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none

        //reminder time selector
        view.addSubview(reminderTimePickerContainerView)
        reminderTimePickerContainerView.addSubview(reminderTimePicker)
        reminderTimePickerContainerView.addSubview(reminderTimePickerToolBar)
        reminderTimePickerContainerView.backgroundColor = UIColor.white

        reminderTimePicker.center = view.center
        reminderTimePicker.dataSource = self
        reminderTimePicker.delegate = self

        //tool bar
        reminderTimePickerToolBar.barStyle = .default
        reminderTimePickerToolBar.isTranslucent = true
        reminderTimePickerToolBar.tintColor = view.tintColor
        reminderTimePickerToolBar.sizeToFit()

        //add button to tool bar
        let doneButton = UIBarButtonItem(title: NSLocalizedString("tool-bar-done-button", comment: ""), style: .plain, target: self, action: #selector(toolBarDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("tool-bar-cancel-button", comment: ""), style: .plain, target: self, action: #selector(toolBarCancelClicked))
        reminderTimePickerToolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        reminderTimePickerToolBar.isUserInteractionEnabled = true

        reminderTimePicker.snp.makeConstraints { make in
            make.top.equalTo(reminderTimePickerToolBar.snp.bottom)
            make.left.equalTo(reminderTimePickerContainerView)
            make.right.equalTo(reminderTimePickerContainerView)
            make.bottom.equalTo(reminderTimePickerContainerView)
        }
        reminderTimePickerToolBar.snp.makeConstraints { make in
            make.bottom.equalTo(reminderTimePicker.snp.top)
            make.right.equalTo(reminderTimePickerContainerView)
            make.left.equalTo(reminderTimePickerContainerView)
            make.top.equalTo(reminderTimePickerContainerView)
            make.height.equalTo(toolBarHeigt)
        }

        reminderTimePickerContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(0)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ReminderTimeOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch ReminderTimeOptions.getCase(by: row) {
            case .fifteenMinutesBefore: return NSLocalizedString("my-profile-reminder-15min-before", comment: "")
            case .halfAnHourBefore: return NSLocalizedString("my-profile-reminder-half-an-hour-before", comment: "")
            case .oneHourBefore: return NSLocalizedString("my-profile-reminder-one-hour-before", comment: "")
            case .none: return NSLocalizedString("my-profile-reminder-none", comment: "")
        }
    }

    /**
     Handles the action of pressing done on the reminder time picker tool bar
     */
    @objc func toolBarDoneClicked() {
        let selectedTimeOption = ReminderTimeOptions.getCase(by: reminderTimePicker.selectedRow(inComponent: 0))
        _ = UserData.setReminderTime(timeReminderOption: selectedTimeOption)
        switch selectedTimeOption {
            case .fifteenMinutesBefore: settingsCell.notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-15min-before", comment: ""), for: .normal)
            case .halfAnHourBefore: settingsCell.notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-half-an-hour-before", comment: ""), for: .normal)
            case .oneHourBefore: settingsCell.notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-one-hour-before", comment: ""), for: .normal)
            case .none: settingsCell.notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-none", comment: ""), for: .normal)
        }
        UIView.animate(withDuration: animationDuration, animations: {
            if let constraint = (self.reminderTimePickerContainerView.constraints.filter {$0.firstAttribute == .height}.first) {
                constraint.constant = 0
                self.view.layoutIfNeeded()
            }
        })
    }

    /**
     Handles the action of pressing cancel on the reminder time picker tool bar
     */
    @objc func toolBarCancelClicked() {
        UIView.animate(withDuration: animationDuration, animations: {
            if let constraint = (self.reminderTimePickerContainerView.constraints.filter {$0.firstAttribute == .height}.first) {
                constraint.constant = 0
                self.view.layoutIfNeeded()
            }
        })
    }

    func reminderTimeSelectionButtonDidClick() {
        UIView.animate(withDuration: animationDuration, animations: {
            if let constraint = (self.reminderTimePickerContainerView.constraints.filter {$0.firstAttribute == .height}.first) {
                constraint.constant = self.reminderTimePickerHeight
                self.view.layoutIfNeeded()
            }
        })
    }

    /**
     Handles pressing of the "MORE" button above following organizations. Should display all possible organizations.
     */
    @objc func showAllOrganizations(_ sender: UIButton) {
        if let user = user {
            if user.followingOrganizations.count > follwingOrganizationRowLimit && !showingAllFollowingOrganizations {
                var indexPathsToInsert: [IndexPath] = []
                for rowIndex in follwingOrganizationRowLimit ..< user.followingOrganizations.count {
                    let newIndexPath = IndexPath(row: rowIndex, section: followingOrganizationsSetion)
                    indexPathsToInsert.append(newIndexPath)
                }
                showingAllFollowingOrganizations = true
                tableView.insertRows(at: indexPathsToInsert, with: .fade)
                sender.isHidden = true
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyProfileHeaderFooterView.identifier) as! MyProfileHeaderFooterView
        switch section {
            case followingOrganizationsSetion:
                sectionHeader.setMainTitle(NSLocalizedString("my-profile-following", comment: ""))
                if (user?.followingOrganizations.count ?? follwingOrganizationRowLimit) > follwingOrganizationRowLimit {
                    sectionHeader.setButtonTitle(NSLocalizedString("my-profile-more-button", comment: ""))
                    sectionHeader.editButton.addTarget(self, action: #selector(self.showAllOrganizations(_:)), for: .touchUpInside)
                } else {
                    sectionHeader.editButton.isHidden = true
                }
            case followingTagsSection:
                sectionHeader.setMainTitle(NSLocalizedString("my-profile-following-tags", comment: ""))
            case settingsSection:
                sectionHeader.setMainTitle(NSLocalizedString("my-profile-settings", comment: ""))
            default:
                return sectionHeader
            }
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case followingOrganizationsSetion:
                if showingAllFollowingOrganizations {
                    return user?.followingOrganizations.count ?? 0
                } else {
                    return (user?.followingOrganizations.count) ?? 0 <= follwingOrganizationRowLimit ? (user?.followingOrganizations.count) ?? 0 : follwingOrganizationRowLimit
                }
            case followingTagsSection:
                return followingTagRowCount
            case settingsSection:
                return settingsRowCount
            default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let user = user {
            switch indexPath.section {
                case followingOrganizationsSetion:
                    let followingOrgCell = tableView.dequeueReusableCell(withIdentifier: OrganizationTableViewCell.identifier) as! OrganizationTableViewCell
                    followingOrgCell.configure(with: AppData.getOrganization(by: user.followingOrganizations[indexPath.row], startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: false))
                    return followingOrgCell
                case followingTagsSection:
                    let followingTagCell = MyProfileTagsTableViewCell()
                    followingTagCell.configure(with: user.followingTags, parentNavigationController: navigationController)
                    return followingTagCell
                case settingsSection:
                    settingsCell.delegate = self
                    settingsCell.configure(with: user)
                    settingsCell.selectionStyle = .none
                    return settingsCell
                default: return cell
            }
        }
        return cell

    }

    /**
     Handles selection of organzations in the tableview. Should segue to an org page.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == followingOrganizationsSetion {
            if let user = user {
                let orgSelected = user.followingOrganizations[indexPath.row]
                let orgViewController = OrganizationViewController()
                orgViewController.configure(organizationPk: orgSelected)
                navigationController?.pushViewController(orgViewController, animated: true)
            }
        }
    }

}
