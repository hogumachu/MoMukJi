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
        let mealtimeHelper: MealtimeHelper
    }
    
    var initialState = State(
        currentDate: Date()
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case navigationLeftButtonTap
        case timeButtonTap(FoodTimeButtonModel)
        case updateDate(Date)
    }
    
    enum Mutation {
        case setCurrentDate(Date)
    }
    
    struct State {
        var currentDate: Date
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .pop, animated: true, completion: nil)
            return .empty()
            
        case .timeButtonTap(let model):
            let mealtime = makeMealtime(using: model)
            dependency.coordinator.transition(to: .foodCreate(dependency.category, mealtime), using: .push, animated: true, completion: nil)
            return .empty()
            
        case .updateDate(let date):
            return .just(.setCurrentDate(date))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCurrentDate(let date):
            newState.currentDate = date
        }
        
        return newState
    }
    
}

extension FoodTimeReactor {
    
    private func makeMealtime(using model: FoodTimeButtonModel) -> Mealtime {
        let date = currentState.currentDate
        let slot: MealtimeSlot = {
            switch model {
            case .morning: return .breakfast
            case .lunch: return .lunch
            case .dinner: return .dinner
            case .midnightSnack: return .midnightSnack
            }
        }()
        return dependency.mealtimeHelper.makeMealtime(using: date, slot: slot)
    }
    
}
