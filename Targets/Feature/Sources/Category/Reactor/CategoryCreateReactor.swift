//
//  CategoryCreateReactor.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/21.
//

import Core
import Domain
import Service
import ReactorKit

final class CategoryCreateReactor: Reactor {
    
    enum ColorState {
        case backgrond
        case label
    }
    
    
    struct Dependency {
        
    }
    
    var initialState = State(
        category: nil,
        backgroundHexColor: "#EEEEEE",
        labelHexColor: "#000000",
        colorState: .backgrond
    )
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case updateCategory(String?)
        case selectedHexColor(String)
        case backgroundColorChangeButtonTap
        case labelColorChangeButton
    }
    
    enum Mutation {
        case setCategory(String?)
        case setHexColor(String)
        case setColorState(ColorState)
    }
    
    struct State {
        var category: String?
        var backgroundHexColor: String
        var labelHexColor: String
        var colorState: ColorState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateCategory(let category):
            return .just(.setCategory(category))
            
        case .selectedHexColor(let hexString):
            return .just(.setHexColor(hexString))
            
        case .backgroundColorChangeButtonTap:
            return .just(.setColorState(.backgrond))
            
        case .labelColorChangeButton:
            return .just(.setColorState(.label))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCategory(let category):
            newState.category = category
            
        case .setHexColor(let hexString):
            switch state.colorState {
            case .backgrond:
                newState.backgroundHexColor = hexString
                
            case .label:
                newState.labelHexColor = hexString
            }
            
        case .setColorState(let colorState):
            newState.colorState = colorState
        }
        return newState
    }
    
}
