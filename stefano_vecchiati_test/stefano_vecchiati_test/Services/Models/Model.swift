//
//  Created by stefano vecchiati.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit

class ViewWidgetModel : BaseCellStruct {
    
}

class Model: Codable {


    static func createModel() -> BaseModel? {

        let model = BaseModel()
        let cell = ViewWidgetModel(nib:
            UINib(nibName: String(describing: ViewWidget.classForCoder()), bundle: nil),
                           identifier: ViewWidget.reuseIdentifier(),
                           father: nil)

        model.cells = [cell]

        model.centerViewController = false
        model.scrollingViewController = false

        return model
    }

    
}
