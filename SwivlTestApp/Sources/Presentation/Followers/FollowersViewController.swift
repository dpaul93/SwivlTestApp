//
//  FollowersViewController.swift
//  SwivlTestApp
//
//  Created Pavlo Deynega on 08.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit
import SVProgressHUD

// MARK: - Implementation

class FollowersViewController: UIViewController, FollowersPresenterOutput {
    @IBOutlet weak var followersTableView: UITableView!
    
    fileprivate var presenter: FollowersPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserDataTableView()
        setupNavigationBar()
        presenter.handleViewIsReady()
    }
    
    // MARK: - Setup UI
    
    private func setupUserDataTableView() {
        followersTableView.separatorColor = .gray
        followersTableView.tableFooterView = UIView(frame: .zero)
        followersTableView.rowHeight = UITableViewAutomaticDimension
        followersTableView.estimatedRowHeight = 116
        
        followersTableView.register(UsersTableViewCell.nib(), forCellReuseIdentifier: UsersTableViewCell.reuseIdentifier())
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshButtonDidTap(sender:)))
    }
    
    // MARK: - Actions
    
    @objc func onRefreshButtonDidTap(sender: Any) {
        SVProgressHUD.show()
        
        presenter.refreshFollowers()
    }
    
    // MARK: - UsersPresenterOutput
    
    func handleDataUpdate() {
        SVProgressHUD.dismiss()
        
        followersTableView.reloadData()
    }
}

extension FollowersViewController: UITableViewDataSource {
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

extension FollowersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = presenter.viewModels[safe: indexPath.row] {
            presenter.handleSelectedViewModel(viewModel)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Factory

final class FollowersViewControllerFactory {
    static func new(
        presenter: FollowersPresenter
    ) -> FollowersViewController {
        let controller = UIStoryboard.instantiateViewController(type: .followers) as! FollowersViewController
        controller.presenter = presenter
        presenter.output = controller
        return controller
    }
}
