// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Coordinator",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "Coordinator",
      targets: ["Coordinator"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Coordinator",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Navigation", package: "Navigation"),
      ]
    ),
    .testTarget(
      name: "CoordinatorTests",
      dependencies: ["Coordinator"]
    )
  ],
  swiftLanguageModes: [.v5]
)
