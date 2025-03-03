//
//  TodoDetailViewModel.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import RxSwift
import RxCocoa

final class TodoDetailViewModel {
    private(set) var todo: Todo
    let titleRelay: BehaviorRelay<String>
    let isCompletedRelay: BehaviorRelay<Bool>
    
    private let updateTodoUseCase: UpdateTodoUseCase
    private let disposeBag = DisposeBag()
    
    init(todo: Todo, updateTodoUseCase: UpdateTodoUseCase) {
        self.todo = todo
        self.updateTodoUseCase = updateTodoUseCase
        self.titleRelay = BehaviorRelay(value: todo.title)
        self.isCompletedRelay = BehaviorRelay(value: todo.isCompleted)
    }
    
    /// Todo を更新
    func saveChanges() -> Completable {
        let updatedTodo = Todo(id: todo.id,
                               title: titleRelay.value,
                               isCompleted: isCompletedRelay.value)
        return updateTodoUseCase.execute(todo: updatedTodo)
            .do(onCompleted: { [weak self] in
                self?.todo = updatedTodo
            })
    }
}
