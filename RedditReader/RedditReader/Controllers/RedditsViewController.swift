//
//  RedditsViewController.swift
//  RedditReader
//
//  Created by Victor on 25/10/22.
//

import UIKit

class RedditsViewController: UIViewController {
    
    // MARK: UI
    fileprivate let redditsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(RedditTableViewCell.self, forCellReuseIdentifier: URLStrings.cellIdentifiers.redditCell.rawValue)
        return view
    }()
    
    fileprivate let refreshControl = UIRefreshControl()
    
    // MARK: ViewModel Logic
    let viewModel = TopRedditsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setUpNavigation()
        self.setupDelegates()
        
        // Request API on load
        self.viewModel.fetchTopReddits()
    }
    
    func setupUI() {
        view.addSubview(redditsTableView)
        redditsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        redditsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        redditsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        redditsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            redditsTableView.refreshControl = refreshControl
        } else {
            redditsTableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshRedditsData(_:)), for: .valueChanged)
    }
    
    func setupDelegates() {
        // TableView Delegate & Data Source
        redditsTableView.dataSource = self
        redditsTableView.delegate = self
        redditsTableView.prefetchDataSource = self
        // ViewModel Delegate
        self.viewModel.delegate = self
    }
    
    func setUpNavigation() {
        navigationItem.title = URLStrings.topReddits.listingTitle.rawValue
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        self.navigationController?.navigationBar.standardAppearance = appearance;
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc private func refreshRedditsData(_ sender: Any) {
        // Fetch Latest Reddit Data
        self.viewModel.fetchTopReddits()
    }
}

extension RedditsViewController: TopRedditsDelegate {
    func dataModelUpdated() {
        self.redditsTableView.reloadData()
        // Let the refresh control disappear
        self.refreshControl.endRefreshing()
    }
}

extension RedditsViewController: UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: URLStrings.cellIdentifiers.redditCell.rawValue, for: indexPath) as! RedditTableViewCell
        
        // Load data
        let item = self.viewModel.dataModel[indexPath.row];
        cell.redditElement = item.data

        return cell
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.viewModel.dataModel.count - 1
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.viewModel.fetchMoreTopReddits()
        }
    }
}

extension RedditsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstantValues.sizes.cellHeight.rawValue
    }
}
