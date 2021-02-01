import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        emailCreationView
            .overlay(
                NavigationLink(
                    destination: passwordCreationView,
                    isActive: viewModel.isShowingPasswordCreation,
                    label: EmptyView.init
                )
            )
    }

    private var emailCreationView: some View {
        Form {
            Section(header: Text("Insira seu melhor e-mail")) {
                TextField("codemus.dev@gmail.com", text: viewModel.email)
            }
        }
        .navigationBarTitle("E-mail")
        .navigationBarItems(trailing: advanceButton)
    }

    private var passwordCreationView: some View {
        Form {
            Section(header: Text("Crie uma senha")) {
                SecureField("Senha", text: viewModel.password)
                SecureField("Confirme sua senha", text: viewModel.passwordConfirmation)
            }
        }
        .navigationBarTitle("Senha")
        .navigationBarItems(trailing: finishButton)
    }

    private var advanceButton: some View {
        Button(action: viewModel.advanceToPasswordCreation) {
            Text("Próximo")
        }
        .disabled(viewModel.state.canAdvanceToPasswordCreation == false)
    }

    private var finishButton: some View {
        Button(action: viewModel.finish) {
            Text("Concluir")
        }
        .disabled(viewModel.state.canFinishSignUp == false)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView(
                viewModel: .init(
                    initialState: .init(
                        email: "asdf@asdf.com",
                        isShowingPasswordCreation: true,
                        password: "",
                        passwordConfirmation: ""
                    ),
                    flowCompleted: {}
                )
            )
        }
    }
}
