//
//  BaseViewController.swift
//  Feature
//
//  Created by 홍성준 on 2023/05/18.
//

import UserInterface
import UIKit

import RxSwift
import ReactorKit

class BaseViewController<ReactorType: Reactor>: UIViewController, View {
    
    typealias Reactor = ReactorType
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttributes()
    }
    
    // MARK: - Methods
    
    func bind(reactor: ReactorType) {}
    func setupLayout() {}
    func setupAttributes() {}
    
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
}
