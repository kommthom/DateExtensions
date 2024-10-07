//
//  Array+Dated.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 10.05.24.
//

import Foundation

public protocol Dated {
    var date: Date { get }
}

extension Array where Element: Dated {
    public func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
