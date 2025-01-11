//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/11/25.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
