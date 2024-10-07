//
//  TypedWeek.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public struct TypedWeek: Sendable, Codable {
	public typealias FormatOutput = String
	
	public enum TypeOfWeekNo: String, Codable, Sendable {
		case ofMonth, ofYear
	}
	
	public let type: TypeOfWeekNo
	public var intValue: Int
	
	public init(type: TypeOfWeekNo, intValue: Int) {
		self.type = type
		self.intValue = intValue
	}
}
