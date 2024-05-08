//
//  FullArticleViewController.swift
//  NewsApp-api
//
//  Created by Alex  on 08.05.2024.
//

import UIKit
import SwiftSoup

class FullArticleViewController: UIViewController {
	
	var article: ArticleModel?
	var articleTitle: String = ""
	var articleText: String = ""
	var articleImages: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		if let article = article, let url = URL(string: article.url) {
			fetchFullArticle(from: url)
		}
	}
	
	func fetchFullArticle(from url: URL) {
		URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
			guard let data = data, error == nil else {
				print("Error fetching full article: \(error?.localizedDescription ?? "Unknown error")")
				return
			}
			do {
				let html = String(data: data, encoding: .utf8)
				let doc: Document = try SwiftSoup.parse(html ?? "")
				
				// Extract article title
				self?.articleTitle = try doc.title()
				
				// Extract article text
				let paragraphs = try doc.select("p.css-at9mc1.evys1bk0")
				for paragraph in paragraphs {
					self?.articleText.append(try paragraph.text())
				}
				
				// Extract image URLs
				let images = try doc.select("img")
				for image in images {
					guard let src = try? image.attr("src") else {
						continue
					}
					self?.articleImages.append(src)
				}
				
				DispatchQueue.main.async {
					self?.updateUI()
				}
			} catch {
				print("Error parsing HTML: \(error)")
			}
		}.resume()
	}
	
	func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let data = data, error == nil else {
				print("Error fetching image: \(error?.localizedDescription ?? "Unknown error")")
				completion(nil)
				return
			}
			let image = UIImage(data: data)
			completion(image)
		}.resume()
	}
	
	func updateUI() {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(scrollView)
		
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(stackView)
		
		// Article title label
		let titleLabel = UILabel()
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		titleLabel.numberOfLines = 0
		titleLabel.text = articleTitle
		stackView.addArrangedSubview(titleLabel)
		
		// Display article images
		for imageURL in articleImages {
			if let url = URL(string: imageURL) {
				fetchImage(from: url) { image in
					if let image = image {
						DispatchQueue.main.async {
							let imageView = UIImageView(image: image)
							imageView.contentMode = .scaleAspectFit
							stackView.addArrangedSubview(imageView)
						}
					}
				}
			}
		}
		
		// Article text label
		let articleTextLabel = UILabel()
		articleTextLabel.numberOfLines = 0
		articleTextLabel.text = articleText
		stackView.addArrangedSubview(articleTextLabel)
		
		// Constraints
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
		])
	}
}
