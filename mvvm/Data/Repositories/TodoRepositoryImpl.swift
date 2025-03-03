//
//  TodoRepositoryImpl.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import Foundation
import RealmSwift
import RxSwift

final class TodoRepositoryImpl: TodoRepository {
    private let realm: Realm

    init() {
        realm = try! Realm() // 簡略化のためエラーハンドリング省略
    }

    func fetchTodos() -> Observable<[Todo]> {
        let todos = realm.objects(TodoRealmModel.self).map { $0.toTodo() }
        return Observable.just(Array(todos))
    }

    func addTodo(_ todo: Todo) -> Completable {
        return Completable.create { [weak self] completable in
            do {
                try self?.realm.write {
                    self?.realm.add(TodoRealmModel(id: todo.id, title: todo.title, isCompleted: todo.isCompleted))
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    func updateTodo(_ todo: Todo) -> Completable {
        return Completable.create { [weak self] completable in
            guard let existingTodo = self?.realm.object(ofType: TodoRealmModel.self, forPrimaryKey: todo.id) else {
                completable(.error(NSError(domain: "Todo Not Found", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            do {
                try self?.realm.write {
                    existingTodo.title = todo.title
                    existingTodo.isCompleted = todo.isCompleted
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }

    func deleteTodo(_ todo: Todo) -> Completable {
        return Completable.create { [weak self] completable in
            guard let existingTodo = self?.realm.object(ofType: TodoRealmModel.self, forPrimaryKey: todo.id) else {
                completable(.error(NSError(domain: "Todo Not Found", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            do {
                try self?.realm.write {
                    self?.realm.delete(existingTodo)
                }
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
