//
//  SuggestLocationPresenter.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import Foundation

class SuggestLocationPresenter {
    
    var view: SuggestLocationViewProtocol?
    var interactor: SuggestLocationInteractorProtocol?
    var router: SuggestLocationRouterProtocol?
}

extension SuggestLocationPresenter : SuggestLocationPresenterProtocol {
    func getRandomLoctationWith(longitude: String, andLatitude latitude: String) {

        view?.showProgress(true)
        
        let params: [String : AnyHashable] = ["uid" : "\(longitude),\(latitude)",
                                              "g et_param" : "value"]
        
        interactor?.getRandomLocationWithParameters(params, andCompletionBlock: { [weak self] (responseModel, error) in
            self?.view?.showProgress(false)
            
            if error == nil || error == "no" {
                if let suggestedLocationEntity = responseModel {
                    self?.view?.setRandomLocationModel(suggestedLocationEntity)
                } else {
                    self?.view?.showError(FAILED)
                }
            } else {
                self?.view?.showError(error!)
            }
        })
    }
}
