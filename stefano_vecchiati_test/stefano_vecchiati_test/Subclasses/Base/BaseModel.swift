//
//  BaseModel.swift
//
//  Created by stefano vecchiati.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    var cells : [CellConfigurator]!
    var titleViewController : String!
    var touchForCloseKeyboard : Bool = false
    var resizeForKeyboard : Bool = false
    var centerViewController : Bool = false
    var scrollingViewController : Bool = true
    var bounceViewController : Bool = true
    var rightBarButtonItems : [UIBarButtonItem]!
    var leftBarButtonItems : [UIBarButtonItem]!
    var hideNavigationBar : Bool = false
    var backgroudImage : UIImage? = nil
    var collectionDirector: CollectionDirector!
    
    func addHandlers() {
        
    }
    
    override init() {
        super.init()
        
        cells = []
        titleViewController = ""
        
        rightBarButtonItems = []
        leftBarButtonItems = []
        
    }

}




