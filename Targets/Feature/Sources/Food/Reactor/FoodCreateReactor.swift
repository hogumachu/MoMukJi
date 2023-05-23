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
    
    typealias Section = FoodCreateSection
    typealias Category = Domain.Category
    
    struct Dependency {
        let coordinator: AppCoordinator
        let foodUseCase: FoodUseCase
        let keywordUseCase: KeywordUseCase
        let category: Category
    }
    
    var initialState = State(
        keyword: nil,
        sections: []
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case updateKeyword(String?)
        case search(String?)
    }
    
    enum Mutation {
        case setKeyword(String)
        case setSections([Section])
    }
    
    struct State {
        var keyword: String?
        var sections: [Section]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateKeyword(let keyword):
            return .concat([
                .just(.setKeyword(keyword ?? "")),
                .just(.setSections(makeRecentKeywordSections(keyword: keyword)))
            ])
            
        case .search(let keyword):
            // TODO: - Rename (Search -> Create)
            let searchKeyword = keyword ?? (currentState.keyword ?? "")
            storeKeyword(keyword: searchKeyword)
            return .concat([
                .just(.setKeyword(searchKeyword)),
                .just(.setSections(makeRecentKeywordSections(keyword: searchKeyword)))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setKeyword(let keyword):
            newState.keyword = keyword
            
        case .setSections(let sections):
            newState.sections = sections
        }
        return newState
    }
    
}

extension FoodCreateReactor {
    
    private func makeRecentKeywordSections(keyword: String?) -> [Section] {
        let keywords = dependency.keywordUseCase.fetchKeywordList(keyword: keyword)
        return [Section(items: keywords)]
    }
    
    private func storeKeyword(keyword: String) {
        dependency.keywordUseCase.store(keyword: keyword)
    }
    
    
}
