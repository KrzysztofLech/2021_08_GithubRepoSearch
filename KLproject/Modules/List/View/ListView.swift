//
//  ListView.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit
import SnapKit

protocol ListViewDelegate: AnyObject {
    func didTypeSearchText(_ text: String)
}

final class ListView: UIView {
    
    weak var delegate: ListViewDelegate?
    
    var isDataPlaceholderHidden = true {
        willSet {
            tableView.backgroundView = newValue ? nil : noDataPlaceholderLabel
        }
    }
    
    // MARK: - UI Components -
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type text"
        textField.textColor = AppColor.text
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .search
        
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = AppColor.text
        button.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = AppColor.text
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = AppColor.background
        return tableView
    }()
    
    private let noDataPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.textColor =  AppColor.text
        label.text = "No data"
        return label
    }()

    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setup() {
        backgroundColor = AppColor.background
        
        searchTextField.addTarget(self, action: #selector(searchTextEditingChanged), for: .editingChanged)
        searchTextField.delegate = self
        
        refreshSearchButton()
        
        isDataPlaceholderHidden = false
    }
    
    // MARK: - Layout -
    
    private func defineLayout() {
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.snp_topMargin)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        
        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(searchTextField)
            make.left.equalTo(searchTextField.snp.right)
            make.right.equalToSuperview()
            make.width.equalTo(50)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }
    
    // MARK: - Actions -
    
    @objc private func didTapOnButton() {
        sendText()
    }
    
    @objc private func searchTextEditingChanged() {
        refreshSearchButton()
    }
    
    private func refreshSearchButton() {
        searchButton.isEnabled = searchTextField.text != ""
        searchButton.alpha = searchTextField.text != "" ? 1.0 : 0.3
    }
    
    private func sendText() {
        guard let text = searchTextField.text else { return }
        searchTextField.resignFirstResponder()
        delegate?.didTypeSearchText(text)
    }
    
    // MARK: - Public methods -
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        tableView.isHidden = show
    }
}

// MARK: - TextField delegate methods -

extension ListView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendText()
        return true
    }
}
