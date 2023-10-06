//
//  TCA_Basics_TutorialApp.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_Basics_TutorialApp: App {
    var body: some Scene {
        WindowGroup {
            let state = ProductListDomain.State()
            let reducer = ProductListDomain { try await APIClient.live.fetchProducts() }
            ProductListView(store: Store(initialState: state,
                                         reducer: { reducer }))
        }
    }
}
