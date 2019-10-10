//
//  SuggestLocationViewController.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import UIKit

class SuggestLocationViewController : UIViewController {

    // MARK: Local Variable
    var suggestLocationPresenter: SuggestLocationPresenterProtocol?
    var suggestedLocation: SuggestLocationEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestLocationPresenter?.getRandomLoctationWith(longitude: "50.2017993", andLatitude: "26.2716025")
    }
}

extension SuggestLocationViewController : SuggestLocationViewProtocol {
    func setRandomLocationModel(_ model: SuggestLocationEntity) {
        suggestedLocation = model
    }
    
    func showError(_ error: String) {
    }
    
    func showProgress(_ show: Bool) {
    }
}

