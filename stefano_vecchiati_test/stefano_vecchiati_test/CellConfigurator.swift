//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

protocol ConfigurableCell : class {
    static var reuseIdentifier: String { get }
    associatedtype DataType
    func configure(data: DataType)
}

extension ConfigurableCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
}

protocol CellConfigurator : class {
    static var reuseId: String { get }
    func configure(cell: UIView)
    var hash: Int { get }
}

//class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: BaseCollectionViewCell {
//
//    static var reuseId: String { return String(describing: CellType.self) }
//
//    let item: DataType
//
//    init(item: DataType) {
//
//        self.item = item
//    }
//
//    func configure(cell: UIView) {
//
//        (cell as! CellType).configure(model: item)
//
//    }
//
//}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType: Hashable>: CellConfigurator where CellType.DataType == DataType, CellType: BaseCollectionViewCell {
    
    static var reuseId: String { return CellType.reuseIdentifier }
    
    var item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
    
    var hash: Int {
        return String(describing: CellType.self).hashValue ^ item.hashValue
    }
}

extension Int: Diffable {
    public var diffIdentifier: AnyHashable {
        return self
    }
}
