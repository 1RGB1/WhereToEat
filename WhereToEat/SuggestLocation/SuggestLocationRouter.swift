//
//  SuggestLocationRouter.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import Foundation
import UIKit

class SuggestLocationRouter {
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}

extension SuggestLocationRouter : SuggestLocationRouterProtocol {
    static func createSuggestLocationModule() -> SuggestLocationViewController {
        
        let view = mainStoryboard.instantiateViewController(withIdentifier: "SuggestLocationViewController") as! SuggestLocationViewController
        
        let presenter = SuggestLocationPresenter()
        let interactor = SuggestLocationInteractor()
        let router = SuggestLocationRouter()
        
        view.suggestLocationPresenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
}
