// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AI",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "AI",
      targets: ["AI"]
    )
  ],
  dependencies: [
    .package(name: "Core", path: "../Core"),
    .package(name: "Domain", path: "../Domain")
  ],
  targets: [
    .target(
      name: "AI",
      dependencies: [
        "Core"
      ]
    ),
    .testTarget(
      name: "AITests",
      dependencies: ["AI"]
    )
  ],
  swiftLanguageModes: [.v5]
)
