//
//  RepoDetailsViewController.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit
import WebKit

protocol RepoDetailsViewControllerDelegate: AnyObject {
    func showAlert(title: String, message: String, errorHandler: @escaping () -> ())
    func didFailPresentingRepo()
}

final class RepoDetailsViewController: UIViewController {

    weak var delegate: RepoDetailsViewControllerDelegate?
    
    // MARK: - Private properties -
    
    private let viewModel: RepoDetailsViewModelProtocol
    private let contentView = RepoDetailsView()
    
    // MARK: - Lifecycle -
        
    init(viewModel: RepoDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadPage()
    }
        
    // MARK: - Setup -
    
    private func setup() {
        navigationController?.navigationBar.tintColor = .gray
        title = viewModel.title
        contentView.webView.navigationDelegate = self
    }
    
    // MARK: - Web link methods -
    
    private func loadPage() {
        guard let url = viewModel.url else { return }
        
        let request = URLRequest(url: url)
        contentView.webView.load(request)
    }
}

extension RepoDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        contentView.isPageDownloading = false
    }
        
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        contentView.isPageDownloading = false
        delegate?.showAlert(
            title: "Page downloading problem!",
            message: "Please select another page",
            errorHandler: { [weak self] in
                self?.delegate?.didFailPresentingRepo()
            })
    }
}
