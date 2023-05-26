//
//  StatisticsReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/26.
//

import Core
import Domain
import Foundation
import ReactorKit
import RxSwift

final class StatisticsReactor: Reactor {
    
    var initialState: State = State(
        habitChartModel: nil,
        categoryChartModel: nil
    )
    private let dependency: Dependency
    
    struct Dependency {
        let coordinator: AppCoordinator
        let categoryUseCase: CategoryUseCase
        let foodUseCase: FoodUseCase
    }
    
    enum Action {
        case refresh
        case navigationLeftButtonTap
    }
    
    enum Mutation {
        case setHabitChartModel(ChartModel)
        case setCategoryChartModel(ChartModel)
    }
    
    struct State {
        var habitChartModel: ChartModel?
        var categoryChartModel: ChartModel?
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setHabitChartModel(fetchHabitChartModel())),
                .just(.setCategoryChartModel(fetchCategoryChartModel()))
            ])
        case .navigationLeftButtonTap:
            dependency.coordinator.close(using: .dismiss, animated: true, completion: nil)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setHabitChartModel(let model):
            newState.habitChartModel = model
            
        case .setCategoryChartModel(let model):
            newState.categoryChartModel = model
        }
        
        return newState
    }
    
}

extension StatisticsReactor {
    
    private func fetchHabitChartModel() -> ChartModel {
        return ChartModel(
            charts: [
                ("아침", 7),
                ("점심", 3),
                ("저녁", 4),
                ("야식", 7)
            ],
            description: "아침, 야식에 비해 점심, 저녁을 먹는 횟수가 적어요!\n더 균형 있는 식사 습관이 필요해요! \n야식 먹는 횟수가 너무 많은 것 같아요!"
        )
    }
    
    private func fetchCategoryChartModel() -> ChartModel {
        return ChartModel(
            charts: [
                ("김치찌개", 7),
                ("초밥", 7),
                ("비비큐 황금 올리브", 4),
                ("스테이크", 3)
            ],
            description: "김치찌개, 초밥 을(를) 자주 먹었어요!"
        )
    }
    
}
