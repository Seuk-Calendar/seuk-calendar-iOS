import Core
import DesignSystem
import SwiftUI

public struct ScrollableTabView: View {
  private let activatedColor: Color
  private let defaultColor: Color
  private let contents: [AnyView]
  private let isEnableTabScroll: Bool
  private let tabBarHeight: CGFloat

  @State private var tabs: [ScrollableTabView.TabModel]
  @State private var activatedTab: String
  @State private var activatedTabID: String? // 탭을 눌렀을 때, 스크롤 포지션에 바인딩 될 변수
  @State private var activatedViewID: String? // 스크롤을 통해 현재 뷰가 바꼈을 때 감지하기위한 변수
  @State private var progress: CGFloat = .zero

  public init(
    tabs: [ScrollableTabView.TabModel],
    activatedColor: Color = .accentColor,
    defaultColor: Color = .primary,
    isEnableTabScroll: Bool = true,
    tabBarHeight: CGFloat = 44,
    @AnyViewArrayBuilder _ builder: @escaping () -> [AnyView]
  ) {
    self.tabs = tabs
    self.activatedTab = tabs[0].id
    self.activatedColor = activatedColor
    self.defaultColor = defaultColor
    self.isEnableTabScroll = isEnableTabScroll
    self.tabBarHeight = tabBarHeight
    self.contents = builder()
  }

  public var body: some View {
    ZStack(alignment: .top) {
      contentView()
      tabBarView()
    }
  }
}

extension ScrollableTabView {
  private func tabBarView() -> some View {
    ScrollView(.horizontal) {
      HStack(spacing: Spacing.sp250) {
        ForEach($tabs) { $tab in
          Button(action: {
            withAnimation(.snappy) {
              activatedTab = tab.id
              activatedTabID = tab.id
              activatedViewID = tab.id
            }
          }) {
            Text(tab.id)
              .padding(.vertical, Spacing.sp250)
              .font(activatedTab == tab.id ? Heading5.bold : Heading5.bold)
              .foregroundStyle(activatedTab == tab.id
                ? activatedColor
                : defaultColor
              )
              .shadow(
                color: activatedTabLayout() == .overlay
                  ? .black.opacity(0.6)
                  : .clear,
                radius: 8 // Figma 기준 Blur 20
              )
              .contentShape(.rect)
          }
          .didScroll {
            tab.size = $0.size
            tab.minX = $0.minX
          }
        }
      }
    }
    .frame(height: tabBarHeight)
    .scrollPosition( // activatedTabID 변경 시, 스크롤 + 중앙정렬
      id: .get { activatedTabID },
      anchor: .center
    )
    .overlay(alignment: .bottom) {
      dynamicIndicator()
    }
    .safeAreaPadding(.horizontal, Spacing.sp400)
    .scrollIndicators(.hidden)
    .scrollDisabled(!isEnableTabScroll)
  }

  private func dynamicIndicator() -> some View {
    ZStack(alignment: .leading) {
      Color.clear
        .frame(height: 2) // ZStack의 Width를 끝까지 확장하기 위한 눈속임

      let inputRange = tabs.indices.compactMap { return CGFloat($0) }
      let widthRange = tabs.compactMap { return $0.size.width }
      let positionRange = tabs.compactMap { return $0.minX }

      let indicatorWidth = progress.linearInterpolated(
        inputRange: inputRange,
        outputRange: widthRange
      ) // xc = progress에서 시작

      let indicatorPosition = progress.linearInterpolated(
        inputRange: inputRange,
        outputRange: positionRange
      ) // xc = progress에서 시작

      Rectangle()
        .fill(activatedColor)
        .frame(width: indicatorWidth, height: 2)
        .offset(x: indicatorPosition)
    }
  }

  private func contentView() -> some View {
    GeometryReader { proxy in
      let size = proxy.size

      ScrollView(.horizontal) {
        LazyHStack(spacing: .zero) {
          ForEach(0 ..< contents.count) { index in
            let isOverlay = tabs[index].layout == .overlay
            let topOffset = isOverlay ? 0 : tabBarHeight + Spacing.sp400

            contents[index]
              .id(tabs[index].id)
              .frame(width: size.width)
              .safeAreaPadding(.top, topOffset)
              .contentShape(.rect)
          }
        }
        .scrollTargetLayout()
        .didScroll {
          progress = -$0.minX / size.width
        }
      }
      .scrollPosition(id: $activatedViewID)
      .scrollIndicators(.hidden)
      .scrollTargetBehavior(.paging)
      .onChange(of: activatedViewID) { _, newValue in
        if let newValue = newValue { // 스크롤로 뷰가 갱신됐을 때, Tab쪽 갱신
          withAnimation(.snappy) {
            activatedTab = newValue
            activatedTabID = newValue
          }
        }
      }
    }
  }
}

// MARK: - helper methods

private extension ScrollableTabView {
  func activatedTabLayout() -> ScrollableTabView.TabModel.Layout? {
    return tabs.first(where: { $0.id == activatedTab })?.layout
  }
}

#Preview {
  ScrollableTabView(
    tabs: [
      .init(title: "1234", layout: .overlay),
      .init(title: "Development"),
      .init(title: "Development1"),
      .init(title: "Development2"),
      .init(title: "Development3 "),
      .init(title: "Development4")
    ]
  ) {
    Text("Hello")
      .font(.title)
      .foregroundColor(.blue)
    Rectangle()
      .fill(.green)
      .frame(width: 100, height: 50)
    Circle()
      .fill(.red)
      .frame(width: 40, height: 40)
    Text("Hello")
      .font(.title)
      .foregroundColor(.blue)
    Rectangle()
      .fill(.green)
      .frame(width: 100, height: 50)
    Circle()
      .fill(.red)
      .frame(width: 40, height: 40)
  }
}
