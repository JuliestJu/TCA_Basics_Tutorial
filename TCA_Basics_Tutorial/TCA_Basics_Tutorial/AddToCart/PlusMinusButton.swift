//
//  PlusMinusButton.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct PlusMinusButton: View {
    let store: Store<AddToCartDomain.State, AddToCartDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    viewStore.send(.didTapMinusButton)
                } label: {
                    Text("-")
                        .padding(10)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                
                Text(viewStore.count.description)
                    .padding(5)
                
                Button {
                    viewStore.send(.didTapPlusButton)
                } label: {
                    Text("+")
                        .padding(10)
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    PlusMinusButton(store: .init(initialState: AddToCartDomain.State()) {
        AddToCartDomain()
    })
}
