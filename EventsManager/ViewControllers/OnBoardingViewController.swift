//
//  OnBoardingViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/22/18.
//

import UIKit

class OnBoardingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //constants
    let minimumSelectionCount = 3
    let navTitleFontSize: CGFloat = 25
    let navSubtitleFontSize: CGFloat = 15
    let titleToTopSpacing: CGFloat = 10
    let titleToSubtitleSpacing: CGFloat = 5
    let sideSpacing: CGFloat = 5
    let navigatorViewHeight: CGFloat = 65
    let navigatorForwardButtonHeight: CGFloat = 45
    let navigatorForwardButtonHorizontalPadding: CGFloat = 10
    let shadowOpacity: Float = 0.6
    let shadowRadius: CGFloat = 5
    let shadowOffset = CGSize(width: 1.5, height: 1.5)

    //datasource
    enum OnBoardingProcess {
        case chooseOrganization
        case chooseTags
    }
    var organizations: [Organization] = []
    var checkedOrganizationIDs: [Int] = []
    var tags: [Tag] = []
    var checkedTags: [Int] = []
    var currentOnBoardingProcess = OnBoardingProcess.chooseOrganization

    var searchController = UISearchController(searchResultsController: nil)

    //view elements
    let tableView = UITableView()
    let emptyState = SearchEmtpyStateView()
    let placeHolderView = UIView() //add this view between the navbar and the tableview to prevent nav bar from collapsing
    let navigatorView = UIView()
    let navigatorForwardButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }

    /**
     Sets the basic layout of the view
     */
    func setLayouts() {
        //For testing
        organizations = [Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org"), Organization(id: 5, name: "Cornell DTI 2", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org"), Organization(id: 4, name: "Cornell DTI 3", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org"), Organization(id: 2, name: "Cornell DTI 4", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org"), Organization(id: 3, name: "Cornell DTI 5", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org")]
        tags = [Tag(id: 1, name: "#Kornell"), Tag(id: 2, name: "#DTI"), Tag(id: 3, name: "#lol"), Tag(id: 4, name: "#random tag"), Tag(id: 5, name: "#ooof")]

        //navigation stuffs
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        //Navigation bar height cannot be change in > iOS 11. We require the text to be fit into two lines.
        navigationItem.titleView = setTitle(title: NSLocalizedString("onboarding-interact-title", comment: ""), subtitle: NSLocalizedString("onboarding-interact-description", comment: ""))
        navigationItem.searchController = searchController
        //searchController.delegate = self
        //searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        definesPresentationContext = true

        view.backgroundColor = UIColor.white
        //place holder view
        view.addSubview(placeHolderView)
        placeHolderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(0)
        }

        //TableView
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckableTableViewCell.self, forCellReuseIdentifier: CheckableTableViewCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true

        tableView.snp.makeConstraints { make in
            make.top.equalTo(placeHolderView.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }

        //navigatorView
        view.addSubview(navigatorView)
        navigatorView.backgroundColor = UIColor.white
        navigatorView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(navigatorViewHeight)
        }

        navigatorForwardButton.layer.shadowColor = UIColor.gray.cgColor
        navigatorForwardButton.layer.shadowOpacity = shadowOpacity
        navigatorForwardButton.layer.shadowRadius = shadowRadius
        navigatorForwardButton.layer.shadowOffset = shadowOffset
        navigatorForwardButton.layer.cornerRadius = navigatorForwardButtonHeight / 2
        setNavigatorFowardButtonStatus()
        navigatorView.addSubview(navigatorForwardButton)
        navigatorForwardButton.snp.makeConstraints { make in
            make.height.equalTo(navigatorForwardButtonHeight)
            make.centerY.equalTo(navigatorView)
            make.right.equalTo(navigatorView).offset(-navigatorForwardButtonHorizontalPadding)
        }
        navigatorForwardButton.addTarget(self, action: #selector(self.onBoardingForwardButtonClicked(_:)), for: .touchUpInside)

        //empty state
        view.addSubview(emptyState)
        view.bringSubview(toFront: emptyState)
        emptyState.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        if organizations.isEmpty {
            enableEmptyState()
            emptyState.setInfoLabel(with: NSLocalizedString("onboarding-no-orgs", comment: ""))
        } else {
            disableEmptyState()
        }
    }

    private func setNavigatorFowardButtonStatus() {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                if checkedOrganizationIDs.count < minimumSelectionCount {
                    navigatorForwardButton.backgroundColor = UIColor.white
                    navigatorForwardButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
                    navigatorForwardButton.setTitle(NSLocalizedString("on-bording-choose-3-to-continue", comment: ""), for: .normal)
                    navigatorForwardButton.isEnabled = false
                } else {
                    navigatorForwardButton.backgroundColor = UIColor(named: "primaryPink")
                    navigatorForwardButton.setTitleColor(UIColor.white, for: .normal)
                    navigatorForwardButton.setTitle(NSLocalizedString("on-bording-continue", comment: ""), for: .normal)
                    navigatorForwardButton.isEnabled = true
                }
            case .chooseTags:
                if checkedTags.count < minimumSelectionCount {
                    navigatorForwardButton.backgroundColor = UIColor.white
                    navigatorForwardButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
                    navigatorForwardButton.setTitle(NSLocalizedString("on-bording-choose-3-to-continue", comment: ""), for: .normal)
                    navigatorForwardButton.isEnabled = false
                } else {
                    navigatorForwardButton.backgroundColor = UIColor(named: "primaryPink")
                    navigatorForwardButton.setTitleColor(UIColor.white, for: .normal)
                    navigatorForwardButton.setTitle(NSLocalizedString("on-bording-continue", comment: ""), for: .normal)
                    navigatorForwardButton.isEnabled = true
            }
        }
    }

    /**
     Sets the title and the subtile for the navigation bar
     */
    private func setTitle(title: String, subtitle: String) -> UIView {

        //Get navigation Bar Height and Width
        let navigationBarWidth = Int(self.navigationController!.navigationBar.frame.width)
        let navigationBarHeight = Int(self.navigationController!.navigationBar.frame.height)

        let titleLabel = UILabel()
        let subtitleLabel = UILabel()

        titleLabel.font = UIFont(name: "Dosis-Bold", size: navTitleFontSize)
        subtitleLabel.font = UIFont(name: "Dosis-Book", size: navSubtitleFontSize)
        titleLabel.textColor = UIColor(named: "primaryPink")
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.numberOfLines = 2

        titleLabel.text = title
        subtitleLabel.text = subtitle

        //Add Title and Subtitle to View
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationBarWidth, height: navigationBarHeight))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView).offset(titleToTopSpacing)
            make.left.equalTo(titleView).offset(sideSpacing)
            make.right.equalTo(titleView).offset(-sideSpacing)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(titleToSubtitleSpacing)
            make.left.equalTo(titleView).offset(sideSpacing)
            make.right.equalTo(titleView).offset(-sideSpacing)
        }

        return titleView

    }

    /**
     Handles the event when user clicks the next button in onboarding
     */
    @objc func onBoardingForwardButtonClicked(_ sender: UIButton) {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                if checkedOrganizationIDs.count >= minimumSelectionCount {
                    currentOnBoardingProcess = .chooseTags
                    navigationItem.titleView = setTitle(title: NSLocalizedString("onboarding-interest-title", comment: ""), subtitle: NSLocalizedString("onboarding-interest-description", comment: ""))
                    tableView.reloadData()
                    setNavigatorFowardButtonStatus()
                }
            case .chooseTags:
                for orgId in checkedOrganizationIDs {
                    _ = UserData.follow(organization: AppData.getOrganization(by: orgId))
                }
                for tagId in checkedOrganizationIDs {
                    _ = UserData.follow(tag: AppData.getTag(by: tagId))
                }
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = TabBarViewController()
                (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                return organizations.count
            case .chooseTags:
                return tags.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckableTableViewCell.identifier) as! CheckableTableViewCell
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                cell.configure(with: organizations[indexPath.row].name)
            case .chooseTags:
                cell.configure(with: tags[indexPath.row].name)
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                let selectedOrganizationID = organizations[indexPath.row].id
                checkedOrganizationIDs.append(selectedOrganizationID)
                setNavigatorFowardButtonStatus()
            case .chooseTags:
                let selectedTagID = tags[indexPath.row].id
                checkedTags.append(selectedTagID)
                setNavigatorFowardButtonStatus()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                let selectedOrganizationID = organizations[indexPath.row].id
                checkedOrganizationIDs.remove(at: checkedOrganizationIDs.firstIndex(of: selectedOrganizationID)!)
                setNavigatorFowardButtonStatus()
            case .chooseTags:
                let selectedTagID = tags[indexPath.row].id
                checkedTags.remove(at: checkedTags.firstIndex(of: selectedTagID)!)
                setNavigatorFowardButtonStatus()
        }
    }

    //search bar stuffs

    func enableEmptyState() {
        emptyState.isHidden = false
        tableView.isHidden = false
    }

    func disableEmptyState() {
        emptyState.isHidden = true
        tableView.isHidden = false
    }

}
