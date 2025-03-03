//
//  TodoListViewModel.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import Foundation
import RxSwift
import RxCocoa

final class TodoListViewModel {
    private let repository: TodoRepository
    private let disposeBag = DisposeBag()

    let todos = BehaviorRelay<[Todo]>(value: [])

    init(repository: TodoRepository) {
        self.repository = repository
        fetchTodos()
    }

    /// TODO一覧を取得
    func fetchTodos() {
        repository.fetchTodos()
            .subscribe(onNext: { [weak self] todos in
                self?.todos.accept(todos)
            })
            .disposed(by: disposeBag)
    }

    /// TODOを追加
    func addTodo(title: String) {
        let newTodo = Todo(id: UUID().uuidString, title: title, isCompleted: false)
        repository.addTodo(newTodo)
            .subscribe(onCompleted: { [weak self] in
                self?.fetchTodos()
            })
            .disposed(by: disposeBag)
    }

    /// TODOを削除
    func deleteTodo(at index: Int) {
        let todo = todos.value[index]
        repository.deleteTodo(todo)
            .subscribe(onCompleted: { [weak self] in
                self?.fetchTodos()
            })
            .disposed(by: disposeBag)
    }
}
