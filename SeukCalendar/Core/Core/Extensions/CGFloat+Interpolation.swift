import Foundation

/// 보간법
public extension CGFloat {
  /// 선형보간
  /// - Parameters:
  ///   - inputRange: 입력 범위(x)
  ///   - outputRange: 출력 범위(y)
  /// - Returns: 보간 결과
  func linearInterpolated(
    inputRange: [Self],
    outputRange: [Self]
  ) -> Self {
    let xc = self
    let length = inputRange.count - 1

    if xc <= inputRange[0] {
      return outputRange[0]
    }

    /*
      (yc − y₀)⁄(xc − x₀) = (y₁ − y₀)⁄(x₁ − x₀)
      우리는 yc를 구해야함
     */

    for index in 1 ... length {
      let x1 = inputRange[index - 1]
      let x2 = inputRange[index]

      let y1 = outputRange[index - 1]
      let y2 = outputRange[index]

      if xc <= inputRange[index] {
        let yc = y1 + ((y2 - y1) / (x2 - x1)) * (xc - x1)
        return yc
      }
    }

    // Input Range의 최대값을 xc가 초과 시,
    return outputRange[length]
  }
}
