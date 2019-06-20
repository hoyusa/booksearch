//
//  CollectionViewController.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/03.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var selectedImage: UIImage?
    var selectItemData: ItemData?
    
    //private let bookData = BookData()
    private var itemData: [ItemData] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let fl = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        fl.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        
        //self.bookData.delegate = self
        let bookData = BookData()
        bookData.getBookData { [weak self] items in
            guard let self = self else { return }
            guard let items = items else {
                //データが取得できませんでした。
                self.itemData = []
                return
            }
            self.itemData = items
        }
        
    }
    
    //セクションの数を指定するメソッド
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    //セルの数を指定するメソッド
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemData.count
    }
    
    //セルの大きさを設定するメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 端末サイズの3/1の width と height にして 3 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //外枠のマージン(top , left , bottom , right)
        return UIEdgeInsets(top: 20 , left:  0, bottom: 20 , right: 0 )
    }
    
    //セル間の余白を設定するメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(0)
    }
    
    //セルのイメージ部分を色々しているメソッド
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Tag番号を使ってImageViewのインスタンス生成
        print("DEBUG*cell*** \(cell) ****")
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: "default")
        print("DEBUG*image*** \(imageView) ****")
        
        print(self.itemData[indexPath.row])
        let item = self.itemData[indexPath.row]
        
        print(item.largeImageUrl!)
        //item.mediumImageUrl imageを作成
        if let url = item.largeImageUrl {
            imageView.image = getImageByUrl(url: url)
        }
        return cell
    }
    
    // Cell が選択された場合
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        // [indexPath.row] から画像名を探し、UImage を設定
        let item = self.itemData[indexPath.row]
        
        print(item.isLiked)
        
        let selectItemData = self.itemData[indexPath.row]
        print(selectItemData.title)
        
        self.selectItemData = selectItemData
        
        if let url = item.largeImageUrl {
            selectedImage = getImageByUrl(url: url)
        }
        if selectedImage != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "DetailsSegue", sender: nil)
        }
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "DetailsSegue") {
            guard let subVC: DetailsViewController = segue.destination as? DetailsViewController else {
                return
            }
            // SubViewController のselectedImgに選択された画像を設定する
            // 選択されたセルのデータをDetailsViewConrtollerに渡してる
            
            subVC.selectedImg = selectedImage
            subVC.selectBookData = selectItemData
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
            else {
                fatalError("Could not find proper header")
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            header.sectionLabel.text = "section \(indexPath.section)"
            print("DEBUG***section**\(indexPath.section)")
            return header
        }
        return UICollectionReusableView()
    }
    
    func getImageByUrl(url: String) -> UIImage?{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
            return UIImage(named: "default")
        }
    }
}

//extension CollectionViewController: bookDataProtocol {
//    func applyData(itemData: [ItemData]) {
//        self.itemData = itemData
//        print(self.itemData[0].id)
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//    }
//}
