import Combine
import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published private(set) var state: LoginViewState
    private let service: LoginService
    private let loginDidSucceed: () -> Void

    var bindings: (
        email: Binding<String>,
        password: Binding<String>,
        isShowingErrorAlert: Binding<Bool>
    ) {
        (
            email: Binding(to: \.state.email, on: self),
            password: Binding(to: \.state.password, on: self),
            isShowingErrorAlert: Binding(to: \.state.isShowingErrorAlert, on: self)
        )
    }

    init(
        initialState: LoginViewState = .init(),
        service: LoginService,
        loginDidSucceed: @escaping () -> Void // TODO: remove
    ) {
        self.service = service
        self.loginDidSucceed = loginDidSucceed
        state = initialState
    }

    func login() {
        state.isLoggingIn = true
        service.login(
            email: state.email,
            password: state.password
        ) { [weak self] error in
            if error == nil {
                self?.loginDidSucceed()
            } else {
                self?.state.isLoggingIn = false
                self?.state.isShowingErrorAlert = true
            }
        }
    }
}

