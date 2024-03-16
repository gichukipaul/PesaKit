    //  Extensions.swift
    //  Created by GichukiPaul on 16/03/2024.


import Foundation

extension Date {
    func formattedDateString() -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: self)
    }
}
