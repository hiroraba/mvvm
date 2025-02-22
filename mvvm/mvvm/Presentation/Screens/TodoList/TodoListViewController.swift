//
//  TodoListViewController.swift
//  mvvm
//
//  Created by 松尾宏規 on 2025/02/21.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel: TodoListViewModel
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()

    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        setupNavigationBar()
        
        tableView.frame = view.bounds
        view.addSubview(tableView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupUI() {
        view.backgroundColor = .white

        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        // ナビゲーションバーのタイトル
        title = "TODO一覧"
            
        // ナビゲーションバーの右側に「追加」ボタンを配置
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
            navigationItem.rightBarButtonItem = addButton
            
        // RxSwiftでタップイベントをハンドルする
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                // 新しいTODOを追加
                self?.viewModel.addTodo(title: "新しいTODO")
            }).disposed(by: disposeBag)
        }
        
    private func bindViewModel() {
        viewModel.todos
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, todo, cell in
                cell.textLabel?.text = todo.title
            }
            .disposed(by: disposeBag)

        // セル削除
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.deleteTodo(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.todos.value[indexPath.row].title
        return cell
    }
}
