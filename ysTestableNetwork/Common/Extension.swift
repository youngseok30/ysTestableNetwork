//
//  Extension.swift
//  ysTestableNetwork
//
//  Created by Ethan Lee on 2022/05/13.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    mutating func append(_ dic: [String: Any]) -> Dictionary {
        for (key, value) in dic {
            self.updateValue(value, forKey: key)
        }
        
        return self
    }
}


extension Data {
    func decoded<T: Decodable>(type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: self)
        } catch let(error){
            print(error)
        }
        
        return nil
    }
}
