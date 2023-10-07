//
//  UserProfile.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 07.10.2023.
//

import Foundation

struct UserProfile: Equatable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
}

extension UserProfile: Decodable {
    private enum ProfileKeys: String, CodingKey {
        case id, email, name, firstName, lastName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
}

extension UserProfile {
    static var sample: UserProfile {
        .init(id: 0,
              email: "helloWorld@gmail.com",
              firstName: "Yuliia",
              lastName: "Vorotchenko")
    }
    
    static var `default`: UserProfile {
        .init(id: 0,
              email: "",
              firstName: "",
              lastName: "")
    }
}
