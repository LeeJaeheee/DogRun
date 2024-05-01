//
//  DateFormatterManager.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    lazy var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String? {
        return timeFormatter.string(from: timeInterval)
    }
}
