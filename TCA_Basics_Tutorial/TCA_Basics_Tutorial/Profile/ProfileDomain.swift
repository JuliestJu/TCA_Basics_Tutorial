//
//  ProfileDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.10.2023.
//

import Foundation
import ComposableArchitecture

struct ProfileDomain: Reducer {

    var userProfile: () async throws -> UserProfile
    
    struct State: Equatable {
        var profile: UserProfile = .default
    }
    
    enum Action: Equatable {
        case fetchUserProfile
        case fetchUserProfileResponse(TaskResult<UserProfile>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchUserProfile:
                return .run {
                    await $0(.fetchUserProfileResponse(
                        TaskResult {
                            try await self.userProfile()
                        }
                    ))
                }
            case .fetchUserProfileResponse(.success(let userProfileResponse)):
                state.profile = userProfileResponse
                return .none
            case .fetchUserProfileResponse(.failure(let error)):
                print("Error: \(error)")
                return .none
            }
        }
    }
}
