//
//  ComponentYear.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public struct ComponentYear: Codable, Sendable {
	public typealias FormatOutput = String
	
	public var intValue: Int
	public var century: Int { self.intValue / 100 }
	public var year: Int { self.intValue % 100 }
	
	public init(century: Int = 20, year: Int = 0) {
		if year > 99 {
			self.intValue = year
		} else {
			self.intValue = year + (100 * century)
		}
	}
}
