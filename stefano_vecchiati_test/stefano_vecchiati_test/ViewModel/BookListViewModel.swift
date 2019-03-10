//
//  BookListViewModel.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit

class BookListViewModel: BaseModel {
    
    typealias BookCellConfig = CollectionCellConfigurator<BookWidget, BookModel>
    
    private var books: [BookModel] = []
    
    private var randomRateButton : UIBarButtonItem!
    
    override init(){
        super.init()
        
        let jsonResult = JsonManager.share.readJson(fileName: FileJSONName.BookList.rawValue)
        
        guard let data = jsonResult.0, jsonResult.1 == nil else {
            
            // show the message error in an alert
            let alert = GeneralUtils.share.alertBuilder(title: R.string.localizable.kErorr(), message: jsonResult.1?.localizedDescription, closeAction: { _ in })
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            return
        }
        
        let decoder = JSONDecoder()
        do {
            books = try decoder.decode([BookModel].self, from: data)
            
            for book in books {
                let cell = BookCellConfig.init(item: book)
                self.cells.append(cell)
            }
            
            
        } catch let error {
            
            // show the message error in an alert
            let alert = GeneralUtils.share.alertBuilder(title: R.string.localizable.kErorr(), message: error.localizedDescription, closeAction: { _ in })
            
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            
        }
        
        self.titleViewController = R.string.localizable.kBookListTitle()
        
        randomRateButton = UIBarButtonItem(title: R.string.localizable.kRandomRaiting(), style: .plain, target: self, action: #selector(randomRateAction))
        randomRateButton.tintColor = UIColor.hexColor(hex: "007AFF")
        self.rightBarButtonItems = [randomRateButton]
        
    }
    
    // variable for check if I must or stop the random rate process
    private var proceedWithRandomProcess : Bool = false {
        didSet {
            proceedWithRandomProcess ? (randomRateButton.tintColor = .gray) : (randomRateButton.tintColor = UIColor.hexColor(hex: "007AFF"))
        }
    }
    
    // random rate process function
    @objc func randomRateAction() {
        
        proceedWithRandomProcess = !proceedWithRandomProcess
        
        DispatchQueue.global(qos: .background).async {
            while self.proceedWithRandomProcess {
                
                let range:Range<UInt32> = 2..<8
                
                self.randomDelay(range: range) {
                    
                    let rangeCell = Int.random(in: 0..<self.books.count)
                    let rangeStar = Double.random(in: 0...5)
                    
                    // execute this code on the main thread because you are working with some UI
                    DispatchQueue.main.async {
                        
                        if let randomCell = self.collectionDirector.collectionView.cellForItem(at: IndexPath(item: rangeCell, section: 0)) {
                            
                            if self.proceedWithRandomProcess {
                                
                                CellAction.custom(.Rate).invoke(cell: randomCell, value: rangeStar)
                                
                            } else {
                                return
                            }
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
    
    override func addHandlers() {
        self.collectionDirector.actionsProxy
            .on(.custom((.Rate))) { (c: BookCellConfig, cell, value) in
                
                
                guard let rateValue = value as? Double, let indexPath = self.collectionDirector.collectionView.indexPath(for: cell) else { return }
                
                
                
                self.books[indexPath.row].rate = rateValue
                
                self.books.sort(by: { $0.rate > $1.rate })
                
                JsonManager.share.writeJson(fileName: FileJSONName.BookList.rawValue, object: AnyEncodable(self.books), completion: { success in
                    
                    if success {
                        self.cells = self.books.map({ book in
                            BookCellConfig.init(item: book)
                        })
                        
                        self.collectionDirector.update(items: self.cells)
                    }
                    
                })
                
        }
    }
    
    // register the cells that the collectionView needs
    override func registerCells() {

        self.collectionDirector.collectionView.register(BookWidget.self, forCellWithReuseIdentifier: BookCellConfig.reuseId)
        
    }
    
    
    
}
