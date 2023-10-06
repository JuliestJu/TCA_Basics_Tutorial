//
//  ProductListDomain.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.09.2023.
//

import Foundation
import ComposableArchitecture

struct ProductListDomain: Reducer {
    struct State: Equatable {
        var dataLoadingStatus = DataLoadingStatus.notStarted
        var productList: IdentifiedArrayOf<ProductDomain.State> = []
        @PresentationState var cartState: CartListDomain.State?
        var shouldOpenCart: Bool = false
        
        var shouldShowError: Bool {
            self.dataLoadingStatus == .error
        }
        var isLoading: Bool {
            self.dataLoadingStatus == .loading
        }
    }
    
    enum Action: Equatable {
        case fetchProducts
        case fetchProductResponse(TaskResult<[Product]>)
        case product(id: ProductDomain.State.ID, action: ProductDomain.Action)
        case setCart(isPresented: Bool)
        case cart(CartListDomain.Action)
    }
   
    var fetchProducts: @Sendable () async throws -> [Product]
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchProducts:
                if state.dataLoadingStatus == .success ||
                   state.dataLoadingStatus == .loading {
                    return .none
                }
                state.dataLoadingStatus = .loading
                return .run { send in
                    await send(
                        .fetchProductResponse(
                            TaskResult { try await self.fetchProducts() }
                        )
                    )
                }
            case .fetchProductResponse(.success(let products)):
                state.dataLoadingStatus = .success
                state.productList = IdentifiedArray(uniqueElements: products
                    .map { ProductDomain.State(id: UUID(), product: $0)}
                )
                return .none
            case .fetchProductResponse(.failure(let error)):
                state.dataLoadingStatus = .error
                print("\(error) \n Unable fetch prducts")
                return .none
            case .product:
                return .none
            case .setCart(let isPresented):
                state.shouldOpenCart = isPresented
                state.cartState = isPresented ?
                CartListDomain.State(cartItems: IdentifiedArray(uniqueElements: state.productList.compactMap {
                        $0.count > 0 ?
                        CartItemDomain.State(cartItem: CartItem(product: $0.product,
                                                                quantity: $0.count),
                                             id: UUID())
                        : nil
                })) :
                nil
                return .none
            case .cart(let action):
                switch action {
                case .didPressCloseButton:
                    state.shouldOpenCart = false
                case .cartItem(_, let action):
                    switch action {
                    case .deleteCartItem(let product):
                        return self.deleteCartItems(for: product, on: &state)
                    }
                case .alert(let alert):
                    return proceedCartListAlerts(actions: alert, state: &state)
                default: break
                }
                return .none
            }
        }
        .forEach(\.productList, action: /ProductListDomain.Action.product(id:action:)) {
            ProductDomain()
        }
        .ifLet(\.cartState, action: /ProductListDomain.Action.cart) {
            CartListDomain { cartItem in
               return "CartItem"
            }
        }
    }
    
    // MARK: - Private methods
    
    private func deleteCartItems(for product: Product, on state: inout State) -> Effect<Action> {
        guard let index = state.productList.firstIndex(where: {
            $0.product.id == product.id
        }) else {
            return .none
        }
        let productStateId = state.productList[index].id
        state.productList[id: productStateId]?.count = 0
        return .none
    }
    
    private func proceedCartListAlerts(actions: PresentationAction<CartListDomain.Action.Alert>,
                       state: inout State) -> Effect<Action> {
        switch actions {
        case .presented(let aa):
            switch aa {
            case .dismissSuccessAlertTapped:
                self.resetProductsCounters(state: &state)
                state.shouldOpenCart = false
                return .none
            default: return .none
            }
        case .dismiss: return .none
        }
    }
    
    private func resetProductsCounters(state: inout State) {
        state.productList
            .map { $0.id }
            .forEach { state.productList[id: $0]?.count = 0 }
    }
}
