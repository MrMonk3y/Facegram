//
//  FeedController.swift
//  Facegram
//
//  Created by Sascha Jecklin on 17.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

class FeedController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 208
        postRef.observe(.value, with: { snapshot in
            guard let posts = snapshot.value as? [String: [String: String]] else{
                print("No posts found")
                return
            }
            Post.feed?.removeAll()
            for (postID, post) in posts {
                let newPost = Post.initWithPostID(postID, postDict: post)!
                Post.feed?.append(newPost)
            }
            Post.feed = Post.feed?.reversed() // Recent at the top
            self.tableView.reloadData() // Refresh the fee with new data
            }, withCancel: { error in
                print(error.localizedDescription)
        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let feed = Post.feed {
            return feed.count
        } else {
            return 0
        }
    }
    
    func postIndex(_ cellIndex: Int) -> Int {
        return tableView.numberOfSections - cellIndex - 1
    
    }
    
    func showOptions(_ sender: UIButton!) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        let post = Post.feed![postIndex(indexPath.section)]
        if post.creator == Profile.currentUser!.username {
            Post.feed!.remove(at: postIndex(indexPath.section))
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert:
            UIAlertAction!) -> Void in
                let postID = post.postID!
                postRef.child(postID).removeValue(completionBlock: { error, ref in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    print("Deleted post: \(ref.description())")
                })
            })
            actionSheet.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let post = Post.feed![postIndex(section)]
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as? PostHeaderCell
        if post.creator == Profile.currentUser?.username {
            headerCell!.profilePicture.image = Profile.currentUser?.picture
        } else {
            // Set to creator's image
        }
        headerCell?.usernameButton.setTitle(post.creator, for: UIControlState())
        
        let headerView = UIView(frame: headerCell!.frame)
        headerView.addSubview(headerCell!)
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = Post.feed! [postIndex(indexPath.section)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
        cell.ellipsis?.addTarget(self, action: #selector(FeedController.showOptions(_:)),
            for: .touchUpInside)
        // im video übersprungen...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = Post.feed![postIndex(indexPath.section)]
            let aspcetRatio = post.image.size.height / post.image.size.width
            return tableView.frame.size.width * aspcetRatio + 80 //height accounting for buttons and caption
    }
    
    @IBAction func viewUseresProfile(_ sender: UIButton!) {
        let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = mainSB.instantiateViewController(withIdentifier: "Profile") as! ProfileController
        profileVC.profileUsername = sender.title(for: UIControlState())
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}
