//
//  ViewController.swift
//  TodoApp1
//
//  Created by 野澤拓己 on 2020/11/19.
//

import UIKit




class ViewController: UIViewController {
    
    var tasks = [String]()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Task"
        configureTableView()
        configureNavigationView()
        setUpUserdefaults()
        
        updateTasks()
    }
    
    // MARK: - setUpUserdefaults
    public func setUpUserdefaults() {
        
        // setupが作られていなかったら作成してカウントをゼロに
        if !UserDefaults.standard.bool(forKey: "setup") {
            
            UserDefaults.standard.set(true, forKey: "setup")
            UserDefaults.standard.set(0, forKey: "count")
        }
        
    }
    
    public func updateTasks() {
        
        tasks.removeAll()
        
        // countを呼び出す
        guard let count = UserDefaults.standard.value(forKey: "count") as? Int else {
            return
        }
        
        for i in 0..<count {
            
            if let task = UserDefaults.standard.value(forKey: "task_\(i+1)") as? String {
                
                tasks.append(task)
                
            }
        }
        
        tableView.reloadData()
        
    }
    
    // MARK:- configure
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    private func configureNavigationView() {
        navigationItem.rightBarButtonItem = .init(
            title: "Add",
            style: .done,
            target: self,
            action: #selector(didTapAdd)
        )
    }
    
    @objc private func didTapAdd() {
        let vc = EntryViewController()
        
        vc.title = "New task"
        vc.updateHandler = {
            
            DispatchQueue.main.async {
                
                self.updateTasks()
                
            }
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
}

