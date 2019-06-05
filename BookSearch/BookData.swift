//
//  BookData.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/05.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BookData: NSObject {
    var id: String?
    var title: String?
    var image: UIImage?
    var smallImageUrl: String?
    var mediumImageUrl: String?
    var largeImageUrl: String?
    var author: String?
    var salesDate: Date?
    var publisherName: String?
    var itemPrice: Int?
    var itemCaption: String?
    
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        smallImageUrl = valueDictionary["image"] as? String
        mediumImageUrl = valueDictionary["image"] as? String
        largeImageUrl = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: smallImageUrl!, options: .ignoreUnknownCharacters)!)
        image = UIImage(data: Data(base64Encoded: mediumImageUrl!, options: .ignoreUnknownCharacters)!)
        image = UIImage(data: Data(base64Encoded: largeImageUrl!, options: .ignoreUnknownCharacters)!)
        
        self.title = valueDictionary["title"] as? String
        self.author = valueDictionary["author"] as? String
        
        let time = valueDictionary["time"] as? String
        self.salesDate = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        self.publisherName = valueDictionary["pubilsherName"] as? String
        self.itemPrice = valueDictionary["itemPrice"] as? Int
        self.itemCaption = valueDictionary["itemCaption"] as? String
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
    }
}
