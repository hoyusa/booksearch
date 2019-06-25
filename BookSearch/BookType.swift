//
//  BookType.swift
//  BookSearch
//
//  Created by 許 裕士 on 2019/06/24.
//  Copyright © 2019 許 裕士. All rights reserved.
//

import Foundation

enum BookType: Int, CaseIterable {
    case Comic
    case aaaa
    case bbbb
    
    var title: String {
        switch self {
        case .Comic: return "漫画"
        case .aaaa: return "AAAA"
        case .bbbb: return "BBBB"
        }
    }
}
