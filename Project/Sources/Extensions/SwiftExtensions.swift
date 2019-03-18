// Swift+Extensions.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

/// Perform an immediate `transform` of an instance of value type `subject`.
///
/// - Parameters:
///     - subject: The subject to transform.
///     - transform: The transform to perform.
///
/// - Throws: Any error that was thrown inside `transform`.
///
/// - Returns: A transformed `subject`.
public func with<Subject>(_ subject: Subject, _ transform: (_ subject: inout Subject) throws -> Void) rethrows -> Subject {
    var subject = subject
    try transform(&subject)
    return subject
}

public func unsafeWith<Subject>(_ transform: (_ subject: inout Subject?) throws -> Void) rethrows -> Subject {
    return try with(nil, transform)!
}

/// Clamp value within a range.
///
/// - Parameters:
///     - value: A value to clamp.
///     - range: A bounding range.
///
/// - Returns: A clamped value.
internal func clamp<T>(_ value: T, within range: ClosedRange<T>) -> T where T: Comparable {
    return max(range.lowerBound, min(range.upperBound, value))
}
