//
//  ProductCell.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductCell: View {
    
    let store: Store<ProductDomain.State, ProductDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Image(viewStore.product.imageString)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                
                VStack(alignment: .leading) {
                    Text(viewStore.product.title)
                    HStack {
                        Text("$\(viewStore.product.price.description)")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        AddToCardButton(store:
                            self.store
                            .scope(state: \.addToCartState,
                                   action: ProductDomain.Action.addToCart)
                        )
                    }
                }
                .font(.title3)
                .multilineTextAlignment(.center)
            }
            .padding(20)
        }
    }
}

#Preview {
    ProductCell(store: .init(initialState:
        ProductDomain.State(id: UUID(),
                            product: Product.sample[0])) {
        ProductDomain()
    })
}
