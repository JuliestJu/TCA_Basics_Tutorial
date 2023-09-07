//
//  ContentView.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<CounterDomain.State, CounterDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    viewStore.send(.decreaseCounter)
                } label: {
                    Text("-")
                        .padding(10)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                
                Text(viewStore.counter.description)
                    .padding(5)
                
                Button {
                    viewStore.send(.increaseCounter)
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
    ContentView(store: .init(initialState: CounterDomain.State()) {
        CounterDomain()
    })
}
