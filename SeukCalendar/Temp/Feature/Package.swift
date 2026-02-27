// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Feature",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(name: "BaseFeature", targets: ["BaseFeature"])
  ],
  dependencies: [
    .package(path: "../Core"),
    .package(path: "../DesignSystem"),
    .package(path: "../Domain"),
    .package(path: "../Navigation")

  ],
  targets: [
    // MARK: - BaseFeature
    .target(
      name: "BaseFeature",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "DesignSystem", package: "DesignSystem"),
        .product(name: "Navigation", package: "Navigation")
      ],
      path: "Sources/BaseFeature"
    ),
    .testTarget(
      name: "BaseFeatureTests",
      dependencies: ["BaseFeature"]
    )
  ],
  swiftLanguageModes: [.v5]
)
