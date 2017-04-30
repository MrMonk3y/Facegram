//
//  RegisterController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 23.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit
import Firebase

protocol RegisterControllerDelegate: class {
    func registerControllerDidCancel(_ controller: RegisterController)
    func registerControllerDidFinish(_ controller: RegisterController, withEmail email: String)
}

class RegisterController: UIViewController {
    @IBOutlet weak var emailField: TranslucentTextField!
    @IBOutlet weak var passwordField: TranslucentTextField!
    @IBOutlet weak var usernameField: TranslucentTextField!
    @IBOutlet weak var registerButton: UIButton!
    weak var delegate: RegisterControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.placeholderText = "Email"
        passwordField.placeholderText = "Password"
        usernameField.placeholderText = "Username"
        
        registerButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderColor = UIColor.lightText.cgColor
        
        emailField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), for: .editingChanged)

    }

    func textFieldDidChange(_ textfield: UITextField) {
        if let username = usernameField.text, !username.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let email = emailField.text, !email.isEmpty {
            registerButton.setTitleColor(UIColor.white, for: UIControlState())
            registerButton.isEnabled = true
        } else {
            registerButton.setTitleColor(UIColor.lightText, for: UIControlState())
            registerButton.isEnabled = false
        }
    }
    
    @IBAction func registerTapped(_ button: UIButton!) {
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty,
            let username = usernameField.text, !username.isEmpty else {
                return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Error occured during registration: \(error?.localizedDescription)")
                return
            }
            guard let uid = user!.uid as String? else {
                print("Invalid uid for user: \(email)")
                return
            }
            usernameRef.child(uid).setValue(username)
            profileRef.child(username).setValue(["username": username])
            let alertController = UIAlertController(title: "Registration Success", message: "Your account was successfully created with email \n\(email)", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Got it", style: .default, handler: { alertAction in
                // Return to login screen. Pass email back
                self.delegate?.registerControllerDidFinish(self, withEmail: email)
            })
            alertController.addAction(dismissAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginTapped(_ button: UIButton!) {
        delegate?.registerControllerDidCancel(self)
    }
}
