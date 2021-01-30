import Combine

final class AppViewModel: ObservableObject {
    @Published private(set) var state: AppViewState?
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService) {
        userCancellable = sessionService.userPublisher
            .map { $0 != nil }
            .removeDuplicates()
            .sink { [weak self] isLoggedIn in
                self?.state = isLoggedIn
                    ? .loggedArea(sessionService)
                    : .login(LoginViewModel(service: sessionService))
            }
    }
}
