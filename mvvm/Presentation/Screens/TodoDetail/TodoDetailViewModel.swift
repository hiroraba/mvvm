//
//  TodoDetailViewModel.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import RxSwift
import RxCocoa

final class TodoDetailViewModel {
    private(set) var todo: Todo
    let titleRelay: BehaviorRelay<String>
    let isCompletedRelay: BehaviorRelay<Bool>
    
    private let repository: TodoRepository
    private let disposeBag = DisposeBag()
    
    init(todo: Todo, repository: TodoRepository) {
        self.todo = todo
        self.repository = repository
        self.titleRelay = BehaviorRelay(value: todo.title)
        self.isCompletedRelay = BehaviorRelay(value: todo.isCompleted)
    }
    
    /// 保存処理を実行し、保存完了時に onCompleted を発行する Completable を返す
    func saveChanges() -> Completable {
        let updatedTodo = Todo(id: todo.id,
                               title: titleRelay.value,
                               isCompleted: isCompletedRelay.value)
        return repository.updateTodo(updatedTodo)
            .do(onCompleted: { [weak self] in
                self?.todo = updatedTodo
                print("Todoが更新されました")
            })
    }
}
