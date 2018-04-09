//
//  UsersViewController.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit
import SVProgressHUD

// MARK: - Implementation

class UsersViewController: UIViewController, UsersPresenterOutput {
    @IBOutlet weak var usersTableView: UITableView!
    
    fileprivate var presenter: UsersPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserDataTableView()
        setupNavigationBar()
        presenter.handleViewIsReady()
    }
    
    // MARK: - Setup UI
    
    private func setupUserDataTableView() {
        usersTableView.separatorColor = .gray
        usersTableView.tableFooterView = UIView(frame: .zero)
        usersTableView.rowHeight = UITableViewAutomaticDimension
        
        usersTableView.register(UsersTableViewCell.nib(), forCellReuseIdentifier: UsersTableViewCell.reuseIdentifier())
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshButtonDidTap(sender:)))
    }
    
    // MARK: - Actions
    
    @objc func onRefreshButtonDidTap(sender: Any) {
        SVProgressHUD.show()
        presenter.loadUsers()
    }
    
    // MARK: - UsersPresenterOutput
    
    func handleDataUpdate() {
        SVProgressHUD.dismiss()
        
        usersTableView.reloadData()
    }
}

extension UsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.reuseIdentifier()) as? UsersTableViewCell,
            let viewModel = presenter.viewModels[safe: indexPath.row]
        else { return UITableViewCell() }
        
        cell.populate(with: viewModel)
        
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = presenter.viewModels[safe: indexPath.row] {
            presenter.handleSelectedViewModel(viewModel)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == presenter.viewModels.count - 1 {
            SVProgressHUD.show()
            presenter.loadNextUsers()
        }
    }
}

// MARK: - Factory

final class UsersViewControllerFactory {
    static func new(
        presenter: UsersPresenter
    ) -> UsersViewController {
        let controller = UIStoryboard.instantiateViewController(type: .users) as! UsersViewController
        controller.presenter = presenter
        presenter.output = controller
        return controller
    }
}
