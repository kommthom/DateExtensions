//
//  ComponentDate.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public struct ComponentDate: Sendable {
	public var yearComponent: ComponentYear?
	public var monthComponent: ComponentMonth?
	public var week: TypedWeek?
	public var day: TypedDay?
	
	public init(yearComponent: ComponentYear? = nil, monthComponent: ComponentMonth? = nil, week: TypedWeek? = nil, day: TypedDay? = nil) {
		self.yearComponent = yearComponent
		self.monthComponent = monthComponent
		self.week = week
		self.day = day
	}
}

extension ComponentDate: Codable {
	private enum CodingKeys: String, CodingKey {
		case yearComponent, monthComponent, week, day
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(yearComponent, forKey: .yearComponent)
		try container.encode(monthComponent, forKey: .monthComponent)
		try container.encode(week, forKey: .week)
		try container.encode(day, forKey: .day)
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let yearComponent = try container.decode(ComponentYear?.self, forKey: .yearComponent)
		let monthComponent = try container.decode(ComponentMonth?.self, forKey: .monthComponent)
		let week = try container.decode(TypedWeek?.self, forKey: .week)
		let day = try container.decode(TypedDay?.self, forKey: .day)
		self.init(yearComponent: yearComponent, monthComponent: monthComponent, week: week, day: day)
	}
}
