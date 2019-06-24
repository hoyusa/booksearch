//
//  FirebaseData.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/21.
//  Copyright © 2019 許 裕士. All rights reserved.
//



import UIKit
import Firebase
import FirebaseDatabase

class FirebaseData: NSObject {
    var id: String?
    var title: String?
    var size: String?
    var author: String?
    var isbn: String?
    var publisherName: String?
    var itemPrice: String?
    var itemCaption: String?
    var salesDate: String?
    var reviewAverage: String?
    var mediumImageUrl: String?
    var largeImageUrl: String?
    // var likes: [String] = []
    var isLiked: Bool = false
    
    //SwiftyJson
    /*init(_ json: JSON) {
     title = json["title"].string
     }*/
    
    init(data: [String: Any]) {
        self.title = data["title"] as? String ?? ""
        self.size = data["size"] as? String ?? ""
        self.author = data["author"] as? String ?? ""
        self.isbn = data["isbn"] as? String ?? ""
        self.publisherName = data["publisherName"] as? String ?? ""
        self.itemPrice = data["itemPrice"] as? String ?? ""
        self.itemCaption = data["itemCaption"] as? String ?? ""
        self.salesDate = data["salesDate"] as? String ?? ""
        self.reviewAverage = data["reviewAverage"] as? String  ?? ""
        self.mediumImageUrl = data["mediumImageUrl"] as? String ?? ""
        self.largeImageUrl = data["largeImageUrl"] as? String ?? ""
        
        print("😄\(mediumImageUrl)")
        print(title)
        print(publisherName)
        print(itemPrice)
        
    }
}
