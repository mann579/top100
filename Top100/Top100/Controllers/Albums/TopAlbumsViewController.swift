//
//  Top100ViewController.swift
//  Top100
//
//  Created by Manpreet on 27/10/2020.
//

import UIKit

class TopAlbumsViewController: UITableViewController, MAMainThreadSafe {
    
    private let cellIdentifier = "AlbumCell"
    let networkManager = NetworkManager()
    var albums = [Album]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TopAlbumTitle", comment: "main title")
        tableView.accessibilityIdentifier = "AlbumTable"
        tableView.separatorColor = UIColor.systemGray
        tableView.estimatedRowHeight = 66.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        self.tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: NSLocalizedString("Fetching Albums...", comment: ""))
        self.tableView.refreshControl?.addTarget(self, action: #selector(loadTheTopAlbums), for: .valueChanged)
        loadTheTopAlbums()
    }
    
    @objc private func loadTheTopAlbums() {
        self.tableView.refreshControl?.beginRefreshing()
        networkManager.getTopAlbums(count: 100) { albums, error in
            if error == nil {
                self.performUIUpdate {
                    MAAlertview.showAlertWrapper(alertTitle: NSLocalizedString("Error", comment: ""),
                                                 alertMessage: NSLocalizedString("APIError", comment: ""))
                }
            }
            self.albums = albums ?? [Album]()
            self.performUIUpdate {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: self.cellIdentifier,
            for: indexPath
        ) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configureWith(album)
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailController = AlbumDetailViewController()
        albumDetailController.album = albums[indexPath.row]
        self.navigationController?.pushViewController(albumDetailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = TableAnimationTypes.makeMoveUpBounceAnimation(rowHeight: (cell as! AlbumTableViewCell).tableViewHeight, duration: 1.0, delayFactor: 0.05)
        let animator = TableViewAnimator(animation: animation)
                animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
}
