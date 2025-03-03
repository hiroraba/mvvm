//
//  FetchTodoUseCase.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import RxSwift

final class FetchTodosUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<[Todo]> {
        return repository.fetchTodos()
    }
}
