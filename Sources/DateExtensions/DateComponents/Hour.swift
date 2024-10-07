//
//  Hour.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public struct Hour: Sendable, Codable {
	public typealias FormatOutput = String
	
	public var intValue: Int
	
	init(_ intValue: Int) {
		self.intValue = intValue
	}
}
