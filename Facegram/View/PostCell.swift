//
//  PostCell.swift
//  Facegram
//
//  Created by Sascha Jecklin on 23.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ellipsis: UIButton!
}

class PostHeaderCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
}