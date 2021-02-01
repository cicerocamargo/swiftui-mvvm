@testable import swiftui_mvvm
import XCTest

final class SignUpViewModelTests: XCTestCase {
    func test_emailBinding_readsValueFromState() {
        let sut = SignUpViewModel(initialState: .init(email: "asdf"))

        XCTAssertEqual(sut.email.wrappedValue, "asdf")
    }

    func test_emailBinding_writesValueToState() {
        let sut = SignUpViewModel(initialState: .init(email: "asdf"))
        sut.email.wrappedValue = ""

        XCTAssert(sut.state.email.isEmpty)
    }

    func test_isShowingPasswordCreationBinding_readsValueFromState() {
        let sut = SignUpViewModel(initialState: .init(isShowingPasswordCreation: true))

        XCTAssert(sut.isShowingPasswordCreation.wrappedValue)
    }

    func test_isShowingPasswordCreationBinding_writesValueToState() {
        let sut = SignUpViewModel(initialState: .init(isShowingPasswordCreation: true))

        sut.isShowingPasswordCreation.wrappedValue = false

        XCTAssertFalse(sut.state.isShowingPasswordCreation)
    }

    func test_advanceToPasswordCreation_whenEmailIsValid_updatesState() {
        let sut = SignUpViewModel(initialState: .init(email: "asdf@asdf.com"))

        sut.advanceToPasswordCreation()

        XCTAssert(sut.state.isShowingPasswordCreation)
    }

    func test_advanceToPasswordCreation_whenEmailIsNotValid_doNotUpdateState() {
        let sut = SignUpViewModel(initialState: .init(email: ""))

        sut.advanceToPasswordCreation()

        XCTAssertFalse(sut.state.isShowingPasswordCreation)
    }
}
