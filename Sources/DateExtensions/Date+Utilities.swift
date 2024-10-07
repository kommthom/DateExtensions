//
//  Date+Utilities.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 14.03.24.
//

import Foundation

// Thanks: Erica Sadun, AshFurrow, sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki, Lily Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen, Greg Titus, Jim Morrison, aclark, Marcin Krzyzanowski, dmitrydims, Sebastian Celis, Seyithan Teymur,

/// Shared static properties
extension Date: Sendable {
    /// Returns common shared calendar, user's preferred calendar
    /// This calendar tracks changes to user’s preferred calendar identifier
    /// unlike `current`.
	public static let sharedCalendar = Calendar.autoupdatingCurrent
    /// Returns the current time
	public static var now: Date { return Date() }
}


/// Inherent date properties / component retrieval
/// Some of these are entirely pointless but I have included all components
public extension Date {
    
    /// Returns date's time interval since reference date
    var interval: TimeInterval { return self.timeIntervalSinceReferenceDate }
    
    
    // MARK: YMD
    
    /// Returns instance's year component
    var year: Int { return Date.sharedCalendar.component(.year, from: self) }
    /// Returns instance's month component
    var month: Int { return Date.sharedCalendar.component(.month, from: self) }
    /// Returns instance's day component
    var day: Int { return Date.sharedCalendar.component(.day, from: self) }
    /// Returns instance's hour component
    
    
    // MARK: HMS
    
    var hour: Int { return Date.sharedCalendar.component(.hour, from: self) }
    
    var quarterHour: Int { return Date.sharedCalendar.component(.minute, from: self) / 15 }
    /// Returns instance's minute component
    var minute: Int { return Date.sharedCalendar.component(.minute, from: self) }
    /// Returns instance's second component
    var second: Int { return Date.sharedCalendar.component(.second, from: self) }
    /// Returns instance's nanosecond component
    var nanosecond: Int { return Date.sharedCalendar.component(.nanosecond, from: self) }
    
    // MARK: Weeks
    
    /// Returns instance's weekday component
    var weekday: Int { return Date.sharedCalendar.component(.weekday, from: self) }
    /// Returns instance's weekdayOrdinal component
    var weekdayOrdinal: Int { return Date.sharedCalendar.component(.weekdayOrdinal, from: self) }
    /// Returns instance's weekOfMonth component
    var weekOfMonth: Int { return Date.sharedCalendar.component(.weekOfMonth, from: self) }
    /// Returns number of weeks + 1  from first of month
    var weekInMonth: Int { return (self.day / 7) + 1 }
    /// Returns instance's weekOfYear component
    var weekOfYear: Int { return Date.sharedCalendar.component(.weekOfYear, from: self) }
    /// Returns number of weeks + 1 from first of year
    var weekInYear: Int { return (self.dayOfYear / 7) + 1 }
    /// Returns instance's yearForWeekOfYear component
    var yearForWeekOfYear: Int { return Date.sharedCalendar.component(.yearForWeekOfYear, from: self) }
    var dayOfYear: Int { return 1 + self.startOfYear.days(to: self) }
    
    // MARK: Other
    
    /// Returns instance's quarter component
    var quarter: Int { return Date.sharedCalendar.component(.quarter, from: self) }
    /// Returns instance's (meaningless) era component
    var era: Int { return Date.sharedCalendar.component(.era, from: self) }
    /// Returns instance's (meaningless) calendar component
    var calendar: Int { return Date.sharedCalendar.component(.calendar, from: self) }
    /// Returns instance's (meaningless) timeZone component.
    var timeZone: Int { return Date.sharedCalendar.component(.timeZone, from: self) }
}

// Date characteristics
extension Date {
    /// Returns true if date falls before current date
    public var isPast: Bool { return self < Date() }
    
    /// Returns true if date falls after current date
    public var isFuture: Bool { return self > Date() }
    
    /// Returns trype of day:  falls on typical weekend or workiday
	public var typeOfDay: TypedDay.TypeOfDay {
        guard let holyday = Holydays.shared.first(matching: .isHolydayDay(comparedTo: self)) else { return Date.sharedCalendar.isDateInWeekend(self) ? .weekend : .workingDay }
        return .holyday(holyday.typeOfHolyday)
    }
}

// Date distances
public extension Date {
    /// Returns the time interval between two dates
    static func interval(_ date1: Date, _ date2: Date) -> TimeInterval {
        return date2.interval - date1.interval
    }
    
    /// Returns a time interval between the instance and another date
    func interval(to date: Date) -> TimeInterval {
        return Date.interval(self, date)
    }
    
    /// Returns the distance between two dates
    /// using the user's preferred calendar
    /// e.g.
    /// ```
    /// let date1 = Date.shortDateFormatter.date(from: "1/1/16")!
    /// let date2 = Date.shortDateFormatter.date(from: "3/13/16")!
    /// Date.distance(date1, to: date2, component: .day) // 72
    /// ```
    /// - Warning: Returns 0 for bad components rather than crashing
    static func distance(_ date1: Date, to date2: Date, component: Calendar.Component) -> Int {
        return Date.sharedCalendar.dateComponents([component], from: date1, to: date2)[component] ?? 0
    }
    
    /// Returns the distance between the instance and another date
    /// using the user's preferred calendar
    /// e.g.
    /// ```
    /// let date1 = Date.shortDateFormatter.date(from: "1/1/16")!
    /// let date2 = Date.shortDateFormatter.date(from: "3/13/16")!
    /// date1.distance(to: date2, component: .day) // 72
    /// ```
    /// - Warning: Returns 0 for bad components rather than crashing
    func distance(to date: Date, component: Calendar.Component) -> Int {
        return Date.sharedCalendar.dateComponents([component], from: self, to: date)[component] ?? 0
    }
    
    /// Returns the number of days between the instance and a given date. May be negative
    func days(to date: Date) -> Int { return distance(to: date, component: .day) }
    /// Returns the number of hours between the instance and a given date. May be negative
    func hours(to date: Date) -> Int { return distance(to: date, component: .hour) }
    
    func quarterHours(to date: Date) -> Int { return minutes(to: date) / 15 }
    /// Returns the number of minutes between the instance and a given date. May be negative
    func minutes(to date: Date) -> Int { return distance(to: date, component: .minute) }
    /// Returns the number of seconds between the instance and a given date. May be negative
    func seconds(to date: Date) -> Int { return distance(to: date, component: .second) }
    
    /// Returns a (days, hours, minutes, seconds) tuple representing the
    /// time remaining between the instance and a target date.
    /// Not for exact use. For example:
    ///
    /// ```
    /// let test = Date().addingTimeInterval(5.days + 3.hours + 2.minutes + 10.seconds)
    /// print(Date().offsets(to: test))
    /// // prints (5, 3, 2, 10 or possibly 9 but rounded up)
    /// ```
    ///
    /// - Warning: returns 0 for any error when fetching component
    func offsets(to date: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let components = Date.sharedCalendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: self, to: date.addingTimeInterval(0.5)) // round up
        return (
            days: components[.day] ?? 0,
            hours: components[.hour] ?? 0,
            minutes: components[.minute] ?? 0,
            seconds: components[.second] ?? 0
        )
    }
    
    func min(_ compareWith: Date) -> Date { self < compareWith ? self : compareWith }
    func max(_ compareWith: Date) -> Date { self > compareWith ? self : compareWith }
}

// Utility
public extension Date {
    /// Return the nearest hour using a 24 hour clock
    var nearestHour: Int { return (self.offset(.minute, 30)).hour }
    
    /// Return the nearest minute
    var nearestMinute: Int { return (self.offset(.second, 30)).minute }
    
    /// Return the nearest minute
    var nearestQuarterHour: Int { return (self.offset(.minute, 7).offset(.second, 30)).minute / 15 }
    
    var roundedToNearestQuarterHour: Date {
        let addedRounding = self.offset(.minute, 7).offset(.second, 30)
        return Date.sharedCalendar.date(from: DateComponents(year: components.year, month: components.month, day: components.day, hour: addedRounding.hour, minute: (addedRounding.minute / 15) * 15)) ?? self
    }
}

// Canonical dates
extension Date {
    
    /// Returns a date representing midnight at the start of this day
    public var startOfDay: Date {
        let midnight = DateComponents(year: components.year, month: components.month, day: components.day)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: midnight) ?? self
    }
    /// Returns a date representing midnight at the start of this day
    public var dateInTimeZone: Date {
        let offsetInSeconds = Date.sharedCalendar.timeZone.secondsFromGMT()
        return self.offset(.second, 0 - offsetInSeconds)
    }
    public func setTime(time: Date, inTimeZone: Bool = true) -> Date {
        var currentDay = self.startOfDay
        if time.hour != 0 { currentDay = currentDay.offset(.hour, time.hour) }
        if time.minute != 0 { currentDay = currentDay.offset(.minute, time.minute) }
        if inTimeZone { currentDay = currentDay.dateInTimeZone }
        return currentDay > self ? currentDay : currentDay.offset(.day, 1)
    }
    /// Returns a date representing midnight at the start of this day.
    /// Is synonym for `startOfDay`.
    public var today: Date { return self.startOfDay }
    /// Returns a date representing midnight at the start of tomorrow
    public var tomorrow: Date { return self.today.offset(.day, 1) }
    public var nextWorkingDay: Date {
        var nextDay = self.tomorrow
        while nextDay.typeOfDay == .weekend {
            nextDay = nextDay.tomorrow
        }
        return nextDay
    }
    public var nextWeekendDay: Date { 
        var nextDay = self.tomorrow
        while nextDay.typeOfDay == .workingDay || nextDay.typeOfDay == .holyday(nil) {
            nextDay = nextDay.tomorrow
        }
        return nextDay
    }

    public var nextWeekendOrHolyday: Date {
            var nextDay = self.tomorrow
            while nextDay.typeOfDay == .workingDay {
                nextDay = nextDay.tomorrow
            }
            return nextDay
        }
    /// Returns a date representing midnight at the start of yesterday
    public var yesterday: Date { return self.today.offset(.day, -1) }
    
    /// Returns today's date at the midnight starting the day
    public static var today: Date { return Date().startOfDay }
    /// Returns tomorrow's date at the midnight starting the day
    public static var tomorrow: Date { return Date.today.offset(.day, 1) }
    /// Returns yesterday's date at the midnight starting the day
    public static var yesterday: Date { return Date.today.offset(.day, -1) }
    
    /// Returns a date representing a second before midnight at the end of the day
    public var endOfDay: Date { return self.tomorrow.startOfDay.offset(.second, -1) }
    /// Returns a date representing a second before midnight at the end of today
    public static var endOfToday: Date { return Date().endOfDay }
    
    /// Determines whether two days share the same date
    public static func sameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Date.sharedCalendar.isDate(date1, inSameDayAs: date2)
    }
    
    /// Returns true if this date is the same date as today for the user's preferred calendar
    public var isToday: Bool { return Date.sharedCalendar.isDateInToday(self) }
    /// Returns true if this date is the same date as tomorrow for the user's preferred calendar
    public var isTomorrow: Bool { return Date.sharedCalendar.isDateInTomorrow(self) }
    /// Returns true if this date is the same date as yesterday for the user's preferred calendar
    public var isYesterday: Bool { return Date.sharedCalendar.isDateInYesterday(self) }
    
    /// Returns the start of the instance's week of year for user's preferred calendar
    public var startOfWeek: Date {
        let components = self.allComponents
        let startOfWeekComponents = DateComponents(weekOfYear: components.weekOfYear, yearForWeekOfYear: components.yearForWeekOfYear)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: startOfWeekComponents) ?? self
    }
    /// Returns the start of the current week of year for user's preferred calendar
    public static var thisWeek: Date {
        return Date().startOfWeek
    }
    
    /// Returns the start of next week of year for user's preferred calendar
    public var nextWeek: Date { return self.offset(.weekOfYear, 1) }
    /// Returns the start of last week of year for user's preferred calendar
    public var lastWeek: Date { return self.offset(.weekOfYear, -1) }
    public func nextWeekday(dayOfWeek: Int) -> Date {
        var daysToAdd = dayOfWeek - weekday
        if daysToAdd < 1 { daysToAdd += 7}
        return self.today.offset(.day, daysToAdd)
    }
    /// Returns the start of next week of year for user's preferred calendar relative to date
    public static var nextWeek: Date { return Date().offset(.weekOfYear, 1) }
    /// Returns the start of last week of year for user's preferred calendar relative to date
    public static var lastWeek: Date { return Date().offset(.weekOfYear, -1) }
    
    /// Returns true if two weeks likely fall within the same week of year
    /// in the same year, or very nearly the same year
    public static func sameWeek(_ date1: Date, _ date2: Date) -> Bool {
        return date1.startOfWeek == date2.startOfWeek
    }
    
    /// Returns true if date likely falls within the current week of year
    public var isThisWeek: Bool { return Date.sameWeek(self, Date.thisWeek) }
    /// Returns true if date likely falls within the next week of year
    public var isNextWeek: Bool { return Date.sameWeek(self, Date.nextWeek) }
    /// Returns true if date likely falls within the previous week of year
    public var isLastWeek: Bool { return Date.sameWeek(self, Date.lastWeek) }
    
    /// Returns a date representing the start of this month
    public var startOfMonth: Date {
        let startDate = DateComponents(year: components.year, month: components.month)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: startDate) ?? self
    }
    public func nextMonthDay(dayOfMonth: Int) -> Date {
        var daysToAdd = dayOfMonth - self.day
        if daysToAdd < 1 { daysToAdd += self.daysInMonth}
        return self.today.offset(.day, daysToAdd)
    }
    public func nextMonthWorkingDay(dayOfMonth: Int) -> Date {
        var currentDay = self.startOfMonth
        if currentDay.typeOfDay == .weekend { currentDay = currentDay.yesterday }
        for _ in 1...dayOfMonth { currentDay = currentDay.nextWorkingDay }
        if currentDay <= self {
            currentDay = self.endOfMonth
            for _ in 1...dayOfMonth { currentDay = currentDay.nextWorkingDay }
        }
        return currentDay
    }
    public func nextMonthWeekendDay(dayOfMonth: Int, withHolyday: Bool = true) -> Date {
        var currentDay = self.startOfMonth
        if currentDay.typeOfDay == .workingDay || (withHolyday && currentDay.typeOfDay == .holyday(nil)) { currentDay = currentDay.yesterday }
        for _ in 1...dayOfMonth { currentDay = withHolyday ? currentDay.nextWeekendDay : currentDay.nextWeekendOrHolyday }
        if currentDay <= self {
            currentDay = self.endOfMonth
            for _ in 1...dayOfMonth { currentDay = withHolyday ? currentDay.nextWeekendDay : currentDay.nextWeekendOrHolyday }
        }
        return currentDay
    }
    /// Returns the start of month for the user's preferred calendar
    public static var thisMonth: Date {
        let components = Date().components
        let themonth = DateComponents(year: components.year, month: components.month)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: themonth) ?? Date()
    }
    /// Returns a date representing a second before midnight at the end of the day
    public var endOfMonth: Date { return self.nextMonth.startOfDay.offset(.day, -1) }
    public var endOfNextMonth: Date {
        let ultimo = self.endOfMonth
        return ultimo.day > self.day ? ultimo : self.nextMonth.endOfMonth
    }
    public var daysInMonth: Int { return self.nextMonth.startOfDay.offset(.day, -1).day }
    /// Returns a date moving 1 month forward
    public var nextMonth: Date { return self.offset(.month, 1) }
    /// Returns a date representing midnight at the start of yesterday
    public var lastMonth: Date { return self.offset(.month, -1) }
    public func nextWeekdayInMonth(week: Int, dayOfWeek: Int) -> Date {
        let dayThisMonth = self.startOfMonth.nextWeekday(dayOfWeek: dayOfWeek).offset(.day, (week - 1) * 7)
        return dayThisMonth > self ? dayThisMonth : self.nextMonth.nextWeekday(dayOfWeek: dayOfWeek).offset(.day, (week - 1) * 7)
    }
    /// Returns the start of next month for the user's preferred calendar
    public static var nextMonth: Date { return thisMonth.offset(.month, 1) }
    /// Returns the start of previous year for the user's preferred calendar
    public static var lastMonth: Date { return thisMonth.offset(.month, -1) }
    /// Returns true if two dates share the same month component
    public static func sameMonth(_ date1: Date, _ date2: Date) -> Bool {
        return (date1.allComponents.year == date2.allComponents.year) &&
            (date1.allComponents.month == date2.allComponents.month)
    }
    
    /// Returns true if date falls within this month for the user's preferred calendar
    public var isThisMonth: Bool { return Date.sameMonth(self, Date.thisMonth) }
    /// Returns true if date falls within next month for the user's preferred calendar
    public var isNextMonth: Bool { return Date.sameMonth(self, Date.nextMonth) }
    /// Returns true if date falls within previous month for the user's preferred calendar
    public var isLastMonth: Bool { return Date.sameMonth(self, Date.lastMonth) }
    
    /// Returns a date representing the start of this year
    public var startOfYear: Date {
        let startDate = DateComponents(year: components.year)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: startDate) ?? self
    }
    public var endOfYear: Date {
        let startDate = DateComponents(year: components.year! + 1)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: startDate)?.yesterday ?? self
    }
    public var daysInYear: Int { return self.endOfYear.dayOfYear }
    public func nextDayOfYear(day: [Int]) -> Date {
        switch day.count {
        case 2:
            var computedDay = day[1] > 1 ? self.startOfYear.offset(.month, day[1] - 1) : self.startOfYear
            if day[0] > 1 { computedDay = computedDay.offset(.day, day[0] - 1) }
            return computedDay > self ? computedDay : computedDay.offset(.year, 1)
        case 1:
            let daysToAdd = day[0] - self.dayOfYear
            return self.offset(.day, daysToAdd > 0 ? daysToAdd : daysToAdd + self.daysInYear)
        default:
            return self
        }
    }
    public func nextYearWorkingDay(dayOfYear: Int) -> Date {
        var currentDay = self.startOfYear
        switch currentDay.typeOfDay {
            case .weekend, .holyday(_): currentDay = currentDay.yesterday
            default: let _ = currentDay
        }
        for _ in 1...dayOfYear { currentDay = currentDay.nextWorkingDay }
        if currentDay <= self {
            currentDay = self.endOfYear
            for _ in 1...dayOfYear { currentDay = currentDay.nextWorkingDay }
        }
        return currentDay
    }
    public func nextYearWeekendDay(dayOfYear: Int) -> Date {
        var currentDay = self.startOfYear
        switch currentDay.typeOfDay {
            case .workingDay: currentDay = currentDay.yesterday
            default: let _ = currentDay
        }
        for _ in 1...dayOfYear { currentDay = currentDay.nextWeekendDay }
        if currentDay <= self {
            currentDay = self.endOfYear
            for _ in 1...dayOfYear { currentDay = currentDay.nextWeekendDay }
        }
        return currentDay
    }
    /// Returns the start of year for the user's preferred calendar
    public static var thisYear: Date {
        let components = Date().components
        let theyear = DateComponents(year: components.year)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: theyear) ?? Date()
    }
    /// Returns the start of next year for the user's preferred calendar
    public var nextYear: Date { return self.offset(.year, 1) }
    public func nextWeekdayInYear(week: Int, dayOfWeek: Int) -> Date {
        let dayThisYear = self.startOfYear.nextWeekday(dayOfWeek: dayOfWeek).offset(.day, (week - 1) * 7)
        return dayThisYear > self ? dayThisYear : self.nextYear.nextWeekday(dayOfWeek: dayOfWeek).offset(.day, (week - 1) * 7)
    }
    /// Returns the start of previous year for the user's preferred calendar
    public var lastYear: Date { return self.offset(.year, -1) }
    /// Returns the start of next year for the user's preferred calendar
    public static var nextYear: Date { return thisYear.offset(.year, 1) }
    /// Returns the start of previous year for the user's preferred calendar
    public static var lastYear: Date { return thisYear.offset(.year, -1) }
    
    /// Returns true if two dates share the same year component
    public static func sameYear(_ date1: Date, _ date2: Date) -> Bool {
        return date1.allComponents.year == date2.allComponents.year
    }
    
    /// Returns true if date falls within this year for the user's preferred calendar
    public var isThisYear: Bool { return Date.sameYear(self, Date.thisYear) }
    /// Returns true if date falls within next year for the user's preferred calendar
    public var isNextYear: Bool { return Date.sameYear(self, Date.nextYear) }
    /// Returns true if date falls within previous year for the user's preferred calendar
    public var isLastYear: Bool { return Date.sameYear(self, Date.lastYear) }
}

//Canonical times
extension Date {
    /// Returns the start of hour
    public var startOfHour: Date {
        let thehour = DateComponents(year: components.year, month: components.month, day: components.day, hour: components.hour)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: thehour) ?? Date()
    }
    /// Returns the start of hour
    public static var thisHour: Date {
        let components = Date().components
        let thehour = DateComponents(year: components.year, month: components.month, day: components.day, hour: components.hour)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: thehour) ?? Date()
    }
    /// Returns the start of next hour
    public var nextHour: Date { return self.offset(.hour, 1) }
    /// Returns the start of previous hour for the user's preferred calendar
    public var lastHour: Date { return self.offset(.hour, -1) }
    /// Returns true if two dates share the same hour component
    /// Returns the start of next hour
    public static var nextHour: Date { return thisHour.offset(.hour, 1) }
    /// Returns the start of previous hour for the user's preferred calendar
    public static var lastHour: Date { return thisHour.offset(.hour, -1) }
    /// Returns true if two dates share the same hour component
    public static func sameHour(_ date1: Date, _ date2: Date) -> Bool {
        return (date1.allComponents.year == date2.allComponents.year) &&
        (date1.allComponents.month == date2.allComponents.month) &&
        (date1.allComponents.day == date2.allComponents.day) &&
        (date1.allComponents.hour == date2.allComponents.hour) }
    //public var nextHourBegin: Date { return Date.sharedCalendar.nextDate(after: self, matching: DateComponents(minute: 0), matchingPolicy: .nextTime) ?? self }
    
    /// Returns true if date falls within this hour
    public var isThisHour: Bool { return Date.sameHour(self, Date.thisHour) }
    /// Returns true if date falls within next hour
    public var isNextHour: Bool { return Date.sameHour(self, Date.nextHour) }
    /// Returns true if date falls within previous hour
    public var isLastHour: Bool { return Date.sameHour(self, Date.lastHour) }
    
    /// Returns the start of quarter hour
    public var startOfQuarterHour: Date {
        let thequarterhour = DateComponents(year: components.year, month: components.month, day: components.day, hour: components.hour, minute: Date.getQuarterFromMinutes(components.minute))
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: thequarterhour) ?? Date()
    }
    /// Returns the start of quarter hour
    public static var thisQuarterHour: Date {
        let components = Date().components
        let thequarterhour = DateComponents(year: components.year, month: components.month, day: components.day, hour: components.hour, minute: getQuarterFromMinutes(components.minute))
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: thequarterhour) ?? Date()
    }
    
    private static func getQuarterFromMinutes(_ minutes: Int?) -> Int {
        let minutesNotNil: Int = minutes ?? 0
        return minutesNotNil - (minutesNotNil % 15)
    }
    
    /// Returns the start of next quarter hour
    public var nextQuarterHour: Date { return startOfQuarterHour.offset(.minute, 15) }
    /// Returns the start of previous hour
    public var lastQuarterHour: Date { return startOfQuarterHour.offset(.minute, -15) }
    /// Returns the start of next quarter hour
    public static var nextQuarterHour: Date { return thisQuarterHour.offset(.minute, 15) }
    /// Returns the start of previous hour
    public static var lastQuarterHour: Date { return thisQuarterHour.offset(.minute, -15) }
    /// Returns true if two dates share the same minute component
    public static func sameQuarterHour(_ date1: Date, _ date2: Date) -> Bool {
        return (date1.allComponents.year == date2.allComponents.year) &&
        (date1.allComponents.month == date2.allComponents.month) &&
        (date1.allComponents.day == date2.allComponents.day) &&
        (date1.allComponents.hour == date2.allComponents.hour) &&
        (getQuarterFromMinutes(date1.allComponents.minute) == getQuarterFromMinutes(date2.allComponents.minute)) }
    
    /// Returns true if date falls within this quarter hour
    public var isThisQuarterHour: Bool { return Date.sameQuarterHour(self, Date.thisQuarterHour) }
    /// Returns true if date falls within next quarter hour
    public var isNextQuarterHour: Bool { return Date.sameQuarterHour(self, Date.nextQuarterHour) }
    /// Returns true if date falls within previous quarter hour
    public var isLastQuarterHour: Bool { return Date.sameQuarterHour(self, Date.lastQuarterHour) }
}
