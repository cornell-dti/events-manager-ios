//
//  LoginViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/18/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import GoogleSignIn
import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        view.backgroundColor = UIColor.white
        let signinButton = GIDSignInButton()
        view.addSubview(signinButton)
        signinButton.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            if let user = UserData.newUser(from: user) {
                if UserData.login(for: user) {
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = TabBarViewController()
                    (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
    }
    
    
    

}
