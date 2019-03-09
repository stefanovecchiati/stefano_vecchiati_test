//
//  BookListViewModel.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit


class BookListViewModel {
    
    typealias BookCellConfig = CollectionCellConfigurator<BookWidget, BookModel>
    
    private var books: [BookModel] = []

    func createModel() -> BaseModel? {
        
        let model = BaseModel()
        
        let jsonResult = JsonManager.share.readJson(fileName: FileJSONName.BookList.rawValue)
        
        guard let data = jsonResult.0, jsonResult.1 == nil else {
            
            // show the message error in an alert
            let alert = GeneralUtils.share.alertBuilder(title: R.string.localizable.kErorr(), message: jsonResult.1?.localizedDescription, closeAction: { _ in })
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            books = try decoder.decode([BookModel].self, from: data)
            
            for book in books {
                let cell = BookCellConfig.init(item: book)
                model.cells.append(cell)
            }
            
            
        } catch let error {
            
            // show the message error in an alert
            let alert = GeneralUtils.share.alertBuilder(title: R.string.localizable.kErorr(), message: error.localizedDescription, closeAction: { _ in })
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            
        }

        model.titleViewController = R.string.localizable.kBookListTitle()
        model.delegate = self
        
        let randomRateButton = UIBarButtonItem(title: R.string.localizable.kRandomRaiting(), style: .plain, target: self, action: nil)
        model.rightBarButtonItems = [randomRateButton]
        
        return model
    }

}

extension BookListViewModel: GenericDelegate {
    
    
    func valueDidChange(key: ValueDidChangeKeys, value: Any, index: IndexPath) {
        switch key {
        case .Rate:
            guard let rateValue = value as? Double else { return }
            books[index.row].rate = rateValue
            JsonManager.share.writeJson(fileName: FileJSONName.BookList.rawValue, object: AnyEncodable(books), completion: { _ in })
        default:
            break
        }
    }
    
    
}


