//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

class CollectionDirector: NSObject {
    let collectionView: BaseColletcionView
    let actionsProxy = CellActionProxy()
    private(set) var items = [CellConfigurator]() {
        didSet {
            if oldValue.isEmpty {
                self.collectionView.reloadData()
            } else {
                let oldHashes = oldValue.map { $0.hash }
                let newHashes = items.map { $0.hash }
                let result = DiffList.diffing(oldArray: oldHashes, newArray: newHashes)
                self.collectionView.perform(result: result)
            }
        }
    }
    
    init(collectionView: BaseColletcionView, items: [CellConfigurator]) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.items = items
        
        NotificationCenter.default.addObserver(self, selector: #selector(onActionEvent(n:)), name: CellAction.notificationName, object: nil)
    }
    
    @objc fileprivate func onActionEvent(n: Notification) {
        if let eventData = n.userInfo?["data"] as? CellActionEventData,
            let cell = eventData.cell as? UICollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) {
            actionsProxy.invoke(action: eventData.action, cell: cell, configurator: self.items[indexPath.row], value: eventData.value)
        }
    }
    
    func update(items: [CellConfigurator]) {
        self.items = items
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CollectionDirector: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellConfigurator = self.items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: cellConfigurator).reuseId, for: indexPath)
        cellConfigurator.configure(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cellConfigurator = self.items[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        self.actionsProxy.invoke(action: .didSelect, cell: cell, configurator: cellConfigurator, value: nil)
    }
}

extension BaseColletcionView {
    func perform(result: DiffList.Result) {
        self.update()
    }
}
