//
//  ProductListView.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 08.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {
    
    let store: Store<ProductListDomain.State, ProductListDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                Group {
                    if viewStore.isLoading {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    } else if viewStore.shouldShowError {
                        ErrorView(message: "Oosp, we couldn't fetch product list") {
                            viewStore.send(.fetchProducts)
                        }
                    } else {
                        List {
                            let stores = self.store
                                .scope(state: \.productList,
                                       action: ProductListDomain.Action.product(id:action:))
                            ForEachStore(stores) { store in
                                ProductCell(store: store)
                            }
                        }
                    }

                }
                .task {
                    viewStore.send(.fetchProducts)
                }
                .navigationTitle("Products")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.setCart(isPresented: true))
                        } label: {
                            Text("Go to cart")
                        }
                    }
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: { $0.shouldOpenCart },
                        send: ProductListDomain.Action.setCart(isPresented:)
                    )
                ) {
                    IfLetStore(self.store.scope(state: \.cartState,
                                                action: ProductListDomain.Action.cart)) { store in
                        CartListView(store: store)
                    }
                }
            }
        }
    }
}

#Preview {
    let state = ProductListDomain.State()
    let reducer = ProductListDomain { Product.sample }
    return ProductListView(store: Store(initialState: state,
                                        reducer: { reducer }))
}
