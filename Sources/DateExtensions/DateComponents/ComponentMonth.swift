//
//  ComponentMonth.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public struct ComponentMonth: Sendable, Codable {
	public typealias FormatOutput = String
	
	public var intValue: Int
	//public var month: Month { Month(intValue)! }
	public var quarter: Int { 1 + (intValue / 4) }
	
	public init?(intValue: Int) {
		if intValue < 1 || intValue > 12 { return nil }
		self.intValue = intValue
	}
}

public enum Month: String, CustomStringConvertible, CaseIterable {
	case january = "january"
	case february = "february"
	case march = "march"
	case april = "april"
	case may = "may"
	case june = "june"
	case july = "july"
	case august = "august"
	case september = " september"
	case october = "october"
	case november = "november"
	case december = "december"
	
	public init?(_ month: Int) {
		self.init(rawValue: Month.allCases[month - 1].rawValue)
	}
	
	public var description: String { self.rawValue }
	public var index: Int { return 1 + Month.allCases.firstIndex(of: self)! }
}
