//
//  ItemData.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/11.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ItemData: NSObject {
    var id: String?
    var title: String?
    var size: String?
    var author: String?
    var isbn: String?
    var publisherName: String?
    var itemPrice: Int?
    var itemCaption: String?
    var salesDate: String?
    var reviewAverage: String?
    var mediumImageUrl: String?
    var largeImageUrl: String?
    var isLiked: Bool = false
    
    init(data: [String: Any]) {
        self.title = data["title"] as? String ?? ""
        self.size = data["size"] as? String ?? ""
        self.author = data["author"] as? String ?? ""
        self.isbn = data["isbn"] as? String ?? ""
        self.publisherName = data["publisherName"] as? String ?? ""
        self.itemPrice = data["itemPrice"] as? Int ?? 0
        self.itemCaption = data["itemCaption"] as? String ?? ""
        self.salesDate = data["salesDate"] as? String ?? ""
        self.reviewAverage = data["reviewAverage"] as? String  ?? ""
        self.mediumImageUrl = data["mediumImageUrl"] as? String ?? ""
        self.largeImageUrl = data["largeImageUrl"] as? String ?? ""
        
        /*
        print("😄\(mediumImageUrl)")
        print(title)
        print(publisherName)
        print(itemPrice)
        */
    }
    
    var postData: [String: Any] {
        return ["title": self.title!,
                "size": self.size!,
                "author": self.author!,
                "isbn": self.isbn!,
                "itemCaption": self.itemCaption!,
                "publisherName": self.publisherName!,
                "itemPrice": self.itemPrice!,
            "reviewAverage": self.reviewAverage!,
            "salesDate": self.salesDate!,
            "mediumImageUrl": self.mediumImageUrl!,
            "largeImageUrl": self.largeImageUrl!]
    }
    
    /*
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        let valueDictionary = snapshot.value as! [String: Any]
        print(id)
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
    }*/
}
