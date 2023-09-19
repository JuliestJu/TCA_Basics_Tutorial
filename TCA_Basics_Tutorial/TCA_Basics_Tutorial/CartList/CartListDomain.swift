//
//  CartListDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 12.09.2023.
//

import Foundation
import ComposableArchitecture

struct CartListDomain: Reducer {
    
    struct State: Equatable {
        var cartItems: IdentifiedArrayOf<CartItemDomain.State> = []
    }
    
    enum Action: Equatable {
        case didPressCloseButton
        case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
    }
    
    struct Environment {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didPressCloseButton:
                return .none
            case .cartItem:
                return .none
            }
        }
    }
}
