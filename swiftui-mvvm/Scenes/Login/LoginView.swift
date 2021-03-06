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
            Section(header: Text("Não possui uma conta?")) {
                Button(action: model.showSignUpFlow) {
                    Text("Criar conta")
                }
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
        .sheet(item: model.bindings.signUpViewModel) { viewModel in
            NavigationView {
                SignUpView(viewModel: viewModel)
            }
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

#if DEBUG
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView(
                model: .init(
                    initialState: .init(),
                    service: EmptyLoginService()
                )
            )
        }
    }
}
#endif
