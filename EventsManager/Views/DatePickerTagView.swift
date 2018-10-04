//
//  DatePickerTagButton.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/26/18.
//
//

import UIKit
import SnapKit

class DatePickerTagView: UIView {

    var date: Date?

    //ViewElements
    let dateLabel = UILabel()
    let displayLabel = UILabel()

    //Constants
    let tagHeight: CGFloat = 30
    let tagWidth: CGFloat = 130
    let dateLabelWidth: CGFloat = 60
    let displayLabelWidth: CGFloat = 70
    let tagFontSize: CGFloat = 14
    let blackBackgroundWidth = 90
    let whiteBackgroundWidth = 30

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    /**
     Sets the date for this date picker
    */
    func setDate(_ date: Date) {
        self.date = date
        displayLabel.text = "\(DateFormatHelper.month(from: date)) \(DateFormatHelper.day(from: date))"
    }

    /**
     Gets the date for this date picker.
    */
    func getDate() -> Date? {
        return date
    }

    /**
     * Modifiy the button's styles
     */
    func layoutUI() {
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = tagHeight / 2
        self.snp.makeConstraints { make in
            make.height.equalTo(tagHeight)
            make.width.equalTo(tagWidth)
        }
        dateLabel.font = UIFont.systemFont(ofSize: tagFontSize)
        displayLabel.font = UIFont.systemFont(ofSize: tagFontSize)
        dateLabel.textColor = UIColor.white
        displayLabel.textColor = UIColor.black
        dateLabel.textAlignment = .center
        displayLabel.textAlignment = .center
        dateLabel.text = NSLocalizedString("date-picker-date", comment: "")

        self.addSubview(dateLabel)
        self.addSubview(displayLabel)

        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(dateLabelWidth)
        }

        displayLabel.snp.makeConstraints { make in
            make.left.equalTo(dateLabel.snp.right)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }

        let blackBackgroundView = UIView()
        blackBackgroundView.backgroundColor = UIColor.black
        blackBackgroundView.layer.cornerRadius = tagHeight / 2
        self.addSubview(blackBackgroundView)
        blackBackgroundView.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.width.equalTo(blackBackgroundWidth)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }

        let whiteBackgroundView = UIView()
        self.addSubview(whiteBackgroundView)
        whiteBackgroundView.backgroundColor = UIColor.white
        whiteBackgroundView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(dateLabelWidth)
            make.width.equalTo(whiteBackgroundWidth)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }

        self.bringSubview(toFront: whiteBackgroundView)
        self.bringSubview(toFront: dateLabel)
        self.bringSubview(toFront: displayLabel)

    }

}
