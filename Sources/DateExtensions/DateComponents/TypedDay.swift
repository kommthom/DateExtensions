//
//  TypedDay.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

import Foundation

public struct TypedDay: Sendable {
	public typealias FormatOutput = String
	
	public enum TypeOfDay: Equatable, Hashable, Codable, Sendable {
		case workingDay, weekend, holyday(Holyday?), ultimo, yearsEnd
		
		public var typeOfDayNo: TypeOfDayNo {
			switch self {
				case .workingDay, .weekend: .ofWeek
				case .holyday(_), .yearsEnd: .ofYear
				case .ultimo: .ofMonth
			}
		}
		
		public static func ==(lhs: TypeOfDay, rhs: TypeOfDay) -> Bool {
			switch (lhs, rhs) {
				case ( .holyday(_), .holyday(_)): return true
				case (.workingDay,.workingDay), (.weekend, .weekend), (.ultimo, .ultimo), (.yearsEnd, .yearsEnd): return true
				default: return false
			}
		}
	}
	
	public enum TypeOfDayNo: String, Codable, Sendable {
		case ofMonth, ofYear, ofWeek
	}
	
	public var type: TypeOfDayNo
	public var dayFilter: TypeOfDay?
	public var intValue: Int
	
	public init(type: TypeOfDayNo = .ofMonth, dayFilter: TypeOfDay? = nil, day: Int = -1) {
		self.type = type
		self.dayFilter = dayFilter
		if let _ = dayFilter {
			self.intValue = -1
			self.intValue = day
		} else {
			self.intValue = day
			if day == 99 && type == .ofMonth {
				self.dayFilter = .ultimo
				self.intValue = day
			} else if day == 999 && type == .ofYear {
				self.dayFilter = .yearsEnd
				self.intValue = day
			} else {
				self.dayFilter = dayFilter
				self.intValue = day
			}
		}
	}
	
	public init (dayOfYear: Int) {
		self.init(type: .ofYear, dayFilter: nil, day: dayOfYear)
	}
	
	public init (dayOfMonth: Int) {
		self.init(type: .ofMonth, dayFilter: nil, day: dayOfMonth)
	}
	
	public init (dayOfWeek: Int) {
		self.init(type: .ofWeek, dayFilter: nil, day: dayOfWeek)
	}
	
	public init?(padded: String) {
		guard let intParsed = try? Int(padded, strategy: IntegerParseStrategy(format: IntegerFormatStyle<Int>())) else { return nil }
		self.init(intValue: intParsed, digits: padded.count)
	}
	
	public init(intValue: Int, digits: Int) {
		let type: TypeOfDayNo = switch digits {
			case 3: .ofYear
			case 1: .ofWeek
			default: .ofMonth
		}
		let dayFilter: TypeOfDay? = switch intValue {
			case 999: .yearsEnd
			case 99: .ultimo
			default: .none
		}
		self.init(type: type, dayFilter: dayFilter, day: intValue)
	}

	public func replaceDayLast(_ forDate: Date) -> Int {
		if self.intValue == 99 && self.type == .ofMonth {
			return forDate.endOfMonth.day
		} else if self.intValue == 999 && self.type == .ofYear {
			return forDate.endOfYear.day
		} else {
			return intValue
		}
	}
	
	public var weekday: Weekday? { self.type == .ofWeek  ? Weekday(self.intValue) : nil }
}

public enum Weekday: String, CustomStringConvertible, CaseIterable {
	case sunday = "sunday"
	case monday = "monday"
	case tuesday = "tuesday"
	case wednesday = "wednesday"
	case thursday = "thursday"
	case friday = "friday"
	case saturday = "saturday"

	public init?(_ weekday: Int) {
		self.init(rawValue: Weekday.allCases[weekday].rawValue)
	}

	///  Initialize with specific date, gets current weekday using Calendar
	public init?(date: Date) {
		self.init(date.weekday)
	}
	
	public var index: Int {
		Weekday.allCases.firstIndex(where: { $0 == self } )!
	}
	
	public var description: String { return self.rawValue }

	/// Weekday for this moment, alias to call `Weekday(date: Date())`
	public static var current: Weekday {
		return Weekday(date: Date())!
	}

//	/// Creates list of all weekdays in week, respects firstWeekday settings in `Calendar.current`
//	public static var all: [Weekday] {
//		return LocaleIdentifier.notSet.localeNames.startingFirstWeekdayNames.map {
//			return Weekday(rawValue: $0)!
//		}
//	}
	
//	/// same with weekdays as string
//	public static var allEnum: [String] {
//		return all.map {
//			return String(describing: $0)
//		}
//	}
	
//	public static func getLocalizedWeekday(locale: LocaleIdentifier = .notSet, find weekday: String) -> Weekday? {
//		if let index = Weekday.getLocalizedWeekdayIndex(locale: locale, find: weekday.trimmingCharacters(in: [","])) {
//			return Weekday(index)
//		} else if let index = Weekday.getLocalizedWeekdayIndex(locale: locale, find: weekday, useShortNames: true) {
//			return Weekday(index)
//		} else { return nil }
//	}
//	
//	public static func getLocalizedWeekdayIndex(locale: LocaleIdentifier = .notSet, find weekday: String, useShortNames: Bool = false) -> Int? {
//		return useShortNames ? locale.localeNames.shortWeekdayNames.firstIndex(of: weekday) : locale.localeNames.allWeekdayNames.firstIndex(of: weekday)
//	}

	/// Creates list of all standard working weekdays in week
	public static var workingDays: [Weekday] {
		return [.monday, .tuesday, .wednesday, .thursday, .friday]
	}

	/// Compare method that can be used in `Collection.sorted` method
	public static func compare(_ lhs: Weekday, _ rhs: Weekday) -> Bool {
		let lhsAligned = (lhs.index + Date.sharedCalendar.firstWeekday) % 7
		let rhsAligned = (rhs.index + Date.sharedCalendar.firstWeekday) % 7
		return lhsAligned < rhsAligned
	}
}
