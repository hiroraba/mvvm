//
//  TodoRealmModel.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import RealmSwift

class TodoRealmModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var isCompleted: Bool

    convenience init(id: String, title: String, isCompleted: Bool) {
        self.init()
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }

    func toTodo() -> Todo {
        return Todo(id: id, title: title, isCompleted: isCompleted)
    }
}
