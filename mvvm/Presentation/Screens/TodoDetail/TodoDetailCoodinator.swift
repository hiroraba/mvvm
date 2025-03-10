//
//  TodoDetailCoodinator.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import UIKit

final class TodoDetailCoordinator {
    private let navigationController: UINavigationController
    private let todo: Todo
    private let repository: TodoRepository

    init(navigationController: UINavigationController, todo: Todo, repository: TodoRepository) {
        self.navigationController = navigationController
        self.todo = todo
        self.repository = repository
    }

    func start() {
        let updateTodoUseCase = UpdateTodoUseCase(repository: repository)
        let viewModel = TodoDetailViewModel(todo: todo, updateTodoUseCase: updateTodoUseCase)
        let viewController = TodoDetailViewController(viewModel: viewModel)

        navigationController.pushViewController(viewController, animated: true)
    }
}
