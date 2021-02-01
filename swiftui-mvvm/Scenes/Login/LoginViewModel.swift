import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginViewState
    private let service: LoginService

    var bindings: (
        email: Binding<String>,
        password: Binding<String>,
        isShowingErrorAlert: Binding<Bool>,
        signUpViewModel: Binding<SignUpViewModel?>
    ) {
        (
            email: Binding(to: \.state.email, on: self),
            password: Binding(to: \.state.password, on: self),
            isShowingErrorAlert: Binding(to: \.state.isShowingErrorAlert, on: self),
            signUpViewModel: Binding(to: \.state.signUpViewModel, on: self)
        )
    }

    init(
        initialState: LoginViewState = .init(),
        service: LoginService
    ) {
        self.service = service
        state = initialState
    }

    func login() {
        state.isLoggingIn = true
        service.login(
            email: state.email,
            password: state.password
        ) { [weak self] error in
            if error != nil {
                self?.state.isLoggingIn = false
                self?.state.isShowingErrorAlert = true
            }
        }
    }

    func showSignUpFlow() {
        state.signUpViewModel = SignUpViewModel(flowCompleted: { [weak self] in
            self?.state.signUpViewModel = nil
        })
    }
}

