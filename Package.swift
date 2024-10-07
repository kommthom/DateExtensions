// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DateExtensions",
	platforms: [
		.macOS(.v15)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DateExtensions",
            targets: ["DateExtensions"]),
    ],
	dependencies: [
		.package(
			name: "UserDTOs", 
			path: "../UserDTOs"
		)
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DateExtensions",
			dependencies: [
				.product(
					name: "UserDTOs",
					package: "UserDTOs"
				)
			]
		),
        .testTarget(
            name: "DateExtensionsTests",
            dependencies: [
				"DateExtensions"
			]
        ),
    ]
)
