//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

struct BookModel: Codable {
    
    var title: String = ""
    var description: String = ""
    var imageName: String = ""
    var rate: Double = 0
    
}


extension BookModel: Hashable {
    static func ==(lhs: BookModel, rhs: BookModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return title.hashValue ^ description.hashValue ^ imageName.hashValue ^ rate.hashValue
    }
}
