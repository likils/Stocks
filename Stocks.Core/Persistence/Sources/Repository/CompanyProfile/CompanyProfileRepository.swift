// ----------------------------------------------------------------------------
//
//  CompanyProfileRepository.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import StocksData

// ----------------------------------------------------------------------------

public protocol CompanyProfileRepository: AnyObject {

    // MARK: - Methods

    func getCompanyProfiles() async -> [CompanyProfileResponseModel]

    func getCompanyProfilesPublisher() -> AnyPublisher<[CompanyProfileResponseModel], Never>

    func putCompanyProfile(_ companyProfile: CompanyProfileResponseModel)

    func moveCompanyProfile(with tickerSymbol: String, to newIndex: Int)

    func removeCompanyProfile(with tickerSymbol: String)

    func removeAll()
}
