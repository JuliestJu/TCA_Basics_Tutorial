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
            VStack {
                HStack {
                    AsyncImage(
                        url: URL(
                            string: viewStore.cartItem.product.imageString
                        )
                    ) {
                        $0
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                    VStack(alignment: .leading) {
                        Text(viewStore.cartItem.product.title)
                            .lineLimit(3)
                            .minimumScaleFactor(0.5)
                        HStack {
                            Text("$\(viewStore.cartItem.product.price.description)")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    
                }
//                ZStack {
                    Group {
                        Text("Quantity: ")
                        +
                        Text("\(viewStore.cartItem.quantity)")
                            .fontWeight(.bold)
                    }
                    .font(.title2)
//                }
            }
        }
    }
}
    
    #Preview {
        CartCell(store: .init(initialState: 
                                CartItemDomain.State(cartItem: CartItem.sample[0],
                                                                 id: UUID()),
                              reducer: {
            CartItemDomain()
        }))
    }
    
