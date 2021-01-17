//
//  LoginTests.swift
//  swiftui-mvvmTests
//
//  Created by Cicero Camargo on 03/10/20.
//  Copyright © 2020 Cicero Camargo. All rights reserved.
//

@testable import swiftui_mvvm
import XCTest

class LoginTests: XCTestCase {
    private var viewModel: LoginViewModel! // Subject Under Test
    private var service: LoginServiceMock!

    override func setUp() {
        super.setUp()
        service = .init()
        viewModel = .init(service: service)
    }

    func testDefaultInitialState() {
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "",
                password: "",
                isLoggingIn: false,
                isShowingErrorAlert: false
            )
        )
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
    }

    func testSuccessfulLoginFlow() {
        viewModel.bindings.email.wrappedValue = "codemus.dev@gmail.com"
        viewModel.bindings.password.wrappedValue = "x"
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)

        viewModel.login()
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "codemus.dev@gmail.com",
                password: "x",
                isLoggingIn: true,
                isShowingErrorAlert: false
            )
        )
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssertEqual(viewModel.state.footerMessage, LoginViewState.isLoggingInFooter)
        XCTAssertEqual(service.lastReceivedEmail, "codemus.dev@gmail.com")
        XCTAssertEqual(service.lastReceivedPassword, "x")
    }

    func testFailableLoginFlow() {
        viewModel.bindings.email.wrappedValue = "codemus.dev@gmail.com"
        viewModel.bindings.password.wrappedValue = "x"
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)

        viewModel.login()
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "codemus.dev@gmail.com",
                password: "x",
                isLoggingIn: true,
                isShowingErrorAlert: false
            )
        )
        XCTAssertFalse(viewModel.state.canSubmit)
        XCTAssertEqual(viewModel.state.footerMessage, LoginViewState.isLoggingInFooter)
        XCTAssertEqual(service.lastReceivedEmail, "codemus.dev@gmail.com")
        XCTAssertEqual(service.lastReceivedPassword, "x")

        struct FakeError: Error {}
        service.completion?(FakeError())
        XCTAssertEqual(
            viewModel.state,
            LoginViewState(
                email: "codemus.dev@gmail.com",
                password: "x",
                isLoggingIn: false,
                isShowingErrorAlert: true
            )
        )
        XCTAssert(viewModel.state.canSubmit)
        XCTAssert(viewModel.state.footerMessage.isEmpty)
    }
}

private final class LoginServiceMock: LoginService {
    var lastReceivedEmail: String?
    var lastReceivedPassword: String?
    var completion: ((Error?) -> Void)?

    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        lastReceivedEmail = email
        lastReceivedPassword = password
        self.completion = completion
    }
}
