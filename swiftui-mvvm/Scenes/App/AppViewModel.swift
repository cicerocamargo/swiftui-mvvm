import Combine

final class AppViewModel: ObservableObject {
    @Published private(set) var state: AppViewState?
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService) {
        userCancellable = sessionService.userPublisher.sink { [weak self] user in
            self?.state = user == nil
                ? .login(LoginViewModel(service: sessionService))
                : .loggedArea(sessionService)
        }
    }
}
