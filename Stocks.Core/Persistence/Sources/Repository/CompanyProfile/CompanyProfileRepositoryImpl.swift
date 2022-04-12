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

    private let storage: AnyStorage<String, [CompanyProfileDataModel]>
    private let storageKey = "company_profiles_key"
    private let companyProfilesPublisher = CurrentValueSubject<[CompanyProfileDataModel], Never>(.empty)

    // MARK: - Construction

    init(storage: AnyStorage<String, [CompanyProfileDataModel]>) {
        self.storage = storage
    }

    // MARK: - Methods

    func getCompanyProfiles() async -> [CompanyProfileDataModel] {
        await self.storage.get(forKey: self.storageKey) ?? .empty
    }

    func getCompanyProfilesPublisher() -> AnyPublisher<[CompanyProfileDataModel], Never> {

        return Just(())
            .asyncFlatMap { [unowned self] in
                await self.getCompanyProfiles()
            }
            .flatMap { [unowned self] companyProfiles in
                return self.companyProfilesPublisher <- { $0.value = companyProfiles }
            }
            .eraseToAnyPublisher()
    }

    func getCompanyProfile(with ticker: String) async -> CompanyProfileDataModel? {
        return await getCompanyProfiles().first { $0.ticker == ticker }
    }

    func putCompanyProfile(_ companyProfile: CompanyProfileDataModel) {
        Task {
            var companyProfiles = await getCompanyProfiles()
            companyProfiles.append(companyProfile)

            await updateStorage(with: companyProfiles)
        }
    }

    func moveCompanyProfile(with ticker: String, to newIndex: Int) {
        Task {

            guard let companyProfile = await getCompanyProfile(with: ticker) else {
                return
            }

            var companyProfiles = await getCompanyProfiles().filter { ticker != $0.ticker }
            companyProfiles.insert(companyProfile, at: newIndex)

            await updateStorage(with: companyProfiles)
        }
    }

    func removeCompanyProfile(with ticker: String) {
        Task {
            let companyProfiles = await getCompanyProfiles().filter { ticker != $0.ticker }
            await updateStorage(with: companyProfiles)
        }
    }

    func removeAll() {
        Task {
            await updateStorage(with: .empty)
        }
    }

    // MARK: - Private Methods

    private func updateStorage(with companyProfiles: [CompanyProfileDataModel]) async {
        await self.storage.put(companyProfiles, forKey: self.storageKey)
        self.companyProfilesPublisher.value = companyProfiles
    }
}
