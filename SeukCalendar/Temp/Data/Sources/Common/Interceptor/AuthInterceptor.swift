//
//import Alamofire
//import Foundation
//
//struct Response: Decodable {
//  let result: TokenResponse
//}
//
//struct TokenResponse: Decodable {
//  let accessToken: String
//  let refreshToken: String
//}
//
//final class AuthInterceptor: RequestInterceptor {
//
//  /// - Note: 헤더에 토큰 삽입 및 리퀘스트 디버깅에 사용
//  func adapt(
//    _ urlRequest: URLRequest,
//    for session: Session,
//    completion: @escaping (Result<URLRequest, any Error>) -> Void
//  ) {
//    var request = urlRequest
//    if let token = UserDefaults.standard.string(forKey: "token") { // 스토리지 교체
//      request.headers.add(.authorization(bearerToken: token))
//    }
//    completion(.success(request))
//  }
//
//  /// - Note 401 발생 시 동작
//  func retry(
//    _ request: Request,
//    for session: Session,
//    dueTo error: any Error,
//    completion: @escaping (RetryResult) -> Void
//  ) {
//    guard let response = request.response,
//          response.statusCode == 401
//    else {
//      completion(.doNotRetry)
//      return
//    }
//
//    Task {
//      do {
//        try await TokenRefresher.shared.validAccessToken()
//        completion(.retry)
//      } catch {
//        completion(.doNotRetry) // retry with Error로 벼경하기
//      }
//    }
//  }
//}
//
//fileprivate actor TokenRefresher {
//  static let shared = TokenRefresher()
//  private var refreshTask: Task<Void, Error>?
//
//  private init() {}
//
//  func validAccessToken() async throws {
//    if let _ = refreshTask {
//      return
//    }
//
//    let task = Task<Void, Error> {
//      defer { refreshTask = nil }
//
//      let refreshToken = "refreshToken"
//      let response = try await AF.request(
//        "https://your.api.com/api/v1/auth/token/reissue",
//        method: .post,
//        parameters: [
//          "accessToken": "accessToken",
//          "refreshToken": refreshToken
//        ]
//      )
//      .serializingDecodable(Response.self)
//      .value
//
//      // save
//      let (newAccessToken, newRefreshToken) = (response.result.accessToken, response.result.refreshToken)
//    }
//
//    refreshTask = task
//  }
//}
