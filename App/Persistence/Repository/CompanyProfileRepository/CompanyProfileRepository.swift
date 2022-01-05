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

    func putCompanyProfile(_ companyProfile: CompanyProfileModel) async

    func moveCompanyProfile(_ companyProfile: CompanyProfileModel, to newIndex: Int) async

    func removeCompanyProfile(_ companyProfile: CompanyProfileModel) async

    func removeAll() async
}
