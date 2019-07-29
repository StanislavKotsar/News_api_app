//
//  NewsTableViewCell.swift
//  tochka_test
//
//  Created by Станислав Коцарь on 28/07/2019.
//  Copyright © 2019 Станислав Коцарь. All rights reserved.
//

import UIKit

protocol NewsTableViewCellDelegate: class {
    func didTappOnImageButton(cell: UITableViewCell)
}

class NewsTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageButton = UIButton()
    weak var delegate: NewsTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
            ])
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            ])
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        imageButton.setTitle("Go to article image", for: .normal)
        imageButton.backgroundColor = .gray
        imageButton.addTarget(self, action: #selector(didTappedOnImageButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            imageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            ])
    }
    
    @objc func didTappedOnImageButton(sender: UIButton) {
        delegate?.didTappOnImageButton(cell: self)
    }

}
