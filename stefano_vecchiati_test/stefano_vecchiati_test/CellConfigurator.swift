//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(model: DataType)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(model: item)
    }
    
}
