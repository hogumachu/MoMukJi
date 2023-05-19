//
//  HomeReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/19.
//

import Core
import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
    
    var initialState = State()
    private let dependency: Dependency
    
    struct Dependency {
        let coordinator: AppCoordinator
    }
    
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
        
    }
    
}
