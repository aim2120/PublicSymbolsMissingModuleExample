import ProjectDescription

let project = Project(
    name: "PublicSymbolsMissingModuleExample",
    targets: [
        .target(
            name: "PublicSymbolsMissingModuleExample",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.PublicSymbolsMissingModuleExample",
            infoPlist: .default,
            sources: ["PublicSymbolsMissingModuleExample/Sources/**"],
            resources: ["PublicSymbolsMissingModuleExample/Resources/**"],
            dependencies: [
                .external(name: "PublicSymbolsMissingModuleExample-PackageA")
            ]
        ),
        .target(
            name: "PublicSymbolsMissingModuleExampleTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.PublicSymbolsMissingModuleExampleTests",
            infoPlist: .default,
            sources: ["PublicSymbolsMissingModuleExample/Tests/**"],
            resources: [],
            dependencies: [.target(name: "PublicSymbolsMissingModuleExample")]
        ),
    ]
)
