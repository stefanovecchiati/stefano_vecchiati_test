//
//  JsonManager.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit

class JsonManager: NSObject {
    
    enum JSONError: Error {
        case fileNotFound, unreadableFile
    }
    
    static let share = JsonManager()
    
    func readJson(fileName : String) -> (Data?, Error?) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return(data, nil)
                
            } catch {
                return(nil, JSONError.unreadableFile)
            }
        } else {
            return(nil, JSONError.fileNotFound)
        }
    }

}
