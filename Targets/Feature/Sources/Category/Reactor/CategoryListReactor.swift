//
//  CategoryListReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/22.
//

import Core
import Domain
import Service
import ReactorKit

final class CategoryListReactor: Reactor {
    
    typealias Section = CategorySection
    typealias Item = CategoryItem
    
    var initialState = State(
        sections: []
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    struct Dependency {
        let coordinator: AppCoordinator
        let categoryUseCase: CategoryUseCase
    }
    
    enum Action {
        case refresh
        case addButtonTap
        case itemSelected(Item)
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
            let sections = makeCategorySections()
            return .just(.setSections(sections))
            
        case .addButtonTap:
            dependency.coordinator.transition(to: .categoryCreate, using: .push, animated: true, completion: nil)
            return .empty()
            
        case .itemSelected(let item):
            let category = Category(name: item.name, textColor: item.textColor, backgroundColor: item.backgroundColor)
            dependency.coordinator.transition(to: .foodCreate(category), using: .push, animated: true, completion: nil)
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

extension CategoryListReactor {
    
    private func makeCategorySections() -> [Section] {
        let items = dependency.categoryUseCase.fetchCategoryList()
            .map { Item(name: $0.name, textColor: $0.textColor, backgroundColor: $0.backgroundColor) }
        return [Section(items: items)]
    }
    
}
