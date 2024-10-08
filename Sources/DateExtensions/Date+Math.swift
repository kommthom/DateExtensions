//
//  Date+Math.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 14.03.24.
//

import Foundation

/*
 Note: These items are meant for simple utility. Pay attention
 to the cautions regarding Calendar.Component use.
 
 Acknowlegements in Date+Utilities.swift
 */

/// Standard interval reference
/// Not meant to replace `offset(_: Calendar.Component, _: Int)` to offset dates
public extension Date {
    /// Returns number of seconds per second
    static let secondInterval: TimeInterval = 1
    /// Returns number of seconds per minute
    static let minuteInterval: TimeInterval = 60
    /// Returns number of seconds per hour
    static let hourInterval: TimeInterval = 3600
    /// Returns number of seconds per 24-hour day
    static let dayInterval: TimeInterval = 86400
    /// Returns number of seconds per standard week
    static let weekInterval: TimeInterval = 604800
}

/// Standard interval reference
/// Not meant to replace `offset(_: Calendar.Component, _: Int)` to offset dates
public extension Int {
    /// Returns number of seconds in n seconds
    var secondInterval: TimeInterval { return TimeInterval(self) * Date.secondInterval }
    /// Returns number of seconds in n minutes
    var minuteInterval: TimeInterval { return TimeInterval(self) * Date.minuteInterval }
    /// Returns number of seconds in n hours
    var hourInterval: TimeInterval { return TimeInterval(self) * Date.hourInterval }
    /// Returns number of seconds in n 24-hour days
    var dayInterval: TimeInterval { return TimeInterval(self) * Date.dayInterval }
    /// Returns number of seconds in n standard weeks
    var weekInterval: TimeInterval { return TimeInterval(self) * Date.weekInterval }
}

/// Utility for component math
public extension Int {
    /// Returns n-second date component
    var seconds: DateComponents {
        return DateComponents(second: self)
    }
    /// Returns n-minute date component
    var minutes: DateComponents {
        return DateComponents(minute: self)
    }
    /// Returns n-hour date component
    var hours: DateComponents {
        return DateComponents(hour: self)
    }
    /// Returns n-day date component
    var days: DateComponents {
        return DateComponents(day: self)
    }
    /// Returns n-week date component
    var weeks: DateComponents {
        return DateComponents(day: self * 7)
    }
    /// Returns n-fortnight date component
    var fortnights: DateComponents {
        return DateComponents(day: self * 14)
    }
    /// Returns n-month date component
    var months: DateComponents {
        return DateComponents(month: self)
    }
    /// Returns n-year date component
    var years: DateComponents {
        return DateComponents(year: self)
    }
    /// Returns n-decade date component
    var decades: DateComponents {
        return DateComponents(year: self * 10)
    }
}

/// Calendar component offsets
extension Date {
    /// Performs calendar math using date components as alternative
    /// to `offset(_: Calendar.Component, _: Int)`
    /// e.g.
    /// ```swift
    /// print((Date() + DateComponents.days(3) + DateComponents.hours(1)).fullString)
    /// ```
    public static func +(lhs: Date, rhs: DateComponents) -> Date {
        return Date.sharedCalendar.date(byAdding: rhs, to: lhs)! // yes force unwrap. sue me.
    }
    
    /// Performs calendar math using date components as alternative
    /// to `offset(_: Calendar.Component, _: Int)`
    /// e.g.
    /// ```swift
    /// print((Date() - DateComponents.days(3) + DateComponents.hours(1)).fullString)
    /// ```
    public static func -(lhs: Date, rhs: DateComponents) -> Date {
        let year = rhs.year ?? 0
        let month = rhs.month ?? 0
        let day = rhs.day ?? 0
        let hour = rhs.hour ?? 0
        let minute = rhs.minute ?? 0
        let second = rhs.second ?? 0
        
        let negative = DateComponents(year: -year, month: -month, day: -day, hour: -hour, minute: -minute, second: -second)
        return Date.sharedCalendar.date(byAdding: negative, to: lhs)! // yes force unwrap. sue me.
    }
    
//    public static func +(lhs: Date, rhs: DateRelative) -> Date? {
//        return rhs.calculateNextDay(lhs)
//    }
//    
//    public static func +(lhs: Date, rhs: DateRelativeList) -> Date? {
//        return rhs.calculateNextDay(lhs)
//    }
//    
//    public static func +(lhs: Date, rhs: RepeatingDateRelativeList) -> Date? {
//        return rhs.calculateNextDay(lhs)
//    }
}

/// Component Math
extension DateComponents {
    
    /// Add two date components together
    public static func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        var copy = DateComponents()
        for component in lhs.members.union(rhs.members) {
            var sum = 0
            // Error workaround where instead of returning nil
            // the values return Int.max
            if let value = lhs.value(for: component),
                value != Int.max, value != Int.min
            { sum = sum + value }
            if let value = rhs.value(for: component),
                value != Int.max, value != Int.min
            { sum = sum + value }
            copy.setValue(sum, for: component)
        }
        return copy
    }
    
    /// Subtract date components
    public static func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        var copy = DateComponents()
        for component in lhs.members.union(rhs.members) {
            var result = 0
            // Error workaround where instead of returning nil
            // the values return Int.max
            if let value = lhs.value(for: component),
                value != Int.max, value != Int.min
            { result = result + value }
            if let value = rhs.value(for: component),
                value != Int.max, value != Int.min
            { result = result - value }
            copy.setValue(result, for: component)
        }
        return copy
    }
}

extension Date {
    public static func - (lhs: Date, rhs: Date) -> DateComponents {
        return Date.sharedCalendar.dateComponents(commonComponents, from: rhs, to: lhs)
    }
}


