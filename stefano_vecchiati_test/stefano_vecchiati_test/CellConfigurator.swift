//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

protocol ConfigurableCell : class {
    associatedtype DataType
    func configure(model: DataType)
}

protocol CellConfigurator : class {
    static var reuseId: String { get }
    func configure(cell: UIView)
    
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: BaseCollectionViewCell {
    
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        
        self.item = item
    }
    
    func configure(cell: UIView) {
        
        (cell as! CellType).configure(model: item)
        
    }
    
}
