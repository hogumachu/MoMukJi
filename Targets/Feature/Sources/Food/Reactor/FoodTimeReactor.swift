//
//  FoodTimeReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/25.
//

import Domain
import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class FoodTimeReactor: Reactor {
    
    typealias Category = Domain.Category
    
    struct Dependency {
        let coordinator: AppCoordinator
        let category: Category
    }
    
    var initialState = State()
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case navigationLeftButtonTap
        case timeButtonTap(FoodTimeButtonModel)
    }
    
    enum Mutation {}
    struct State {}
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .pop, animated: true, completion: nil)
            return .empty()
            
        case .timeButtonTap(let model):
            let foodTime = makeFoodTime(using: model)
            dependency.coordinator.transition(to: .foodCreate(dependency.category, foodTime), using: .push, animated: true, completion: nil)
            return .empty()
        }
    }
    
}

extension FoodTimeReactor {
    
    private func makeFoodTime(using model: FoodTimeButtonModel) -> FoodTimeEnum {
        switch model {
        case .morning: return .morning
        case .lunch: return .lunch
        case .dinner: return .dinner
        case .midnightSnack: return .midnightSnack
        }
    }
    
}
