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
        
        let jsonResult = JsonManager.share.readJson(fileName: "BookList")
        
        guard let data = jsonResult.0, jsonResult.1 == nil else {
            
            // show the message error in an alert
            let alert = GeneralUtils.share.alertBuilder(title: R.string.localizable.kErorr(), message: jsonResult.1?.localizedDescription, closeAction: { _ in })
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let books = try decoder.decode([BookModel].self, from: data)
            
            for book in books {
               let cell = BookCellConfig.init(item: book)
                model.cells.append(cell)
            }
            
            
        } catch let error {
            
            // show the message error in an alert
            let alert = GeneralUtils.share.alertBuilder(title: R.string.localizable.kErorr(), message: error.localizedDescription, closeAction: { _ in })
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            
        }

        model.titleViewController = "Book List"
        
        return model
    }

}
