//
//  CartListDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 12.09.2023.
//

import Foundation
import ComposableArchitecture

struct CartListDomain: Reducer {
    
    // MARK: - State
    struct State: Equatable {
        var dataLoadingStatus = DataLoadingStatus.notStarted
        var cartItems: IdentifiedArrayOf<CartItemDomain.State> = []
        var totalPrice: Double = 0.0
        var isPayButtonDisabled = false
        var totalPriceString: String {
            let roundedValue = round(totalPrice * 100) / 100
            return "$\(roundedValue)"
        }
        
        var isRequestInProgress: Bool {
            dataLoadingStatus == .loading
        }
        
        @PresentationState var purchaseConfirmationAlert: AlertState<Action.Alert>?
        @PresentationState var purchaseResponseAlert: AlertState<Action.Alert>?
    }
    
    // MARK: - Actions
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case didPressPayButton
        case didPressCloseButton
        case cartItem(id: CartItemDomain.State.ID, action: CartItemDomain.Action)
        case getTotalPrice
        case didRecievePurchaseResponse(TaskResult<String>)
        
        enum Alert: Equatable {
            case cancelPurchaseTapped
            case confirmPurchaseTapped
            case dismissSuccessAlertTapped
            case dismissErrorAlertTapped
        }
    }
    
    // MARK: - Public properties
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
                return self.produceConfirmPaymentAlert(state: &state)
            case .didRecievePurchaseResponse(.success):
                state.dataLoadingStatus = .success
                return self.produceOrderResultAlert(state: &state, isSuccessfull: true)
            case .didRecievePurchaseResponse(.failure):
                state.dataLoadingStatus = .error
                return self.produceOrderResultAlert(state: &state, isSuccessfull: false)
            case .alert(.presented(.confirmPurchaseTapped)):
                return self.confirmPurchase(state: &state)
            case .alert(.dismiss):
                state.purchaseConfirmationAlert = nil
                state.purchaseResponseAlert = nil
                return .none
            case .alert(.presented(.cancelPurchaseTapped)):
                return .none
            case .alert(.presented(.dismissSuccessAlertTapped)):
                return .none
            case .alert(.presented(.dismissErrorAlertTapped)):
                return .none
            }
        }
        .forEach(\.cartItems,
                  action: /Action.cartItem(id:action:)) {
            CartItemDomain()
        }
        .ifLet(\.$purchaseConfirmationAlert, action: /Action.alert)
        .ifLet(\.$purchaseResponseAlert, action: /Action.alert)
    }
    
    // MARK: - Private methods
    private static func verifyPayButtonVisibility(state: inout State) -> Effect<Action> {
        state.isPayButtonDisabled = state.totalPrice == 0
        return .none
    }
    
    private func confirmPurchase(state: inout CartListDomain.State) -> Effect<Action> {
        state.dataLoadingStatus = .loading
        let items = state.cartItems.map { $0.cartItem }
        return .run { send in
            await send(
                .didRecievePurchaseResponse(
                    TaskResult {
                        try await APIClient.live.sendOrder(items)
                    }
                )
            )
        }
    }
    
    private func produceConfirmPaymentAlert(state: inout CartListDomain.State) -> Effect<Action> {
        state.purchaseConfirmationAlert = AlertState {
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
    }
    
    private func produceOrderResultAlert(state: inout CartListDomain.State, isSuccessfull: Bool) -> Effect<Action> {
        state.purchaseResponseAlert = AlertState {
            isSuccessfull ? TextState("Thank You!") : TextState("Oops!")
        } actions: {
            isSuccessfull ?
            ButtonState(role: .none, action: .dismissSuccessAlertTapped) {
                TextState("Done")
            }
            :
            ButtonState(role: .none, action: .dismissErrorAlertTapped) {
                TextState("Done")
            }
        } message: {
            isSuccessfull ?
            TextState("Your order is is process")
            :
            TextState("Unable to send order, try again later")
        }
        return .none
    }
}
