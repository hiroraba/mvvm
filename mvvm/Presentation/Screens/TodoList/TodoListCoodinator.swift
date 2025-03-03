//
//  TodoListCoodinator.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import UIKit

final class TodoListCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = TodoRepositoryImpl()
        let viewModel = TodoListViewModel(repository: repository)
        let viewController = TodoListViewController(viewModel: viewModel)
        
        // セル選択時の処理で TodoDetail へ遷移
        viewController.didSelectTodo = { [weak self] todo in
            guard let self = self else { return }
            let detailCoordinator = TodoDetailCoordinator(navigationController: self.navigationController, todo: todo)
            detailCoordinator.start()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
