// ----------------------------------------------------------------------------
//
//  Precedence.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

// MARK: - LeftAssignmentPrecedence

precedencegroup LeftAssignmentPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
    assignment: true
}

infix operator <- : LeftAssignmentPrecedence

@discardableResult
public func <- <T>(lhs: T, rhs: (inout T) throws -> Void) rethrows -> T {
    var value = lhs
    try rhs(&value)
    return value
}
