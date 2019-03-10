//
//  BaseColletcionView.swift
//
//  Created by stefano vecchiati.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class BaseColletcionView: UICollectionView {
    
    static let minimumInteritemSpacing : CGFloat = 10
    
    func setupCollection(withModel model : BaseModel) {
        
        self.backgroundColor = .clear
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = model.scrollingViewController
        
        self.alwaysBounceVertical = model.bounceViewController
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 10, height: 40)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = BaseColletcionView.minimumInteritemSpacing
        self.collectionViewLayout = layout
        
    }
    
    func update() {
        
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
        
    }
    
    private var shouldInvalidateLayout = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldInvalidateLayout {
            collectionViewLayout.invalidateLayout()
            shouldInvalidateLayout = false
        }
    }
    
    override func reloadData() {
        shouldInvalidateLayout = true
        super.reloadData()
    }
    
    deinit {
        
    }
    
}
