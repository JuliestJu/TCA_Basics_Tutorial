//
//  CartItemDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 12.09.2023.
//

import Foundation
import ComposableArchitecture

struct CartItemDomain: Reducer {
    struct State: Equatable, Identifiable {
        let cartItem: CartItem
        let id: UUID
    }
    
    enum Action: Equatable {
        case any
    }
    
    struct Environment {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .any: return .none
            }
        }
    }
}
