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
        var productList: IdentifiedArrayOf<ProductDomain.State> = []
        var cartState: CartListDomain.State?
        var shouldOpenCart: Bool = false
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
                return .run { send in
                    await send(
                        .fetchProductResponse(
                            TaskResult { try await self.fetchProducts() }
                        )
                    )
                }
            case .fetchProductResponse(.success(let products)):
                state.productList = IdentifiedArray(uniqueElements: products
                    .map { ProductDomain.State(id: UUID(), product: $0)}
                )
                return .none
            case .fetchProductResponse(.failure(let error)):
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
                case .cartItem:
                    print("cartItem")
                }
                return .none
            }
        }
        .forEach(\.productList, action: /ProductListDomain.Action.product(id:action:)) {
            ProductDomain()
        }
    }
}
