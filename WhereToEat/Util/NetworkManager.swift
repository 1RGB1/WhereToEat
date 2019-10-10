//
//  NetworkManager.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    // MARK: Static Function
    static func preformNetworkActivityWithURL(_ url: String,
                                              Parameters params: [String : AnyHashable],
                                              HTTPMethod method: HTTPMethod,
                                              andCompletionHandler completion: @escaping(_ response: DataResponse<Any>) -> ()) {
        
        guard let requestURL = URL(string: url) else { return }
        
        Alamofire.request(requestURL, method: method, parameters: params).responseJSON { (response) in
            completion(response)
        }
    }
}
