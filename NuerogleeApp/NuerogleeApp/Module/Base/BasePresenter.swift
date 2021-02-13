//
//  BasePresenter.swift
//  ToolTracking
//
//  Created by User on 12/27/20.
//

import Foundation

protocol BasePresenterProtocal: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
}

extension BasePresenterProtocal {
    /*
     *Throw an error if presenter called viewDidLoad but hasn't been called inside ViewController
     */
    func viewDidLoad() {
        fatalError("viewDidLoad hasn't been called inside ViewController")
    }

    /*
     *Throw an error if presenter called viewWillAppear but hasn't been called inside ViewControlle
     */
    func viewWillAppear(animated: Bool) {
        fatalError("viewWillAppear hasn't been called inside ViewController")
    }
}
