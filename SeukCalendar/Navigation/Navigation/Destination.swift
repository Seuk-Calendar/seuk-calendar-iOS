import AVFoundation
import Foundation

/// 모든 네비게이션 타입을 포함하는 상위 열거형
public enum Destination: Hashable {
  case tab(_ destination: TabDestination)
  case push(_ destination: PushDestination)
  case sheet(_ destination: SheetDestination)
  case fullScreen(_ destination: FullScreenDestination)
}

// MARK: - Tab Destination

public enum TabDestination: String, Hashable {
  case home
  case myPage
}

// MARK: - Push Destination

public enum PushDestination: Hashable {
  case emailSignIn
  case emailSignUp(email: String)
  case demandDetail(id: String)
  case videoEdit(asset: AVAsset)
}

// MARK: - Sheet Destination

public enum SheetDestination: Identifiable, Hashable {
  case feedComment(shortsId: String)
  case demandComment(demandId: String)
  case signIn

  public var id: String {
    switch self {
    case let .feedComment(shortsId): "feedComment_\(shortsId)"
    case let .demandComment(demandId): "demandComment_\(demandId)"
    case .signIn: "signIn"
    }
  }

  public var header: String? {
    switch self {
    case .feedComment: "댓글"
    case .demandComment: "댓글"
    case .signIn: nil
    }
  }
}

public enum FullScreenDestination: Identifiable, Hashable {
  case upload

  public var id: String {
    switch self {
    case .upload:
      "upload"
    }
  }
}
