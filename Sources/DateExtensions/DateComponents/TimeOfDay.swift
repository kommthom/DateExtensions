//
//  TimeOfDay.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 01.10.24.
//

public enum TimeOfDay: Int, Codable, Hashable, Equatable, CaseIterable, Sendable {
	case morning = 15
	case noon = 16
	case afternoon = 17
	case evening = 18
	case night = 19
	case keyWord = 20
	
	public var hour: Hour? {
		return switch self {
			case .morning: Hour(8)
			case .noon: Hour(12)
			case .afternoon: Hour(15)
			case .evening: Hour(18)
			case .night: Hour(22)
			case .keyWord: nil
		}
	}

	public var quarterHour: QuarterHour? {
		return switch self {
			case .keyWord: nil
			default: QuarterHour(0)
		}
	}
}
