//
//  CartListView.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 08.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
    let store: Store<CartListDomain.State, CartListDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 })  { viewStore in
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.cartItems,
                        action: CartListDomain.Action.cartItem(id:action:)
                        
                    )
                ) {
                    CartCell(store: $0)
                }
            }
        }
    }
}

#Preview {
    let array = IdentifiedArrayOf(uniqueElements: CartItem.sample.map {
        CartItemDomain.State(cartItem: $0,
                             id: UUID())
    })
    return CartListView(store: Store(initialState: CartListDomain.State(cartItems: array),
                              reducer: {
        CartListDomain()
    }))
}
