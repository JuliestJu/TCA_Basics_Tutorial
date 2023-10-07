//
//  RootView.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    
    let store: Store<RootDomain.State, RootDomain.Action>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(get: \.selectedTab,
                                                 send: RootDomain.Action.selectedTab),
                    content:  {
                ProductListView(store: self.store.scope(state: \.productListState,
                                                        action: RootDomain.Action.productList))
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Products")
                }
                .tag(RootDomain.Tab.products)
                
                ProfileView(store: self.store.scope(state: \.profileState,
                                                    action: RootDomain.Action.profile))
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(RootDomain.Tab.profile)
            })
        }
    }
}

#Preview {
    let state = RootDomain.State()
    let reducer = RootDomain {
        return Product.sample
    } sendOrder: { item in
        return "OK"
    } fetchUserProfile: {
        .default
    }

    return RootView(store: Store(initialState: state,
                                    reducer: { reducer }))
    
}
