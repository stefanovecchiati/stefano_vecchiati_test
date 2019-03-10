//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

enum CellAction: Hashable {
    
    case didSelect
    case custom(ValueDidChangeKeys)
    
    //hashable
    public var hashValue: Int {
        switch self {
        case .didSelect:
            return 1
        case .custom(let custom):
            return custom.hashValue
        }
    }
    
    public static func ==(lhs: CellAction, rhs: CellAction) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension CellAction {
    static let notificationName = NSNotification.Name(rawValue: "CellAction")
    
    public func invoke(cell: Any, value: Any?) {
        NotificationCenter.default.post(name: CellAction.notificationName,
                                        object: nil,
                                        userInfo: ["data": CellActionEventData(action: self, cell: cell, value: value)])
    }

    
}

class CellActionProxy {

    private var actions = [String: ((CellConfigurator, UIView, Any?) -> Void)]()
    
    func invoke(action: CellAction, cell: UIView, configurator: CellConfigurator, value: Any?) {
        let key = "\(action.hashValue)\(type(of: configurator).reuseId)"
        if let action = self.actions[key] {
            action(configurator, cell, value)
        }
    }
    
    @discardableResult
    func on<CellType, DataType>(_ action: CellAction, handler: @escaping ((CollectionCellConfigurator<CellType, DataType>, CellType, Any?) -> Void)) -> Self {
        let key = "\(action.hashValue)\(CellType.reuseIdentifier)"
        self.actions[key] = { (c, cell, value) in
            handler(c as! CollectionCellConfigurator<CellType, DataType>, cell as! CellType, value)
        }
        return self
    }
}

struct CellActionEventData {
    let action: CellAction
    let cell: Any
    let value : Any?
}
