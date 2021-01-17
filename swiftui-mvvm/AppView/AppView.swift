import SwiftUI

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        switch viewModel.state {
        case let .login(viewModel):
            return AnyView(
                NavigationView {
                    LoginView(model: viewModel)
                }
            )
        
        case let .loggedArea(sessionService):
            return AnyView(
                VStack {
                    Text("Bem-vindo!")
                    Button(action: sessionService.logout) {
                        Text("Sair")
                    }
                }
            )
        
        case .none:
            return AnyView(EmptyView())
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel: .init(sessionService: FakeSessionService(user: .init())))
    }
}
