import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

enum Module: CaseIterable {
    case core
    case domain
    case service
    case userInterface
    case feature
    
    var name: String {
        switch self {
        case .core:  return "Core"
        case .domain: return "Domain"
        case .service: return "Service"
        case .userInterface: return "UserInterface"
        case .feature: return "Feature"
        }
    }
}

enum ExternalDependency {
    case rxSwift
    case rxCocoa
    case rxRelay
    case reactorKit
    case rxDataSources
    case snapKit
    case then
    
    
    var name: String {
        switch self {
        case .rxSwift: return "RxSwift"
        case .rxCocoa: return "RxCocoa"
        case .rxRelay: return "RxRelay"
        case .reactorKit: return "ReactorKit"
        case .rxDataSources: return "RxDataSources"
        case .snapKit: return "SnapKit"
        case .then: return "Then"
        }
    }
    
    var external: TargetDependency {
        return .external(name: self.name)
    }
}

extension Module {
    // MARK: - Module Dependencies
    var dependencies: [TargetDependency] {
        switch self {
        case .core:
            return [
                ExternalDependency.rxSwift.external,
                ExternalDependency.rxRelay.external
            ]
            
        case .domain:
            return [
                .target(name: Module.core.name)
            ]
            
        case .service:
            return [
                .target(name: Module.domain.name)
            ]
            
        case .userInterface:
            return [
                .target(name: Module.domain.name),
                ExternalDependency.rxSwift.external,
                ExternalDependency.rxCocoa.external
            ]
            
        case .feature:
            return [
                .target(name: Module.userInterface.name),
                .target(name: Module.domain.name),
                ExternalDependency.rxSwift.external,
                ExternalDependency.rxCocoa.external,
                ExternalDependency.rxRelay.external,
                ExternalDependency.reactorKit.external,
                ExternalDependency.rxDataSources.external,
                ExternalDependency.snapKit.external,
                ExternalDependency.then.external
            ]
        }
    }
    
    func createTargets(deploymentTarget: DeploymentTarget) -> [Target] {
        return Project.createFeatureTargets(
            name: name,
            deploymentTarget: deploymentTarget,
            dependencies: dependencies
        )
    }
}

private let settings = Settings.settings(configurations: [
    .debug(
        name: "Debug",
        xcconfig: .relativeToRoot("Targets/App/Configuration/Debug.xcconfig")
    ),
    .release(
        name: "Release",
        xcconfig: .relativeToRoot("Targets/App/Configuration/Release.xcconfig")
    )
])

func makeTargets() -> [Target] {
    let deploymentTarget = DeploymentTarget.iOS(targetVersion: "13.0", devices: [.iphone])
    let appTargets = Project.createAppTarget(
        name: "MoMukJi",
        deploymentTarget: deploymentTarget,
        dependencies: [
            .target(name: Module.feature.name),
            .target(name: Module.service.name)
        ]
    )
    let moduleTargets = Module.allCases.flatMap { $0.createTargets(deploymentTarget: deploymentTarget) }
    
    return [appTargets] + moduleTargets
}

let project = Project(
    name: "MoMukJi",
    settings: settings,
    targets: makeTargets()
)
