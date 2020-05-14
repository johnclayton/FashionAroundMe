//
//  BusinessesViewController.swift
//  FashionAroundMe
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

	var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

		let resultsController = self.storyboard?.instantiateViewController(withIdentifier: "BusinessesListViewController")
		searchController = UISearchController(searchResultsController: resultsController)
		searchController.searchBar.placeholder = NSLocalizedString("Search nearby", comment: "")
		self.navigationItem.searchController = searchController

		bindViewModel()
	}

	func bindViewModel()  {
		let container = Container.shared

		guard let resultsController = searchController.searchResultsController as? BusinessesListViewController else { return }
		let query = searchController.searchBar.rx.text.asSignal(onErrorJustReturn: nil)
		let resultsModel = BusinessesListViewModel(yelp: container.state.yelp, locationManager: container.locationManager)
		resultsModel.bind(query: query)
		resultsController.viewModel = resultsModel
	}

}
