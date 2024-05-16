//
//  CNPValidator.swift
//  AppTemplate
//
//  Created by Bogdan Ionescu on 12.04.2023.
//

import Foundation

// Romanian identification number validator
// Sample valid CNP number: 6030423015815

struct CNPValidator {

    let controlKey = [2, 7, 9, 1, 4, 6, 3, 5, 8, 2, 7, 9]

    var cnp: String
    private var cnpArray: [Int]
    private var year: Int?
    
    init(cnp: String) {
        self.cnp = cnp
        self.cnpArray = cnp.compactMap({ Int(String($0)) })
    }
    
    func isValid() -> Bool {
        guard cnp.count == 13,
              cnpArray.count == 13 else {
            return false
        }
        
        return validateCNP()
    }
    
    mutating private func setYear() {

    }
    
    private func validateCNP() -> Bool {
        return checkHash()
    }

    private func checkHash() -> Bool {
        var hashSum = 0
        
        for i in 0...11 {
            hashSum += cnpArray[i] * controlKey[i]
        }
        
        hashSum = hashSum % 11
        if hashSum == 10 {
            hashSum = 1
        }
        
        return hashSum == cnpArray[12]
    }
    
}
