// ----------------------------------------------------------------------------
//
//  CompanyProfileRepositoryImpl.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Combine
import Foundation
import StocksData
import StocksSystem

// ----------------------------------------------------------------------------

final class CompanyProfileRepositoryImpl: CompanyProfileRepository {

    // MARK: - Private Properties

    private let storage: AnyStorage<String, [CompanyProfileResponseModel]>
    private let storageKey = "company_profiles_key"
    private let companyProfilesPublisher = PassthroughSubject<[CompanyProfileResponseModel], Never>()

    // MARK: - Construction

    init(storage: AnyStorage<String, [CompanyProfileResponseModel]>) {
        self.storage = storage
    }

    // MARK: - Methods

    func getCompanyProfiles() async -> [CompanyProfileResponseModel] {
        await self.storage.get(forKey: self.storageKey) ?? .empty
    }

    func getCompanyProfilesPublisher() -> AnyPublisher<[CompanyProfileResponseModel], Never> {

        Task {
            let companyProfiles = await getCompanyProfiles()
            self.companyProfilesPublisher.send(companyProfiles)
        }

        return self.companyProfilesPublisher
            .subscribe(on: DispatchQueue.global())
            .eraseToAnyPublisher()
    }

    func putCompanyProfile(_ companyProfile: CompanyProfileResponseModel) {
        Task {
            var companyProfiles = await getCompanyProfiles()
            companyProfiles.append(companyProfile)

            await updateStorage(with: companyProfiles)
        }
    }

    func moveCompanyProfile(with tickerSymbol: String, to newIndex: Int) {
        Task {

            guard let companyProfile = await getCompanyProfiles().first(where: { tickerSymbol == $0.tickerSymbol })
            else {
                return
            }

            var companyProfiles = await getCompanyProfiles().filter { tickerSymbol != $0.tickerSymbol }
            companyProfiles.insert(companyProfile, at: newIndex)

            await updateStorage(with: companyProfiles)
        }
    }

    func removeCompanyProfile(with tickerSymbol: String) {
        Task {
            let companyProfiles = await getCompanyProfiles().filter { tickerSymbol != $0.tickerSymbol }
            await updateStorage(with: companyProfiles)
        }
    }

    func removeAll() {
        Task {
            await self.storage.removeAll()
        }
    }

    // MARK: - Private Methods

    private func updateStorage(with companyProfiles: [CompanyProfileResponseModel]) async {
        await self.storage.put(companyProfiles, forKey: self.storageKey)
        self.companyProfilesPublisher.send(companyProfiles)
    }
}
