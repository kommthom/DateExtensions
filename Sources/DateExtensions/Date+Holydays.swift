//
//  Date+Holydays.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 27.03.24.
//

import Foundation

public enum Holyday: Int, CustomStringConvertible, CaseIterable, Codable, Sendable {
    case newyear = 46
    case rosemonday = 47
    case goodfriday = 48
    case eastersunday = 49
    case eastermonday = 50
    case labourday = 51
    case ascensionday = 86
    case whitsunday = 52
    case whitmonday = 53
    case corpuschristi = 54
    case halloween = 55
    case allsaints = 56
    case christmaseve = 57
    case christmas = 58
    case christmas2 = 59
    case newyearseve = 60
    
    public var description: String { String(describing: self) }
}

public struct HolydayDay: Sendable, Comparable {
    public let date: Date
    public let typeOfHolyday: Holyday
    
    public static func < (lhs: HolydayDay, rhs: HolydayDay) -> Bool {
        lhs.date < rhs.date
    }
}

public struct Holydays: Sendable {
	public static let shared: Holydays = Holydays()
    
    public let holydays: [HolydayDay]
    
    public init() {
        var holydays: [HolydayDay] = .init()
        var nextHolyday = Date.today.startOfYear.offset(.day, -1)
        for _ in -2...5 { //for next eight years
            for holyday in Holyday.allCases {
                nextHolyday = nextHolyday.nextHolyday(typeOfHolyday: holyday)
                holydays.append(HolydayDay(date: nextHolyday, typeOfHolyday: holyday))
            }
        }
        self.holydays = holydays.sorted(by: < )
    }
    
    public func first(matching predicate: Predicate<HolydayDay>) -> HolydayDay? {
        holydays.first(where: predicate.matches)
    }
}

extension Predicate where Target == HolydayDay {
    public static func isHolydayDay(comparedTo date: Date = .today) -> Self {
        Predicate {
            return $0.date == date
        }
    }
}

public extension Date {
    func nextHolyday(typeOfHolyday: Holyday) -> Date {
        var newDate = self
        while newDate <= self { newDate = Date.calculateHolydayFor(desiredYear: newDate.year, typeOfHolyday: typeOfHolyday) }
        return newDate
    }
    
    static func calculateHolydayFor(desiredYear: Int, typeOfHolyday: Holyday) -> Date {
        return switch typeOfHolyday {
            case .newyear: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 1, day: 1)) ?? Date.today
            case .rosemonday: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, -41)
            case .goodfriday: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, -2)
            case .eastersunday: Date.calculateEasterDateFor(desiredYear: desiredYear)
            case .eastermonday: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, 1)
            case .labourday: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 5, day: 1)) ?? Date.today
            case .ascensionday: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, 39)
            case .whitsunday: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, 49)
            case .whitmonday: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, 50)
            case .corpuschristi: Date.calculateEasterDateFor(desiredYear: desiredYear).offset(.day, 60)
            case .halloween: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 10, day: 30)) ?? Date.today
            case .allsaints: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 11, day: 1)) ?? Date.today
            case .christmaseve: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 12, day: 24)) ?? Date.today
            case .christmas: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 12, day: 25)) ?? Date.today
            case .christmas2: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 12, day: 26)) ?? Date.today
            case .newyearseve: Date.sharedCalendar.date(from: DateComponents(year: desiredYear, month: 12, day: 31)) ?? Date.today
            //default: Date.today
        }
    }
    
    static func calculateEasterDateFor(desiredYear: Int) -> Date {
        // Calculate the date for Easter in any given year
        let a = desiredYear % 19
        let b = desiredYear / 100
        let c = desiredYear % 100
        let d = (19 * a + b - b / 4 - ((b - (b + 8) / 25 + 1) / 3) + 15) % 30
        let e = (32 + 2 * (b % 4) + 2 * (c / 4) - d - (c % 4)) % 7
        let f = d + e - 7 * ((a + 11 * d + 22 * e) / 451) + 114
        let month = f / 31
        let day = f % 31 + 1
        
        // Create Date for Easter
        let easterday = DateComponents(year: desiredYear, month: month, day: day)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: easterday) ?? Date.today
    }
}
