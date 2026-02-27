// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DesignSystem",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "DesignSystem",
      targets: ["DesignSystem"]
    )
  ],
  dependencies: [
    .package(name: "Core", path: "../Core")
  ],
  targets: [
    .target(
      name: "DesignSystem",
      dependencies: ["Core"],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "DesignSystemTests",
      dependencies: ["DesignSystem"]
    )
  ],
  swiftLanguageModes: [.v5]
)
