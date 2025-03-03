//
//  TodoDetailCoodinator.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import UIKit

final class TodoDetailCoordinator {
    private let navigationController: UINavigationController
    private let todo: Todo

    init(navigationController: UINavigationController, todo: Todo) {
        self.navigationController = navigationController
        self.todo = todo
    }
    
    func start() {
        // Repository のインスタンスは TodoRepositoryImpl などから生成する
        let repository = TodoRepositoryImpl()
        let viewModel = TodoDetailViewModel(todo: todo, repository: repository)
        let viewController = TodoDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
