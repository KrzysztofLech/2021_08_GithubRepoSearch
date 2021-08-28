//
//  ListViewController.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func showAlert(title: String, message: String, errorHandler: @escaping () -> ())
}

final class ListViewController: UIViewController {
    
    // MARK: - Public properties -
    
    weak var delegate: ListViewControllerDelegate?
    
    // MARK: - Private properties -
    
    private let viewModel: ListViewModelProtocol
    private let contentView = ListView()
    
    // MARK: - Lifecycle -
    
    init(viewModel: ListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchData()
    }
    
    // MARK: - Setup view -
    
    private func setupView() {
        title = "Github repositories"
        navigationController?.navigationBar.barTintColor = AppColor.background
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: AppColor.text ?? UIColor.white]
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.isTranslucent = false
        
        contentView.delegate = self
    }
    
    // MARK: - Data methods -
    
    private func fetchData() {
        ///contentView.showActivityIndicator(true)
        
        viewModel.fetchData { [weak self] errorText in
            DispatchQueue.main.async {
                ///self?.contentView.showActivityIndicator(false)
                
                if let errorText = errorText {
                    self?.delegate?.showAlert(
                        title: "Data dwonloading problem!",
                        message: errorText,
                        errorHandler: {
                            self?.fetchData()
                        })
                } else {
                    print(self?.viewModel.repositoriesData.count)
                    ///self?.contentView.tableView.reloadData()
                }
            }
        }
    }
}

extension ListViewController: ListViewDelegate {
    func didTypeSearchText(_ text: String) {
        print(text)
    }
}
