//
//  TodoListViewModel.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import RxSwift
import RxCocoa
import Foundation

final class TodoListViewModel {
    let todos = BehaviorRelay<[Todo]>(value: [])

    private let fetchTodosUseCase: FetchTodosUseCase
    private let saveTodoUseCase: SaveTodoUseCase
    private let deleteTodoUseCase: DeleteTodoUseCase
    private let disposeBag = DisposeBag()

    init(fetchTodosUseCase: FetchTodosUseCase, saveTodoUseCase: SaveTodoUseCase, deleteTodoUseCase: DeleteTodoUseCase) {
        self.fetchTodosUseCase = fetchTodosUseCase
        self.saveTodoUseCase = saveTodoUseCase
        self.deleteTodoUseCase = deleteTodoUseCase
        fetchTodos()
    }

    /// TODO一覧を取得
    func fetchTodos() {
        fetchTodosUseCase.execute()
            .subscribe(onNext: { [weak self] todos in
                self?.todos.accept(todos)
            })
            .disposed(by: disposeBag)
    }

    /// 新しい TODO を追加
    func addTodo(title: String) {
        let newTodo = Todo(id: UUID().uuidString, title: title, isCompleted: false)
        saveTodoUseCase.execute(todo: newTodo)
            .subscribe(onCompleted: { [weak self] in
                self?.fetchTodos() // 追加後に再取得
            })
            .disposed(by: disposeBag)
    }

    /// TODOを削除
    func deleteTodo(at index: Int) {
        let todo = todos.value[index]
        deleteTodoUseCase.execute(todo: todo)
            .subscribe(onCompleted: { [weak self] in
                self?.fetchTodos()
            })
            .disposed(by: disposeBag)
    }
}
