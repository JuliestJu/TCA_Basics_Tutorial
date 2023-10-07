//
//  RootDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.10.2023.
//

import Foundation
import ComposableArchitecture

struct RootDomain: Reducer {
    
    var fetchProducts: @Sendable () async throws -> [Product]
    var sendOrder: @Sendable ([CartItem]) async throws -> String
    var fetchUserProfile: @Sendable () async throws -> UserProfile
    
    struct State: Equatable {
        var selectedTab = Tab.products
        var productListState = ProductListDomain.State()
        var profileState = ProfileDomain.State()
    }
    
    enum Tab {
        case products, profile
    }
    
    enum Action: Equatable {
        case selectedTab(Tab)
        case productList(ProductListDomain.Action)
        case profile(ProfileDomain.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectedTab(let tab):
                state.selectedTab = tab
                return .none
            case .productList, .profile:
                return .none
            }
        }
        Scope(state: \.productListState,
              action: /RootDomain.Action.productList) {
            ProductListDomain(fetchProducts: self.fetchProducts)
        }
        Scope(state: \.profileState,
              action: /RootDomain.Action.profile) {
            ProfileDomain(userProfile: self.fetchUserProfile)
        }
    }
}
