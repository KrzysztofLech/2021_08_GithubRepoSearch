//
//  ListItemTableViewCell.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit
import SnapKit

final class ListItemTableViewCell: UITableViewCell {
    
    // MARK: - Constants -
    
    private enum Constants {
        static let containerPadding: CGFloat = 20
        static let innerPadding: CGFloat = 8
        static let height: CGFloat = 60
    }
    
    // MARK: - UI Components -
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.cellBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor =  AppColor.cellContent
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor =  AppColor.cellContent
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // MARK: - Layout -
    
    private func defineLayout() {
        addContainerView()
        addNameLabel()
        addDescriptionLabel()
    }
    
    private func addContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.equalTo(Constants.containerPadding)
            make.right.equalTo(-Constants.containerPadding)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.height)
        }
    }
    
    private func addNameLabel() {
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalTo(Constants.containerPadding)
            make.right.equalTo(-Constants.containerPadding)
        }
    }
    
    private func addDescriptionLabel() {
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.innerPadding)
            make.left.equalTo(Constants.containerPadding)
            make.right.bottom.equalTo(-Constants.containerPadding)
        }
    }
    
    // MARK: - Public methods -
    
    func configure(withName text: String, andDescription description: String?) {
        nameLabel.text = text
        descriptionLabel.text = description
    }
}
