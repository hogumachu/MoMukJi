//
//  HomeReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/19.
//

import Core
import Domain
import RxSwift
import ReactorKit

final class HomeReactor: Reactor {
    
    typealias Section = HomeSection
    
    var initialState = State(sections: [])
    private let dependency: Dependency
    
    struct Dependency {
        let coordinator: AppCoordinator
        let foodUseCase: FoodUseCase
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case refresh
        case addButtonTap
    }
    
    enum Mutation {
        case setSections([Section])
    }
    
    struct State {
        var sections: [Section]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
//            let foods = fetchFoodList()
//            let sections = makeSections(foods: foods)
            let sections = makeMockSections()
            return .just(.setSections(sections))
            
        case .addButtonTap:
            dependency.coordinator.transition(to: .foodCreate, using: .modal, animated: true, completion: nil)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
        }
        return newState
    }
    
}

extension HomeReactor {
    
    private func fetchFoodList() -> [Food] {
        return dependency.foodUseCase
            .fetchFoodList(request: FoodRequest())
    }
    
    private func makeSections(foods: [Food]) -> [Section] {
        return Set<String>(foods.map(\.category))
            .sorted(by: <)
            .map { category -> Section in
                let items = foods
                    .filter { $0.category == category }
                    .map { Section.Item(name: $0.name, count: $0.count)}
                    .sorted { $0.count > $1.count }
                return Section(category: category, items: items)
            }
    }
    
    private func makeMockSections() -> [Section] {
        return [
            Section(category: "한식", items: [.init(name: "김치찌개", count: 6), .init(name: "된장찌개", count: 5)]),
            Section(category: "양식", items: [.init(name: "파스타", count: 3), .init(name: "피자", count: 1)]),
            Section(category: "아시안", items: [.init(name: "쌀국수", count: 4)]),
            Section(category: "일식", items: [.init(name: "돈가스", count: 5), .init(name: "우동", count: 4)])
        ]
    }
    
}
