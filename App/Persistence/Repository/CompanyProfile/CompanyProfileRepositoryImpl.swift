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
    private let companyProfilesPublisher = CurrentValueSubject<[CompanyProfileModel], Never>(.empty)

// MARK: - Methods

    func getCompanyProfiles() async -> [CompanyProfileModel] {
        await storage.get(forKey: storageKey) ?? .empty
    }

    func getCompanyProfilesPublusher() async -> AnyPublisher<[CompanyProfileModel], Never> {

        let companyProfiles = await getCompanyProfiles()
        companyProfilesPublisher.value = companyProfiles

        return companyProfilesPublisher.eraseToAnyPublisher()
    }

    func putCompanyProfile(_ companyProfile: CompanyProfileModel) {
        Task {
            var companyProfiles = await getCompanyProfiles()
            companyProfiles.append(companyProfile)

            await updateStorage(with: companyProfiles)
        }
    }

    func moveCompanyProfile(_ companyProfile: CompanyProfileModel, to newIndex: Int) {
        Task {
            var companyProfiles = await getCompanyProfiles().filter { companyProfile.tickerSymbol != $0.tickerSymbol }
            companyProfiles.insert(companyProfile, at: newIndex)

            await updateStorage(with: companyProfiles)
        }
    }

    func moveCompanyProfile(from index: Int, to newIndex: Int) {
        Task {
            var companyProfiles = await getCompanyProfiles()

            let companyProfile = companyProfiles.remove(at: index)
            companyProfiles.insert(companyProfile, at: newIndex)

            await updateStorage(with: companyProfiles)
        }
    }

    func removeCompanyProfile(_ companyProfile: CompanyProfileModel) {
        Task {
            let companyProfiles = await getCompanyProfiles().filter { companyProfile.tickerSymbol != $0.tickerSymbol }
            await updateStorage(with: companyProfiles)
        }
    }

    func removeCompanyProfile(atIndex index: Int) {
        Task {
            var companyProfiles = await getCompanyProfiles()
            companyProfiles.remove(at: index)
            await updateStorage(with: companyProfiles)
        }
    }

    func removeAll() {
        Task {
            await storage.removeAll()
            companyProfilesPublisher.value = .empty
        }
    }

// MARK: - Private Methods

    private func updateStorage(with companyProfiles: [CompanyProfileModel]) async {
        await storage.put(companyProfiles, forKey: storageKey)
        companyProfilesPublisher.value = companyProfiles
    }
}
