//
//  Container.swift
//  FashionAroundMe
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift


class Container {
	static var shared = Container()
	lazy var locationManager: CLLocationManager = {
		let manager = CLLocationManager()
		manager.requestWhenInUseAuthorization()
		manager.startUpdatingLocation()
		return manager
	}()
	lazy var state = State()
}

typealias Business = YelpService.Businesses.Response.Business

class State {

	lazy var yelp = Yelp()

	class Yelp {
		func businesses(near location: CLLocation, query: String) -> Observable<[Business]> {
			guard query.isEmpty == false else { return Observable.just([]) }
			let key = Query(location: location, query: query)

			// Kick off a new request so we can update results
			_ = self.businessesService
				.find(businessesNear: location, query: query)
				.subscribe(onSuccess: { result in
					self.update(newResults: result, forQuery: key)
				})

			// Return cached results or a placeholder that the subscriber can receive updates on
			return businessesByQuerySubject
				.map { $0[key] ?? [] }
		}

		private let businessesService = YelpService.Businesses()
		private struct Query: Hashable {
			let location: CLLocation
			let query: String
		}
		private var businessesByQuerySubject = BehaviorSubject<[Query:[Business]]>(value: [:])
		private func update(newResults: [Business], forQuery query: Query) {
			var results = try! businessesByQuerySubject.value()
			results[query] = newResults
			businessesByQuerySubject.onNext(results)
		}

		var subscriptions = DisposeBag()
	}
}
