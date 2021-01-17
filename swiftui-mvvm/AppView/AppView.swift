import SwiftUI

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        switch viewModel.state {
        case .login:
            return EmptyView()
        
        case .loggedArea:
            return EmptyView()
        
        case .none:
            return EmptyView()
        }
    }

}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(viewModel: .init(sessionService: FakeSessionService(user: nil)))
    }
}
