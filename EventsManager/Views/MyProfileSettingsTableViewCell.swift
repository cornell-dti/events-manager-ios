//
//  MyProfileReminderSettingsTableViewCell.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/28/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit
import UserNotifications

protocol MyProfileSettingsTableViewCellDelegate: class {
    func reminderTimeSelectionButtonDidClick()
}

class MyProfileSettingsTableViewCell: UITableViewCell {

    //datasource
    weak var delegate: MyProfileSettingsTableViewCellDelegate?

    //constants
    let wrapperViewHeight: CGFloat = 30
    let horizontalSideMargins: CGFloat = 20
    let verticalSideMargins: CGFloat = 10
    let fontSize: CGFloat = 15

    //view elemtents
    let reminderSwitchWrapperView = UIView()
    let eventRemindersLabel = UILabel()
    let eventRemindersSwitch = UISwitch()
    let notificationWrapperView = UIView()
    let notifyMeLabel = UILabel()
    let notifyTimePickerButton = UIButton()
    let netIdWrapperView = UIView()
    let netIdLabel = UILabel()
    let netIdDisplayLabel = UILabel()
    let logoutWrapperView = UIView()
    let logoutButton = UIButton()

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayouts()
    }

    /** Sets the basic layout of the cell */
    func setLayouts() {
        self.addSubview(reminderSwitchWrapperView)
        reminderSwitchWrapperView.addSubview(eventRemindersLabel)
        reminderSwitchWrapperView.addSubview(eventRemindersSwitch)
        eventRemindersLabel.text = NSLocalizedString("my-profile-event-reminders", comment: "")
        eventRemindersLabel.font = UIFont.systemFont(ofSize: fontSize)
        eventRemindersLabel.snp.makeConstraints { make in
            make.left.equalTo(reminderSwitchWrapperView)
            make.centerY.equalTo(reminderSwitchWrapperView)
        }
        eventRemindersSwitch.snp.makeConstraints { make in
            make.right.equalTo(reminderSwitchWrapperView)
            make.centerY.equalTo(reminderSwitchWrapperView)
        }
        eventRemindersSwitch.addTarget(self, action: #selector(self.eventReminderSwitcherSwitched(_:)), for: .allEvents)
        reminderSwitchWrapperView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(verticalSideMargins)
            make.left.equalTo(self).offset(horizontalSideMargins)
            make.right.equalTo(self).offset(-horizontalSideMargins)
            make.height.equalTo(wrapperViewHeight)
        }
        self.addSubview(notificationWrapperView)
        notificationWrapperView.addSubview(notifyMeLabel)
        notificationWrapperView.addSubview(notifyTimePickerButton)
        notifyMeLabel.text = NSLocalizedString("my-profile-notify-me", comment: "")
        notifyMeLabel.font = UIFont.systemFont(ofSize: fontSize)
        notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-one-hour-before", comment: ""), for: .normal)
        notifyTimePickerButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        notifyTimePickerButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        notifyTimePickerButton.addTarget(self, action: #selector(self.remindersSelectionButtonPressed(_:)), for: .touchUpInside)
        notifyMeLabel.snp.makeConstraints { make in
            make.left.equalTo(notificationWrapperView)
            make.centerY.equalTo(notificationWrapperView)
        }
        notifyTimePickerButton.snp.makeConstraints { make in
            make.right.equalTo(notificationWrapperView)
            make.centerY.equalTo(notificationWrapperView)
        }
        notificationWrapperView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(horizontalSideMargins)
            make.top.equalTo(reminderSwitchWrapperView.snp.bottom).offset(verticalSideMargins)
            make.right.equalTo(self).offset(-horizontalSideMargins)
            make.height.equalTo(wrapperViewHeight)
        }

        let separator = UIView()
        self.addSubview(separator)
        separator.backgroundColor = UIColor.gray
        separator.snp.makeConstraints { make in
            make.height.equalTo(0.8)
            make.left.equalTo(self).offset(horizontalSideMargins)
            make.right.equalTo(self).offset(-horizontalSideMargins)
            make.top.equalTo(notificationWrapperView.snp.bottom).offset(verticalSideMargins)
        }

        self.addSubview(netIdWrapperView)
        netIdWrapperView.addSubview(netIdLabel)
        netIdWrapperView.addSubview(netIdDisplayLabel)
        netIdWrapperView.isHidden = true
        netIdLabel.font = UIFont.systemFont(ofSize: fontSize)
        netIdLabel.text = NSLocalizedString("my-profile-net-id", comment: "")
        netIdDisplayLabel.font = UIFont.systemFont(ofSize: fontSize)
        netIdDisplayLabel.textColor = UIColor.gray
        netIdLabel.snp.makeConstraints { make in
            make.left.equalTo(netIdWrapperView)
            make.centerY.equalTo(netIdWrapperView)
        }
        netIdDisplayLabel.snp.makeConstraints { make in
            make.right.equalTo(netIdWrapperView)
            make.centerY.equalTo(netIdWrapperView)
        }
        netIdWrapperView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(verticalSideMargins)
            make.left.equalTo(self).offset(horizontalSideMargins)
            make.right.equalTo(self).offset(-horizontalSideMargins)
            make.height.equalTo(wrapperViewHeight)
        }

        self.addSubview(logoutWrapperView)
        logoutWrapperView.addSubview(logoutButton)
        logoutButton.isHidden = true
        logoutButton.addTarget(self, action: #selector(self.logout(_:)), for: .touchUpInside)
        logoutButton.setTitle(NSLocalizedString("my-profile-logout-button", comment: ""), for: .normal)
        logoutButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        logoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoutWrapperView)
            make.right.equalTo(logoutWrapperView)
        }
        logoutWrapperView.snp.makeConstraints { make in
            make.top.equalTo(netIdWrapperView.snp.bottom).offset(verticalSideMargins)
            make.right.equalTo(self).offset(-horizontalSideMargins)
            make.left.equalTo(self).offset(horizontalSideMargins)
            make.bottom.equalTo(self)
            make.height.equalTo(wrapperViewHeight)
        }
    }

    /**
     Configures the settings cell with a user
    */
    func configure(with user: User) {
        netIdDisplayLabel.text = user.netID
        if user.reminderEnabled {
            eventRemindersSwitch.isOn = true
            switch ReminderTimeOptions.getCase(by: user.reminderTime) {
            case .fifteenMinutesBefore:
                notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-15min-before", comment: ""), for: .normal)
            case .halfAnHourBefore:
                notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-half-an-hour-before", comment: ""), for: .normal)
            case .oneHourBefore:
                notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-one-hour-before", comment: ""), for: .normal)
            case .none:
                notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-none", comment: ""), for: .normal)
            }
        } else {
            eventRemindersSwitch.isOn = false
            toggleNotifyMeSelectorDisabled()
        }
    }

    /**
     Enable the notify me selection if it's disabled, enable it if it's not.
    */
    func toggleNotifyMeSelectorDisabled() {
        if notifyTimePickerButton.isEnabled == true {
            notifyTimePickerButton.isEnabled = false
            notifyTimePickerButton.setTitleColor(UIColor.gray, for: .normal)
            notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-none", comment: ""), for: .normal)
        } else {
            notifyTimePickerButton.isEnabled = true
            notifyTimePickerButton.setTitle(NSLocalizedString("my-profile-reminder-15min-before", comment: ""), for: .normal)
            notifyTimePickerButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        }
    }

    /**
     Handler for the log out button
     */
    @objc func logout(_ sender: UIButton) {
       UserData.logOut()
    }

    /**
     Handler for the event reminder switch.
     */
    @objc func eventReminderSwitcherSwitched(_ sender: UISwitch) {
        self.toggleNotifyMeSelectorDisabled()
        _ = UserData.setReminderEnabled(rem: sender.isOn)
        if sender.isOn {
            _ = UserData.setReminderTime(timeReminderOption: .fifteenMinutesBefore)
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }

    /**
     Handler for the reminder selection button.
     */
    @objc func remindersSelectionButtonPressed(_ sender: UIButton) {
        delegate?.reminderTimeSelectionButtonDidClick()
    }
}
