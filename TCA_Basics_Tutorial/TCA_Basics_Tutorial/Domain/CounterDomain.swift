//
//  CounterDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import Foundation
import ComposableArchitecture

struct CounterDomain: Reducer {
    struct State: Equatable {
        var counter = 0
    }

    enum Action: Equatable {
        case increaseCounter
        case decreaseCounter
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .increaseCounter:
            state.counter += 1
            return .none
        case .decreaseCounter:
            state.counter -= 1
            return .none
        }
    }
}
