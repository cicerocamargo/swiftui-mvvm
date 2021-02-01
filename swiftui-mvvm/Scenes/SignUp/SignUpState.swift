import Foundation

struct SignUpState {
    var email = ""
    var isShowingPasswordCreation = false
    var password = ""
    var passwordConfirmation = ""
}

extension SignUpState {
    var canAdvanceToPasswordCreation: Bool { !email.isEmpty }

    var canFinishSignUp: Bool {
        !email.isEmpty
            && !password.isEmpty
            && !passwordConfirmation.isEmpty
            && password == passwordConfirmation
    }
}
