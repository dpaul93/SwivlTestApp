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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
