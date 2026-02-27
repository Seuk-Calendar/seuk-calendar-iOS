// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Domain",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "CalendarDomain",
      targets: ["CalendarDomain"]
    ),
    .library(
      name: "UserDomain",
      targets: ["UserDomain"]
    ),
    .library(
      name: "CalendarDomainTestSupport",
      targets: ["CalendarDomainTestSupport"]
    ),
    .library(
      name: "UserDomainTestSupport",
      targets: ["UserDomainTestSupport"]
    ),
  ],
  dependencies: [
    .package(path: "../Core")
  ],
  targets: [
    // CalendarDomain
    .target(
      name: "CalendarDomain",
      dependencies: [
        .product(name: "Core", package: "Core")
      ],
      path: "Sources/CalendarDomain"
    ),
    .target(
      name: "CalendarDomainTestSupport",
      dependencies: ["CalendarDomain"],
      path: "TestSupport/CalendarDomainTestSupport"
    ),
    .testTarget(
      name: "CalendarDomainTests",
      dependencies: ["CalendarDomain"]
    ),
    // UserDomain
    .target(
      name: "UserDomain",
      dependencies: [
        .product(name: "Core", package: "Core")
      ],
      path: "Sources/UserDomain"
    ),
    .target(
      name: "UserDomainTestSupport",
      dependencies: ["UserDomain"],
      path: "TestSupport/UserDomainTestSupport"
    ),
    .testTarget(
      name: "UserDomainTests",
      dependencies: ["UserDomain"]
    )
  ],
  swiftLanguageModes: [.v5]
)
