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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                Form {
                    Section {
                        Text(viewStore.profile.firstName.capitalized)
                        +
                        Text(" ")
                        +
                        Text(viewStore.profile.lastName.capitalized)
                    } header: {
                        Text("Full name")
                    }
                    Section {
                        Text(viewStore.profile.email)
                    } header: {
                        Text("Email")
                    }
                }
                .task {
                    viewStore.send(.fetchUserProfile)
                }
                .navigationTitle("Profile")
            }
        }
    }
}

#Preview {
    let state = ProfileDomain.State(profile: .default)
    let reducer = ProfileDomain { .default }
    return ProfileView(store: Store(initialState: state,
                                    reducer: { reducer }))
}
