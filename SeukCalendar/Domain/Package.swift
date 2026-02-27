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
      name: "ParsingDomain",
      targets: ["ParsingDomain"]
    ),
    .library(
      name: "RecapDomain",
      targets: ["RecapDomain"]
    ),
    .library(
      name: "WidgetDomain",
      targets: ["WidgetDomain"]
    ),
    .library(
      name: "CalendarDomainTestSupport",
      targets: ["CalendarDomainTestSupport"]
    )
  ],
  dependencies: [
    .package(name: "Core", path: "../Core")
  ],
  targets: [
    // CalendarDomain
    .target(
      name: "CalendarDomain",
      dependencies: ["Core"]
    ),

    // ParsingDomain
    .target(
      name: "ParsingDomain",
      dependencies: ["Core"]
    ),

    // RecapDomain
    .target(
      name: "RecapDomain",
      dependencies: ["Core"]
    ),

    // WidgetDomain
    .target(
      name: "WidgetDomain",
      dependencies: ["Core"]
    ),

    // TestSupport
    .target(
      name: "CalendarDomainTestSupport",
      dependencies: ["CalendarDomain"],
      path: "TestSupport/CalendarDomainTestSupport"
    ),

    // Tests
    .testTarget(
      name: "DomainTests",
      dependencies: [
        "CalendarDomain",
        "ParsingDomain",
        "RecapDomain",
        "WidgetDomain",
        "CalendarDomainTestSupport"
      ]
    )
  ],
  swiftLanguageModes: [.v5]
)
