//
//  EntryViewController.swift
//  TodoApp1
//
//  Created by 野澤拓己 on 2020/11/20.
//

import UIKit

class EntryViewController: UIViewController {
    
    public var updateHandler: (() -> Void)?
    
    private let field: UITextField = {
       let field = UITextField()
        field.returnKeyType = .done
        
        field.backgroundColor = .systemBackground
        field.layer.cornerRadius = 65/2
        field.placeholder = "Write a new task"
        
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.borderWidth = 0.5
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(field)
        field.delegate = self
        configureNavigationView()
    }
    
    // MARK:- configure
    private func configureNavigationView() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
    }
    
    @objc private func didTapSave() {
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        // 入力したtodoとcountを同時につける
        // この場合、新規に追加するので最新のcountにを呼び出している
        guard let count = UserDefaults.standard.value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count + 1
        
        // データの保存
        UserDefaults.standard.set(newCount, forKey: "count")
        UserDefaults.standard.set(text, forKey: "task_\(newCount)")
        
        updateHandler?()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- configure
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        field.frame = CGRect(
            x: 20,
            y: navBarHeight! + 20,
            width: view.frame.size.width - 40,
            height: 65
        )
    }
}

extension EntryViewController : UITextFieldDelegate {
    // テキストフィールドを閉じたとき（エンターを押したとき）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        didTapSave()
        
        return true
    }
}
