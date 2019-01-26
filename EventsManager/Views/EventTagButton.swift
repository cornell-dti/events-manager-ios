//
//  EventTagButton.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/5/18.
//
//

import UIKit
import SnapKit

class EventTagButton: UIButton {
    //Constants
    let tagHeight = CGFloat(integerLiteral: 30)
    let tagFontSize: CGFloat = 14

    private var tagPk = -1

    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    func setTag(with pk: Int) {
        tagPk = pk
        setTitle("    \(AppData.getTag(by: pk).name)    ", for: state)
    }

    func getTagPk() -> Int {
        return tagPk
    }

    /**
     * Modifiy the button's styles
     */
    func layoutUI() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: tagFontSize)
        self.layer.cornerRadius = tagHeight / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(UIColor.black, for: .normal)
        self.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(tagHeight)
        }
    }

}
