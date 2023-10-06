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
            NavigationStack {
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
                .navigationTitle("Cart")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewStore.send(.didPressCloseButton)
                        } label: {
                            Text("Close")
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.getTotalPrice)
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        viewStore.send(.didPressPayButton)
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Pay \(viewStore.totalPriceString)")
                                .font(.title)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(
                        viewStore.isPayButtonDisabled ? .gray : .blue
                    )
                    .cornerRadius(10)
                    .padding()
                    .disabled(viewStore.isPayButtonDisabled)
                }
                .alert(
                    store: self.store.scope(state: \.$purchaseConfirmationAlert,
                                            action: { .alert($0) })
                )
                .alert(
                    store: self.store.scope(state: \.$purchaseResponseAlert,
                                            action: { .alert($0) })
                )
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
        CartListDomain { cartItem in
            return cartItem.last?.product.title ?? "no product"
        }
    }))
    
}
