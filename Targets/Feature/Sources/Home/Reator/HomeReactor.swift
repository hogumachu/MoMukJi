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
        let timeHelper: MealtimeHelper
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
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
            let foods = fetchFoodList()
            let sections = makeSections(foods: foods)
            return .just(.setSections(sections))
            
        case .addButtonTap:
            dependency.coordinator.transition(to: .categoryList, using: .modal, animated: true, completion: nil)
            return .empty()
            
        case .itemSelected(let item):
            switch item {
            case .title:
                return .empty()
                
            case .food(let model):
                guard let food = dependency.foodUseCase.fetchFoodList(request: .init(name: model.name)).first else { return .empty() }
                dependency.coordinator.transition(to: .foodDetail(food), using: .push, animated: true, completion: nil)
                return .empty()
                
            case .time(let model):
                guard let food = dependency.foodUseCase.fetchFoodList(request: .init(name: model.name)).first else { return .empty() }
                dependency.coordinator.transition(to: .foodDetail(food), using: .push, animated: true, completion: nil)
                return .empty()
            }
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
            return .food(.init(name: food.name, count: food.mealtimes.count, category: food.category))
        }
        if items.isEmpty {
            return []
        }
        return [.food([.title("최근에 먹은 음식")] + items.prefix(20))]
    }
    
    private func makeTimeSection(foods: [Food]) -> [Section] {
        let slot = dependency.timeHelper.currentMealtimeSlot()
        let items: [Item] = {
            return foods.filter { $0.mealtimes.contains(where: { $0.slot == slot }) }
                .sorted(by: slot.sort)
                .prefix(8)
                .map { $0.timeItem(using: slot) }
        }()
        
        if items.isEmpty {
            return []
        }
        return [.food([.title(slot.title)] + items)]
    }
    
}

private extension MealtimeSlot {

    var title: String {
        switch self {
        case .breakfast: return "아침으로 자주 먹었어요"
        case .lunch: return "점심으로 자주 먹었어요"
        case .dinner: return "저녁으로 자주 먹었어요"
        case .midnightSnack: return "야식으로 자주 먹었어요"
        }
    }
    
    func sort(_ lhs: Food, _ rhs: Food) -> Bool {
        let lhsMealCount = lhs.mealtimes.filter { $0.slot == self }.count
        let rhsMealCount = rhs.mealtimes.filter { $0.slot == self }.count
        return lhsMealCount > rhsMealCount
    }

}

private extension Food {
    
    func timeItem(using slot: MealtimeSlot) -> HomeItem {
        let count = mealtimes.filter { $0.slot == slot }.count
        return HomeItem.time(.init(
            name: name,
            count: count,
            totalCount: mealtimes.count,
            category: category
        ))
    }
    
}
