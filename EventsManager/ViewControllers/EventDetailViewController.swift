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

class EventDetailViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate{
    
    //Constants
    let buttonHeight:CGFloat = 45
    let standardEdgeSpacing:CGFloat = 20
    let imageViewHeight:CGFloat = 220
    let buttonStackInnerSpacing:CGFloat = 15
    let infoStackEdgeSpacing:CGFloat = 40
    let iconSideLength:CGFloat = 25
    let infoStackIconLabelSpacing:CGFloat = 20
    let infoTableSpacing:CGFloat = 12
    let eventDescriptionFontSize = CGFloat(integerLiteral: 16)
    let mapViewHeight = CGFloat(integerLiteral: 140)
    let tagScrollViewHeight = CGFloat(integerLiteral: 50)
    let tagHorizontalSpacing = CGFloat(integerLiteral: 8)
    let tagLabelFontSize = CGFloat(integerLiteral: 22)
    let eventImageGradientOpcaity:Float = 0.3
    let eventImageGradientStartPoint = CGPoint(x: 0.5, y: 0.0)
    let eventImageGradientEndPoint = CGPoint(x: 0.5, y: 1.0)
    let floatingButtonSideLength:CGFloat = 35
    let floatingButtonSideSpacing:CGFloat = 20
    let floatingButtonTopSpacing:CGFloat = 8
    let backButtonLeftInset:CGFloat = 10
    let backButtonTopBottomInset:CGFloat = 7
    let backButtonRightInset:CGFloat = 0
    let shareButtonInset:CGFloat = 7
    let shadowOpacity:Float = 0.6
    let shadowRadius:CGFloat = 5
    let shadowOffset = CGSize(width: 1.5, height: 1.5)
    let eventTitleFontSize:CGFloat = 18
    let defaultDescriptionLines = 3
    let defaultTitleLines = 2
    
    //datasource
    var event:Event?
    
    //view elements
    var scrollView = UIScrollView()
    var contentView = UIView()
    let eventImageContainerView = UIView();
    var eventImage = UIImageView()
    var interestedButton = UIButton()
    var goingButton = UIButton()
    let eventName = UILabel()
    let eventDescription = UILabel()
    let eventDescriptionShowMoreButton = UIButton()
    var eventTime = UILabel()
    var eventParticipantCount = UILabel()
    var eventOrganizer = UILabel()
    var eventLocation = UILabel()
    var eventMapView = MKMapView()
    var tagScrollView = UIScrollView()
    var tagStack = UIStackView()
    let backButton = UIButton()
    let shareButton = UIButton()
    
    var statusBarHeight:CGFloat = 0
    var statusBarHidden:Bool = false
    
    
    //Hide and show the nav bar on entering and exiting the details page.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
    func setLayouts(){
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
        backButton.imageEdgeInsets = UIEdgeInsets(top: backButtonTopBottomInset, left: backButtonLeftInset, bottom: backButtonTopBottomInset, right: backButtonRightInset)
        backButton.tintColor = UIColor(named: "primaryBlue")
        backButton.layer.cornerRadius = floatingButtonSideLength / 2
        backButton.layer.shadowColor = UIColor.gray.cgColor
        backButton.layer.shadowOpacity = shadowOpacity
        backButton.layer.shadowRadius = shadowRadius
        backButton.layer.shadowOffset = shadowOffset
        backButton.addTarget(self, action: #selector(self.backButtonPressed(_:)), for: .touchUpInside)
        
        shareButton.backgroundColor = UIColor.white
        var shareButtonIcon = #imageLiteral(resourceName: "share")
        shareButtonIcon = shareButtonIcon.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareButtonIcon, for: .normal)
        shareButton.tintColor = UIColor(named: "primaryBlue")
        shareButton.imageEdgeInsets = UIEdgeInsets(top: shareButtonInset, left: shareButtonInset, bottom: shareButtonInset, right: shareButtonInset)
        shareButton.layer.cornerRadius = floatingButtonSideLength / 2
        shareButton.layer.shadowColor = UIColor.gray.cgColor
        shareButton.layer.shadowOpacity = shadowOpacity
        shareButton.layer.shadowRadius = shadowRadius
        shareButton.layer.shadowOffset = shadowOffset
        
        //interested and going buttons
        interestedButton.layer.shadowColor = UIColor.gray.cgColor
        interestedButton.layer.shadowOpacity = shadowOpacity
        interestedButton.layer.shadowRadius = shadowRadius
        interestedButton.layer.shadowOffset = shadowOffset
        interestedButton.backgroundColor = UIColor.white
        interestedButton.setTitleColor(UIColor(named: "primaryBlue"), for: .normal)
        goingButton.backgroundColor = UIColor(named: "primaryBlue")
        goingButton.setTitleColor(UIColor.white, for: .normal)
        interestedButton.layer.cornerRadius = buttonHeight / 2
        goingButton.layer.cornerRadius = buttonHeight / 2
        interestedButton.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(buttonHeight)
        }
        goingButton.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(buttonHeight)
        }
        let buttonStack = UIStackView(arrangedSubviews: [interestedButton, goingButton])
        buttonStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = buttonStackInnerSpacing
        
        //Name and description
        eventName.numberOfLines = defaultTitleLines
        eventName.font = UIFont.boldSystemFont(ofSize: eventTitleFontSize)
        eventName.textAlignment = .center
        
        eventDescriptionShowMoreButton.setTitleColor(UIColor(named: "primaryBlue"), for: .normal)
        eventDescriptionShowMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: eventDescriptionFontSize)
        eventDescriptionShowMoreButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0, right: 0.01)
        eventDescriptionShowMoreButton.addTarget(self, action: #selector(detailsMoreButtonPressed(_:)), for: .touchUpInside)
        eventDescription.numberOfLines = defaultDescriptionLines
        eventDescription.textColor = UIColor.gray
        eventDescription.textAlignment = .justified
        eventDescription.font = UIFont.systemFont(ofSize: eventDescriptionFontSize)
        
        //table of info
        let calendarIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        calendarIcon.image = #imageLiteral(resourceName: "calender")
        calendarIcon.snp.makeConstraints{make in
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
        participantIcon.snp.makeConstraints{make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let participantStack = UIStackView(arrangedSubviews: [participantIcon, eventParticipantCount])
        participantStack.alignment = .center
        participantStack.axis = .horizontal
        participantStack.distribution = .fill
        participantStack.spacing = infoStackIconLabelSpacing
        
        let organizerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        organizerIcon.image = #imageLiteral(resourceName: "building")
        organizerIcon.snp.makeConstraints{make in
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
        locationIcon.image = #imageLiteral(resourceName: "location")
        locationIcon.snp.makeConstraints{make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let locationStack = UIStackView(arrangedSubviews: [locationIcon, eventLocation])
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
        contentView.addSubview(buttonStack)
        contentView.addSubview(eventName)
        contentView.addSubview(eventDescription)
        contentView.addSubview(eventDescriptionShowMoreButton)
        contentView.addSubview(infoTableStack)
        contentView.addSubview(eventMapView)
        contentView.addSubview(tagScrollView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        
        //Constraints for UI elements
        backButton.snp.makeConstraints{ make in
            make.width.equalTo(floatingButtonSideLength)
            make.height.equalTo(floatingButtonSideLength)
            make.left.equalTo(view).offset(floatingButtonSideSpacing)
            make.top.equalTo(view).offset(floatingButtonTopSpacing + statusBarHeight)
        }
        
        shareButton.snp.makeConstraints{ make in
            make.width.equalTo(floatingButtonSideLength)
            make.height.equalTo(floatingButtonSideLength)
            make.right.equalTo(view).offset(-floatingButtonSideSpacing)
            make.top.equalTo(view).offset(floatingButtonTopSpacing + statusBarHeight)
        }
        
        eventImageContainerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(imageViewHeight).priority(.required)
        }
        
        eventImage.snp.makeConstraints{make in
            make.top.equalTo(view)
            make.left.equalTo(eventImageContainerView)
            make.right.equalTo(eventImageContainerView)
            make.bottom.equalTo(eventImageContainerView)
        }
        
        
        buttonStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventImageContainerView.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        
        eventName.snp.makeConstraints{ make in
            make.top.equalTo(buttonStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        
        eventDescription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventName.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        eventDescriptionShowMoreButton.snp.makeConstraints{ make in
            make.top.equalTo(eventDescription.snp.bottom)
            make.right.equalTo(eventDescription.snp.right)
        }
        
        infoTableStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventDescriptionShowMoreButton.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(infoStackEdgeSpacing)
            make.right.equalTo(contentView).offset(-infoStackEdgeSpacing)
        }
        
        eventMapView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(infoTableStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
            make.height.equalTo(mapViewHeight)
        }
        
        tagScrollView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(eventMapView.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
            make.height.equalTo(tagScrollViewHeight)
            make.bottom.equalTo(contentView)
        }
        
        tagStack.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(tagScrollView)
        }
        
        
}
    
    /* Allow client to configure the event detail page by passing in an event object */
    func configure(with event:Event){
        self.event = event
        
        eventImage.kf.setImage(with: event.eventImage)
        interestedButton.setTitle(NSLocalizedString("interested-button", comment: ""), for: .normal)
        goingButton.setTitle(NSLocalizedString("going-button", comment: ""), for: .normal)
        
        eventName.text = event.eventName
        eventDescriptionShowMoreButton.setTitle(NSLocalizedString("description-more-button", comment: ""), for: .normal)
        eventDescription.text = event.eventDescription
        eventTime.text = "\(NSLocalizedString("from", comment: "")) \(DateFormatHelper.hourMinute(from: event.startTime)) \(NSLocalizedString("to", comment: "")) \(DateFormatHelper.hourMinute(from: event.endTime))"
        eventOrganizer.text = event.eventOrganizer
        eventLocation.text = event.eventLocation
        eventParticipantCount.text = "\(event.eventParticipantCount) \(NSLocalizedString("participant-going", comment: ""))"
        
        for tag in event.eventTags {
            let tagButton = EventTagButton()
            tagButton.setTitle(tag, for: .normal)
            tagButton.addTarget(self, action: #selector(self.tagButtonPressed(_:)), for: .touchUpInside)
            tagStack.addArrangedSubview(tagButton)
        }
        
    }
    
    /**
     Handler for the pressing action of the organization name. Should segue to the correct organization page.
     - sender: the sender of the action
     */
    @objc func orgNamePressed(_ sender: UITapGestureRecognizer){
        let testOrg = Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org")
        let orgController = OrganizationViewController()
        orgController.configure(organization: testOrg)
        navigationController?.pushViewController(orgController, animated: true)
    }
    
    /**
      Handler for the pressing action of tag buttons. Should segue to the correct tagview controller.
      - sender: the sender of the action.
     */
    @objc func tagButtonPressed(_ sender: UIButton) {
        let tagViewController = TagViewController()
        if let tagButton = sender as? EventTagButton {
            let tag = tagButton.getTagName()
            if let rootViewEventsDiscoveryController = navigationController?.viewControllers.first as? EventsDiscoveryController {
                tagViewController.setup(with: rootViewEventsDiscoveryController.events, for: tag)
                navigationController?.pushViewController(tagViewController, animated: true)
            }
        }
    }
    
    /**
     Handler for the pressing action of the back button floating at the top left of the page. Should navigate back to the previous page.
    */
    @objc func backButtonPressed(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    /**
     Handler for the pressing action of the "more" button under event description. Should extend event description or shrink.
     */
    @objc func detailsMoreButtonPressed(_ sender:UIButton){
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
    
    private var shouldHideStatusBar:Bool {
        let height = scrollView.contentOffset.y + statusBarHeight * 2
        return height >= imageViewHeight
    }
    
    //Delegate method of UIGestureRecognizer. Used to enable swipe left to return
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
