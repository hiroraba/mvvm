//
//  TodoRepository.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import Foundation
import RxSwift

protocol TodoRepository {
    func fetchTodos() -> Observable<[Todo]>
    func addTodo(_ todo: Todo) -> Completable
    func updateTodo(_ todo: Todo) -> Completable
    func deleteTodo(_ todo: Todo) -> Completable
}
