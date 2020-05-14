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
		//TODO: fetch the image and set it here
		self.imageView?.image = UIImage(named: "placeholder")
	}

	var subscriptions = DisposeBag()
}
