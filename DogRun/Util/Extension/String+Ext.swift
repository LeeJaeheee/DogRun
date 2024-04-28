//
//  String+Ext.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation

extension String {
    
    func formattedPhoneNumber() -> String {

        let digits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let maxDigitsLength = 11
        
        let trimmed = String(digits.prefix(maxDigitsLength))
        
        if trimmed.count >= 8 {
            let start = trimmed.index(trimmed.startIndex, offsetBy: 0)
            let middle = trimmed.index(trimmed.startIndex, offsetBy: 3)
            let end = trimmed.index(trimmed.startIndex, offsetBy: 7)
            
            let firstNumber = String(trimmed[start..<middle])
            let middleNumber = String(trimmed[middle..<end])
            let lastNumber = String(trimmed[end...])
            
            return "\(firstNumber)-\(middleNumber)-\(lastNumber)"
        } else if trimmed.count >= 4 {
            let start = trimmed.index(trimmed.startIndex, offsetBy: 0)
            let middle = trimmed.index(trimmed.startIndex, offsetBy: 3)
            
            let firstNumber = String(trimmed[start..<middle])
            let middleNumber = String(trimmed[middle...])
            
            return "\(firstNumber)-\(middleNumber)"
        } else {
            return trimmed
        }
        
    }
    
}
