//
//  OnBoardingViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/22/18.
//

import UIKit
import Firebase

class OnBoardingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating {

    //constants
    let minimumSelectionCount = 1
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
    var filteredOrganizations: [Organization] = []
    var checkedOrganizationIDs: [Int] = []
    var tags: [Tag] = []
    var filteredTags: [Tag] = []
    var checkedTags: [Int] = []
    var checkedTagNames: [String] = []
    var currentOnBoardingProcess = OnBoardingProcess.chooseOrganization
    var user: User?

    //search
    var searchController = UISearchController(searchResultsController: nil)
    var currentSearchScope = SearchOptions.organization

    let searchSegments = [NSLocalizedString("search-segment-events", comment: ""), NSLocalizedString("search-segment-organizations", comment: ""), NSLocalizedString("search-segment-tags", comment: "")]
    let searchSegmentOrgIndex = 1
    let searchSegmentTagIndex = 2

    //view elements
    let tableView = UITableView()
    let emptyState = SearchEmtpyStateView()
    let placeHolderView = UIView() //add this view between the navbar and the tableview to prevent nav bar from collapsing
    let navigatorView = UIView()
    let navigatorForwardButton = UIButton()
    let loadingVC = LoadingViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()

        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .reloadData, object: nil)

        loadingVC.configure(with: NSLocalizedString("loading", comment: ""))
        _ = AppData.getEvents(startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingVC), endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingVC), noConnection: GenericLoadingHelper.noConnection(from: self), updateData: true)
    }

    /**
     Calls AppData to update locally saved data.
     */
    @objc func updateData() {
        let events = AppData.getEvents(startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: false)
        var uniqueOrgIds = Set<Int>()
        var uniqueTagIds = Set<Int>()
        for event in events {
            uniqueOrgIds.insert(event.eventOrganizer)
            for tag in event.eventTags {
                uniqueTagIds.insert(tag)
            }
        }
        for org in uniqueOrgIds {
            organizations.append(AppData.getOrganization(by: org, startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: false))
        }
        for tag in uniqueTagIds {
            tags.append(AppData.getTag(by: tag, startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: false))
        }
        filteredTags = tags
        filteredOrganizations = organizations
        tableView.reloadData()
    }

    /**
     Sets the basic layout of the view
     */
    func setLayouts() {

        //navigation stuffs
        if #available(iOS 11, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        //Navigation bar height cannot be change in > iOS 11. We require the text to be fit into two lines.
        navigationItem.titleView = setTitle(title: NSLocalizedString("onboarding-interact-title", comment: ""), subtitle: NSLocalizedString("onboarding-interact-description", comment: ""))
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        definesPresentationContext = true

        navigationItem.searchController = searchController //?

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
        tableView.rowHeight = UITableView.automaticDimension
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
        view.bringSubviewToFront(emptyState)
        emptyState.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        disableEmptyState()

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

        titleLabel.font = UIFont(name: "SFProText-Bold", size: navTitleFontSize)
        subtitleLabel.font = UIFont(name: "SFProText-Light", size: navSubtitleFontSize)
        titleLabel.textColor = UIColor(named: "primaryPink")
        subtitleLabel.textColor = UIColor.black
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

                    currentOnBoardingProcess = .chooseTags
                    navigationItem.titleView = setTitle(title: NSLocalizedString("onboarding-interest-title", comment: ""), subtitle: NSLocalizedString("onboarding-interest-description", comment: ""))
                    searchController.isActive = false
                    tableView.reloadData()
                    setNavigatorFowardButtonStatus()

            case .chooseTags:
                for orgId in checkedOrganizationIDs {
                    _ = UserData.follow(organization: orgId)
                    _ = UserData.addClickForOrganization(pk: orgId)
                }
                for tagId in checkedTags {
                    _ = UserData.follow(tag: tagId)
                    _ = UserData.addClickForTag(pk: tagId)
                }
                for tagName in checkedTagNames {
                    Analytics.logEvent("tagButtonPressed", parameters: [
                        "tagName": tagName
                        ])
                }
                let mainVC = TabBarViewController()
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true, completion: nil)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                return filteredOrganizations.count
            case .chooseTags:
                return filteredTags.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckableTableViewCell.identifier) as! CheckableTableViewCell
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                cell.configure(with: filteredOrganizations[indexPath.row].name)
                if checkedOrganizationIDs.contains(filteredOrganizations[indexPath.row].id) {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            case .chooseTags:
                cell.configure(with: filteredTags[indexPath.row].name)
                if checkedTags.contains(filteredTags[indexPath.row].id) {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                let selectedOrganizationID = filteredOrganizations[indexPath.row].id
                checkedOrganizationIDs.append(selectedOrganizationID)
                user?.followingOrganizations.append(filteredOrganizations[indexPath.row].id)
                setNavigatorFowardButtonStatus()
            case .chooseTags:
                let selectedTagID = filteredTags[indexPath.row].id
                let selectedTagName = filteredTags[indexPath.row].name
                checkedTags.append(selectedTagID)
                checkedTagNames.append(selectedTagName)
                user?.followingTags.append(filteredOrganizations[indexPath.row].id)
                setNavigatorFowardButtonStatus()
            }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch currentOnBoardingProcess {
            case .chooseOrganization:
                let selectedOrganizationID = filteredOrganizations[indexPath.row].id
                checkedOrganizationIDs.remove(at: checkedOrganizationIDs.index(of: selectedOrganizationID)!)
                user?.followingOrganizations.remove(at: (user?.followingOrganizations.index(of:selectedOrganizationID)!)!)
                setNavigatorFowardButtonStatus()
            case .chooseTags:
                let selectedTagID = filteredTags[indexPath.row].id
                let selectedTagName = filteredTags[indexPath.row].name
                checkedTags.remove(at: checkedTags.index(of: selectedTagID)!)
                checkedTagNames.remove(at: checkedTagNames.index(of: selectedTagName)!)
                user?.followingTags.remove(at: (user?.followingTags.index(of:selectedTagID)!)!)
                setNavigatorFowardButtonStatus()
            }

    }

    //search bar stuffs

    func enableEmptyState() {
        emptyState.isHidden = false
        tableView.isHidden = true
    }

    func disableEmptyState() {
        emptyState.isHidden = true
        tableView.isHidden = false
    }

    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String) {
        if !isSearching() {
            filteredOrganizations = organizations
            filteredTags = tags
            tableView.reloadData()
        } else {
            var filteredResults: [Any] = []
            switch currentOnBoardingProcess {
                case .chooseOrganization:
                    filteredOrganizations = organizations.filter({ (organization: Organization) -> Bool in
                        return organization.name.lowercased().contains(searchText.lowercased())
                    })
                    filteredResults = filteredOrganizations
                case .chooseTags:
                    filteredTags = tags.filter({ (tag: Tag) -> Bool in
                        return tag.name.lowercased().contains(searchText.lowercased())
                    })
                    filteredResults = filteredTags
            }
            if !filteredResults.isEmpty {
                disableEmptyState()
            } else {
                enableEmptyState()
                emptyState.setInfoLabel(with: NSLocalizedString("search-empty-state-no-result", comment: ""))
            }
            // updateDataSource()
            tableView.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

}
