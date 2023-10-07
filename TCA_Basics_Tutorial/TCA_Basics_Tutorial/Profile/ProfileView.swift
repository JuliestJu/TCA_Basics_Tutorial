//
//  ProfileView.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct ProfileView: View {
    let store: Store<ProfileDomain.State, ProfileDomain.Action>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let state = ProfileDomain.State(profile: .default)
    let reducer = ProfileDomain { UserProfile.sample }
    return ProfileView(store: Store(initialState: state,
                                    reducer: { reducer }))
}
