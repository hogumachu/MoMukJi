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
