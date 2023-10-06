//
//  APIClient.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 06.10.2023.
//

import Foundation

struct APIClient {
    
    var fetchProducts: () async throws -> [Product]
    var sedOrder: ([CartItem]) async throws -> String
    
    struct APIError: Error {}
}

extension APIClient {
    
    static let live = Self {
        let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://fakestoreapi.com/products")!)
        let products = try JSONDecoder().decode([Product].self, from: data)
        return products
    } sedOrder: { cartItems in
        let payload = try JSONEncoder().encode(cartItems)
        var urlRequest = URLRequest(url: URL(string: "https://fakestoreapi.com/carts")!)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)
        guard let httpResponse = (response as? HTTPURLResponse) else {
            throw APIError()
        }
        
        return "Status \(httpResponse.statusCode)"
    }

}
