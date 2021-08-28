//
//  RepoDetailsView.swift
//  KLproject
//
//  Created by KL on 28/08/2021.
//

import UIKit
import SnapKit
import WebKit

final class RepoDetailsView: UIView {
    
    var isPageDownloading: Bool = false {
        willSet {
            newValue ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - UI Components -
    
    private var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = AppColor.text
        return view
    }()
    
    let webView = WKWebView()
    
    // MARK: - Init -
    
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
        backgroundColor = .white
        isPageDownloading = true
    }
    
    // MARK: - Layout -
    
    private func defineLayout() {
        addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
