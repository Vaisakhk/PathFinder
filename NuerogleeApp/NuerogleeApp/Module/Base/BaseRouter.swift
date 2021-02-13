//
//  BaseRouter.swift
//  ToolTracking
//
//  Created by User on 12/25/20.
//

import UIKit

protocol RouterProtocal: class {
    func showAlertPopup(with message:String,title:String,successButtonTitle:String)
    func showAlertPopup(with message:String,title:String,successButtonTitle:String,successBlock: @escaping (_ isSuccess:Bool) -> Void)
    func showAlertWithButtons(alertMessage:String,title:String,successButtonTitle:String,cancelButtonTitle:String,successBlock: @escaping (_ isSuccess:Bool) -> Void)
}

class BaseRouter: RouterProtocal {
    
    /*
     * The holder for ViewController
     */
 
    private unowned var _viewController: UIViewController

    /*
     *  Temporary stored ViewController
     */
    private var _temporaryStoredViewController: UIViewController?
    
    /* Initialize new BaseRouter with provided ViewController
     * Parameters :
            viewController: The ViewController that needs to be activated / showed
     * Returns    :
            A ViewController that inherit capabilities given by the Router Protocal
     */
    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }
}


// MARK: - BaseRouter Helpers
extension BaseRouter {
    /*
     * Get current active view controller that BaseRouter has
     * Returns:
            A View Controller from active BaseRouter
              
     */
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }

    /*
     * Get current active Navigationcontroller that BaseRouter has
     * Returns:
            A NavigationController from active BaseRouter
              
     */
    var navigationController: UINavigationController? {
        return viewController.navigationController == nil ? viewController as? UINavigationController :  viewController.navigationController
    }
}

// MARK: - BaseRouter Helper for Alert
extension BaseRouter {
    /*
     * show AlertController
     * Parameters:
            message             : Message to display in alert
            title               : Alert Title
            successButtonTitle  : Success button title
     *
     */
    func showAlertPopup(with message:String,title:String,successButtonTitle:String) {
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        let ok  = UIAlertAction(title: successButtonTitle, style: .default) { (UIAlertAction) in
           
        }
        alert.addAction(ok)
        viewController.present(alert, animated: true, completion: nil);
    }
    
    /*
     * show AlertController with completion handler to get button action
     * Parameters:
            message             : Message to display in alert
            title               : Alert Title
            successButtonTitle  : Success button title
            successBlock        : Completion handler to return button click
     *
     */
    
    func showAlertPopup(with message:String,title:String,successButtonTitle:String,successBlock: @escaping (_ isSuccess:Bool) -> Void) {
        let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
        let ok  = UIAlertAction(title: successButtonTitle, style: .default) { (UIAlertAction) in
            successBlock(true)
        }
        alert.addAction(ok)
        viewController.present(alert, animated: true, completion: nil);
    }
    
    /*
     * show AlertController with more than one button and completion handler to get button action
     * Parameters:
            alertMessage        : Message to display in alert
            title               : Alert Title
            successButtonTitle  : Success button title
            cancelButtonTitle   : Cancel button tittle
            successBlock        : Completion handler to return button click
     *
     */
     func showAlertWithButtons(alertMessage:String,title:String,successButtonTitle:String,cancelButtonTitle:String,successBlock: @escaping (_ isSuccess:Bool) -> Void) {
        let alert = UIAlertController(title: title , message: alertMessage , preferredStyle: .alert)
        let ok  = UIAlertAction(title: successButtonTitle, style: .default) { (UIAlertAction) in
            successBlock(true)
        }
        alert.addAction(ok)
        let cancel  = UIAlertAction(title: cancelButtonTitle, style: .default) { (UIAlertAction) in
            successBlock(false)
        }
        alert.addAction(cancel)
        viewController.present(alert, animated: true, completion: nil);
    }
    
}

// MARK: - UIViewController Helpers

extension UIViewController {

    /*
     * Present a BaseRouter modally
     * Parameters:
            router        : The target Router to navigate
            animated      : Shows animation when navigating or not
            completion    : Completion handler when navigation are done
     *
     */
    func presentRouter(_ router: BaseRouter, presentationStyle:UIModalPresentationStyle, animated: Bool = true, completion: (() -> ())? = nil) {
        let controller = router.viewController
        controller.modalPresentationStyle = presentationStyle
        present(controller, animated: animated, completion: completion)
    }
    
    /*
     * Dissmiss a BaseRouter
     * Parameters:
            animated      : Shows animation when navigating or not
            completion    : Completion handler when navigation are done
     *
     */
    func dismissRouter(animated: Bool = true, completion: (() -> ())? = nil) {
        dismiss(animated: animated, completion: completion)
    }
}

// MARK: - UINavigationController Helpers

extension UINavigationController {

    /*
     * Pushes a ViewController onto the receiver’s stack and updates the UI
     * Parameters:
            router     : The target Router to navigate
            animated   : Shows animation when navigating or not
     *
     */
    func pushRouter(_ router: BaseRouter, animated: Bool = true) {
        self.pushViewController(router.viewController, animated: animated)
    }

    /*
     * Pop a ViewController from the stack
     * Parameters:
            animated  : Shows animation when navigating or not
     *
     */
    func popRouter(animated: Bool = true) {
        self.popViewController(animated: true)
    }

    /*
     * Replaces all active ViewControllers currently managed by the navigation controller with the specified Router.
     * Parameters:
            router    : The specified Router
            animated  : Shows animation when navigating or not
     *
     */
    func setRootWireframe(_ router: BaseRouter, animated: Bool = true) {
        self.setViewControllers([router.viewController], animated: animated)
    }
}

