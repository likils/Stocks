// ----------------------------------------------------------------------------
//
//  CompanyProfileRepositoryImpl.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine

// ----------------------------------------------------------------------------

final class CompanyProfileRepositoryImpl: CompanyProfileRepository {

// MARK: - Construction

    init(storage: AnyStorage<String, [CompanyProfileModel]>) {
        self.storage = storage
    }

// MARK: - Private Properties

    private let storage: AnyStorage<String, [CompanyProfileModel]>
    private let storageKey = "\(CompanyProfileModel.self)"
    private let companyProfilesPublisher = CurrentValueSubject<[CompanyProfileModel], Never>([])

// MARK: - Methods

    func getCompanyProfiles() async -> [CompanyProfileModel] {
        await storage.get(forKey: storageKey) ?? []
    }

    func getCompanyProfilesPublusher() async -> AnyPublisher<[CompanyProfileModel], Never> {

        let companies = await getCompanyProfiles()
        companyProfilesPublisher.value = companies

        return companyProfilesPublisher.eraseToAnyPublisher()
    }

    func putCompanyProfile(_ company: CompanyProfileModel) async {

        var companies = await getCompanyProfiles()
        companies.append(company)

        await storage.put(companies, forKey: storageKey)
        companyProfilesPublisher.value = companies
    }

    func moveCompanyProfile(_ company: CompanyProfileModel, to newIndex: Int) async {

        var companies = await getCompanyProfiles().filter { company.ticker != $0.ticker }
        companies.insert(company, at: newIndex)

        await storage.put(companies, forKey: storageKey)
        companyProfilesPublisher.value = companies
    }

    func removeCompanyProfile(_ company: CompanyProfileModel) async {
        let companies = await getCompanyProfiles().filter { company.ticker != $0.ticker }

        await storage.put(companies, forKey: storageKey)
        companyProfilesPublisher.value = companies
    }

    func removeAll() async {
        await storage.removeAll()
        companyProfilesPublisher.value = []
    }
}
