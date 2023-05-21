//
//  FoodCreateReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/20.
//

import Foundation
import ReactorKit
import Domain

final class FoodCreateReactor: Reactor {
    
    struct Dependency {
        let coordinator: AppCoordinator
        let useCase: FoodUseCase
    }
    
    var initialState = State()
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return state
    }
    
}

