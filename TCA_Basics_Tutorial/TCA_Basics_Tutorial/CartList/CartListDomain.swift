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
        var totalPrice: Double = 0.0
        var isPayButtonDisabled = false
        
        var totalPriceString: String {
            let roundedValue = round(totalPrice * 100) / 100
            return "$\(roundedValue)"
        }
    }
    
    enum Action: Equatable {
        case didPressCloseButton
        case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
        case getTotalPrice
    }
    
    struct Environment {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didPressCloseButton:
                return .none
            case .cartItem(let id, let action):
                switch action {
                case .deleteCartItem:
                    state.cartItems.remove(id: id)
                    return .send(.getTotalPrice)
                }
            case .getTotalPrice:
                let items = state.cartItems.map { $0.cartItem }
                state.totalPrice = items.reduce(0.0, {
                    $0 + ($1.product.price * Double($1.quantity))
                })
                return CartListDomain.verifyPayButtonVisibility(state: &state)
            }
        }.forEach(\.cartItems,
                   action: /Action.cartItem(id:action:)) {
            CartItemDomain()
        }
    }
    
    private static func verifyPayButtonVisibility(state: inout State) -> Effect<Action> {
        state.isPayButtonDisabled = state.totalPrice == 0
        return .none
    }
}
