// ----------------------------------------------------------------------------
//
//  Array.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

extension Array {

    // MARK: - Properties

    public static var empty: Array {
        return []
    }

    // MARK: - Methods

    @discardableResult
    public mutating func move(fromIndex oldIndex: Int, toIndex newIndex: Int) -> Element {

        let object = remove(at: oldIndex)
        insert(object, at: newIndex)

        return object
    }
}
