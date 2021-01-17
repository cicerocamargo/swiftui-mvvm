import Foundation

protocol LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    )
}

struct EmptyLoginService: LoginService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {}
}
