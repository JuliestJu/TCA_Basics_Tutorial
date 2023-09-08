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
            List {
                let stores = self.store
                    .scope(state: \.productList,
                           action: ProductListDomain.Action.product(id:action:))
                ForEachStore(stores) { store in
                    ProductCell(store: store)
                }
            }
            .task {
                viewStore.send(.fetchProducts)
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
