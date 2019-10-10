//
//  SuggestLocationInteractor.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import ObjectMapper

class SuggestLocationInteractor {}

extension SuggestLocationInteractor : SuggestLocationInteractorProtocol {
    func getRandomLocationWithParameters(_ params: [String : AnyHashable], andCompletionBlock completion: @escaping (SuggestLocationEntity?, String?) -> ()) {
        
        NetworkManager.preformNetworkActivityWithURL(GENERATE_RANDOM_PLACE_URL, Parameters: params, HTTPMethod: GET) { (response) in
            
            guard let value = response.result.value else {
                completion(nil, FAILED)
                return
            }
            
            let suggetLocationEntity = Mapper<SuggestLocationEntity>().map(JSONObject: value)
            completion(suggetLocationEntity, suggetLocationEntity?.error)
        }
    }
}
