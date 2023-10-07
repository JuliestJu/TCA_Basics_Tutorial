//
//  ErrorView.swift
//  TCA_Basics_Tutorial
//
//  Created by Юлія Воротченко on 06.10.2023.
//

import SwiftUI

struct ErrorView: View {
    
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("(:").font(.title)
            Text("")
            Text(message).font(.title2)
            Button {
                self.retryAction()
            } label: {
                Text("Retry").font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(width: 130, height: 60)
            .background(.blue)
            .clipShape(.capsule(style: .circular))
            .padding()
        }
    }
}

#Preview {
    ErrorView(message: "ErrorView preview") {
        print("ErrorView Preview closure")
    }
}
