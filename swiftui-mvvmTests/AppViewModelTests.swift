@testable import swiftui_mvvm
import Combine
import XCTest

final class AppViewModelTests: XCTestCase {
    func test_whenUserIsLoggedIn_showsLoggedArea() {
        let (sut, _) = makeSUT(isLoggedIn: true)
        
        XCTAssert(sut.state?.isLoggedArea == true)
    }
    
    func test_whenUserIsNotLoggedIn_showsLogin() {
        let (sut, _) = makeSUT(isLoggedIn: false)
        
        XCTAssert(sut.state?.isLogin == true)
    }
    
    func test_whenUserLogsIn_showsLoggedArea() {
        let (sut, service) = makeSUT(isLoggedIn: false)
        
        service.login(email: "", password: "", completion: { _ in })

        XCTAssert(sut.state?.isLoggedArea == true)
    }
    
    func test_whenUserLogsOut_showsLogin() {
        let (sut, service) = makeSUT(isLoggedIn: true)
        
        service.logout()

        XCTAssert(sut.state?.isLogin == true)
    }
}

// MARK: - Helpers

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

private extension AppViewState {
    var isLogin: Bool {
        guard case .login = self else { return false }
        return true
    }
    
    var isLoggedArea: Bool {
        guard case .loggedArea = self else { return false }
        return true
    }
}
