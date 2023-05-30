//
//  FoodDetailReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/29.
//

import Domain
import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class FoodDetailReactor: Reactor {
    
    typealias Category = Domain.Category
    
    struct Dependency {
        let coordinator: AppCoordinator
        let food: Food
        let foodUseCase: FoodUseCase
    }
    
    var initialState: State
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.initialState = State(
            food: dependency.food,
            isFavorite: dependency.food.isFavorite
        )
    }
    
    enum Action {
        case refresh
        case navigationLeftButtonTap
        case navigationRightButtonTap(Bool?)
        case foldableButtonTap(MealtimeSlot)
        case likeButtonTap
        case dislikeButtonTap
    }
    
    enum Mutation {
        case setFavorite(Bool?)
        case setFavoriteTitle(String)
        case setMealtimeTitle(String)
        case setBreakfast(MealtimeFoldableViewModel)
        case setLunch(MealtimeFoldableViewModel)
        case setDinner(MealtimeFoldableViewModel)
        case setMidnightSnack (MealtimeFoldableViewModel)
    }
    
    struct State {
        var food: Food
        var isFavorite: Bool?
        var favoriteTitle: String?
        var mealtimeTitle: String?
        var breakfast: MealtimeFoldableViewModel?
        var lunch: MealtimeFoldableViewModel?
        var dinner: MealtimeFoldableViewModel?
        var midnightSnack: MealtimeFoldableViewModel?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let food = currentState.food
            let favoriteTitle = "\(food.name), 좋아하시나요?"
            let mealtimeTitle = currentState.isFavorite != nil ? "\(food.name), 이럴 때 즐기셨어요!" : "이럴 때 즐기셨어요!"
            let breakfast = makeMealtimeFoldableViewModel(food: food, slot: .breakfast)
            let lunch = makeMealtimeFoldableViewModel(food: food, slot: .lunch)
            let dinner = makeMealtimeFoldableViewModel(food: food, slot: .dinner)
            let midnightSnack = makeMealtimeFoldableViewModel(food: food, slot: .midnightSnack)
            return .concat([
                .just(.setFavoriteTitle(favoriteTitle)),
                .just(.setMealtimeTitle(mealtimeTitle)),
                .just(.setBreakfast(breakfast)),
                .just(.setLunch(lunch)),
                .just(.setDinner(dinner)),
                .just(.setMidnightSnack(midnightSnack))
            ])
            
        case .navigationLeftButtonTap:
            let food = makeCurrentFood()
            if isChanged == false {
                dependency.coordinator.close(using: .pop, animated: true, completion: nil)
                return .empty()
            }
            do {
                try dependency.foodUseCase.update(food: food)
                ToastHelper.showSuccess(message: "성공적으로 변경되었어요!")
                dependency.coordinator.close(using: .pop, animated: true) { [weak self] in
                    self?.dependency.coordinator.refresh()
                }
            } catch {
                ToastHelper.showFail(message: "변경에 실패했어요")
                dependency.coordinator.close(using: .pop, animated: true, completion: nil)
            }
            return .empty()
            
        case .navigationRightButtonTap(let isFavorite):
            guard let isFavorite else {
                return .empty()
            }
            return .just(.setFavorite(!isFavorite))
            
        case .foldableButtonTap(let slot):
            let model = makeToggledMealtimeFoldableViewModel(food: dependency.food, slot: slot)
            switch slot {
            case .breakfast: return .just(.setBreakfast(model))
            case .lunch: return .just(.setLunch(model))
            case .dinner: return .just(.setDinner(model))
            case .midnightSnack: return .just(.setMidnightSnack(model))
            }
            
        case .likeButtonTap:
            let mealtimeTitle = "\(dependency.food.name), 이럴 때 즐기셨어요!"
            return .concat([
                .just(.setMealtimeTitle(mealtimeTitle)),
                .just(.setFavorite(true))
            ])
            
        case .dislikeButtonTap:
            let mealtimeTitle = "\(dependency.food.name), 이럴 때 즐기셨어요!"
            return .concat([
                .just(.setMealtimeTitle(mealtimeTitle)),
                .just(.setFavorite(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setFavorite(let isFavorite):
            newState.isFavorite = isFavorite
            
        case .setFavoriteTitle(let title):
            newState.favoriteTitle = title
            
        case .setMealtimeTitle(let title):
            newState.mealtimeTitle = title
            
        case .setBreakfast(let model):
            newState.breakfast = model
            
        case .setLunch(let model):
            newState.lunch = model
            
        case .setDinner(let model):
            newState.dinner = model
            
        case .setMidnightSnack(let model):
            newState.midnightSnack = model
            
        }
        return newState
    }
    
}

extension FoodDetailReactor {
    
    private var isChanged: Bool {
        return currentState.food.isFavorite != currentState.isFavorite
    }
    
    private func makeMealtimeFoldableViewModel(food: Food, slot: MealtimeSlot, isFolded: Bool = true) -> MealtimeFoldableViewModel {
        let mealtimes = food.mealtimes.filter { $0.slot == slot }
        let title = slot.title
        let subtitle = "\(mealtimes.count)회"
        let times = mealtimes.map { mealtime -> String in
            return "\(mealtime.year)년 \(mealtime.month)월 \(mealtime.day)일"
        }
        return MealtimeFoldableViewModel(title: title, subtitle: subtitle, times: times, isFolded: isFolded)
    }
    
    private func makeToggledMealtimeFoldableViewModel(food: Food, slot: MealtimeSlot) -> MealtimeFoldableViewModel {
        let isFolded: Bool = {
            switch slot {
            case .breakfast: return !(currentState.breakfast?.isFolded ?? false)
            case .lunch: return !(currentState.lunch?.isFolded ?? false)
            case .dinner: return !(currentState.dinner?.isFolded ?? false)
            case .midnightSnack: return !(currentState.midnightSnack?.isFolded ?? false)
            }
        }()
        return makeMealtimeFoldableViewModel(food: food, slot: slot, isFolded: isFolded)
    }
    
    private func makeCurrentFood() -> Food {
        return Food(
            name: currentState.food.name,
            category: currentState.food.category,
            mealtimes: currentState.food.mealtimes,
            isFavorite: currentState.isFavorite
        )
    }
    
}

private extension MealtimeSlot {
    
    var title: String {
        switch self {
        case .breakfast: return "아침"
        case .lunch: return "점심"
        case .dinner: return "저녁"
        case .midnightSnack: return "야식"
        }
    }
    
}
