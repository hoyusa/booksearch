//
//  ViewController.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/03.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        else{
            //TabBar経由で今週の新刊一覧を表示する
            let collectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(collectionViewController, animated: true, completion: nil)
        }
    }


}

