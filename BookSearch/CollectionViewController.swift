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
    
    let photos = ["item0.jpg", "item1.jpg", "item2.jpg", "item3.jpg", "item4.jpg", "item5.jpg"]
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //セクションの数を指定するメソッド
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    //セルの大きさを設定するメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 端末サイズの3/1の width と height にして 3 列にする場合
        let width: CGFloat = UIScreen.main.bounds.width / 3
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    //セルの余白を設定するメソッド
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Tag番号を使ってImageViewのインスタンス生成
        
        print("DEBUG*cell*** \(cell) ****")
        let imageView = cell.viewWithTag(1) as! UIImageView
        print("DEBUG*image*** \(imageView) ****")
        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        let cellImage = UIImage(named: photos[indexPath.row])
        // UIImageをUIImageViewのimageとして設定
        imageView.image = cellImage
        
        return cell
    }
    
    // Cell が選択された場合
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = UIImage(named: photos[indexPath.row])
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
            subVC.selectedImg = selectedImage
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
    
}
