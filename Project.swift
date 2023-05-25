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

public extension TargetDependency {
    
    enum ExternalSPM {
        case rxSwift
        case rxCocoa
        case rxRelay
        case reactorKit
        case rxDataSources
        case snapKit
        case then
        case swinject
        case lottie
        
        var object: TargetDependency {
            switch self {
            case .rxSwift: return TargetDependency.external(name: "RxSwift")
            case .rxCocoa: return TargetDependency.external(name: "RxCocoa")
            case .rxRelay: return TargetDependency.external(name: "RxRelay")
            case .reactorKit: return TargetDependency.external(name: "ReactorKit")
            case .rxDataSources: return TargetDependency.external(name: "RxDataSources")
            case .snapKit: return TargetDependency.external(name: "SnapKit")
            case .then: return TargetDependency.external(name: "Then")
            case .swinject: return TargetDependency.external(name: "Swinject")
            case .lottie: return TargetDependency.external(name: "Lottie")
            }
        }
    }

    enum Carthage {
        
    }
    
    enum InternalSPM: CaseIterable {
        case realmSwift
        
        var object: TargetDependency {
            switch self {
            case .realmSwift: return TargetDependency.package(product: "RealmSwift")
            }
        }
        
        var package: Package {
            switch self {
            case .realmSwift: return .remote(url: "https://github.com/realm/realm-swift.git", requirement: .upToNextMajor(from: "10.39.1"))
            }
        }
    }
    
}

extension Module {
    // MARK: - Module Dependencies
    var dependencies: [TargetDependency] {
        switch self {
        case .core:
            return [
                .ExternalSPM.rxSwift.object,
                .ExternalSPM.rxRelay.object,
                .ExternalSPM.swinject.object
            ]
            
        case .domain:
            return [
                .target(name: Module.core.name)
            ]
            
        case .service:
            return [
                .target(name: Module.domain.name),
                .InternalSPM.realmSwift.object
            ]
            
        case .userInterface:
            return [
                .target(name: Module.domain.name),
                .ExternalSPM.rxSwift.object,
                .ExternalSPM.rxCocoa.object,
                .ExternalSPM.lottie.object
            ]
            
        case .feature:
            return [
                .target(name: Module.userInterface.name),
                .target(name: Module.service.name),
                .ExternalSPM.rxSwift.object,
                .ExternalSPM.rxCocoa.object,
                .ExternalSPM.rxRelay.object,
                .ExternalSPM.reactorKit.object,
                .ExternalSPM.rxDataSources.object,
                .ExternalSPM.snapKit.object,
                .ExternalSPM.then.object
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
    let deploymentTarget = DeploymentTarget.iOS(targetVersion: "14.0", devices: [.iphone])
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

func makePackages() -> [Package] {
    return TargetDependency.InternalSPM.allCases.map(\.package)
}

let project = Project(
    name: "MoMukJi",
    packages: makePackages(),
    settings: settings,
    targets: makeTargets()
)
