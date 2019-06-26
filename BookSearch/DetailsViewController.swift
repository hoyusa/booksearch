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
import SVProgressHUD

class DetailsViewController: UIViewController {
    
    var selectedImg: UIImage!
    
    //↓選択したセルのデータが格納されてる
    var selectBookData: ItemData!
    //↓お気に入り登録したデータのISBNを入れてる
    var favoriteArray:[ItemData] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var reviewAverageLabel: UILabel!
    @IBOutlet weak var salesDateLabel: UILabel!
    @IBOutlet weak var itemCaptionLabel: UILabel!
    @IBOutlet weak var likeSuter: UIButton!
    
    @IBAction func likeButton(_ sender: Any) {
        print("likeButtonが押されたよ")
        SVProgressHUD.show()
        
        // 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath).child(selectBookData.isbn!)
        if selectBookData.isLiked{
            //削除
            postRef.removeValue()
            SVProgressHUD.showSuccess(withStatus: "解除")
            SVProgressHUD.dismiss(withDelay: 0.5)
        } else {
            postRef.setValue(selectBookData.postData)
            SVProgressHUD.showSuccess(withStatus: "登録")
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
        updateButton(isLiked: !selectBookData.isLiked)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
            //itemCaptionが空だったら文字列を代入する
            if selectBookData.itemCaption?.isEmpty ?? true {
                selectBookData.itemCaption = "概要が登録されていません"
            }
            
            //各値をUI部品に設定
            print(selectBookData)
            print(selectBookData.itemPrice!)
            
            titleLabel.text = selectBookData.title
            sizeLabel.text = selectBookData.size
            authorLabel.text = selectBookData.author
            publisherNameLabel.text = selectBookData.publisherName
            itemPriceLabel.text = ("￥\(selectBookData.itemPrice!)")
            reviewAverageLabel.text = ("レビュー平均：\(selectBookData.reviewAverage!)")
            salesDateLabel.text = ("発売日：\(selectBookData.salesDate!)")
            itemCaptionLabel.text = selectBookData.itemCaption
            
            imageView.image = selectedImg
            // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            fetchFavorite()
        }
        
        /*
        //itemCaptionが空だったら文字列を代入する
        if selectBookData.itemCaption?.isEmpty ?? true {
            selectBookData.itemCaption = "概要が登録されていません"
        }
        
        //各値をUI部品に設定
        
        
        print(selectBookData.itemPrice)
        
        titleLabel.text = selectBookData.title
        sizeLabel.text = selectBookData.size
        authorLabel.text = selectBookData.author
        publisherNameLabel.text = selectBookData.publisherName
        itemPriceLabel.text = ("￥\(selectBookData.itemPrice!)")
        reviewAverageLabel.text = ("レビュー平均：\(selectBookData.reviewAverage!)")
        salesDateLabel.text = ("発売日：\(selectBookData.salesDate!)")
        itemCaptionLabel.text = selectBookData.itemCaption
        
        imageView.image = selectedImg
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        fetchFavorite()
 */
    
    
    func fetchFavorite() {
        
        //let postRef = Database.database().reference().child(Const.PostPath)
        let postRef = Database.database().reference().child(Const.PostPath).child(selectBookData.isbn!)
        //let query = postRef.queryOrdered(byChild: "isbn").queryEqual(toValue: selectBookData.isbn)
        
        postRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            print(snapshot.value!)
            guard (snapshot.value as? [String : Any]) != nil else {
                self.updateButton(isLiked: false)
                return
            }
            self.updateButton(isLiked: true)
            //self.favoriteArray.append(ItemData(data: postDict))
        })
    }
    
    //ボタン状態の更新を行うメソッド
    func updateButton(isLiked: Bool) {
        if isLiked {
            let buttonImage = UIImage(named: "likesuter")
            likeSuter.setImage(buttonImage, for: .normal)
            print("お気に入りに登録したよ")
        } else {
            let buttonImage = UIImage(named: "suter")
            likeSuter.setImage(buttonImage, for: .normal)
            print("お気に入り解除したよ")
        }
        selectBookData.isLiked = isLiked
    }
    
}
