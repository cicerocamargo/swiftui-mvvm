//
//  Login.swift
//  swiftui-mvvm
//
//  Created by Cicero Camargo on 17/09/20.
//  Copyright © 2020 Cicero Camargo. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var model: LoginViewModel

    init(model: LoginViewModel) {
        self.model = model
    }

    var body: some View {
        Form {
            Section(footer: formFooter) {
                TextField("email", text: model.bindings.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("senha", text: model.bindings.password)
            }
        }
        .navigationBarItems(trailing: submitButton)
        .navigationBarTitle("Identifique-se")
        .disabled(model.state.isLoggingIn)
        .alert(isPresented: model.bindings.isShowingErrorAlert) {
            Alert(
                title: Text("Erro ao fazer login"),
                message: Text("Verifique seu email e senha e tente novamente mais tarde")
            )
        }
    }

    private var submitButton: some View {
        Button(action: model.login) {
            Text("Entrar")
        }
        .disabled(model.state.canSubmit == false)
    }

    private var formFooter: some View {
        Text(model.state.footerMessage)
    }
}

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

protocol LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    )
}

struct EmptyLoginService: LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {}
}

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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(
                model: .init(
                    initialState: .init(),
                    service: EmptyLoginService(),
                    loginDidSucceed: {}
                )
            )
        }
    }
}
