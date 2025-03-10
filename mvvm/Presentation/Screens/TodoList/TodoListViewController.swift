//
//  TodoListViewController.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoListViewController: UIViewController {
    private let viewModel: TodoListViewModel
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()

    // セル選択時のアクション通知用クロージャ
    var didSelectTodo: ((Todo) -> Void)?

    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // Storyboard 経由では生成されない前提
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "TODO一覧"
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 画面が表示されるたびに最新のデータを取得して TableView を更新する
        viewModel.fetchTodos()
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton

        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.addTodo(title: "新しいTODO")
            })
            .disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func bindViewModel() {
        viewModel.todos
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, todo, cell in
                cell.textLabel?.text = todo.title
            }
            .disposed(by: disposeBag)

        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.deleteTodo(at: indexPath.row)
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Todo.self)
            .subscribe(onNext: { [weak self] todo in
                self?.didSelectTodo?(todo)
            })
            .disposed(by: disposeBag)
    }
}
