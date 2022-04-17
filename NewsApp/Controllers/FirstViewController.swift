//
//  ViewController.swift
//  NewsApp
//
//  Created by Nodirbek on 17/04/22.
//

import UIKit
import SafariServices
import JGProgressHUD

class FirstViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    var articles: [Article] = []
    let tableView = UITableView()
    var page = 1
    var hasMoreFollowers = true
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        getData()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 110
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.id)
    }
    
    func getData(){
        spinner.show(in: view)
        NetworkManager.shared.getData(page: page) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                
                self.articles.append(contentsOf: articles)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.spinner.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func presentSafari(for index: Int) {
        let safariVC = SFSafariViewController(url: URL(string: articles[index].url)!)
        present(safariVC, animated: true)
    }
}


extension FirstViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.id, for: indexPath) as! ArticleCell
        
        let article = articles[indexPath.row]
        cell.set(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSafari(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offSetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            if page > 4 {
                return
            }
            getData()
        }
    }
    
}

