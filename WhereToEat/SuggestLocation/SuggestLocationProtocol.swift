//
//  SuggestLocationProtocol.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import Foundation

protocol SuggestLocationViewProtocol : class {
    func setRandomLocationModel(_ model: SuggestLocationEntity)
    func showError(_ error: String)
    func showProgress(_ show: Bool)
}

protocol SuggestLocationPresenterProtocol : class {
    func getRandomLoctationWith(longitude: String, andLatitude latitude: String)
}

protocol SuggestLocationRouterProtocol : class {
    static func createSuggestLocationModule() -> SuggestLocationViewController
}

protocol SuggestLocationInteractorProtocol : class {
    func getRandomLocationWithParameters(_ params: [String : AnyHashable],
                                         andCompletionBlock completion: @escaping (_ model: SuggestLocationEntity?, _ error: String?) -> ())
}
