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
      name: "CalendarData",
      targets: ["CalendarData"]
    ),
    .library(
      name: "ParsingData",
      targets: ["ParsingData"]
    ),
    .library(
      name: "RecapData",
      targets: ["RecapData"]
    ),
    .library(
      name: "WidgetData",
      targets: ["WidgetData"]
    )
  ],
  dependencies: [
    .package(name: "Core", path: "../Core"),
    .package(name: "Domain", path: "../Domain")
  ],
  targets: [
    // CalendarData
    .target(
      name: "CalendarData",
      dependencies: [
        "Core",
        .product(name: "CalendarDomain", package: "Domain")
      ]
    ),

    // ParsingData
    .target(
      name: "ParsingData",
      dependencies: [
        "Core",
        .product(name: "ParsingDomain", package: "Domain")
      ]
    ),

    // RecapData
    .target(
      name: "RecapData",
      dependencies: [
        "Core",
        .product(name: "RecapDomain", package: "Domain")
      ]
    ),

    // WidgetData
    .target(
      name: "WidgetData",
      dependencies: [
        "Core",
        .product(name: "WidgetDomain", package: "Domain")
      ]
    ),

    // Tests
    .testTarget(
      name: "DataTests",
      dependencies: [
        "CalendarData",
        "ParsingData",
        "RecapData",
        "WidgetData",
        .product(name: "CalendarDomainTestSupport", package: "Domain")
      ]
    )
  ],
  swiftLanguageModes: [.v5]
)
