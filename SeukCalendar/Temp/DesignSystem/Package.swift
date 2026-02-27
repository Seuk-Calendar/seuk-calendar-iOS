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
    .package(path: "../Core")
  ],
  targets: [
    .target(
      name: "DesignSystem",
      dependencies: [
        .product(name: "Core", package: "Core")
      ],
      resources: [
        .process("Resources")
      ]
    )
  ],
  swiftLanguageModes: [.v5]
)
