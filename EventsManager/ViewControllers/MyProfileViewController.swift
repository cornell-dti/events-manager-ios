//
//  MyProfileViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit
import Kingfisher

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //constants
    let followingOrganizationsSetion = 0
    let followingTagsSecgtion = 1
    let follwingOrganizationRowLimit = 3
    
    let headerHeight:CGFloat = 55
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
    let tableView = UITableView(frame:CGRect(), style: .grouped)
    
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
        configure(with: User(netID: "qh75", name:"John Appleseed" , avatar: URL(string: "http://cornelldti.org/img/team/davidc.jpg")!, interestedEvents: [], goingEvents: [], followingOrganizations: [Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org"), Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org"), Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org")], preferredCategories: [], followingTags: ["#Kornell", "#LOLOL", "#Cornel", "#Can't get into CS Courses", "#omgggggg"]))
    }
    
    /**
      Configures the personal profile view controller with a user model
     */
    func configure(with user: User){
        self.user = user
        userAvatar.kf.setImage(with: user.avatar)
        userName.text = user.name
        tableView.reloadData()
    }
    
    /* Sets all the layout elements in the details view */
    func setLayouts(){
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
            make.right.equalTo(topBar).offset(-topBarSideMargins)
        }
        //tableview
        view.addSubview(tableView)
        view.bringSubview(toFront: topBar)
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(topBar.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyProfileFollowingTableViewCell.self, forCellReuseIdentifier: MyProfileFollowingTableViewCell.identifier)
        tableView.register(MyProfileHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: MyProfileHeaderFooterView.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyProfileHeaderFooterView.identifier) as! MyProfileHeaderFooterView
        switch section {
        case followingOrganizationsSetion:
            sectionHeader.setMainTitle(NSLocalizedString("my-profile-following", comment: ""))
            sectionHeader.setButtonTitle(NSLocalizedString("my-profile-more-button", comment: ""))
        case followingTagsSecgtion:
            sectionHeader.setMainTitle(NSLocalizedString("my-profile-following-tags", comment: ""))
        default:
            return sectionHeader
        }
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case followingOrganizationsSetion:
                return (user?.followingOrganizations.count ?? 0) <= follwingOrganizationRowLimit ? (user?.followingOrganizations.count ?? 0) : follwingOrganizationRowLimit
            case followingTagsSecgtion:
                return 1
            default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let user = user {
            switch indexPath.section {
            case followingOrganizationsSetion:
                let followingOrgCell = tableView.dequeueReusableCell(withIdentifier: MyProfileFollowingTableViewCell.identifier) as! MyProfileFollowingTableViewCell
                followingOrgCell.configure(with: user.followingOrganizations[indexPath.row])
                return followingOrgCell
            case followingTagsSecgtion:
                let followingTagCell = MyProfileTagsTableViewCell()
                followingTagCell.configure(with: user.followingTags)
                return followingTagCell
            default: return cell
            }
        }
        return cell
        
    }

}
