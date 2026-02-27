//
//  PLBadge.swift
//  DesignSystem
//
//  Created by YoungK on 9/22/25.
//

import SwiftUI

public struct PLBadge: View {
  private let count: Int

  public init(_ count: Int = 0) {
    self.count = count
  }

  public var body: some View {
    Group {
      if count > 0 {
        Text(count > 99 ? "99+" : "\(count)") // 99를 넘으면 99+ 로 표기
          .font(.caption) // TODO: 변경된 font로 적용 필요
          .foregroundStyle(PoolColor.Grays.white)
          .padding(.horizontal, Spacing.sp100)
          .padding(.vertical, 1)
          .background(PoolColor.Colors.red)
          .clipShape(Capsule())
      } else {
        Circle()
          .fill(PoolColor.Colors.red)
          .frame(width: 4, height: 4)
      }
    }
  }
}

#Preview {
  VStack(spacing: 5) {
    Text("Badge").font(.headline)
    PLBadge()
    PLBadge(8)
    PLBadge(50)
    PLBadge(150)
  }
}
