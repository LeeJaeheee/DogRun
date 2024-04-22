//
//  MapModel.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import Foundation

struct Trace {
    var latitude: Double
    var longitude: Double
    
    func latitudeString() -> String {
        return String(self.latitude)
    }
}

struct TrackData {
    var date: Date?
    var traces: [Trace]
    
    mutating func appendTrace(trace: Trace) {
        self.traces.append(trace)
    }
    
    func formattedDate() -> String {
        guard let date = self.date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
}
