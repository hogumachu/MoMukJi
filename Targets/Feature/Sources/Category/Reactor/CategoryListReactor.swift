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
        case navigationLeftButtonTap
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
            guard let category = fetchCategory(item: item) else {
                return .empty()
            }
            
            dependency.coordinator.transition(to: .foodCreate(category), using: .push, animated: true, completion: nil)
            return .empty()
            
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
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
        let items = dependency.categoryUseCase.fetchCategoryList(request: CategoryRequest())
            .map { Item(name: $0.name, textColor: $0.textColor, backgroundColor: $0.backgroundColor) }
        return [Section(items: items)]
    }
    
    private func fetchCategory(item: CategoryItem) -> Category? {
        let category = dependency.categoryUseCase.fetchCategoryList(request: CategoryRequest(category: item.name)).first
        return category
    }
    
}
