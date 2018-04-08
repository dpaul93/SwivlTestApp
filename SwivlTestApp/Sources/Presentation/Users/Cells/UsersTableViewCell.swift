//
//  UsersTableViewCell.swift
//  SwivlTestApp
//
//  Created by Pavlo Deynega on 08.04.18.
//Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit
import AlamofireImage

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileURL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupNameLabel()
        setupProfileURLLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupProfilePicImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profilePicImageView.af_cancelImageRequest()
        profilePicImageView.image = nil
        nameLabel.text = nil
        profileURL.text = nil
    }
    
    func populate(with viewModel: UsersTableViewCellViewModel) {
        viewModel.photoURL.map { profilePicImageView.af_setImage(withURL: $0) }
        nameLabel.text = viewModel.name
        profileURL.text = viewModel.profileURL
    }

    // MARK: - Setup UI
    
    private func setupNameLabel() {
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
    }

    private func setupProfileURLLabel() {
        profileURL.textColor = .black
        profileURL.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
    }
    
    private func setupProfilePicImageView() {
        profilePicImageView.layer.cornerRadius = profilePicImageView.bounds.height / 2
        profilePicImageView.layer.borderWidth = 1
        profilePicImageView.layer.borderColor = UIColor.gray.cgColor
        profilePicImageView.layer.masksToBounds = true
    }
}
