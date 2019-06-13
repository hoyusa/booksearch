//
//  DetailsViewController.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/03.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DetailsViewController: UIViewController {
    
    var selectedImg: UIImage!
    var selectTitle: String?
    var selectAuthor: String?
    var selectPublisherName: String?
    var selectPrice: String?
    var selectCaption: String?
    var selectReviewAverage: String?
    var selectSalesDate: String?
    
    
    //↓選択したセルのデータが格納されてる
    var selectBookData: ItemData!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var reviewAverageLabel: UILabel!
    @IBOutlet weak var salesDateLabel: UILabel!
    @IBOutlet weak var itemCaptionLabel: UILabel!
    @IBOutlet weak var likeSuter: UIButton!

    @IBAction func likeButton(_ sender: Any) {
        print("likeButtonが押されたよ")
        
        //print(selectBookData.id)
        //Firebaseにデータ保存する準備
        if let uid = Auth.auth().currentUser?.uid {
            if selectBookData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in selectBookData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = selectBookData.likes.index(of: likeId)!
                        break
                    }
                }
                selectBookData.likes.remove(at: index)
            } else {
                selectBookData.likes.append(uid)
            }
            
            // 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath)
            let postDic = ["title": selectBookData.title, "author": selectBookData.author, "publisherName": selectBookData.publisherName, "itemPrice": selectBookData.itemPrice, "reviewAverage": selectBookData.reviewAverage, "salesDate": selectBookData.salesDate, "mediumImageUrl": selectBookData.mediumImageUrl, "largeImageUrl": selectBookData.largeImageUrl, "likes": selectBookData.likes, "isLiked": selectBookData.isLiked] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            /*
            // 増えたlikesをFirebaseに保存する
            print(selectBookData.id)
            let postRef = Database.database().reference().child(Const.PostPath)
            let likes = ["likes": selectBookData.likes, "isLiked": selectBookData.isLiked] as [String : Any]
            postRef.updateChildValues(likes)
        }
        */
            
        if selectBookData.isLiked {
            let buttonImage = UIImage(named: "likesuter")
            likeSuter.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "suter")
            likeSuter.setImage(buttonImage, for: .normal)
        }
    }
    
//    func setItemData(_ itemData: ItemData) {
//
//    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectTitle
        authorLabel.text = selectAuthor
        publisherNameLabel.text = selectPublisherName
        itemPriceLabel.text = ("￥\(selectPrice!)")
        reviewAverageLabel.text = selectReviewAverage
        salesDateLabel.text = selectSalesDate
        itemCaptionLabel.text = selectCaption
        
        print(selectBookData.title)
        
        imageView.image = selectedImg
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
}
