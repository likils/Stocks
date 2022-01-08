// ----------------------------------------------------------------------------
//
//  CandlesResolution.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

public enum CandlesResolution: String, Codable {
    case minute = "1"
    case minutes_5 = "5"
    case minutes_15 = "15"
    case minutes_30 = "30"
    case minutes_60 = "60"
    case day = "D"
    case week = "W"
    case month = "M"
}
