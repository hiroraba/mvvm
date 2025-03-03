//
//  TodoDetailViewController.swift
//  mvvm
//
//  Created by hiroraba on 2025/02/21.
//

import UIKit
import RxSwift
import RxCocoa

final class TodoDetailViewController: UIViewController {
    private let viewModel: TodoDetailViewModel
    private let disposeBag = DisposeBag()
    
    // UIコンポーネント
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "タイトルを入力"
        return tf
    }()
    
    private let isCompletedSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    init(viewModel: TodoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // Storyboard 経由で生成されない前提のため
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Todo詳細"
        setupNavigationBar()
        setupUI()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        // ナビゲーションバー右側に「保存」ボタンを配置
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        navigationItem.rightBarButtonItem = saveButton
        
        // 保存ボタンタップ時に viewModel.saveChanges() を呼び出し、完了時に前画面へ戻る
        saveButton.rx.tap
            .flatMapLatest { [weak self] _ -> Completable in
                guard let self = self else { return Completable.empty() }
                return self.viewModel.saveChanges()
                    .observe(on: MainScheduler.instance)  // MainSchedulerで実行するよう指定
            }
            .subscribe(onCompleted: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

    }
    
    private func setupUI() {
        // UIコンポーネントの追加と簡易レイアウト
        view.addSubview(titleTextField)
        view.addSubview(isCompletedSwitch)
        
        titleTextField.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 40)
        isCompletedSwitch.frame = CGRect(x: 20, y: 160, width: 0, height: 0)
    }
    
    private func bindViewModel() {
        // 初期値の設定
        titleTextField.text = viewModel.todo.title
        isCompletedSwitch.isOn = viewModel.todo.isCompleted
        
        // ユーザ入力を viewModel の Relay にバインド
        titleTextField.rx.text.orEmpty
            .skip(1)  // 初期値をスキップ
            .bind(to: viewModel.titleRelay)
            .disposed(by: disposeBag)
        
        isCompletedSwitch.rx.value
            .skip(1)
            .bind(to: viewModel.isCompletedRelay)
            .disposed(by: disposeBag)
    }
}
