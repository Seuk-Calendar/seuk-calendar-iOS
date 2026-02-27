// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Data",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "Common",
      targets: ["Common"]
    ),
    .library(
      name: "CalendarData",
      targets: ["CalendarData"]
    ),
    .library(
      name: "UserData",
      targets: ["UserData"]
    ),
    .library(
      name: "KeyChainData",
      targets: ["KeyChainData"]
    )
  ],
  dependencies: [
    .package(path: "../Core"),
    .package(path: "../Domain")
  ],
  targets: [
    // Common (shared network utilities)
    .target(
      name: "Common",
      dependencies: [
        .product(name: "Core", package: "Core"),
      ],
      path: "Sources/Common"
    ),
    .testTarget(
      name: "CommonTests",
      dependencies: ["Common"]
    ),

    // CalendarData
    .target(
      name: "CalendarData",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "CalendarData", package: "Domain"),
        "Common"
      ],
      path: "Sources/CalendarData"
    ),
    .testTarget(
      name: "CalendarDataTests",
      dependencies: ["CalendarData"]
    ),

    // UserData
    .target(
      name: "UserData",
      dependencies: [
        .product(name: "Core", package: "Core"),
        .product(name: "UserDomain", package: "Domain"),
        "Common"
      ],
      path: "Sources/UserData"
    ),
    .testTarget(
      name: "UserDataTests",
      dependencies: ["UserData"]
    ),

    // KeyChainData
    .target(
      name: "KeyChainData",
      dependencies: [
        .product(name: "Core", package: "Core")
      ],
      path: "Sources/KeyChainData"
    ),
    .testTarget(
      name: "KeyChainDataTests",
      dependencies: ["KeyChainData"]
    )
  ],
  swiftLanguageModes: [.v5]
)
