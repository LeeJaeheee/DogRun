//
//  ArrayExtension.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import Foundation

extension Array where Element == String {
    
    func hashtagsString() -> String {
        return self.map { "#\($0)" }.joined(separator: " ")
    }
    
}
