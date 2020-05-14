//
//  BusinessTableViewCell.swift
//  FashionAroundMe
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BusinessTableViewCell: UITableViewCell {

	override func prepareForReuse() {
		super.prepareForReuse()
		subscriptions = DisposeBag()
	}
	func bind(business: Business) {
		self.textLabel?.text = business.name
		self.imageView?.image = UIImage(named: "placeholder")
		guard business.imageURL.isEmpty == false else { return }
		let imageURL = URL(string: business.imageURL)!
		let imageView = self.imageView
		URLSession.shared.rx
			.response(request: URLRequest(url: imageURL))
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { (response, data) in
				imageView?.image = UIImage(data: data)
			})
			.disposed(by: subscriptions)
	}

	var subscriptions = DisposeBag()
}
