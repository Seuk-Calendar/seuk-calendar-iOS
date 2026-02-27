//
//  Coordinator.swift
//  Pool
//
//  Created by YoungK on 2/9/26.
//

import Navigation
import SwiftUI

// TODO: Destination 의존 대신 Feature enum에 의존하도록 변경 예정
// Navigation 모듈 의존성 제거, enum을 통한 가독성 유지
@MainActor
public struct AppCoordinator {
  public init() {}

  @ViewBuilder
  public func view(for destination: Destination) -> some View {
    switch destination {
    case let .tab(destination):
      view(for: destination)
    case let .push(destination):
      view(for: destination)
    case let .sheet(destination):
      view(for: destination)
    case let .fullScreen(destination):
      view(for: destination)
    @unknown default:
      EmptyView()
    }
  }

  @ViewBuilder
  public func view(for destination: TabDestination) -> some View {
    switch destination {
    default:
      Text("구현 예정")
    }
  }

  @ViewBuilder
  public func view(for destination: PushDestination) -> some View {
    switch destination {
    default:
      Text("구현 예정")
    }
  }

  @ViewBuilder
  public func view(for destination: SheetDestination) -> some View {
    switch destination {
    default:
      Text("구현 예정")
    }
  }

  @ViewBuilder
  public func view(for destination: FullScreenDestination) -> some View {
    switch destination {
    default:
      Text("구현 예정")
    }
  }
}
