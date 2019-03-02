//
//  CheckableTableViewCell.swift
//  EventsManager
//
//  Created by Ashrita Raman on 9/29/18.
//

import Foundation
import UIKit
class CheckableTableViewCell: UITableViewCell {
    static let identifier = "checkableTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /** Set the basic layout of the view */
    func setLayouts() {
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }

    func configure(with title: String) {
        self.textLabel?.text = title
    }
}
