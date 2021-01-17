import Foundation

struct LoginViewState: Equatable {
    var email = ""
    var password = ""
    var isLoggingIn = false
    var isShowingErrorAlert = false
}

extension LoginViewState {
    static let isLoggingInFooter = "Fazendo login..."

    var canSubmit: Bool {
        email.isEmpty == false // TODO: Improve email validation
            && password.isEmpty == false
            && isLoggingIn == false
    }

    var footerMessage: String {
        isLoggingIn ? Self.isLoggingInFooter : ""
    }
}
