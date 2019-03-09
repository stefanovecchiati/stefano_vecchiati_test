//
//  JsonManager.swift
//  stefano_vecchiati_test
//
//  Created by stefano vecchiati on 09/03/2019.
//  Copyright © 2019 com.stefanovecchiati. All rights reserved.
//

import UIKit

struct AnyEncodable: Encodable {
    
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

class JsonManager: NSObject {
    
    enum JSONError: Error {
        case fileNotFound, unreadableFile
    }
    
    static let share = JsonManager()
    
    func readJson(fileName : String) -> (Data?, Error?) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(fileName + ".json")
            
            do {
                
                let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                return(data, nil)
                
            } catch {
                return loadJSONFileFirstTime(fileName: fileName)
            }
        } else {
            return loadJSONFileFirstTime(fileName: fileName)
        }
    }
    
    func writeJson(fileName: String, object: AnyEncodable, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let fileURL = dir.appendingPathComponent(fileName + ".json")
                
                do {
                    let jsonData = try JSONEncoder().encode(object)
                    try jsonData.write(to: fileURL)
                    completion(true)
                } catch {
                    print("Failed to write JSON data: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    private func loadJSONFileFirstTime(fileName : String) -> (Data?, Error?) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                DispatchQueue.global(qos: .background).async {
                    self.writeJson(fileName: fileName, object: AnyEncodable(data)) { _ in }
                }
                
                return(data, nil)
                
            } catch {
                return(nil, JSONError.unreadableFile)
            }
        } else {
            return(nil, JSONError.fileNotFound)
        }
            
    }
    
}


