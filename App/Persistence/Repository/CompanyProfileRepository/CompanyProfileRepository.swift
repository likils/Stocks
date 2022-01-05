// ----------------------------------------------------------------------------
//
//  CompanyProfileRepository.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine

// ----------------------------------------------------------------------------

public protocol CompanyProfileRepository: AnyObject {

// MARK: - Methods

    func getCompanyProfiles() async -> [CompanyProfileModel]

    func getCompanyProfilesPublusher() async -> AnyPublisher<[CompanyProfileModel], Never>

    func putCompanyProfile(_ companyProfile: CompanyProfileModel)

    func moveCompanyProfile(_ companyProfile: CompanyProfileModel, to newIndex: Int)

    func moveCompanyProfile(from index: Int, to newIndex: Int)

    func removeCompanyProfile(_ companyProfile: CompanyProfileModel)

    func removeCompanyProfile(atIndex index: Int)

    func removeAll()
}
