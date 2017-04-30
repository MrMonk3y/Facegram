//
//  ProfileController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 17.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

enum ActionButtonState: String {
    case CurrentUser = "Edit Profile"
    case NotFollowing = "+ Follow"
    case Following = "✔ Following"
}

class ProfileController: UIViewController {
    @IBOutlet weak var profilePic:UIImageView!
    @IBOutlet weak var postLabel:UILabel!
    @IBOutlet weak var followersLabel:UILabel!
    @IBOutlet weak var followingLabel:UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var profileUsername = Profile.currentUser?.username // Show currentUser by default
    var userProfile: Profile? // Fetch a user's profile if necessary
    var actionButtonState: ActionButtonState = .CurrentUser {
        willSet(newState) {
            switch newState {
            case .CurrentUser:
                actionButton.backgroundColor = UIColor.rawColor(red: 228, green: 228, blue: 228, alpha: 1.0)
                actionButton.layer.borderWidth = 1
            case .NotFollowing:
                actionButton.backgroundColor = UIColor.white
                actionButton.layer.borderColor = UIColor.rawColor(red: 18, green: 86, blue: 136, alpha: 1.0).cgColor
                actionButton.layer.borderWidth = 1
            case .Following:
                actionButton.backgroundColor = UIColor.rawColor(red: 111, green: 187, blue: 82, alpha: 1.0)
                actionButton.layer.borderWidth = 0
            }
            actionButton.setTitle(newState.rawValue, for: UIControlState())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.layer.cornerRadius = 3
        profilePic.layer.cornerRadius = 40 // Heigth and Width in storyboard is 80
        profilePic.layer.masksToBounds = true // Required for UIImageView to hide the clip portioned
        guard let username = profileUsername else {
            print("Np username for ProfileController")
            return
        }
        userProfile = Profile.currentUser
        if username == Profile.currentUser?.username {
            //Update profile ui
            updateProfile()
        } else {
            logoutButton.isEnabled = false
            logoutButton.tintColor = UIColor.clear
        }
        profileRef.child(username).observeSingleEvent(of: .value, with: { snapshot in
            guard let profile = snapshot.value as? [String: AnyObject] else {
                return
            }
            self.userProfile = Profile.initWithUsername(username, profileDict: profile)
            if username != Profile.currentUser?.username {
                if self.userProfile!.followers.contains(Profile.currentUser!.username) {
                   // Following
                    self.actionButtonState = .Following
                } else {
                   // Not Following
                    self.actionButtonState = .NotFollowing
                }
              }
            self.updateProfile()
            }, withCancel: {error in
                print("Problem loading \(self.profileUsername)'s profile \(error.localizedDescription)")
    })
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = profileUsername
    }
    
    func updateProfile() {
        postLabel.text = "\(userProfile!.posts.count)"
        followersLabel.text = "\(userProfile!.followers.count)"
        followingLabel.text = "\(userProfile!.following.count)"
        if let profPic = userProfile?.picture {
            profilePic.image = profPic
        }
    }
    
    @IBAction func editProfile(_ sender: AnyObject) {
        print("user wants to edit their profile")
        switch actionButtonState {
        case .CurrentUser:
            let actioSheet = UIAlertController(title: "Edit Profile", message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let photoAction = UIAlertAction(title: "Change Photo", style: .default, handler: { action in
            let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            })
            actioSheet.addAction(cancelAction)
            actioSheet.addAction(photoAction)
            present(actioSheet, animated: true, completion: nil)
        case .NotFollowing:
            actionButtonState = .Following
            Profile.currentUser?.following.append(userProfile!.username)
            userProfile?.followers.append(Profile.currentUser!.username)
            userProfile?.sync()
            Profile.currentUser?.sync()
        case .Following:
            actionButtonState = .NotFollowing
            if let index = Profile.currentUser?.following.index(of: profileUsername!) {
            Profile.currentUser?.following.remove(at: index)
            }
            if let index = userProfile?.followers.index(of: (Profile.currentUser?.username)!) {
                userProfile?.followers.remove(at: index)
            }
            userProfile?.sync()
            Profile.currentUser?.sync()
        }
    }
    
    @IBAction func logouutTapped(_ sender: UIBarButtonItem) {
        postRef.removeAllObservers()
        tabBarController?.dismiss(animated: true, completion: nil) // dismiss the centerTabBarController
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userProfile?.picture = info[UIImagePickerControllerEditedImage] as? UIImage
        profilePic.image = userProfile?.picture
        userProfile?.sync()
        picker.dismiss(animated: true, completion: nil)
    }
}
