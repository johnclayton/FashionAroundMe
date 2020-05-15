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
import RxCoreLocation

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

		viewModel.businesses.bind(to: tableView.rx.items(cellIdentifier: "BusinessTableViewCell")) { index, business, cell in
			guard let businessCell = cell as? BusinessTableViewCell else { return }
			businessCell.bind(business: business)
		}
		.disposed(by: subscriptions)

		tableView.rx.itemSelected
			.subscribe(onNext: { (indexPath) in
				tableView.deselectRow(at: indexPath, animated: true)
			})
			.disposed(by: subscriptions)
	}

	private var subscriptions = DisposeBag()
}

class BusinessesListViewModel {

	init(yelp: State.Yelp, locationManager: CLLocationManager) {
		self.yelp = yelp
		self.locationManager = locationManager
	}


	var businesses: Observable<[Business]> {
//		let coffee = Business(id: "E8RJkjfdcwgtyoPMjQ_Olg", name: "Four Barrel Coffee", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/NBm7cKsFwecEm82oP_-qUg/o.jpg")
//		return Observable.just([coffee])

		let location = locationManager.rx.location.take(1)
		let yelp = self.yelp
		return Observable.combineLatest(location, remoteSearchTrigger.asObservable())
			.flatMapLatest { (maybeLocation, maybeQuery) ->  Observable<[Business]>
				in
				guard let query = maybeQuery, query.isEmpty == false
					, let location = maybeLocation else {
					return Observable.just([])
				}
				return yelp.businesses(near: location, query: query)
			}
			.do(onNext: { (result) in
				print(result)
			}, onError: { (error) in
				print(error)
			})
	}

	private let remoteSearchTrigger = PublishRelay<String?>()

	/// Bind events from view controller back to view model
	func bind(querySignal: Signal<String?>) {
		subscriptions = DisposeBag()

		let queryRelay = BehaviorRelay<String?>(value: nil)
		querySignal
			.emit(to: queryRelay)
			.disposed(by: subscriptions)

		let remoteSearchThrottle = DispatchTimeInterval.milliseconds(200)
		queryRelay
			.debounce(remoteSearchThrottle, scheduler: MainScheduler.instance)
			.asSignal(onErrorJustReturn: nil)
			.emit(to: remoteSearchTrigger)
			.disposed(by: subscriptions)

		let backgroundScheduler = ConcurrentDispatchQueueScheduler.init(qos: .userInteractive)
		remoteSearchTrigger
			.observeOn(backgroundScheduler)
			.subscribeOn(backgroundScheduler)
			.subscribe()
			.disposed(by: subscriptions)
	}

	private let yelp: State.Yelp
	private let locationManager: CLLocationManager
	private var subscriptions = DisposeBag()

}
