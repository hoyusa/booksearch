//
//  CollectionViewController.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/03.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
//カテゴリ欄のライブラリ
import BTNavigationDropdownMenu
private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var menuView: BTNavigationDropdownMenu!
    var selectedImage: UIImage?
    var selectItemData: ItemData?
    var currentPage: Int = 0
    var bookType: Int = 0
    
    //private var bookType: BookType = .Comic
    
    //private let bookData = BookData()
    private var itemData: [ItemData] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.bookType.title)
        currentPage += 1
        guard let fl = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        fl.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        
        //self.bookData.delegate = self
        let bookData = BookData()
        bookData.getBookData(bookType: self.bookType, page: currentPage) { [weak self] items in
            guard let self = self else { return }
            guard let items = items else {
                //データが取得できませんでした。
                self.itemData = []
                return
            }
            self.itemData = items
        }
        setMenu()
    }
    
    //プルダウンメニューのメソッド
    func setMenu() {
        let items = ["全て", "単行本", "文庫", "新書", "全集・双書", "事・辞典", "図鑑", "絵本", "カセット,CD", "コミック"]
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "カテゴリ", items: items)
        
        //オプションです
        /*
         menuView.cellHeight = 50
         menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
         menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
         menuView.shouldKeepSelectedCellColor = true
         menuView.cellTextLabelColor = UIColor.whiteColor()
         menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
         menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
         menuView.arrowPadding = 15
         menuView.animationDuration = 0.5
         menuView.maskBackgroundColor = UIColor.blackColor()
         menuView.maskBackgroundOpacity = 0.3
         */
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if self.bookType != indexPath {
                self.bookType = indexPath
                print(self.bookType)
                
                let bookData = BookData()
                bookData.getBookData(bookType: self.bookType, page: self.currentPage) { [weak self] items in
                    guard let self = self else { return }
                    guard let items = items else {
                        //データが取得できませんでした。
                        //self.itemData = []
                        return
                    }
                    self.itemData.removeAll()
                    self.itemData.append(contentsOf: items)
                   
                }
            }
        }
        self.navigationItem.titleView = menuView
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
            imageView.image = getImageByUrl(urlString: url)
        }
        return cell
    }
    
    // Cell が選択された場合
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // [indexPath.row] から画像名を探し、UImage を設定
        let item = self.itemData[indexPath.row]

        print(item.isLiked)

        let selectItemData = self.itemData[indexPath.row]
        print(selectItemData.title)

        self.selectItemData = selectItemData

        if let url = item.largeImageUrl {
            selectedImage = getImageByUrl(urlString: url)
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == itemData.count - 1 {
            loadMore()
        }
    }
    
    func loadMore() {
        //self.bookData.delegate = self
        //APIの表示ページをプラス1する
        currentPage += 1
        
        let bookData = BookData()
        bookData.getBookData(bookType: self.bookType, page: currentPage) { [weak self] items in
            guard let self = self else { return }
            guard let items = items else {
                //データが取得できませんでした。
                //self.itemData = []
                return
            }
            self.itemData.append(contentsOf: items)
        }
        
    }
    
    /*
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
    */
    func getImageByUrl(urlString: String) -> UIImage?{
        guard let url = URL(string: urlString) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
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
