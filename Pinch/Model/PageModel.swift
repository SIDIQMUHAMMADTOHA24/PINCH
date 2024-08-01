//
//  PageModel.swift
//  Pinch
//
//  Created by sidiqtoha on 01/08/24.
//

import Foundation


struct Page: Identifiable{
    let id: Int
    let imageName: String
}

extension Page {
    var tumbnailName: String{
        return "thumb-" + imageName
    }
}
