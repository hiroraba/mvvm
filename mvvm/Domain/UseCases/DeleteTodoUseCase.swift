//
//  DeleteTodoUseCase.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import RxSwift

final class DeleteTodoUseCase {
    private let repository:TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(todo: Todo) -> Completable {
        return repository.deleteTodo(todo)
    }
}
