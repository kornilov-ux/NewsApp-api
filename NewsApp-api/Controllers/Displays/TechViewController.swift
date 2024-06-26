//
//  ViewController.swift
//  NewsApp-api
//
//  Created by Alex  on 04.05.2024.
//

import UIKit

class TechViewController: UIViewController {

	let displayManager = ArticleDisplayManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		displayManager.setupTableView(in: view)
		displayManager.didSelectArticle = { [weak self] article in
			self?.displayManager.handleArticleSelection(article, navigationController: self?.navigationController)
		}
		displayManager.fetchData(for: "technology")
	}
}

