//
//  TodoListCoodinator.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import UIKit

final class TodoListCoodinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    /// Todo一覧画面を起動する
    func start() {
        let repository = TodoRepositoryImpl()
        let viewModel = TodoListViewModel(repository: repository)
        let viewController = TodoListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    /// Todo詳細画面へ遷移する
    func showTodoDetail(todo: Todo) {
//        let detailCoordinator = TodoDetailCoordinator(navigationController: navigationController, todo: todo)
//        detailCoordinator.start()
    }
}
