//
//  BookData.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/07.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON

//protocol bookDataProtocol {
//    func applyData(itemData: [ItemData])
//}

class BookData{
    
    //var itemArray:[ItemData] = []
    
    //var delegate: bookDataProtocol?
    
    func getBookData(completion: @escaping ([ItemData]?) -> Void){
        //var postArray:[ItemData] = []
        let url: URL = URL(string: "https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404?format=json&size=9&booksGenreId=001004008&sort=sales&applicationId=1070782050507759834")!
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            
            guard let data = data else { return }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else { return }
                
                print(json)
                print(json.count)
                
                guard let items = json["Items"] as? [Any] else {
                    
                    completion(nil)
                    return
                    
                }
                
                print(items.count)
                
                /*
                guard let hoge = items["Item"] as? [String: Any] else {

                    completion(nil)
                    return
                }
                */
                //print(hoge["title"])
                print("😄😄下からitemsのprintだよ😄😄")
                print(items.count)
                
                var itemArray:[ItemData] = []
                
                for item in items {
                    guard let dic = item as? [String: Any] else { continue }
//                    print(dic)
                    let hoge = dic["Item"] as! [String: Any]
          //          print(hoge["title"])
                    
                    //let hoge = ItemData(data: dic)
                    
                    itemArray.append(ItemData(data: hoge))
                    print("下がitemArrayだよ")
                    print(itemArray)
                    
                    
                    
                }
                
                completion(itemArray)
                print(itemArray)
                
                /*
               // self.delegate?.applyData(itemData: self.itemArray)
                if let items = json["Items"] as? [Any], let itemFirst = items.first as? [String: Any], let item = itemFirst["Item"] as? [String: Any] {
                    //各データを格納
                    let title = item["title"] as? String ?? ""
                    let author = item["author"] as? String ?? ""
                    let publisherName = item["publisherName"] as? String ?? ""
                    let itemPrice = item["itemPrice"] as? Int
                    let itemCaption = item["itemCaption"] as? String ?? ""
                    let salesDate = item["salesDate"] as? String ?? ""
                    let reviewAverage = item["reviewAverage"] as? String ?? ""
                    let mediumImageUrl = item["mediumImageUrl"] as? String ?? ""
                    let largeImageUrl = item["largeImageUrl"] as? String ?? ""
                    print(item)
//                    print("😄下がpostArrayだよ")
//                    postArray.append(ItemData(data: item))
//                    print(postArray)
//
                    //確認用のprint
                    print(title)
                    print(author)
                    print(publisherName)
                    print(itemPrice!)
                    print(itemCaption)
                    print(salesDate)
                    print(reviewAverage)
                    print(mediumImageUrl)
                    print(largeImageUrl)
                    
                }
 */
            } catch {
                completion(nil)
                //エラー処理
            }
            
        })
        task.resume()
    }
}
