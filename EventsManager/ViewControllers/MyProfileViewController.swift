//
//  MyProfileViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit
import Kingfisher

class MyProfileViewController: UIViewController {
    
    //constants
    let topBarHeight:CGFloat = 90
    let personalAvatarSideLength:CGFloat = 60
    let settingsButtonSideLength:CGFloat = 30
    let topBarSideMargins:CGFloat = 20
    let userNameFontSize:CGFloat = 18
    let shadowOpacity:Float = 0.2
    let shadowRadius:CGFloat = 2
    let shadowOffset = CGSize(width: 0, height: 2)
    let scrollingAnimationDuration = 0.3
    
    //view elements
    let topBar = UIView()
    let userAvatar = UIImageView()
    let userName = UILabel()
    let settingButton = UIButton()
    
    //data source
    var user:User?
    
    override func viewWillAppear(_ animated: Bool) {
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
        configure(with: User(netID: "qh75", name:"John Appleseed" , avatar: URL(string: "http://cornelldti.org/img/team/davidc.jpg")!, interestedEvents: [], goingEvents: [], followingOrganizations: [], joinedOrganizations: [], preferredCategories: []))
    }
    
    /**
      Configures the personal profile view controller with a user model
     */
    func configure(with user: User){
        userAvatar.kf.setImage(with: user.avatar)
        userName.text = user.name
    }
    
    /* Sets all the layout elements in the details view */
    func setLayouts(){
        //top bar
        view.addSubview(topBar)
        view.backgroundColor = UIColor.white
        topBar.addSubview(userAvatar)
        topBar.addSubview(userName)
        topBar.addSubview(settingButton)
        userAvatar.layer.cornerRadius = personalAvatarSideLength/2
        userAvatar.clipsToBounds = true
        userName.font = UIFont.boldSystemFont(ofSize: userNameFontSize)
        settingButton.setBackgroundImage(#imageLiteral(resourceName: "settings"), for: .normal)
        
        topBar.backgroundColor = UIColor.white
        topBar.layer.shadowColor = UIColor.gray.cgColor
        topBar.layer.shadowOpacity = shadowOpacity
        topBar.layer.shadowRadius = shadowRadius
        topBar.layer.shadowOffset = shadowOffset
        
        topBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.height.equalTo(topBarHeight)
        }
        userAvatar.snp.makeConstraints{ make in
            make.left.equalTo(topBar).offset(topBarSideMargins)
            make.height.equalTo(personalAvatarSideLength)
            make.width.equalTo(personalAvatarSideLength)
            make.centerY.equalTo(topBar)
        }
        userName.snp.makeConstraints{ make in
            make.left.equalTo(userAvatar.snp.right).offset(topBarSideMargins)
            make.centerY.equalTo(topBar)
        }
        settingButton.snp.makeConstraints{ make in
            make.left.equalTo(userName.snp.right).offset(topBarSideMargins)
            make.width.equalTo(settingsButtonSideLength)
            make.height.equalTo(settingsButtonSideLength)
            make.right.equalTo(topBar).offset(-topBarSideMargins)
            make.centerY.equalTo(topBar)
        }
        
    }

}
