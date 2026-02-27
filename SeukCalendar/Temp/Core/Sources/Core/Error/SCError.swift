//
//  SCError.swift
//  Core
//
//  Created by YoungK on 12/22/25.
//

import Foundation

public protocol SCError: Error {
  /// Debug용: 프린트 또는 로그 등에 사용되는 디버깅용 상세 메시지
  var errorDescription: String { get }

  /// UI용: 사용자에게 보여줄 메시지
  var userMessage: String { get }

  // TODO: 에러수준 등 추가로 필요한 속성들을 해당 프로토콜에 정의..
}
