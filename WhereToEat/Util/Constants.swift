//
//  Constants.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import Alamofire

// Calling APIs
let BASE_URL: String = "https://wainnakel.com/api/v1/"
let GENERATE_RANDOM_PLACE_URL: String = BASE_URL + "GenerateFS.php?"

// HTTP Methods
let GET: HTTPMethod = HTTPMethod.get

// Others
let FAILED: String = "Failed"
let ERROR: String = "Error"
let ACCESS_DENIED: String = "Access to your location is needed"

enum AnimationDirection {
    case animateIn
    case animateOut
}
