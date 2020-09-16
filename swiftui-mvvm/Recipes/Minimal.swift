//
//  Minimal.swift
//  swiftui-mvvm
//
//  Created by Cicero Camargo on 16/09/20.
//  Copyright © 2020 Cicero Camargo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var model: ContentViewModel

    init(model: ContentViewModel) {
        self.model = model
    }

    var body: some View {
        Text(model.state.isLoading ? "Carregando..." : model.state.message)
            .onAppear(perform: model.loadData)
    }
}

struct ContentViewState {
    var isLoading = false
    var message = ""
}

class ContentViewModel: ObservableObject {
    @Published private(set) var state: ContentViewState

    init(initialState: ContentViewState = .init()) {
        state = initialState
    }

    func loadData() {
        state.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state.isLoading = false
            self.state.message = "Olá Mundo!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(model: .init(initialState: .init(isLoading: true)))
                .previewDisplayName("Loading")
            ContentView(model: .init(initialState: .init(message: "Hello")))
                .previewDisplayName("Loaded")
        }
    }
}
