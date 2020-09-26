//
//  LoginViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/18/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import GoogleSignIn
import UIKit

class LoginViewController: UIViewController, GIDSignInDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //constants
    let iconSpacingFromTop: CGFloat = 130
    let iconSideLength: CGFloat = 120
    let stackInnerSpacing: CGFloat = 0
    let appLabelFontSize: CGFloat = 50
    let appIntroFontSize: CGFloat = 22
    let introIconSpacing: CGFloat = 30
    let buttonIntroSpacing: CGFloat = 70
    let sideSpacing: CGFloat = 50
    let poweredByFontSize: CGFloat = 16
    let signatureFontSize: CGFloat = 18
    let signatureLeftSpacing: CGFloat = 20
    let signatureVerticleSpacing: CGFloat = 5
    let signatureBottomSpacing: CGFloat = 15
    let signinButtonHeight: CGFloat = 40
    let signinButtonFontSize: CGFloat = 18
    let signInButtonCornerRadius: CGFloat = 5

    //view elements
    let signinButton = UIButton()
    let appIcon = UIImageView()
    let appLabel = UILabel()
    let appIntro = UILabel()
    let powerByLabel = UILabel()
    let signatureLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setLayouts()
        configure()
    }

    /**
     Sets the basic layout of the view
     */
    func setLayouts() {
        view.backgroundColor = UIColor(named: "primaryPink")
        view.addSubview(signinButton)
        signinButton.backgroundColor = .white
        signinButton.setTitle(NSLocalizedString("get-started", comment: ""), for: .normal)
        signinButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        signinButton.addTarget(self, action: #selector(getStarted(_:)), for: .touchUpInside)
        signinButton.titleLabel?.font = UIFont(name: "SFProText-Light", size: signinButtonFontSize)
        signinButton.layer.cornerRadius = signInButtonCornerRadius
        let appIconAndNameStack = UIStackView(arrangedSubviews: [appIcon, appLabel])
        appIconAndNameStack.alignment = .center
        appIconAndNameStack.distribution = .fill
        appIconAndNameStack.axis = .horizontal
        appIconAndNameStack.spacing = stackInnerSpacing

        appIcon.snp.makeConstraints { make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        appLabel.font = UIFont(name: "SFProText-SemiBold", size: appLabelFontSize)
        appIntro.font = UIFont(name: "SFProText-Light", size: appIntroFontSize)
        appLabel.textColor = UIColor.white
        appIntro.textColor = UIColor.white
        appIntro.textAlignment = .center
        appIntro.numberOfLines = 0

        view.addSubview(appIconAndNameStack)
        view.addSubview(appIntro)

        appIconAndNameStack.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(iconSpacingFromTop)
        }

        appIntro.snp.makeConstraints { make in
            make.top.equalTo(appIconAndNameStack.snp.bottom).offset(introIconSpacing)
            make.left.equalTo(view).offset(sideSpacing)
            make.right.equalTo(view).offset(-sideSpacing)
        }

        signinButton.snp.makeConstraints { make in
            make.top.equalTo(appIntro.snp.bottom).offset(buttonIntroSpacing)
            make.left.equalTo(view).offset(sideSpacing)
            make.right.equalTo(view).offset(-sideSpacing)
            make.height.equalTo(signinButtonHeight)
        }

        view.addSubview(powerByLabel)
        view.addSubview(signatureLabel)
        powerByLabel.textColor = UIColor.white
        powerByLabel.font = UIFont(name: "SFProText-Regular", size: poweredByFontSize)
        signatureLabel.textColor = UIColor.white
        signatureLabel.font = UIFont(name: "SFProText-Regular", size: signatureFontSize)

        signatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-signatureBottomSpacing)
            make.left.equalTo(view).offset(signatureLeftSpacing)
        }

        powerByLabel.snp.makeConstraints { make in
            make.bottom.equalTo(signatureLabel.snp.top).offset(-signatureVerticleSpacing)
            make.left.equalTo(view).offset(signatureLeftSpacing)
        }
    }

    /** Set values for view elements */
    func configure() {
        appIcon.image = UIImage(named: "logo")
        appLabel.text = NSLocalizedString("app-name", comment: "")
        appIntro.text = NSLocalizedString("app-intro", comment: "")
        powerByLabel.text = NSLocalizedString("app-powered-by", comment: "")
        signatureLabel.text = NSLocalizedString("app-signature", comment: "")
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            Alert.informative(with: NSLocalizedString("google-signin-error", comment: ""), with: NSLocalizedString("error", comment: ""), from: self)
            print("\(error.localizedDescription)")
        } else {
            let loadingViewController = LoadingViewController()
            loadingViewController.configure(with: "Logging You In...")
            present(loadingViewController, animated: true, completion: {
                if var user = UserData.newUser(from: user) {
                    user.serverAuthToken = ""
                    loadingViewController.dismiss(animated: true, completion: {
                        if UserData.login(for: user) {
                            self.present(UINavigationController(rootViewController: OnBoardingViewController()), animated: true, completion: nil)
                        }
                    })
                    Internet.getServerAuthToken(for: user.googleIdToken, { (serverAuthToken) in
                        if serverAuthToken == nil {
                            loadingViewController.dismiss(animated: true, completion: {
                                UserData.logOut()
                                Alert.informative(with: NSLocalizedString("backend-signin-error", comment: ""), with: NSLocalizedString("error", comment: ""), from: (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!)

                            })
                        } else {
                            user.serverAuthToken = serverAuthToken!
                            loadingViewController.dismiss(animated: true, completion: {
                                if UserData.login(for: user) {
                                    self.present(UINavigationController(rootViewController: OnBoardingViewController()), animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            })
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.

    }
    @objc func getStarted(_ sender: UIButton) {
        let user = UserData.tempUser()!
        _ = UserData.login(for: user)
        self.present(UINavigationController(rootViewController: OnBoardingViewController()), animated: true, completion: nil)

    }
}
