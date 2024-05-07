//
//  CustomTabBarController.swift
//  NewsApp-api
//
//  Created by Alex  on 07.05.2024.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		generateTabBar()
		setTabBarAppearance()
		
    }
    
	private func generateTabBar() {
		 let vc = TechViewController()
		 viewControllers = [
			 generateVC(
				 viewController: vc,
				 title: "Tech",
				 image: UIImage(named: "tech"),
				 selectedImage: UIImage(named: "techFill")
			 ),
			 generateVC(
				 viewController: MediaViewController(),
				 title: "Media",
				 image: UIImage(named: "Media"),
				 selectedImage: UIImage(named: "MediaFill")
			 ),
			 generateVC(
				 viewController: BusinessViewController(),
				 title: "Business",
				 image: UIImage(named: "Business"),
				 selectedImage: UIImage(named: "BusinessFill")
			 ),
			 generateVC(
				 viewController: EnergyViewController(),
				 title: "Energy",
				 image: UIImage(named: "Energy"),
				 selectedImage: UIImage(named: "EnergyFill")
			 )
		 ]
	 }
	
	private func generateVC(viewController: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) -> UIViewController {
		let vc = UINavigationController(rootViewController: viewController)
		vc.tabBarItem.title = title
		vc.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
		vc.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
		return vc
	}


	private func setTabBarAppearance() {
		tabBar.layer.masksToBounds = true
		let positionOnY: CGFloat = 14
		let width = tabBar.bounds.width
		let height = tabBar.bounds.height + 50
		let roundLayer = CAShapeLayer()
		let bezierPath = UIBezierPath(
			roundedRect: CGRect(
				x: 0,
				y: tabBar.bounds.minY - positionOnY,
				width: width,
				height: height
			),
			cornerRadius: 0
		)

//		roundLayer.path = bezierPath.cgPath
//		roundLayer.fillColor = UIColor.white.cgColor
//		tabBar.layer.insertSublayer(roundLayer, above: tabBar.layer) // Add above tabBar content
		tabBar.itemWidth = width / 5
		tabBar.itemPositioning = .centered
		let appearance = UITabBarItem.appearance()
		let attributes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
			NSAttributedString.Key.foregroundColor:UIColor.darkGray
		]
		appearance.setTitleTextAttributes(attributes, for: .normal)
	}

	
}
