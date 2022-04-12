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

    func getCompanyProfiles() async -> [CompanyProfileDataModel]

    func getCompanyProfilesPublisher() -> AnyPublisher<[CompanyProfileDataModel], Never>

    func getCompanyProfile(with ticker: String) async -> CompanyProfileDataModel?

    func putCompanyProfile(_ companyProfile: CompanyProfileDataModel)

    func moveCompanyProfile(with ticker: String, to newIndex: Int)

    func removeCompanyProfile(with ticker: String)

    func removeAll()
}
