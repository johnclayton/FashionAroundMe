//
//  Service.swift
//  FashionAroundMe
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya
import CoreLocation

private let clientID = "nIIBhrMRMZrpPPkVzPXHwQ"
private let apiKey = "T5Uy1QJeiNEdk57lzh9sKkAhRGrDJewPffIvfW9i8wjnWVttDMgDhM-fS0NxlCu47dOQ62UBO83dB2siIV8PMG_YSVixvvMNpH6r4ixEZFu3z9PaU6Jc49zqk3q9XnYx"

struct YelpService {
	enum BusinessesInterface {
		case search(near: CLLocation, query: String)
		case fetch(id: String)
	}

	struct Businesses {

	}

}

extension YelpService.BusinessesInterface: TargetType {
	var baseURL: URL {
		return URL(string: "https://api.yelp.com/v3/businesses")!
	}

	var path: String {
		switch self {
		case .search(_, _):
			return "search"
		default:
			preconditionFailure()
		}
	}

	var method: Moya.Method {
		switch self {
		case .search:
			return .get
		default:
			preconditionFailure()
		}
	}

	var task: Task {
		switch self {
		case .search(let location, let query):
			let parameters = [
				"latitude" : "\(location.coordinate.latitude)"
				, "longitude" : "\(location.coordinate.longitude)"
				, "term" : query
			]
			return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
		default:
			preconditionFailure()
		}
	}

	var headers: [String : String]? {
		return [ "Authorization" : "Bearer \(apiKey)" ]
	}
}



extension YelpService.Businesses {
	func find(businessesNear location: CLLocation, query: String) -> Single<[Response.Business]> {
		guard query.isEmpty == false else { return Single.just([]) }

		return provider().rx
			.request(.search(near: location, query: query))
			.do(onSuccess: { (response) in
				print(response)
			}, onError: { (error) in
				print(error)
			})
			.map(Response.self)
			.map { $0.businesses }
	}

	private func provider() -> MoyaProvider<YelpService.BusinessesInterface> {
		let provider = MoyaProvider<YelpService.BusinessesInterface>(plugins: [NetworkLoggerPlugin()])
		return provider
	}
}

extension YelpService.Businesses {
	struct Response: Decodable {
		var businesses: [Business]
		struct Business: Decodable {
			var id: String
			var name: String
			var imageURL: String

			enum CodingKeys: String, CodingKey {
				case id, name
				case imageURL = "image_url"
			}
		}
	}
}

extension YelpService.BusinessesInterface {
	var sampleData: Data {
		"""
		{
		  "businesses": [
			{
			  "id": "E8RJkjfdcwgtyoPMjQ_Olg",
			  "alias": "four-barrel-coffee-san-francisco",
			  "name": "Four Barrel Coffee",
			  "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/NBm7cKsFwecEm82oP_-qUg/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/four-barrel-coffee-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 2090,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7670169511878,
				"longitude": -122.42184275
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$",
			  "location": {
				"address1": "375 Valencia St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "375 Valencia St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14158964289",
			  "display_phone": "(415) 896-4289",
			  "distance": 0.0
			},
			{
			  "id": "b-qKz-s2lYfWnIQJ4QukZQ",
			  "alias": "stanza-coffee-san-francisco",
			  "name": "Stanza Coffee",
			  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/AGV-aajkWAGrPkF8g9Cchg/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/stanza-coffee-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 318,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7648968,
				"longitude": -122.4225344
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$",
			  "location": {
				"address1": "3126 16th St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "3126 16th St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14155538966",
			  "display_phone": "(415) 553-8966",
			  "distance": 243.46305414709124
			},
			{
			  "id": "v3hMOlyGUQQfGZQMXFNoZg",
			  "alias": "sextant-coffee-roasters-san-francisco",
			  "name": "Sextant Coffee Roasters",
			  "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/MdVTLgA1pedGlA45h2BBsg/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/sextant-coffee-roasters-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 202,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				},
				{
				  "alias": "coffeeroasteries",
				  "title": "Coffee Roasteries"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7724716,
				"longitude": -122.4129463
			  },
			  "transactions": [
				"pickup",
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "1415 Folsom St",
				"address2": null,
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "1415 Folsom St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14153551415",
			  "display_phone": "(415) 355-1415",
			  "distance": 989.6249282476958
			},
			{
			  "id": "VD527WwvrhE3Nhzf5vaMNw",
			  "alias": "sightglass-coffee-san-francisco-7",
			  "name": "Sightglass Coffee",
			  "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/GN9IKSYDBoYeU-ESatS3gw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/sightglass-coffee-san-francisco-7?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 1844,
			  "categories": [
				{
				  "alias": "coffeeroasteries",
				  "title": "Coffee Roasteries"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.77696,
				"longitude": -122.40851
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "270 Seventh St",
				"address2": "",
				"address3": null,
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "270 Seventh St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14158611313",
			  "display_phone": "(415) 861-1313",
			  "distance": 1622.718341036618
			},
			{
			  "id": "ajuYwySutMShLW6WLJfapw",
			  "alias": "linea-caffe-san-francisco",
			  "name": "Linea Caffe",
			  "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/prVzmiBZgCLGX31NNT53pA/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/linea-caffe-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 185,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				},
				{
				  "alias": "coffeeroasteries",
				  "title": "Coffee Roasteries"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7616956528829,
				"longitude": -122.419991932757
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "3417 18th St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "3417 18th St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14155903011",
			  "display_phone": "(415) 590-3011",
			  "distance": 613.6602165345697
			},
			{
			  "id": "VOoHZDC-dgDUzTSsmgESOQ",
			  "alias": "ritual-coffee-roasters-san-francisco",
			  "name": "Ritual Coffee Roasters",
			  "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/US3QFxMJGdl7XwIk4I12GQ/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/ritual-coffee-roasters-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 1905,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				},
				{
				  "alias": "coffeeroasteries",
				  "title": "Coffee Roasteries"
				}
			  ],
			  "rating": 3.5,
			  "coordinates": {
				"latitude": 37.75642,
				"longitude": -122.42137
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "1026 Valencia St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "1026 Valencia St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14156411011",
			  "display_phone": "(415) 641-1011",
			  "distance": 1177.0759907776035
			},
			{
			  "id": "ywuPgzXcP4l1viSteduK9A",
			  "alias": "ritual-coffee-roasters-san-francisco-5",
			  "name": "Ritual Coffee Roasters",
			  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/ujrvwgbpU1KmV2IpkFqjsw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/ritual-coffee-roasters-san-francisco-5?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 332,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.77646571106,
				"longitude": -122.42434780212
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "432B Octavia St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94102",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "432B Octavia St",
				  "San Francisco, CA 94102"
				]
			  },
			  "phone": "+14158650989",
			  "display_phone": "(415) 865-0989",
			  "distance": 1073.476287846797
			},
			{
			  "id": "EIE9lm4086L7wNiqGqpsKA",
			  "alias": "coffee-cultures-san-francisco-3",
			  "name": "Coffee Cultures",
			  "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/qfojjwnr4g-06Z-fKV_cnA/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/coffee-cultures-san-francisco-3?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 122,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				},
				{
				  "alias": "desserts",
				  "title": "Desserts"
				},
				{
				  "alias": "breakfast_brunch",
				  "title": "Breakfast & Brunch"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7760169057583,
				"longitude": -122.414747737348
			  },
			  "transactions": [
				"pickup",
				"delivery"
			  ],
			  "price": "$",
			  "location": {
				"address1": "1301 Mission St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "1301 Mission St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14158964272",
			  "display_phone": "(415) 896-4272",
			  "distance": 1179.1496950321498
			},
			{
			  "id": "I-32OYNaIU4AMkUB-17fpw",
			  "alias": "stable-cafe-san-francisco",
			  "name": "Stable Cafe",
			  "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/N7yNHk09gBeWiqlNHJVVqw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/stable-cafe-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 515,
			  "categories": [
				{
				  "alias": "breakfast_brunch",
				  "title": "Breakfast & Brunch"
				},
				{
				  "alias": "cafes",
				  "title": "Cafes"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7632381549085,
				"longitude": -122.41531057781
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$",
			  "location": {
				"address1": "2128 Folsom St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "2128 Folsom St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14155521199",
			  "display_phone": "(415) 552-1199",
			  "distance": 711.514657328807
			},
			{
			  "id": "Xkchmq10e0VDe_KJAIaARA",
			  "alias": "coffeeshop-san-francisco-3",
			  "name": "CoffeeShop",
			  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/A3BtU_JhldDZQrEcGEFVKA/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/coffeeshop-san-francisco-3?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 14,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.5,
			  "coordinates": {
				"latitude": 37.75747,
				"longitude": -122.40991
			  },
			  "transactions": [],
			  "location": {
				"address1": "2761 21st St",
				"address2": "",
				"address3": null,
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "2761 21st St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14153683802",
			  "display_phone": "(415) 368-3802",
			  "distance": 1490.7556697988125
			},
			{
			  "id": "LV9GJW3NCHgMRbnWo_5xgw",
			  "alias": "stonemill-matcha-san-francisco",
			  "name": "Stonemill Matcha",
			  "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/xm-Mrr5LU1kP0Z6uQNoWqA/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/stonemill-matcha-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 853,
			  "categories": [
				{
				  "alias": "cafes",
				  "title": "Cafes"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.76401,
				"longitude": -122.4215
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "561 Valencia St",
				"address2": null,
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "561 Valencia St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14157963876",
			  "display_phone": "(415) 796-3876",
			  "distance": 337.63422366265206
			},
			{
			  "id": "z7yT8d8gIWEMjK6VIsPsCg",
			  "alias": "rise-and-grind-coffee-and-tea-san-francisco-5",
			  "name": "Rise & Grind Coffee and Tea",
			  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/uaoXRlbmoLG7HjxxbT_s7g/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/rise-and-grind-coffee-and-tea-san-francisco-5?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 32,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.5,
			  "coordinates": {
				"latitude": 37.755818,
				"longitude": -122.414605
			  },
			  "transactions": [
				"pickup",
				"delivery"
			  ],
			  "price": "$",
			  "location": {
				"address1": "2598 Folsom St",
				"address2": "",
				"address3": null,
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "2598 Folsom St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14158008279",
			  "display_phone": "(415) 800-8279",
			  "distance": 1398.391233002151
			},
			{
			  "id": "U1g2Yd3tEgw_bAhdwVJLBA",
			  "alias": "samovar-valencia-st-san-francisco",
			  "name": "Samovar - Valencia St.",
			  "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/38xs6fRc1W2vWgRZW6KCRQ/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/samovar-valencia-st-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 386,
			  "categories": [
				{
				  "alias": "tea",
				  "title": "Tea Rooms"
				},
				{
				  "alias": "cafes",
				  "title": "Cafes"
				},
				{
				  "alias": "bubbletea",
				  "title": "Bubble Tea"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7663154558352,
				"longitude": -122.421848215163
			  },
			  "transactions": [
				"pickup",
				"delivery"
			  ],
			  "price": "$",
			  "location": {
				"address1": "411 Valencia St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "411 Valencia St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14155536887",
			  "display_phone": "(415) 553-6887",
			  "distance": 78.00411703402588
			},
			{
			  "id": "ppUyFBWrnUEAnuwPlfSF1A",
			  "alias": "mauerpark-san-francisco",
			  "name": "Mauerpark",
			  "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/qkyL9LGQZm4gkTq7lVZ9Pw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/mauerpark-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 66,
			  "categories": [
				{
				  "alias": "cafes",
				  "title": "Cafes"
				}
			  ],
			  "rating": 4.5,
			  "coordinates": {
				"latitude": 37.76269,
				"longitude": -122.42872
			  },
			  "transactions": [],
			  "location": {
				"address1": "500 Church St",
				"address2": "",
				"address3": null,
				"city": "San Francisco",
				"zip_code": "94114",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "500 Church St",
				  "San Francisco, CA 94114"
				]
			  },
			  "phone": "+14155254429",
			  "display_phone": "(415) 525-4429",
			  "distance": 772.6236800284648
			},
			{
			  "id": "5BDM9d8DI_iHGyBmJzWBow",
			  "alias": "saint-frank-coffee-san-francisco-4",
			  "name": "Saint Frank Coffee",
			  "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/UCplPX8_Gtx66jXJBJ2ITw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/saint-frank-coffee-san-francisco-4?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 39,
			  "categories": [
				{
				  "alias": "coffeeroasteries",
				  "title": "Coffee Roasteries"
				}
			  ],
			  "rating": 4.5,
			  "coordinates": {
				"latitude": 37.7794760416406,
				"longitude": -122.410497234799
			  },
			  "transactions": [],
			  "price": "$$",
			  "location": {
				"address1": "1081 Mission St",
				"address2": "",
				"address3": null,
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "1081 Mission St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14158818062",
			  "display_phone": "(415) 881-8062",
			  "distance": 1706.951678278841
			},
			{
			  "id": "xI2gY1Bf0MrV0E7k9lbUvg",
			  "alias": "sightglass-coffee-san-francisco-3",
			  "name": "Sightglass Coffee",
			  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/CxfiZv57u44M6WtIrizKNw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/sightglass-coffee-san-francisco-3?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 240,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.759243,
				"longitude": -122.4111862
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "3014 20th St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "3014 20th St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14156411043",
			  "display_phone": "(415) 641-1043",
			  "distance": 1267.5959150458882
			},
			{
			  "id": "AfqpSxetSUMc63ZPCfbneg",
			  "alias": "craftsman-and-wolves-san-francisco",
			  "name": "Craftsman and Wolves",
			  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/uXIQq9jt4QZzUvFtts9S-Q/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/craftsman-and-wolves-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 1531,
			  "categories": [
				{
				  "alias": "bakeries",
				  "title": "Bakeries"
				},
				{
				  "alias": "cafes",
				  "title": "Cafes"
				},
				{
				  "alias": "cakeshop",
				  "title": "Patisserie/Cake Shop"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7609695,
				"longitude": -122.4218206
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "746 Valencia St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94110",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "746 Valencia St",
				  "San Francisco, CA 94110"
				]
			  },
			  "phone": "+14159137713",
			  "display_phone": "(415) 913-7713",
			  "distance": 672.4479642826301
			},
			{
			  "id": "kZtCd070jWwmCAFOTIm2Wg",
			  "alias": "blue-bottle-coffee-san-francisco-12",
			  "name": "Blue Bottle Coffee",
			  "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/d2vFzO3kGnPDcL7dw5kEyQ/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/blue-bottle-coffee-san-francisco-12?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 107,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.5,
			  "coordinates": {
				"latitude": 37.77674,
				"longitude": -122.41636
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "1355 Market St",
				"address2": "Ste 190",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "1355 Market St",
				  "Ste 190",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+15106533394",
			  "display_phone": "(510) 653-3394",
			  "distance": 1206.3919598723508
			},
			{
			  "id": "-NbDKVqG170J19MqSQ5q_A",
			  "alias": "the-mill-san-francisco",
			  "name": "The Mill",
			  "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/LjO1o6YyRiOBABqxXURSkw/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/the-mill-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 1155,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				},
				{
				  "alias": "bakeries",
				  "title": "Bakeries"
				},
				{
				  "alias": "desserts",
				  "title": "Desserts"
				}
			  ],
			  "rating": 4.0,
			  "coordinates": {
				"latitude": 37.7764801534107,
				"longitude": -122.437750024358
			  },
			  "transactions": [
				"delivery"
			  ],
			  "price": "$$",
			  "location": {
				"address1": "736 Divisadero St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94117",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "736 Divisadero St",
				  "San Francisco, CA 94117"
				]
			  },
			  "phone": "+14153451953",
			  "display_phone": "(415) 345-1953",
			  "distance": 1749.890161085604
			},
			{
			  "id": "SiqcQqHhRtQbtkXOLo640g",
			  "alias": "vega-coffee-san-francisco",
			  "name": "Vega Coffee",
			  "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/xjfueUOFAGTaIDihgt4P1Q/o.jpg",
			  "is_closed": false,
			  "url": "https://www.yelp.com/biz/vega-coffee-san-francisco?adjust_creative=nIIBhrMRMZrpPPkVzPXHwQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=nIIBhrMRMZrpPPkVzPXHwQ",
			  "review_count": 130,
			  "categories": [
				{
				  "alias": "coffee",
				  "title": "Coffee & Tea"
				}
			  ],
			  "rating": 4.5,
			  "coordinates": {
				"latitude": 37.7745635,
				"longitude": -122.410969
			  },
			  "transactions": [],
			  "price": "$",
			  "location": {
				"address1": "1246 Folsom St",
				"address2": "",
				"address3": "",
				"city": "San Francisco",
				"zip_code": "94103",
				"country": "US",
				"state": "CA",
				"display_address": [
				  "1246 Folsom St",
				  "San Francisco, CA 94103"
				]
			  },
			  "phone": "+14156406843",
			  "display_phone": "(415) 640-6843",
			  "distance": 1271.858329169704
			}
		  ],
		  "total": 2400,
		  "region": {
			"center": {
			  "longitude": -122.42184275,
			  "latitude": 37.7670169511878
			}
		  }
		}
		""".data(using: .utf8)!
	}

}
