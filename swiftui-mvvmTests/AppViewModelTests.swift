@testable import swiftui_mvvm
import XCTest

enum AppViewState {
    case login
    case loggedArea
}

struct User {}

import Combine

protocol SessionService: LoginService {
    var user: User? { get }
    var userPublisher: AnyPublisher<User?, Never> { get }
    func logout()
}

final class AppViewModel {
    @Published private(set) var state: AppViewState
    private var userCancellable: AnyCancellable?
    
    init(sessionService: SessionService) {
        state = sessionService.user == nil ? .login : .loggedArea
        userCancellable = sessionService.userPublisher.sink { [weak self] user in
            self?.state = user == nil ? .login : .loggedArea
        }
    }
}

final class AppViewModelTests: XCTestCase {
    func test_whenUserIsLoggedIn_showsLoggedArea() {
        let (sut, _) = makeSUT(isLoggedIn: true)
        
        XCTAssert(sut.state == .loggedArea)
    }
    
    func test_whenUserIsNotLoggedIn_showsLogin() {
        let (sut, _) = makeSUT(isLoggedIn: false)
        
        XCTAssert(sut.state == .login)
    }
    
    func test_whenUserLogsIn_showsLoggedArea() {
        let (sut, service) = makeSUT(isLoggedIn: false)
        
        service.login(email: "", password: "", completion: { _ in })

        XCTAssert(sut.state == .loggedArea)
    }
    
    func test_whenUserLogsOut_showsLogin() {
        let (sut, service) = makeSUT(isLoggedIn: true)
        
        service.logout()

        XCTAssert(sut.state == .login)
    }
}

private extension AppViewModelTests {
    class StubSessionService: SessionService {
        private let userSubject: CurrentValueSubject<User?, Never>
        
        private(set) lazy var userPublisher = userSubject.eraseToAnyPublisher()
        
        var user: User? { userSubject.value }
        
        init(user: User?) {
            self.userSubject = .init(user)
        }
        
        func login(
            email: String,
            password: String,
            completion: @escaping (Error?) -> Void) {
            userSubject.send(.init())
        }
        
        func logout() {
            userSubject.send(nil)
        }
    }
    
    func makeSUT(isLoggedIn: Bool) -> (AppViewModel, StubSessionService) {
        let sessionService = StubSessionService(user: isLoggedIn ? .init() : nil)
        return (AppViewModel(sessionService: sessionService), sessionService)
    }
}
