import Foundation
import ProjectDescription

enum Environment {
    private static var environment: [String: String] {
        ProcessInfo.processInfo.environment
    }

    static var useSPM: Bool {
        environment["TUIST_USE_SPM"] == "true"
    }
}

let useSPM = Environment.useSPM

let packages: [Package] = useSPM ? [
    .package(url: "https://github.com/aim2120/PublicSymbolsMissingModuleExample-PackageA", from: "0.0.6"),
] : []

let targets: [Target] = useSPM ? [
    // MARK: Use SPM
    .target(
        name: "PublicSymbolsMissingModuleExample",
        destinations: .iOS,
        product: .staticLibrary,
        bundleId: "io.tuist.PublicSymbolsMissingModuleExample",
        infoPlist: .default,
        sources: ["PublicSymbolsMissingModuleExample/Sources/**"],
        dependencies: [
            .package(product: "PublicSymbolsMissingModuleExample-PackageA", type: .runtime)
        ]
    ),
    .target(
        name: "PublicSymbolsMissingModuleExampleTests",
        destinations: .iOS,
        product: .unitTests,
        bundleId: "io.tuist.PublicSymbolsMissingModuleExampleTests",
        infoPlist: .default,
        sources: ["PublicSymbolsMissingModuleExample/Tests/**"],
        dependencies: [.target(name: "PublicSymbolsMissingModuleExample")]
    ),
] : [
    // MARK: Use Frameworks
    .target(
        name: "PublicSymbolsMissingModuleExample",
        destinations: .iOS,
        product: .staticFramework,
        bundleId: "io.tuist.PublicSymbolsMissingModuleExample",
        infoPlist: .default,
        sources: ["PublicSymbolsMissingModuleExample/Sources/**"],
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
        dependencies: [.target(name: "PublicSymbolsMissingModuleExample")]
    ),
]

let project = Project(
    name: "PublicSymbolsMissingModuleExample",
    packages: packages,
    targets: targets
)
