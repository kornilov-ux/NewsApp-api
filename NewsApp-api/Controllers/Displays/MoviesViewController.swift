//
//  MediaViewController.swift
//  NewsApp-api
//
//  Created by Alex  on 07.05.2024.
//

import UIKit

class MoviesViewController: UIViewController {

	let displayManager = ArticleDisplayManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		displayManager.setupTableView(in: view)
		displayManager.didSelectArticle = { [weak self] article in
			self?.displayManager.handleArticleSelection(article, navigationController: self?.navigationController)
		}
		displayManager.fetchData(for: "movies")
	}
}
