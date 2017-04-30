//
//  PostModel.swift
//  Facegram
//
//  Created by Sascha Jecklin on 15.07.16.
//  Copyright © 2016 Sascha Jecklin. All rights reserved.
//

import UIKit

class Post {
    let creator:String
    let timestamp:Date
    let image:UIImage
    let caption:String?
    let postID: String?
    static var feed:Array<Post>?
    
    init(id: String?, creator:String, image:UIImage, caption:String?) {
        self.postID = id
        self.creator = creator
        self.image = image
        self.caption = caption
        timestamp = Date()
    }
    
    static func initWithPostID(_ postID: String, postDict: [String: String]) -> Post? {
        guard let creator = postDict["creator"], let base64String = postDict["image"] else {
            // Conditions failed...
            print("Invalid Post Dictionary")
            return nil
        }
        let caption = postDict["caption"]
        let image = UIImage.imageWithBase64String(base64String)
        return Post(id: postID, creator: creator, image: image, caption: caption)
    }
    
    func dictValue() -> [String: String] {
        var postDict = [String: String]()
        postDict["creator"] = creator
        postDict["image"] = image.base64String()
        if let realCaption = caption {
            postDict["caption"] = realCaption
        }
        return postDict
    }
    
}
