//
//  ViewController.swift
//  NewsApp
//
//  Created by Nodirbek on 17/04/22.
//

import UIKit
import SafariServices

class FirstViewController: UIViewController {
    
    var articles: [Article] = []
    let tableView = UITableView()
    
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
        NetworkManager.shared.getData {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let articles):
                self.articles = articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        
    }
    
