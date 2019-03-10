//
//  BaseCollectionViewCell.swift
//
//  Created by stefano vecchiati.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit
import Stevia

class BaseCollectionViewCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 12, *) { setupSelfSizingForiOS12(contentView: contentView) }
        
        
    }
    
    func contentSetup() {
        
    }
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
}

extension UICollectionViewCell {
    /// This is a workaround method for self sizing collection view cells which stopped working for iOS 12
    func setupSelfSizingForiOS12(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = contentView.leftAnchor.constraint(equalTo: leftAnchor)
        let rightConstraint = contentView.rightAnchor.constraint(equalTo: rightAnchor)
        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
}
