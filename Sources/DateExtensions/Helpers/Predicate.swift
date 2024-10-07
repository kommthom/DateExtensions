//
//  Predicate.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 22.03.24.
//

import Foundation

extension KeyPath:@unchecked @retroactive Sendable {}

//typealias Predicate<T> = (T) -> Bool

public struct Predicate<Target: Sendable>: Sendable {
    public var matches: @Sendable(Target) -> Bool

    public init(matcher: @escaping @Sendable (Target) -> Bool) {
        matches = matcher
    }
}

public func ==<T: Sendable, V: Sendable & Equatable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] == rhs }
}

public prefix func !<T: Sendable>(rhs: KeyPath<T, Bool>) -> Predicate<T> {
    rhs == false
}

public func ><T: Sendable, V: Sendable & Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] > rhs }
}

public func <<T: Sendable, V: Sendable & Comparable>(lhs: KeyPath<T, V>, rhs: V) -> Predicate<T> {
    Predicate { $0[keyPath: lhs] < rhs }
}

public func &&<T: Sendable>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    Predicate { lhs.matches($0) && rhs.matches($0) }
}

public func ||<T: Sendable>(lhs: Predicate<T>, rhs: Predicate<T>) -> Predicate<T> {
    Predicate { lhs.matches($0) || rhs.matches($0) }
}

public func ~=<T: Sendable, V: Sendable & Collection>(lhs: KeyPath<T, V>, rhs: V.Element) -> Predicate<T> where V.Element: Sendable & Equatable {
    Predicate { $0[keyPath: lhs].contains(rhs) }
}
