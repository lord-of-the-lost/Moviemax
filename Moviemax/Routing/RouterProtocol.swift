//
//  RouterProtocol.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

protocol RouterProtocol: AnyObject {
    associatedtype ViewControllerType: UIViewController
    var viewController: ViewControllerType? { get set }
}
