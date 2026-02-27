// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Feature",
  platforms: [
    .iOS(.v18)
  ],
  products: [
    .library(
      name: "BaseFeature",
      targets: ["BaseFeature"]
    ),
    .library(
      name: "CalendarFeature",
      targets: ["CalendarFeature"]
    ),
    .library(
      name: "InputFeature",
      targets: ["InputFeature"]
    ),
    .library(
      name: "RecapFeature",
      targets: ["RecapFeature"]
    ),
    .library(
      name: "WidgetFeature",
      targets: ["WidgetFeature"]
    ),
    .library(
      name: "SettingsFeature",
      targets: ["SettingsFeature"]
    )
  ],
  dependencies: [
    .package(name: "Core", path: "../Core"),
    .package(name: "DesignSystem", path: "../DesignSystem"),
    .package(name: "Domain", path: "../Domain"),
    .package(name: "Navigation", path: "../Navigation")
  ],
  targets: [
    // BaseFeature
    .target(
      name: "BaseFeature",
      dependencies: [
        "Core",
        "DesignSystem",
        "Navigation"
      ]
    ),

    // CalendarFeature
    .target(
      name: "CalendarFeature",
      dependencies: [
        "Core",
        "DesignSystem",
        "Navigation",
        "BaseFeature",
        .product(name: "CalendarDomain", package: "Domain")
      ]
    ),

    // InputFeature
    .target(
      name: "InputFeature",
      dependencies: [
        "Core",
        "DesignSystem",
        "Navigation",
        "BaseFeature",
        .product(name: "ParsingDomain", package: "Domain")
      ]
    ),

    // RecapFeature
    .target(
      name: "RecapFeature",
      dependencies: [
        "Core",
        "DesignSystem",
        "Navigation",
        "BaseFeature",
        .product(name: "RecapDomain", package: "Domain")
      ]
    ),

    // WidgetFeature
    .target(
      name: "WidgetFeature",
      dependencies: [
        "Core",
        "DesignSystem",
        "BaseFeature",
        .product(name: "WidgetDomain", package: "Domain")
      ]
    ),

    // SettingsFeature
    .target(
      name: "SettingsFeature",
      dependencies: [
        "Core",
        "DesignSystem",
        "Navigation",
        "BaseFeature"
      ]
    ),

    // Tests
    .testTarget(
      name: "FeatureTests",
      dependencies: [
        "BaseFeature",
        "CalendarFeature",
        "InputFeature",
        "RecapFeature",
        "WidgetFeature",
        "SettingsFeature",
        .product(name: "CalendarDomainTestSupport", package: "Domain")
      ]
    )
  ],
  swiftLanguageModes: [.v5]
)
