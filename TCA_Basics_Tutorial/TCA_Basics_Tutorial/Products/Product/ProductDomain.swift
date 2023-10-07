//
//  ProductDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import Foundation
import ComposableArchitecture

struct ProductDomain: Reducer {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var addToCartState = AddToCartDomain.State()
        
        var count: Int {
            get { addToCartState.count }
            set { addToCartState.count = newValue }
        }
    }
    
    enum Action: Equatable {
        case addToCart(AddToCartDomain.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \State.addToCartState, action: /ProductDomain.Action.addToCart) {
            AddToCartDomain()
        }
        Reduce { state, action in
            switch action {
            case .addToCart(.didTapMinusButton):
                return .none
            case .addToCart(.didTapPlusButton):
                state.addToCartState.count = max(0, state.addToCartState.count)
                return .none
            }
        }
    }
}
