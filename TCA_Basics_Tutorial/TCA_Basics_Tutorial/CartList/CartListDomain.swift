//
//  CartListDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 12.09.2023.
//

import Foundation
import ComposableArchitecture

struct CartListDomain: Reducer {
    
    struct State: Equatable {
        var cartItems: IdentifiedArrayOf<CartItemDomain.State> = []
        var totalPrice: Double = 0.0
        var isPayButtonDisabled = false
        var totalPriceString: String {
            let roundedValue = round(totalPrice * 100) / 100
            return "$\(roundedValue)"
        }
        
        @PresentationState var confirmationAlert: AlertState<Action.ConfirmationAlert>?
    }
    
    enum Action: Equatable {
        case confirmationDialog(PresentationAction<ConfirmationAlert>)
        case didPressPayButton
        
        case didPressCloseButton
        case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
        case getTotalPrice
        case didRecievePurchaseResponse(TaskResult<String>)
        
        enum ConfirmationAlert: Equatable {
            case cancelPurchaseTapped
            case confirmPurchaseTapped
        }
    }
    
    var sendOrder: ([CartItem]) async throws -> String
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didPressCloseButton:
                return .none
            case .cartItem(let id, let action):
                switch action {
                case .deleteCartItem:
                    state.cartItems.remove(id: id)
                    return .send(.getTotalPrice)
                }
            case .getTotalPrice:
                let items = state.cartItems.map { $0.cartItem }
                state.totalPrice = items.reduce(0.0, {
                    $0 + ($1.product.price * Double($1.quantity))
                })
                return CartListDomain.verifyPayButtonVisibility(state: &state)
            case .didPressPayButton:
                state.confirmationAlert = AlertState {
                    TextState("Confirm your purchase")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmPurchaseTapped) {
                        TextState("Pay \(state.totalPriceString)")
                    }
                    ButtonState(role: .cancel, action: .cancelPurchaseTapped) {
                        TextState("Cancel")
                    }
                } message: { [state] in
                    TextState("Do you want to proceed with your purchace of \(state.totalPriceString)?")
                }
                return .none
            case .didRecievePurchaseResponse(.success(let message)):
                print(message)
                return .none
            case .didRecievePurchaseResponse(.failure(let error)):
                print(error.localizedDescription)
                return .none
            case .confirmationDialog(.presented(.confirmPurchaseTapped)):
                return self.confirmPurchase(state: state)
            case .confirmationDialog(.dismiss):
                state.confirmationAlert = nil
                return .none
            case .confirmationDialog(.presented(.cancelPurchaseTapped)):
                return .none
            }
        }
        .forEach(\.cartItems,
                  action: /Action.cartItem(id:action:)) {
            CartItemDomain()
        }
                  .ifLet(\.$confirmationAlert, action: /Action.confirmationDialog)
    }
    
    private static func verifyPayButtonVisibility(state: inout State) -> Effect<Action> {
        state.isPayButtonDisabled = state.totalPrice == 0
        return .none
    }
    
    private func confirmPurchase(state: CartListDomain.State) -> Effect<Action> {
        let items = state.cartItems.map { $0.cartItem }
        return .run { send in
            await send(
                .didRecievePurchaseResponse(
                    TaskResult {
                        try await self.sendOrder(items)
                    }
                )
            )
        }
    }
}
