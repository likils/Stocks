// ----------------------------------------------------------------------------
//
//  RequestFactoryBundle.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2022. All rights reserved.
//
// ----------------------------------------------------------------------------

import Resolver

// ----------------------------------------------------------------------------

extension Resolver {

    // MARK: - Methods

    public static func registerRequestFactories() {
        Resolver.defaultScope = .shared

        registerSettings()
        
        register {
            CompanyCandlesRequestFactory(requestProvider: .init(requestPath: .companyCandles))
        }

        register {
            CompanyNewsRequestFactory(requestProvider: .init(requestPath: .companyNews))
        }

        register {
            CompanyProfileRequestFactory(requestProvider: .init(requestPath: .companyProfile))
        }

        register {
            CompanyQuotesRequestFactory(requestProvider: .init(requestPath: .companyQuotes))
        }

        register {
            CompanySearchRequestFactory(requestProvider: .init(requestPath: .companySearch))
        }

        register {
            NewsRequestFactory(requestProvider: .init(requestPath: .news))
        }

        register {
            ImageRequestFactory(cachedImageRepository: Resolver.resolve())
        }

        register {
            OnlineTradesWebSocketContainer(requestProvider: .init(), token: resolve(name: .token))
        }
    }
}
