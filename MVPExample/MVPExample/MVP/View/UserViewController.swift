//
//  ViewController.swift
//  MVPExample
//
//  Created by Piotr Wesołowski on 23/01/2023.
//

import UIKit

class UserViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var users = [User]()
    
    private let presenter = UserPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User"
        
        // Table
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Presenter
        presenter.setViewDelegate(delegate: self)
        presenter.getUsers()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTap(user: users[indexPath.row])
    }
}

extension UserViewController: UserPresenterDelegate {
    func presentUser(users: [User]) {
        self.users = users
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
