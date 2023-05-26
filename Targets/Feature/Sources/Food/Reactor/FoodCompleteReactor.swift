//
//  FoodCompleteReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/26.
//

import Domain
import Foundation
import ReactorKit

final class FoodCompleteReactor: Reactor {
    
    var initialState: State
    private let dependency: Dependency
    
    struct Dependency {
        let coordinator: AppCoordinator
        let food: Food
    }
    
    enum Action {
        case animationFinished
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var title: String
        var subtitle: String
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.initialState = State(
            title: "성공적으로 저장되었어요",
            subtitle: "\(dependency.food.name) 좋아요!"
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .animationFinished:
            dependency.coordinator.close(using: .dismiss, animated: true) { [weak self] in
                self?.dependency.coordinator.refresh()
            }
            return .empty()
        }
    }
    
}
