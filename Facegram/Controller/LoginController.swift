//
//  LoginController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 23.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    @IBOutlet weak var usernameField: TranslucentTextField!
    @IBOutlet weak var passwordField: TranslucentTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.placeholderText = "Username"
        passwordField.placeholderText = "Password"
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor.lightText.cgColor
        
        usernameField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), for: .editingChanged)

    }
    
    func textFieldDidChange(_ textfield: UITextField) {
        if let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty {
            loginButton.setTitleColor(UIColor.white, for: UIControlState())
            loginButton.isEnabled = true
        } else {
            loginButton.setTitleColor(UIColor.lightText, for: UIControlState())
            loginButton.isEnabled = false
        }
    }
    
    func login(_ email: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
                return
            } else {
                print("Signed in with uid:", user!.uid)
                let uid = user!.uid
                usernameRef.child(uid).observeSingleEvent(of: .value, with: { snapshot in
                    guard let username = snapshot.value as? String else {
                        print("No user found for \(email)")
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    profileRef.child(username).observeSingleEvent(of: .value, with: { snapshot in
                        self.activityIndicator.stopAnimating()
                        guard let profile = snapshot.value as? [String: AnyObject] else {
                            print("No profile found for user")
                            return
                        }
                    Profile.currentUser = Profile.initWithUsername(username, profileDict: profile)
                        let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let rootController = mainSB.instantiateViewController(withIdentifier: "Tabs") // Initialize CenterTabBarController
                        self.present(rootController, animated: true, completion: nil)
                    })
              })
            }
        }
        
    }
    
    @IBAction func loginTapped(_ button: UIButton!) {
        guard let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty else {
                return
        }
        activityIndicator.startAnimating()
        login(username, password: password)
    }
    
    @IBAction func signupTapped(_ button: UIButton!) {
        let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
        let registerController = mainSB.instantiateViewController(withIdentifier: "Register") as! RegisterController // Make sure to set register view controller id to ‘Register‘
        registerController.delegate = self
        present(registerController, animated: true, completion: nil)
        
    }
}

extension LoginController: RegisterControllerDelegate {
    func registerControllerDidCancel(_ controller: RegisterController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func registerControllerDidFinish(_ controller: RegisterController, withEmail email: String) {
        usernameField.text = email
        controller.dismiss(animated: true, completion: nil)
    }
}
