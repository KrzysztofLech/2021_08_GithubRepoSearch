//
//  ListViewController.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func showAlert(title: String, message: String, errorHandler: @escaping () -> ())
    func didSelectListItem(_ itemData: GitHubRepoData)
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
        
        setupTitle()
        setupView()
    }
    
    // MARK: - Setup view -
    
    private func setupView() {
        navigationController?.navigationBar.barTintColor = AppColor.background
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: AppColor.text ?? UIColor.white]
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.isTranslucent = false
        
        contentView.delegate = self
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(
            ListItemTableViewCell.self,
            forCellReuseIdentifier: ListItemTableViewCell.className)

    }
    
    private func setupTitle() {
        title = viewModel.title
    }
    
    // MARK: - Data methods -
    
    private func fetchData(withPhrase phrase: String) {
        contentView.showActivityIndicator(true)
        
        viewModel.fetchData(withPhrase: phrase) { [weak self] errorText in
            DispatchQueue.main.async {
                self?.contentView.showActivityIndicator(false)
                
                if let errorText = errorText {
                    self?.delegate?.showAlert(
                        title: "Data dwonloading problem!",
                        message: errorText,
                        errorHandler: {
                            self?.fetchData(withPhrase: phrase)
                        })
                } else {
                    self?.setupTitle()
                    self?.presentData()
                }
            }
        }
    }
    
    private func presentData() {
        contentView.isDataPlaceholderHidden = !viewModel.repositoriesData.isEmpty
        contentView.tableView.reloadData()
    }
}

// MARK: - ListViewDelegate methods -

extension ListViewController: ListViewDelegate {
    func didTypeSearchText(_ text: String) {
        fetchData(withPhrase: text)
    }
}

// MARK: - TableView data source methods -

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositoriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.tableView.dequeueReusableCell(withIdentifier: ListItemTableViewCell.className, for: indexPath) as? ListItemTableViewCell
        else { return UITableViewCell() }
        let cellData = viewModel.repositoriesData[indexPath.row]
        cell.configure(withName: cellData.name, andDescription: cellData.description)
        return cell
    }
}

// MARK: - TableView delegate methods -

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoData = viewModel.repositoriesData[indexPath.row]
        delegate?.didSelectListItem(repoData)
    }
}
