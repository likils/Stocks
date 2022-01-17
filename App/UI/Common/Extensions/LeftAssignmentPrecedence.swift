// ----------------------------------------------------------------------------
//
//  LeftAssignmentPrecedence.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

precedencegroup LeftAssignmentPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
    assignment: true
}

infix operator <- : LeftAssignmentPrecedence

@discardableResult
public func <- <T>(lhs: T, rhs: (inout T) throws -> Void) rethrows -> T {

    guard var value = Optional(lhs) else {
        return lhs
    }

    try rhs(&value)
    return value
}
