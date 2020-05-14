//
//  BusinessesListViewController.swift
//  FashionAroundMe
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class BusinessesListViewController: UIViewController, UITableViewDelegate {

	@IBOutlet var tableView: UITableView!
	var searchController: UISearchController!

	var viewModel: BusinessesListViewModel!

	override func viewDidLoad() {
        super.viewDidLoad()



		bindViewModel()
    }

	func bindViewModel() {
		subscriptions = DisposeBag()

		let tableView = self.tableView!
		tableView.delegate = self
		tableView.dataSource = nil

		viewModel.businesses.asObservable().bind(to: tableView.rx.items(cellIdentifier: "BusinessTableViewCell")) { index, business, cell in
			guard let businessCell = cell as? BusinessTableViewCell else { return }
			businessCell.bind(business: business)
		}
		.disposed(by: subscriptions)

		tableView.rx.itemSelected
			.subscribe(onNext: { (indexPath) in
				tableView.deselectRow(at: indexPath, animated: true)
			})
			.disposed(by: subscriptions)

		let query = searchController.searchBar.rx.text.asSignal(onErrorJustReturn: nil)

		// We can eventually send in selection events for pushing a detail VC
//		let selection = tableView.rx.modelSelected(Business.self).asSignal()
		viewModel.bind(query: query)
	}

	private var subscriptions = DisposeBag()
}

class BusinessesListViewModel {

	init(yelp: State.Yelp, locationManager: CLLocationManager) {
		self.yelp = yelp
		self.locationManager = locationManager
	}


	var businesses: Driver<[Business]> {
		fatalError("Unimplemented")
//		return Driver.combineLatest(<#T##collection: Collection##Collection#>)
//		return self.yelp.businesses(near: <#T##CLLocation#>, query: <#T##String#>).asDriver(onErrorJustReturn: [])
	}


	/// Bind events from view controller back to view model
	func bind(query: Signal<String?>) {
		subscriptions = DisposeBag()

	}

	private let yelp: State.Yelp
	private let locationManager: CLLocationManager
	private var subscriptions = DisposeBag()

}
