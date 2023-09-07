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
            ProductCell(store: .init(initialState: ProductDomain.State(product: Product.sample[0]), reducer: {
                ProductDomain()
            }))
        }
    }
}
