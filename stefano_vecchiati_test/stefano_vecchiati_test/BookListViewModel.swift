//
//  BookListViewModel.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit


class BookListViewModel: BaseCellStruct {
    
    typealias BookCellConfig = CollectionCellConfigurator<BookWidget, BookModel>

    
    static func createModel() -> BaseModel? {
        
        let model = BaseModel()
        let cell = BookCellConfig.init(item: BookModel())
        
        model.cells = [cell]
        
        model.titleViewController = "Book List"
        
        return model
    }

}
