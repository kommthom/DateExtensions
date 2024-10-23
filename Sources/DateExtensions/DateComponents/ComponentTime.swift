//
//  ComponentTime.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

import Foundation
public struct ComponentTime: Sendable {
	public enum AmPm: Int, RawRepresentable { case am = 0, pm = 1 }
	
	public var hour: Hour
	public var quarterHour: QuarterHour
	public var timeOfDay: TimeOfDay?
	public var timeZone: TimeZone
	public var time: Date?
	
	public init?(time: Date) {
		self.init(hour: time.hour, quarterHour: ((time.minute + 14) / 15) % 4)
	}
	
	public init(hour: Int = 0, quarterHour: Int = 0, timeOfDay: TimeOfDay? = nil, timeZone: TimeZone = DateConstants.default.timeZone!) {
		if let _ = timeOfDay {
			self.timeOfDay = timeOfDay
			self.hour = timeOfDay!.hour!
			self.quarterHour = timeOfDay!.quarterHour!
		} else {
			self.hour = Hour(hour)
			self.quarterHour = QuarterHour(quarterHour)
			self.timeOfDay = TimeOfDay.allCases.first(where: { $0.hour?.intValue == hour && $0.quarterHour?.intValue == quarterHour } )
		}
		self.timeZone = timeZone
	}
}

extension ComponentTime: Codable {
	private enum CodingKeys: String, CodingKey {
		case hour, quarterHour
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(hour, forKey: .hour)
		try container.encode(quarterHour, forKey: .quarterHour)
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let hour = try container.decode(Hour.self, forKey: .hour)
		let quarterHour = try container.decode(QuarterHour.self, forKey: .quarterHour)
		self.init(hour: hour.intValue, quarterHour: quarterHour.intValue)
	}
}
