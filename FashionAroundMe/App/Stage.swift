//
//  Stage.swift
//  FashionAroundMe
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import UIKit

/// An object that can direct scene transitions for us
class Stage {
	init(navigator: UINavigationController) {
		self.navigator = navigator
	}

	@discardableResult
	func show<S: Scene>(_ scene: S, sender: Any? = nil) -> Stage {
		navigator.show(scene.viewController, sender: sender)
		return self
	}

	private let navigator: UINavigationController
}

protocol Scene {
	var stage: Stage { get }
	var storyboardName: String { get }
	var viewController: UIViewController { get }
}
