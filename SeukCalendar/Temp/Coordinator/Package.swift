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
    .package(path: "../Core"),
    .package(path: "../Navigation"),
    .package(path: "../Feature"),
    .package(path: "../Domain"),
    .package(path: "../Data")
  ],
  targets: [
    .target(
      name: "Coordinator",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "Navigation", package: "Navigation"),
        // Feature targets
        .product(name: "BaseFeature", package: "Feature"),
        .product(name: "ShortsFeature", package: "Feature"),
        .product(name: "SignInFeature", package: "Feature"),
        .product(name: "DemandFeature", package: "Feature"),
        .product(name: "UploadFeature", package: "Feature"),
        .product(name: "MyPageFeature", package: "Feature"),
        .product(name: "MainTabFeature", package: "Feature"),
        .product(name: "HomeFeature", package: "Feature"),
        .product(name: "CommentFeature", package: "Feature"),
        // Domain targets
        .product(name: "ShortsDomain", package: "Domain"),
        .product(name: "DemandDomain", package: "Domain"),
        .product(name: "UserDomain", package: "Domain"),
        .product(name: "CommentDomain", package: "Domain"),
        // Data targets
        .product(name: "ShortsData", package: "Data"),
        .product(name: "CommentData", package: "Data"),
        .product(name: "DemandData", package: "Data"),
        .product(name: "UserData", package: "Data"),
        .product(name: "KeyChainData", package: "Data")
      ]
    ),
    .testTarget(
      name: "CoordinatorTests",
      dependencies: ["Coordinator"]
    )
  ],
  swiftLanguageModes: [.v5]
)
