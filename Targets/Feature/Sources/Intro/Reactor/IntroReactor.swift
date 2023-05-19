//
//  IntroReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/18.
//

import RxSwift
import ReactorKit

final class IntroReactor: Reactor {
    
    private let dependency: Depedency
    var initialState = State()
    
    struct Depedency {
        let coordinator: AppCoordinator
    }
    
    init(dependency: Depedency) {
        self.dependency = dependency
    }
    
    enum Action {
        case homeButtonTap
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .homeButtonTap:
            dependency.coordinator.start(root: .home)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
}
