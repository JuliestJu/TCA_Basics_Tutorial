//
//  RootDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.10.2023.
//

import Foundation
import ComposableArchitecture

struct RootDomain: Reducer {
    
    struct State: Equatable {
        var selectedTab = Tab.products
        var productListState = ProductListDomain.State()
    }
    
    enum Tab {
        case products, profile
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default: break
            }
        }
    }
}
