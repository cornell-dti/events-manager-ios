//
//  OnBoardingViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/22/18.
//

import UIKit

class OnBoardingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //constants
    let navTitleFontSize:CGFloat = 25
    let navSubtitleFontSize:CGFloat = 15
    let titleToTopSpacing:CGFloat = 10
    let titleToSubtitleSpacing:CGFloat = 5
    let sideSpacing:CGFloat = 5

    //datasource
    var organizations:[Organization] = []
    var checkOrganization:[Organization] = []

    var searchController = UISearchController(searchResultsController: nil)

    //view elements
    let tableView = UITableView()
    let emptyState = SearchEmtpyStateView()
    let placeHolderView = UIView() //add this view between the navbar and the tableview to prevent nav bar from collapsing

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
    }

    /**
     Sets the basic layout of the view
     */
    func setLayouts() {
        //For testing
        organizations = [Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org"), Organization(id: 1, name: "Cornell DTI 2", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org"), Organization(id: 1, name: "Cornell DTI 3", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org"), Organization(id: 1, name: "Cornell DTI 4", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org"), Organization(id: 1, name: "Cornell DTI 5", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org")]

        //navigation stuffs
        navigationController?.title = NSLocalizedString("onboarding-interact-title", comment: "")
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        //Navigation bar height cannot be change in > iOS 11. We require the text to be fit into two lines.
        navigationItem.titleView = setTitle(title: "Interact", subtitle: "Choose some on-campus organizations that you would like to follow. ")
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
            make.bottom.equalTo(view)
        }

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

    /**
     Sets the title and the subtile for the navigation bar
     */
    private func setTitle(title:String, subtitle:String) -> UIView {

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
     Update the data source based on filtered Events
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckableTableViewCell.identifier) as! CheckableTableViewCell
            cell.configure(with: organizations[indexPath.row].name)
        cell.selectionStyle = .none
        return cell
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
