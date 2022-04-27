// ----------------------------------------------------------------------------
//
//  NewsViewModel.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksPersistence
import Resolver

// ----------------------------------------------------------------------------

final class SettingsPresenter {

    // MARK: - Properties

    weak var viewInput: SettingsViewInput?
    
    // MARK: - Private Properties

    private unowned var coordinator: SettingsCoordination
    @LazyInjected private var companyProfileRepository: CompanyProfileRepository
    
    // MARK: - Construction

    init(coordinator: SettingsCoordination) {
        self.coordinator = coordinator
    }
}

// MARK: - @protocol SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {

    // MARK: - Methods

    func viewDidLoad() {
        let settingsType = [SettingsType.reset(title: "Reset")]
        viewInput?.updateView(with: settingsType)
    }

    func cellTapped(with type: SettingsType) {
        switch type {
            case .reset(_):
                self.companyProfileRepository.removeAll()
                self.coordinator.didFinishClosure?()
        }
    }
}
