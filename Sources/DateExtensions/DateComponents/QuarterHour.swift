//
//  QuarterHour.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public struct QuarterHour: Sendable, Codable {
	public typealias FormatOutput = String
	
	public var intValue: Int
	public var minutes: Int { intValue * 15 }
	
	init(_ intValue: Int) {
		self.intValue = intValue
	}
	init(minutes: Int) {
		self.intValue = minutes / 15
	}
}
