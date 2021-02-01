import Combine
import SwiftUI

final class SignUpViewModel: ObservableObject, Identifiable {
    @Published private(set) var state: SignUpState

    private let flowCompleted: () -> Void

    init(initialState: SignUpState = .init(), flowCompleted: @escaping () -> Void) {
        state = initialState
        self.flowCompleted = flowCompleted
    }

    func advanceToPasswordCreation() {
        guard state.canAdvanceToPasswordCreation else {
            return
        }
        state.isShowingPasswordCreation = true
    }

    func finish() {
        guard state.canFinishSignUp else {
            return
        }
        // do request ...
        flowCompleted()
    }
}

// MARK: - Bindings

extension SignUpViewModel {
    var email: Binding<String> {
        Binding(to: \.state.email, on: self)
    }

    var isShowingPasswordCreation: Binding<Bool> {
        Binding(to: \.state.isShowingPasswordCreation, on: self)
    }

    var password: Binding<String> {
        Binding(to: \.state.password, on: self)
    }

    var passwordConfirmation: Binding<String> {
        Binding(to: \.state.passwordConfirmation, on: self)
    }
}

// MARK: - Equatable

extension SignUpViewModel: Equatable {
    static func == (lhs: SignUpViewModel, rhs: SignUpViewModel) -> Bool {
        lhs === rhs
    }
}
