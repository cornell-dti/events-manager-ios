//
//  EventDetailViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/20/18.
//
//

import UIKit
import MapKit
import Kingfisher
import GoogleMaps
import GooglePlaces
import UserNotifications
import Firebase
import EventKit


class EventDetailViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    //Constants
    let gAnalyticsScreenName = "event detail pg"

    let buttonHeight: CGFloat = 40
    let standardEdgeSpacing: CGFloat = 20
    let imageViewHeight: CGFloat = 220
    let buttonStackInnerSpacing: CGFloat = 15
    let infoStackEdgeSpacing: CGFloat = 40
    let iconSideLength: CGFloat = 25
    let infoStackIconLabelSpacing: CGFloat = 20
    let infoTableSpacing: CGFloat = 12
    let eventDescriptionFontSize = CGFloat(integerLiteral: 16)
    let mapViewHeight: CGFloat = 220
    let mapViewDirectionsBarHeight: CGFloat = 35
    let mapViewDirectionsBarOpacity: Float = 0.7
    let tagScrollViewHeight = CGFloat(integerLiteral: 50)
    let tagHorizontalSpacing = CGFloat(integerLiteral: 8)
    let tagLabelFontSize = CGFloat(integerLiteral: 22)
    let eventImageGradientOpcaity: Float = 0.3
    let eventImageGradientStartPoint = CGPoint(x: 0.5, y: 0.0)
    let eventImageGradientEndPoint = CGPoint(x: 0.5, y: 1.0)
    let floatingButtonSideLength: CGFloat = 35
    let floatingButtonSideSpacing: CGFloat = 20
    let floatingButtonTopSpacing: CGFloat = 8
    let backButtonLeftInset: CGFloat = 10
    let backButtonTopBottomInset: CGFloat = 7
    let backButtonRightInset: CGFloat = 0
    let buttonImageWidth: CGFloat = 23
    let buttonImageHeight: CGFloat = 26
    let buttonImageTopSpacing: CGFloat = 7
    let buttonImageLeftSpacing: CGFloat = 0 //15
    let modifiedEdgeSpacing: CGFloat = 35
    let modifiedbuttonImageLeftSpacing: CGFloat = 15 //65
    let buttonFontSize: CGFloat = 14
    let shadowOpacity: Float = 0.6
    let shadowRadius: CGFloat = 5
    let shadowOffset = CGSize(width: 1.5, height: 1.5)
    let eventTitleFontSize: CGFloat = 18
    let defaultDescriptionLines = 3
    let defaultTitleLines = 2
    let directionsButtonRightSpacing: CGFloat = 10

    //datasource
    var event: Event?
    let placesClient = GMSPlacesClient.shared()
    var mapLocation: CLLocationCoordinate2D?

    //view elements
    var scrollView = UIScrollView()
    var contentView = UIView()
    let eventImageContainerView = UIView()
    var eventImage = UIImageView()
    let eventName = UILabel()
    let eventDescription = UILabel()
    let eventDescriptionShowMoreButton = UIButton()
    let shareButton = UIButton()
    let bookmarkedButton = UIButton()
    var eventTime = UILabel()
    var eventParticipantCount = UILabel()
    var eventOrganizer = UnderlinedLabel()
    var eventLocation = UILabel()
    var eventLocView = UILabel()
    let eventMapViewWrapper = UIView()
    let eventMapDirectionsBar = UIView()
    let eventMapViewDirectionsButton = UIButton()
    var eventMapView = GMSMapView()
    var tagScrollView = UIScrollView()
    var tagStack = UIStackView()
    let backButton = UIButton()
    let loadingViewController = LoadingViewController()

    var statusBarHeight: CGFloat = 0
    var statusBarHidden: Bool = false
    weak var navigationControllerInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?

    //Hide and show the nav bar on entering and exiting the details page.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.interactivePopGestureRecognizer?.delegate = navigationControllerInteractivePopGestureRecognizerDelegate ?? nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationControllerInteractivePopGestureRecognizerDelegate = navigationController?.interactivePopGestureRecognizer?.delegate
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        Analytics.logEvent("eventViewed", parameters: [
            "eventName": eventName.text ?? ""
            ])
        //GoogleAnalytics.trackEvent(category: "view", action: "visit", label: (event?.eventName)!)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setLayouts()
    }

    /* Sets all the layout elements in the details view */
    func setLayouts() {
        loadingViewController.configure(with: NSLocalizedString("loading", comment: ""))

        view.addSubview(scrollView)
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        scrollView.backgroundColor = UIColor.white
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(-statusBarHeight)
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view.frame.width)
        }

        //Image gradient
        let eventImageGradient = CAGradientLayer()
        eventImageGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: imageViewHeight)
        eventImageGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        eventImageGradient.opacity = eventImageGradientOpcaity
        eventImageGradient.startPoint = eventImageGradientStartPoint
        eventImageGradient.endPoint = eventImageGradientEndPoint
        eventImage.layer.insertSublayer(eventImageGradient, at: 0)

        eventImage.clipsToBounds = true
        eventImage.contentMode = .scaleAspectFill

        //floating Buttons
        backButton.backgroundColor = UIColor.white
        var backButtonIcon = #imageLiteral(resourceName: "back")
        backButtonIcon = backButtonIcon.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonIcon, for: .normal)
        //backButton.imageEdgeInsets = UIEdgeInsets(top: backButtonTopBottomInset, left: backButtonLeftInset, bottom: backButtonTopBottomInset, right: backButtonRightInset)
        backButton.contentEdgeInsets = UIEdgeInsets(top: backButtonTopBottomInset, left: backButtonLeftInset, bottom: backButtonTopBottomInset, right: backButtonRightInset)
        backButton.tintColor = UIColor(named: "primaryPink")
        backButton.layer.cornerRadius = floatingButtonSideLength / 2
        backButton.layer.shadowColor = UIColor.gray.cgColor
        backButton.layer.shadowOpacity = shadowOpacity
        backButton.layer.shadowRadius = shadowRadius
        backButton.layer.shadowOffset = shadowOffset
        backButton.addTarget(self, action: #selector(self.backButtonPressed(_:)), for: .touchUpInside)

        //Name and description
        eventName.numberOfLines = defaultTitleLines
        eventName.font = UIFont.boldSystemFont(ofSize: eventTitleFontSize)
        eventName.textAlignment = .center

        eventDescriptionShowMoreButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        eventDescriptionShowMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: eventDescriptionFontSize)
        eventDescriptionShowMoreButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0, right: 0.01)
        eventDescriptionShowMoreButton.addTarget(self, action: #selector(detailsMoreButtonPressed(_:)), for: .touchUpInside)
        eventDescription.numberOfLines = defaultDescriptionLines
        eventDescription.textColor = UIColor.gray
        eventDescription.textAlignment = .justified
        eventDescription.font = UIFont.systemFont(ofSize: eventDescriptionFontSize)
        //buttons

        bookmarkedButton.backgroundColor = UIColor.white
        bookmarkedButton.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        //bookmarkedButton.imageEdgeInsets = UIEdgeInsetsMake(0, bookmarkedButton.titleLabel?.frame.size.width ?? <#default value#>, 0, -bookmarkedButton.titleLabel?.frame.size.width);
        bookmarkedButton.setTitle(NSLocalizedString("details-bookmark-button", comment: ""), for: .normal)
        bookmarkedButton.tintColor = UIColor(named: "primaryPink")
        bookmarkedButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        bookmarkedButton.layer.cornerRadius = buttonHeight / 2
        bookmarkedButton.layer.shadowColor = UIColor.gray.cgColor
        bookmarkedButton.layer.shadowOpacity = shadowOpacity
        bookmarkedButton.layer.shadowRadius = shadowRadius
        bookmarkedButton.layer.shadowOffset = shadowOffset
        bookmarkedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)
        bookmarkedButton.addTarget(self, action: #selector(self.changeAttendance (_:)), for: .touchUpInside)

        bookmarkedButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }

        bookmarkedButton.imageView?.snp.makeConstraints { make in
            make.top.equalTo(bookmarkedButton).offset(buttonImageTopSpacing)
            make.left.equalTo(bookmarkedButton).offset(modifiedbuttonImageLeftSpacing)
            make.width.equalTo(buttonImageWidth)
            make.height.equalTo(buttonImageHeight)
        }

        shareButton.backgroundColor = UIColor.white
        shareButton.setImage(UIImage(named: "share1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.setTitle(NSLocalizedString("details-share-button", comment: ""), for: .normal)
        shareButton.tintColor = UIColor(named: "primaryPink")
        shareButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        shareButton.layer.cornerRadius = buttonHeight / 2
        shareButton.layer.shadowColor = UIColor.gray.cgColor
        shareButton.layer.shadowOpacity = shadowOpacity
        shareButton.layer.shadowRadius = shadowRadius
        shareButton.layer.shadowOffset = shadowOffset
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)
        shareButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)

        shareButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }

        shareButton.imageView?.snp.makeConstraints { make in
            make.top.equalTo(shareButton).offset(buttonImageTopSpacing)
            make.left.equalTo(shareButton).offset(modifiedbuttonImageLeftSpacing)
            make.width.equalTo(buttonImageWidth)
            make.height.equalTo(buttonImageHeight)
        }

        let buttonStack = UIStackView(arrangedSubviews: [bookmarkedButton, shareButton])
//        let buttonStack = UIStackView(arrangedSubviews: [bookmarkedButton])
        buttonStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.spacing = buttonStackInnerSpacing

        //table of info
        let calendarIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        calendarIcon.image = #imageLiteral(resourceName: "date")
        calendarIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let calendarStack = UIStackView(arrangedSubviews: [calendarIcon, eventTime])
        calendarStack.alignment = .center
        calendarStack.axis = .horizontal
        calendarStack.distribution = .fill
        calendarStack.spacing = infoStackIconLabelSpacing

        let participantIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        participantIcon.image = #imageLiteral(resourceName: "friends")
        participantIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let participantStack = UIStackView(arrangedSubviews: [participantIcon, eventParticipantCount])
        participantStack.alignment = .center
        participantStack.axis = .horizontal
        participantStack.distribution = .fill
        participantStack.spacing = infoStackIconLabelSpacing

        let organizerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        organizerIcon.image = #imageLiteral(resourceName: "organization")
        organizerIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let organizerStack = UIStackView(arrangedSubviews: [organizerIcon, eventOrganizer])
        organizerStack.alignment = .center
        organizerStack.axis = .horizontal
        organizerStack.distribution = .fill
        organizerStack.spacing = infoStackIconLabelSpacing

        let organzationTapGesture = UITapGestureRecognizer(target: self, action: #selector(orgNamePressed(_:)))
        eventOrganizer.addGestureRecognizer(organzationTapGesture)
        eventOrganizer.isUserInteractionEnabled = true

        let locationIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        locationIcon.image = #imageLiteral(resourceName: "lcation")
        locationIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        
        eventLocation.numberOfLines = 0
        eventLocView.addSubview(eventLocation)
        eventLocation.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let locationStack = UIStackView(arrangedSubviews: [locationIcon, eventLocView])
        locationStack.alignment = .center
        locationStack.axis = .horizontal
        locationStack.distribution = .fill
        locationStack.spacing = infoStackIconLabelSpacing

        let infoTableStack = UIStackView(arrangedSubviews: [calendarStack, participantStack, organizerStack, locationStack])
        infoTableStack.alignment = .leading
        infoTableStack.axis = .vertical
        infoTableStack.distribution = .fill
        infoTableStack.spacing = infoTableSpacing

        let tagLabel = UILabel()
        tagLabel.text = NSLocalizedString("tag-button", comment: "")
        tagLabel.font = UIFont.boldSystemFont(ofSize: tagLabelFontSize)
        tagStack.insertArrangedSubview(tagLabel, at: 0)
        tagStack.alignment = .center
        tagStack.axis = .horizontal
        tagStack.distribution = .fill
        tagStack.spacing = tagHorizontalSpacing
        tagScrollView.addSubview(tagStack)

        contentView.addSubview(eventImageContainerView)
        eventImageContainerView.addSubview(eventImage)
        contentView.addSubview(eventName)
        contentView.addSubview(eventDescription)
        contentView.addSubview(eventDescriptionShowMoreButton)
        contentView.addSubview(buttonStack)
        contentView.addSubview(infoTableStack)
        contentView.addSubview(eventMapViewWrapper)
        contentView.addSubview(tagScrollView)
        view.addSubview(backButton)

        //Constraints for UI elements
        backButton.snp.makeConstraints { make in
            make.width.equalTo(floatingButtonSideLength)
            make.height.equalTo(floatingButtonSideLength)
            make.left.equalTo(view).offset(floatingButtonSideSpacing)
            make.top.equalTo(view).offset(floatingButtonTopSpacing + statusBarHeight)
        }

        eventImageContainerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(imageViewHeight).priority(.required)
        }

        eventImage.snp.makeConstraints {make in
            make.top.equalTo(eventImageContainerView)
            make.left.equalTo(eventImageContainerView)
            make.right.equalTo(eventImageContainerView)
            make.bottom.equalTo(eventImageContainerView)
        }

        eventName.snp.makeConstraints { make in
            make.top.equalTo(eventImage.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }

        eventDescription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventName.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        eventDescriptionShowMoreButton.snp.makeConstraints { make in
            make.top.equalTo(eventDescription.snp.bottom)
            make.right.equalTo(eventDescription.snp.right)
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(eventDescriptionShowMoreButton.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(modifiedEdgeSpacing)
            make.right.equalTo(contentView).offset(-modifiedEdgeSpacing)
        }

        infoTableStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(buttonStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(infoStackEdgeSpacing)
            make.right.equalTo(contentView).offset(-infoStackEdgeSpacing)
        }

        eventMapViewWrapper.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(infoTableStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
            make.height.equalTo(mapViewHeight)
        }
        eventMapViewWrapper.addSubview(eventMapView)
        eventMapView.snp.makeConstraints { make in
            make.edges.equalTo(eventMapViewWrapper)
        }
        eventMapDirectionsBar.backgroundColor = UIColor.white
        eventMapDirectionsBar.layer.opacity = mapViewDirectionsBarOpacity
        eventMapViewWrapper.addSubview(eventMapDirectionsBar)
        eventMapDirectionsBar.snp.makeConstraints { make in
            make.height.equalTo(mapViewDirectionsBarHeight)
            make.bottom.equalTo(eventMapViewWrapper)
            make.left.equalTo(eventMapViewWrapper)
            make.right.equalTo(eventMapViewWrapper)
        }
        eventMapDirectionsBar.addSubview(eventMapViewDirectionsButton)
        eventMapViewDirectionsButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        eventMapViewDirectionsButton.setTitle(NSLocalizedString("event-details-directions-button", comment: ""), for: .normal)
        eventMapViewDirectionsButton.snp.makeConstraints { make in
            make.right.equalTo(eventMapDirectionsBar).offset(-directionsButtonRightSpacing)
            make.centerY.equalTo(eventMapDirectionsBar)
        }
        eventMapViewDirectionsButton.addTarget(self, action: #selector(self.directionsButtonPressed(_:)), for: .touchUpInside)

        tagScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventMapViewWrapper.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
            make.height.equalTo(tagScrollViewHeight)
            make.bottom.equalTo(contentView)
        }

        tagStack.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(tagScrollView)
        }

    }

    /* Allow client to configure the event detail page by passing in an event object */
    func configure(with eventPk: Int) {
        let event = AppData.getEvent(pk: eventPk, startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController), endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController), noConnection: GenericLoadingHelper.noConnection(from: self), updateData: true)
        self.event = event
        if let user = UserData.getLoggedInUser() {
            if user.bookmarkedEvents.contains(event.id) {
                bookmarkedButton.backgroundColor = UIColor(named: "primaryPink")
                bookmarkedButton.setTitle(NSLocalizedString("bookmarked-button-clicked", comment: ""), for: .normal)
                bookmarkedButton.setTitleColor(UIColor.white, for: .normal)
                bookmarkedButton.tintColor = UIColor.white
                bookmarkedButton.setImage(UIImage(named: "filledbookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }
        _ = UserData.addClickForEvent(event: event)
        eventImage.kf.setImage(with: event.eventImage)

        eventName.text = event.eventName
        eventDescriptionShowMoreButton.setTitle(NSLocalizedString("description-more-button", comment: ""), for: .normal)
        eventDescription.text = event.eventDescription
        eventDescriptionShowMoreButton.isHidden = !eventDescription.isTruncated()
        eventTime.text = DateFormatHelper.formatDateRange(from: event.startTime, to: event.endTime)

        eventOrganizer.text = AppData.getOrganization(
            by: event.eventOrganizer,
            startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController),
            endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController),
            noConnection: GenericLoadingHelper.noConnection(from: self),
            updateData: false).name
        eventOrganizer.textColor = UIColor(named: "primaryPink")
        eventLocation.text = AppData.getLocationPlaceIdTuple(by: event.eventLocation,
                                                             startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController),
                                                             endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController),
                                                             noConnection: GenericLoadingHelper.noConnection(from: self),
                                                             updateData: false).0
        
        if eventLocation.text?.contains("http") ?? false {
            let eventLocationTapGesture = UITapGestureRecognizer(target: self, action: #selector(eventLocationPressed(_:)))
            eventLocView.addGestureRecognizer(eventLocationTapGesture)
            eventLocView.isUserInteractionEnabled = true
            let attributedString = NSMutableAttributedString.init(string: eventLocation.text ?? "")
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                NSRange.init(location: 0, length: attributedString.length))
            eventLocation.attributedText = attributedString
        }
        eventParticipantCount.text = "\(event.eventParticipantCount) \(NSLocalizedString("participant-going", comment: ""))"
        configureMap(event)

        for tagPk in event.eventTags {
            let tagButton = EventTagButton()
            tagButton.setTag(with: tagPk)
            tagButton.addTarget(self, action: #selector(self.tagButtonPressed(_:)), for: .touchUpInside)
            tagStack.addArrangedSubview(tagButton)
        }

    }

    func configureMap(_ event: Event) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
        placesClient.fetchPlace(fromPlaceID: event.location.placeId, placeFields: fields, sessionToken: nil, callback: { (result: GMSPlace?, error: Error?) in
            if let error = error {
                print(error)
                self.eventMapViewWrapper.isHidden = true
                if let constraint = (self.eventMapViewWrapper.constraints.filter {$0.firstAttribute == .height}.first) {
                    constraint.constant = 0
                    self.view.layoutIfNeeded()
                }
                return
                } else {
                if let result = result {
                    self.mapLocation = result.coordinate
                    self.eventMapView.moveCamera(GMSCameraUpdate.fit(result.viewport!))
                    let mapMarker = GMSMarker(position: result.coordinate)
                    mapMarker.map = self.eventMapView
                    self.eventMapView.selectedMarker = mapMarker
                }
            }
        })
    }

    /**
     Handler for pressing the directions button in the map. Should open google maps (if installed) or apple maps and shows the desired location.
     - sender: the sender of the action
     */
    @objc func directionsButtonPressed(_ sender: UIButton) {
        if let mapLocation = mapLocation {
            let url: URL
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                url = URL(string: "comgooglemaps://center=?q=\(mapLocation.latitude),\(mapLocation.longitude)")!
            } else {
                url = URL(string: "http://maps.apple.com/?q=\(mapLocation.latitude),\(mapLocation.longitude)")!
            }
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }

    /**
     Handler for the pressing action of the organization name. Should segue to the correct organization page.
     - sender: the sender of the action
     */
    @objc func orgNamePressed(_ sender: UITapGestureRecognizer) {
        if let event = event {
            let org = AppData.getOrganization(by: event.eventOrganizer, startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: false)
            if org.email != "donotdisplay@cornell.edu" {
                let orgController = OrganizationViewController()
                orgController.configure(organizationPk: event.eventOrganizer)
                navigationController?.pushViewController(orgController, animated: true)
            }
        }

    }

    @objc func eventLocationPressed(_ sender: UITapGestureRecognizer) {
        var eventLocationText = eventLocation.text
        eventLocationText = eventLocationText?.trimmingCharacters(in: .whitespaces)
        eventLocationText = eventLocationText?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("eventloc", eventLocationText)
        if let url = URL(string: eventLocationText!) {
            UIApplication.shared.open(url)
        }
    }

    /**
     Handler for the pressing action of tag buttons. Should segue to the correct tagview controller.
     - sender: the sender of the action.
     */
    @objc func tagButtonPressed(_ sender: UIButton) {
        if let tagButton = sender as? EventTagButton {
            let tag = tagButton.getTagPk()
            Analytics.logEvent("tagButtonPressed", parameters: [
                "tagName": tagButton.titleLabel?.text ?? ""
                ])
            let tagViewController = TagViewController()
            //GoogleAnalytics.trackEvent(category: "button click", action: "tag", label: String(tag))
            tagViewController.setup(with: AppData.getEventsAssociatedWith(tag: tag), for: tag)
            navigationController?.pushViewController(tagViewController, animated: true)
        }
    }

    /**
     Handler for the pressing action of the back button floating at the top left of the page. Should navigate back to the previous page.
     */
    @objc func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func changeAttendance(_ sender: UIButton) {
        bookmarkedButton.isEnabled = false
        var success = false
        let group = DispatchGroup()

        group.enter()
        if let user = UserData.getLoggedInUser() {
            if let event = event {
                Internet.changeAttendance(serverToken: user.serverAuthToken!, id: event.id, attend: bookmarkedButton.backgroundColor == UIColor.white) { result in
                        success = result
                        group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            if success {
                self.bookmarkedButtonPressed()
                if let event = self.event {
                    _ = AppData.getEvent(pk: event.id, startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: self.loadingViewController), endLoading: GenericLoadingHelper.endLoading(loadingVC: self.loadingViewController), noConnection: GenericLoadingHelper.noConnection(from: self), updateData: true)
                }
            }
            self.bookmarkedButton.isEnabled = true
        }
    }
    /**
    Handler for adding or deleting events to the user's iCal
    */
    func addorDeleteEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, bookmarked: Bool, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
         let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                var eventExists = false
                var identifier = ""
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                let existingEvents = eventStore.events(matching: predicate)
                for ev in existingEvents {
                    if ev.title == title && ev.startDate == startDate && ev.endDate == endDate {
                        eventExists = true
                        identifier = ev.eventIdentifier
                        break
                    }
                }
                do {
                    if !eventExists && bookmarked {
                        try eventStore.save(event, span: .thisEvent)
                    } else if eventExists && !bookmarked {
                        if let calEvToDelete = eventStore.event(withIdentifier: identifier) {
                            try eventStore.remove(calEvToDelete, span: .thisEvent, commit: true)
                        }
                    }
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    /**
     Handler for the pressing action of the bookmark button. Should change the color of the button and add it to the user's bookmarked list.
     */
    func bookmarkedButtonPressed() {
        let center = UNUserNotificationCenter.current()
        if var user = UserData.getLoggedInUser() {
            if bookmarkedButton.backgroundColor == UIColor.white {
                bookmarkedButton.backgroundColor = UIColor(named: "primaryPink")
                bookmarkedButton.setTitle(NSLocalizedString("bookmarked-button-clicked", comment: ""), for: .normal)
                bookmarkedButton.setTitleColor(UIColor.white, for: .normal)
                bookmarkedButton.tintColor = UIColor.white
                bookmarkedButton.setImage(UIImage(named: "filledbookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
                Analytics.logEvent("bookmarked", parameters: [
                    "eventName": event?.eventName ?? ""
                    ])
                if let event = event {
                    if !user.bookmarkedEvents.contains(event.id) {
                        user.bookmarkedEvents.append(event.id)
                        addorDeleteEventToCalendar(title: event.eventName, description: event.eventDescription, startDate: event.startTime, endDate: event.endTime, bookmarked: true)
                    }
                    if user.reminderEnabled {
                        let content = UNMutableNotificationContent()
                        content.title = NSLocalizedString("notification-title", comment: "")
                        content.body = "\(NSLocalizedString("notification-body-1", comment: "")) \(event.eventName)\(NSLocalizedString("notification-body-2", comment: ""))"
                        content.sound = .default
                        let minutesBeforeEvent = ReminderTimeOptions.getValue(from: ReminderTimeOptions.getCase(by: user.reminderTime))
                        let minuteComp = DateComponents(minute: -minutesBeforeEvent)
                        let remindDate = Calendar.current.date(byAdding: minuteComp, to: event.startTime)
                        if let remindDate = remindDate {
                            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ], from: remindDate)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                                        repeats: false)
                            let notificationIdentifier = "\(NSLocalizedString("notification-identifier", comment: ""))\(event.id)"
                            let request = UNNotificationRequest(identifier: notificationIdentifier,
                                                                content: content, trigger: trigger)
                            center.add(request, withCompletionHandler: { (_) in
                            })
                            Analytics.logEvent("notificationAdded", parameters: [
                                "notificationName": eventName.description
                            ])
                        }
                    }

                }
            } else {
                bookmarkedButton.backgroundColor = UIColor.white
                bookmarkedButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
                bookmarkedButton.setTitle(NSLocalizedString("details-bookmark-button", comment: ""), for: .normal)
                bookmarkedButton.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
                bookmarkedButton.tintColor = UIColor(named: "primaryPink")
                Analytics.logEvent("unbookmarked", parameters: [
                    "eventName": event?.eventName ?? ""
                    ])
                if let event = event {
                    user.bookmarkedEvents = user.bookmarkedEvents.filter {$0 != event.id}
                    addorDeleteEventToCalendar(title: event.eventName, description: event.eventDescription, startDate: event.startTime, endDate: event.endTime, bookmarked: false)
                    let notificationIdentifier = "\(NSLocalizedString("notification-identifier", comment: ""))\(event.id)"
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
                }
            }
            _ = UserData.login(for: user)
        }
    }


    @objc func shareButtonPressed(_ sender: UIButton) {
        var textToShare = ""
        if let e = event {
            textToShare = "Come checkout \(e.eventName) at \(e.location.building) in room \(e.location.room) from \(DateFormatHelper.datetime(from: e.startTime)) to \(DateFormatHelper.datetime(from: e.endTime)). \(e.eventDescription) View this event on cue, the best app to find events on Cornell's campus."
        }
        if let eventDeepLink = URL(string: Endpoint.getURLString(address: .eventDeepLink, queryParams: [Endpoint.QueryParam.eventPk : String(event?.id ?? 1)])),
            let orgDeepLink = URL(string: Endpoint.getURLString(address: .organizationDeepLink, queryParams: [.organizationPk: String(event?.eventOrganizer ?? 1)])){
            let objectsToShare:[Any] = [textToShare, eventDeepLink, orgDeepLink ]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //

            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
        //Ganalytics
       // GoogleAnalytics.trackEvent(category: "button click", action: "share", label: "event detail page")
    }

    /**
     Handler for the pressing action of the "more" button under event description. Should extend event description or shrink.
     */
    @objc func detailsMoreButtonPressed(_ sender: UIButton) {
        eventDescription.numberOfLines = eventDescription.numberOfLines == 0 ? defaultDescriptionLines : 0
        eventDescriptionShowMoreButton.setTitle(eventDescription.numberOfLines == 0 ? NSLocalizedString("description-less-button", comment: "") : NSLocalizedString("description-more-button", comment: ""), for: .normal)
    }

    //scrollview delegate method. Will be triggered when scrollview scrolled.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if statusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            statusBarHidden = shouldHideStatusBar
        }
    }

    //hide status bar when the image is scrolled over
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }

    private var shouldHideStatusBar: Bool {
        let height = scrollView.contentOffset.y + statusBarHeight * 2
        return height >= imageViewHeight
    }

    //Delegate method of UIGestureRecognizer. Used to enable swipe left to return
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
