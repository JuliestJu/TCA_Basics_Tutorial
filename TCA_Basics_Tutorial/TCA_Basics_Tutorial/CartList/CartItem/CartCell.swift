//
//  CartCell.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 19.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct CartCell: View {
    
    let store: Store<CartItemDomain.State, CartItemDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
        }
    }
}

#Preview {
    CartCell(store: .init(initialState: CartItemDomain.State(cartItem: CartItem.sample[0], id: UUID()), reducer: {
        CartItemDomain()
    }))
}
