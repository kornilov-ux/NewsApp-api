//
//  ViewController.swift
//  NewsApp-api
//
//  Created by Alex  on 04.05.2024.
//

import UIKit

class TechViewController: UIViewController {
	
	override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			navigationController?.tabBarController?.tabBar.isHidden = false
			navigationController?.navigationBar.tintColor = .black
		}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
	}

}

