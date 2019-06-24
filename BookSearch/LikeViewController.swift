//
//  LikeViewController.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/03.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LikeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookArray: [ItemData] = []
    var selectCell: ItemData!
    var selectedImage: UIImage?
    
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルのタップを有効にする
        tableView.allowsSelection = true
        
        let nib = UINib(nibName: "LikeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が追加されたらbookArrayに追加してTableViewを再表示する
                let booksRef = Database.database().reference().child(Const.PostPath)
                booksRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // bookDataクラスを生成して受け取ったデータを設定する
                    
                    guard let valueDictionary = snapshot.value as? [String: Any] else { return }
                    let bookData = ItemData(data: valueDictionary)
                    
                    print(bookData.itemPrice)
                    
                    print(bookData.itemPrice)
                    self.bookArray.insert(bookData, at: 0)

                    // TableViewを再表示する
                    self.tableView.reloadData()
                    
                })
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                booksRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    // ItemDataクラスを生成して受け取ったデータを設定する
                    guard let valueDictionary = snapshot.value as? [String: Any] else {return}
                    let bookData = ItemData(data: valueDictionary)
                    
                    // 保持している配列からisbnが同じものを探す
                    var index: Int = 0
                    for book in self.bookArray {
                        if book.isbn == bookData.isbn {
                            index = self.bookArray.index(of: book)!
                            break
                        }
                        
                        // 差し替えるため一度削除する
                        self.bookArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.bookArray.insert(bookData, at: index)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                    
                })
                
                //セルの削除をするメソッド
                booksRef.observe(.childRemoved, with: { snapshot in
                    print("DEBUG_PRINT: .childremovedイベントが呼ばれました。")
                    
                    // ItemDataクラスを生成して受け取ったデータを設定する
                    guard let valueDictionary = snapshot.value as? [String: Any] else {return}
                    let bookData = ItemData(data: valueDictionary)
                    
                    // 保持している配列からisbnが同じものを探す
                    var index: Int = 0
                    for book in self.bookArray {
                        if book.isbn == bookData.isbn {
                            index = self.bookArray.index(of: book)!
                            break
                        }
                    }
                    // 差し替えるため一度削除する
                    self.bookArray.remove(at: index)
                    
                    // TableViewを再表示する
                    self.tableView.reloadData()
                    
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
            }
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                bookArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
    }
    
    //セルのスライド削除をするデリゲートメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //選択したセルの情報をselectCellDataに格納
            let selectCellData = self.bookArray[indexPath.row]
            //postRefにFirevaseの選択したセル情報を格納する
            let postRef = Database.database().reference().child(Const.PostPath).child(selectCellData.isbn!)
            //Firebaseの選択セル情報を削除
            postRef.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    //セルがタップされた際に書籍詳細画面に遷移するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        print(self.bookArray[indexPath.row].itemPrice)
        
        
        //DetailsViewControllerに渡す値をセット
        selectCell = bookArray[indexPath.row]
        
        if let url = selectCell.largeImageUrl {
            print(selectCell.itemPrice)
            selectedImage = getImageByUrl(urlString: url)
        }
        
        //DetailsViewControllerへ遷移するSegueを呼び出す
        performSegue(withIdentifier: "SelectCellSegue",sender: nil)
    }
    
    // Segueで遷移時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "SelectCellSegue") {
            guard  let subVC: DetailsViewController = segue.destination as? DetailsViewController else{
                return
            }
            
            //DetailsViewControllerに選択したセル情報を設定する
            
            subVC.selectBookData = selectCell
            subVC.selectedImg = self.selectedImage
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LikeTableViewCell
        cell.setItemData(bookArray[indexPath.row])
        
        return cell
    }
    
    //文字列を元にimageを取得するメソッド
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

