//
//  CartItem.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 12.09.2023.
//

import Foundation

struct CartItem: Equatable {
    let product: Product
    let quantity: Int
}

extension CartItem: Encodable {
    private enum CartItemKeys: String, CodingKey {
        case productId
        case quantity
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CartItemKeys.self)
        try container.encode(product.id, forKey: .productId)
        try container.encode(quantity, forKey: .quantity)
    }
}

extension CartItem {
    static var sample: [CartItem] {
        [
            .init(product: Product.sample[0], quantity: 3),
            .init(product: Product.sample[1], quantity: 1),
            .init(product: Product.sample[2], quantity: 1)
            
        ]
    }
}
