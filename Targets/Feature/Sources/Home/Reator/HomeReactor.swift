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
    typealias Item = HomeItem
    
    var initialState = State(sections: [])
    private let dependency: Dependency
    
    struct Dependency {
        let coordinator: AppCoordinator
        let foodUseCase: FoodUseCase
        let timeHelper: FoodTimeHelper
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
            let foods = fetchFoodList()
            let sections = makeSections(foods: foods)
            return .just(.setSections(sections))
            
        case .addButtonTap:
            dependency.coordinator.transition(to: .categoryList, using: .modal, animated: true, completion: nil)
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
            .fetchFoodList(request: FoodRequest(category: nil))
    }
    
    private func makeSections(foods: [Food]) -> [Section] {
        return makeTimeSection(foods: foods) + makeFoodSection(foods: foods)
    }
    
    private func makeFoodSection(foods: [Food]) -> [Section] {
        let items = foods.map { food -> Item in
            return .food(.init(name: food.name, count: food.time?.count ?? 0, category: food.category))
        }
        if items.isEmpty {
            return []
        }
        return [.food([.title("최근에 먹은 음식")] + items.prefix(20))]
    }
    
    private func makeTimeSection(foods: [Food]) -> [Section] {
        let timeEnum = dependency.timeHelper.currentTimeEnum()
        let items: [Item] = {
            return foods.filter { $0.filter(using: timeEnum) }
                .sorted(by: timeEnum.sort)
                .prefix(8)
                .map { $0.item(using: timeEnum) }
        }()
        
        if items.isEmpty {
            return []
        }
        return [.food([.title(timeEnum.title)] + items)]
    }
    
}

private extension FoodTimeEnum {
    
    var title: String {
        switch self {
        case .morning: return "아침으로 자주 먹었어요"
        case .lunch: return "점심으로 자주 먹었어요"
        case .dinner: return "저녁으로 자주 먹었어요"
        case .midnightSnack: return "야식으로 자주 먹었어요"
        }
    }
    
    func sort(_ lhs: Food, _ rhs: Food) -> Bool {
        switch self {
        case .morning: return (lhs.time?.morningCount ?? 0) > (rhs.time?.morningCount ?? 0)
        case .lunch: return (lhs.time?.lunchCount ?? 0) > (rhs.time?.lunchCount ?? 0)
        case .dinner: return (lhs.time?.dinnerCount ?? 0) > (rhs.time?.dinnerCount ?? 0)
        case .midnightSnack: return (lhs.time?.midnightSnackCount ?? 0) > (rhs.time?.midnightSnackCount ?? 0)
        }
    }
    
}

private extension Food {
    
    var totalCount: Int {
        return (time?.morningCount ?? 0) + (time?.lunchCount ?? 0) + (time?.dinnerCount ?? 0) + (time?.midnightSnackCount ?? 0)
    }
    
    func filter(using timeEnum: FoodTimeEnum) -> Bool {
        switch timeEnum {
        case .morning:
            guard let morning = time?.morningCount else { return false }
            return morning > 0
            
        case .lunch:
            guard let lunch = time?.lunchCount else { return false }
            return lunch > 0
            
        case .dinner:
            guard let dinner = time?.dinnerCount else { return false }
            return dinner > 0
            
        case .midnightSnack:
            guard let midnightSnack = time?.midnightSnackCount else { return false }
            return midnightSnack > 0
        }
    }
    
    func item(using timeEnum: FoodTimeEnum) -> HomeItem {
        let count: Int = {
            switch timeEnum {
            case .morning: return time?.morningCount ?? 0
            case .lunch: return time?.lunchCount ?? 0
            case .dinner: return time?.dinnerCount ?? 0
            case .midnightSnack: return time?.midnightSnackCount ?? 0
            }
        }()
        
        return .time(.init(
            name: name,
            count: count,
            totalCount: totalCount,
            category: category
        ))
    }
    
}
