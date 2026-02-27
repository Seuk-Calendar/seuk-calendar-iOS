//
//  Coordinator.swift
//  Pool
//
//  Created by YoungK on 2/9/26.
//

import SwiftUI
import Navigation
import ShortsFeature
import HomeFeature
import MyPageFeature
import SignInFeature
import DemandFeature
import UploadFeature

// TODO: Destination 의존 대신 Feature enum에 의존하도록 변경 예정
// Navigation 모듈 의존성 제거, enum을 통한 가독성 유지
@MainActor
public struct Coordinator {
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
    }
  }
  
  @ViewBuilder
  public func view(for destination: TabDestination) -> some View {
    switch destination {
    case .home:
      HomeViewFactory.createView()
    case .myPage:
      MyPageViewFactory.createView()
    }
  }
  
  @ViewBuilder
  public func view(for destination: PushDestination) -> some View {
    switch destination {
    case .emailSignIn:
      SignInViewFactory.createEmailSignInView()
    case let .emailSignUp(email: email):
      SignInViewFactory.createEmailSignUpView(email: email)
    case let .demandDetail(id: id):
      DemandViewFactory.createDemandDetailView()
    case let .videoEdit(asset):
      UploadViewFactory.createVideoEditingView(asset: asset)
    }
  }
  
  @ViewBuilder
  public func view(for destination: SheetDestination) -> some View {
    switch destination {
    case let .feedComment(shortsId):
      FeedViewFactory.createFeedCommentListView(shortsId: shortsId)
    case let .demandComment(demandId):
      DemandViewFactory.createDemandCommentListView(demandId: demandId)
    case .signIn:
      SignInViewFactory.createSignInView()
    }
  }
  
  @ViewBuilder
  public func view(for destination: FullScreenDestination) -> some View {
    switch destination {
    case .upload:
      UploadViewFactory.createUploadEntryView()
    }
  }
}

