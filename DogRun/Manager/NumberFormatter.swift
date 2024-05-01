//
//  NumberFormatter.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import Foundation

final class NumberFormatterManager {
    static let shared = NumberFormatterManager()
    
    private init() {}
    
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
    
    func formatDistance(_ distance: Double) -> String {
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        if distance < 1000 {
            return "\(formatter.string(from: NSNumber(value: distance)) ?? "")m"
        } else {
            let kilometers = distance / 1000
            return "\(formatter.string(from: NSNumber(value: kilometers)) ?? "")km"
        }
    }
}
