//
//  LikeTableViewCell.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/03.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setItemData(_ bookData: ItemData) {
        if let url = bookData.largeImageUrl {
            print(bookData.largeImageUrl)
            bookImageView.image = getImageByUrl(url: url)
        }
        
        self.titleLabel.text = bookData.title
        self.dateLabel.text = ("発売日：\(bookData.salesDate!)")
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
