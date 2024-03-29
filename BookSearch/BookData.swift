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
import SwiftyJSON

class BookData: NSObject {
    var itemArray:[ItemData] = []
    
    let url: URL = URL(string: "https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404?format=json&size=9&booksGenreId=001&applicationId=1070782050507759834")!
    
    let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
        
        guard let data = data else { return }
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else { return }
            print(json)
            
            print(json.count)
            
            guard let items = json["Items"] as? [Any] else { return }
            
            for item in items {
                guard let dic = item as? [String: Any] else { continue }
                self.itemArray.append(ItemData(data: dic))
            }
            
            /*if let items = json["Items"] as? [Any], let itemFirst = items.first as? [String: Any], let item = itemFirst["Item"] as? [String: Any] {
             let title = item["title"] as? String ?? ""
             print(title)
             }*/
            
        } catch {
            
            //エラー処理
        }
    })
    task.resume()
}

class itemData: NSObject {
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
