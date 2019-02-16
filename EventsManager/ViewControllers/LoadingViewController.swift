//
//  LoadingViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 11/3/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    let containerViewOpacity: CGFloat = 0.9
    let containerViewSideLength: CGFloat = 200
    let containerViewCornerRadius: CGFloat = 15
    let containerViewBottomToMessageSpacing: CGFloat = 20
    let messageFontSize: CGFloat = 18

    let containerView = UIView()
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }

    /**
     Configures the loading with controller with the loading message.
     Requires: The message should not be more than 15 characters.
    */
    func configure(with message: String) {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        messageLabel.text = message
    }

    /**
     Sets the initial layout of the view controller.
     */
    func setLayouts() {
        view.backgroundColor = UIColor(white: 0.0, alpha: 0)
        containerView.backgroundColor = UIColor(white: 0.0, alpha: containerViewOpacity)
        containerView.layer.cornerRadius = containerViewCornerRadius
        activityIndicatorView.startAnimating()
        messageLabel.font = UIFont.boldSystemFont(ofSize: messageFontSize)
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        view.addSubview(containerView)
        containerView.addSubview(activityIndicatorView)
        containerView.addSubview(messageLabel)

        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(containerViewSideLength)
            make.height.equalTo(containerViewSideLength)
        }

        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.centerY.equalTo(containerView)
        }

        messageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-containerViewBottomToMessageSpacing)
            make.centerX.equalTo(containerView)
        }

    }

}
