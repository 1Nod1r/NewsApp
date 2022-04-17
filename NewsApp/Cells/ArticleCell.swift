//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Nodirbek on 17/04/22.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    static let id = "ArticleCell"
    
    let avatarImageView = AvatarImageView(frame: .zero)
    let titleLabel = TitleLabel(textAllignment: .left, fontSize: 18)
    let bodyLabel = BodyLabel(fontSize: 17)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(article: Article){
        guard let image = article.urlToImage else{
            return
        }
        NetworkManager.shared.downloadImage(from: image) {[weak self] image in
            guard let self = self else{ return }
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }
        titleLabel.text = article.title
        bodyLabel.text = article.content
        
    }
    
    private func configure(){
        addSubview(avatarImageView)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 26),
            titleLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -padding),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            bodyLabel.heightAnchor.constraint(equalToConstant: 55),
            bodyLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -padding),
            
        ])
    }

}
