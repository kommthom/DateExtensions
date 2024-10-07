//
//  DateRelative.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

import Foundation

public struct DateRelative: Sendable {
	public var dateComponent: ComponentDate?
	// computed properties
	public var year: Int? { dateComponent?.yearComponent?.intValue }
	public var quarter: Int? { dateComponent?.monthComponent?.quarter }
	public var month: Int? { dateComponent?.monthComponent?.intValue }
	public var weekOfMonth: Int? { dateComponent?.week?.type == .ofMonth ? dateComponent?.week!.intValue: nil }
	public var weekOfYear: Int? { dateComponent?.week?.type == .ofYear ? dateComponent?.week!.intValue: nil }
	public var weekDay: Weekday? { dateComponent?.day?.type == .ofWeek ? dateComponent?.day!.weekday : nil }
	public var monthDay: Int? { dateComponent?.day?.type == .ofMonth ? dateComponent?.day!.intValue : nil }
	public var yearDay: Int? { dateComponent?.day?.type == .ofYear ? dateComponent?.day!.intValue : nil }
	
	public var timeComponent: ComponentTime?
	// computed properties
	public var hour: Int? { timeComponent?.hour.intValue }
	public var hourAMPM: Int? { timeComponent == nil ? nil : timeComponent!.hour.intValue % 12 }
	public var amPm: ComponentTime.AmPm? { timeComponent == nil ? nil : ComponentTime.AmPm(rawValue: timeComponent!.hour.intValue / 12) }
	public var quarterHour: Int? { timeComponent?.quarterHour.intValue }
	public var timeOfDay: TimeOfDay? { timeComponent?.timeOfDay }
	
	public var isIntervalFromNow: Bool?
	public var timeZone: TimeZone
	
	public init(date: ComponentDate? = nil, time: ComponentTime? = nil, isIntervalFromNow: Bool? = nil, timeZone: TimeZone = DateConstants.shared.defaultTimeZone) {
		self.dateComponent = date
		self.timeComponent = time
		self.isIntervalFromNow = isIntervalFromNow
		//self.timeZone = timeZone
	}
	public init(century: Int? = nil, year: Int? = nil, month: Int? = nil, week: ComponentDate.TypedWeek? = nil, day: Int? = nil, dayType: ComponentDate.TypedDay.TypeOfDayNo? = nil, dayFilter: ComponentDate.TypedDay.TypeOfDay? = nil, hour: Int? = nil, quarterHour: Int? = nil, timeOfDay: ComponentTime.TimeOfDay? = nil, isIntervalFromNow: Bool? = nil ) {
		let yearComponent = year == nil ? nil : century == nil ? ComponentDate.ComponentYear(year: year!) : ComponentDate.ComponentYear(century: century!, year: year!)
		let monthComponent = month == nil ? nil : ComponentDate.ComponentMonth(intValue: month!)
		var dayTyped: ComponentDate.TypedDay?
		if let dayComponent = day {
			dayTyped = ComponentDate.TypedDay(type: dayType ?? .ofMonth, dayFilter: dayFilter, day: day!)
		} else if let _ = dayType {
			dayTyped = ComponentDate.TypedDay(type: dayType!, dayFilter: dayFilter)
		} else {
			dayTyped = nil
		}
		self.dateComponent = yearComponent == nil && monthComponent == nil && week == nil && dayTyped == nil ? nil : ComponentDate(yearComponent: yearComponent, monthComponent: monthComponent, week: week, day: dayTyped)
		self.timeComponent = hour == nil || quarterHour == nil ? nil : ComponentTime(hour: hour!, quarterHour: quarterHour!, timeOfDay: timeOfDay, timeZone: TimeZone)
		self.isIntervalFromNow = isIntervalFromNow
	}
}

extension DateRelative: Codable {
	private enum CodingKeys: String, CodingKey {
		case dateComponent, timeComponent, timeZone, isIntervalFromNow
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(dateComponent, forKey: .dateComponent)
		try container.encode(timeComponent, forKey: .timeComponent)
		try container.encode(timeZone, forKey: .timeZone)
		try container.encode(isIntervalFromNow, forKey: .isIntervalFromNow)
	}
}
