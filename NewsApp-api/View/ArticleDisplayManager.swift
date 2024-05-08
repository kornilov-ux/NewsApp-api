//
//  ArticleDisplayManager.swift
//  NewsApp-api
//
//  Created by Alex  on 07.05.2024.
//

import UIKit

class ArticleDisplayManager: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	var articles: [ArticleModel] = []
	var tableView: UITableView!
	var didSelectArticle: ((ArticleModel) -> Void)?

	// MARK: - TableView DataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
		let article = articles[indexPath.row]
		cell.configure(with: article)
		return cell
	}
	
	// MARK: - TableView Delegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedArticle = articles[indexPath.row]
		didSelectArticle?(selectedArticle)
	}
	
	// MARK: - Helper Methods
	
	func registerCell(for tableView: UITableView) {
		tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
	}
	
	func setupTableView(in view: UIView) {
		let tableView = UITableView(frame: view.bounds, style: .plain)
		tableView.dataSource = self
		tableView.delegate = self
		registerCell(for: tableView)
		view.addSubview(tableView)
		self.tableView = tableView
	}
	
	func handleArticleSelection(_ article: ArticleModel, navigationController: UINavigationController?) {
		print("Selected article: \(article.title)")
		let fullArticleVC = FullArticleViewController()
		fullArticleVC.article = article // Передаем выбранную статью в FullArticleViewController
		navigationController?.pushViewController(fullArticleVC, animated: true)
	}

	
	// MARK: - Fetching Data
	
	func fetchData(for section: String) {
		NetworkManager().fetchData(for: section) { [weak self] result in
			switch result {
			case .success(let articles):
				self?.articles = articles
				DispatchQueue.main.async {
					self?.tableView.reloadData()
				}
			case .failure(let error):
				print("Error fetching data: \(error)")
			}
		}
	}
}

// MARK: - Article Cell

class ArticleCell: UITableViewCell {
	
	let titleLabel = UILabel()
	let abstractLabel = UILabel()
	let dateLabel = UILabel()
	let thumbnailImageView = UIImageView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
//	func configure(with article: ArticleModel) {
//		titleLabel.text = article.title
//		abstractLabel.text = article.abstract
//		dateLabel.text = article.published_date
//		
//		if let multimedia = article.multimedia.first, let thumbnailURL = URL(string: multimedia.url) {
//				DispatchQueue.global().async {
//					if let imageData = try? Data(contentsOf: thumbnailURL) {
//						DispatchQueue.main.async {
//							self.thumbnailImageView.image = UIImage(data: imageData)
//						}
//					}
//				}
//			}
//	}
	func configure(with article: ArticleModel) {
		titleLabel.text = article.title
		abstractLabel.text = article.abstract
		dateLabel.text = article.published_date
		
		if let multimedia = article.multimedia.first, let thumbnailURL = URL(string: multimedia.url) {
			URLSession.shared.dataTask(with: thumbnailURL) { [weak self] (data, response, error) in
				guard let data = data, error == nil else {
					print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
					return
				}
				DispatchQueue.main.async {
					self?.thumbnailImageView.image = UIImage(data: data)
				}
			}.resume()
		}
	}

	
	func setupViews() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(abstractLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(thumbnailImageView)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		abstractLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
		//thumbnailImageView.contentMode = .scaleAspectFit

		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			
			abstractLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
			abstractLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			abstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			
			dateLabel.topAnchor.constraint(equalTo: abstractLabel.bottomAnchor, constant: 8),
			dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			
			thumbnailImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
			thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			thumbnailImageView.heightAnchor.constraint(equalToConstant: 300)
		])
		
		titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
		titleLabel.numberOfLines = 0
		abstractLabel.numberOfLines = 0
		dateLabel.font = UIFont.italicSystemFont(ofSize: 12)
		dateLabel.textColor = UIColor.gray
	}
}
