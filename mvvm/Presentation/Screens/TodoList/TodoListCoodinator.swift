//
//  TodoListCoodinator.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import UIKit

final class TodoListCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = TodoRepositoryImpl()
        
        let fetchTodosUseCase = FetchTodosUseCase(repository: repository)
        let deleteTodoUseCase = DeleteTodoUseCase(repository: repository)
        let saveTodoUseCase = SaveTodoUseCase(repository: repository)
        
        let viewModel = TodoListViewModel(fetchTodosUseCase: fetchTodosUseCase, saveTodoUseCase: saveTodoUseCase, deleteTodoUseCase: deleteTodoUseCase)
        let viewController = TodoListViewController(viewModel: viewModel)
        
        viewController.didSelectTodo = { [weak self] todo in
            guard let self = self else { return }
            let detailCoordinator = TodoDetailCoordinator(navigationController: self.navigationController, todo: todo, repository: repository)
            detailCoordinator.start()
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
