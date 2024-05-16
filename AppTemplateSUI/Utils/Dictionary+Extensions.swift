//
//  Dictionary+Extensions.swift
//  AppTemplate
//
//  Created by Bogdan Ionescu on 12.04.2023.
//

import Foundation

extension Dictionary {
    func decode<T: Codable>() -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            return nil
        }
    }
}
