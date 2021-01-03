//
//  CPAlertVC.swift
//  CPAlertView
//
//  Created by Phong Cao on 2/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

enum AnimationType{
    case scale
    case rotate
    case bounceUp
    case zoomIn
}

class iOSAlertView: UIViewController {
    
    //MARK: - DECLARE
    
    var userAction:((_ callback: Bool) -> Void)? = nil
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var status_lbl: UILabel!
    @IBOutlet weak var message_lbl: UILabel!
    
    
    @IBOutlet weak var symbol_lbl: UILabel!
    
    var backgroundColor: UIColor = .black
    var backgroundOpacity: CGFloat = 0.5

    
    var titleMessage: String = ""
    var message: String = ""
    var status: Bool = false
    
    var animationType: AnimationType = .bounceUp

    //MARK: - LIFECYCLE
    
    convenience init(title: String, message: String, animationType: AnimationType = .scale) {
        
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = backgroundColor.withAlphaComponent(backgroundOpacity)
        self.view.alpha = 0

        if status{
            status_lbl.textColor = #colorLiteral(red: 0.1171835735, green: 0.6489965916, blue: 0.2086822093, alpha: 1)
            status_lbl.text = "Successful !"
            
            symbol_lbl.text = "✓"
            symbol_lbl.backgroundColor = #colorLiteral(red: 0.1171835735, green: 0.6489965916, blue: 0.2086822093, alpha: 1)
        }else{
            status_lbl.textColor = #colorLiteral(red: 0.8726132512, green: 0.0768373087, blue: 0.07286302, alpha: 1)
            status_lbl.text = "Unsuccessful !"
            
            symbol_lbl.text = "✗"
            symbol_lbl.backgroundColor = #colorLiteral(red: 0.8726132512, green: 0.0768373087, blue: 0.07286302, alpha: 1)
        }
        message_lbl.text = message
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating(type: self.animationType)
    }
    
    
    func showAlert(title: String, message: String, animationType: AnimationType, status:Bool, action: ((_ value: Bool) -> Void)? = nil) {
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.titleMessage = title
        self.message = message
        userAction = action
        self.status = status
        self.animationType = animationType
        guard let viewController = Util.topViewController()else{return}
        viewController.present(self, animated: true, completion: nil)
        
    }
    
    
    private func startAnimating(type: AnimationType) {
        symbol_lbl.transform = CGAffineTransform(rotationAngle: 2.5)
        switch type {
        case .rotate:
            alertView.transform = CGAffineTransform(rotationAngle: 1.5)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + alertView.frame.height/2
            alertView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .zoomIn:
            alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        default:
            alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            print("use new animation ")
        }
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 1
            self.alertView.transform = .identity
            self.symbol_lbl.transform = .identity
           
        }, completion: {(n)in
            
        })
        
    }
    

    @IBAction func OKAtion(_ sender: Any) {
 
        closeWithAnimation()
        if userAction != nil{
            userAction!(true)
        }
        
        dismiss(animated: true, completion: {
            
        })
    }

    
    func closeWithAnimation(){
        
        symbol_lbl.transform = CGAffineTransform(rotationAngle: 1.5)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 0
            self.symbol_lbl.transform = .identity
            if self.animationType == .bounceUp{
                let screenHeight = (UIScreen.main.bounds.height/2 + self.alertView.frame.height/2)
                self.alertView.transform =  CGAffineTransform(translationX: 0, y: screenHeight)
            }else if self.animationType == .zoomIn{
                self.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }else{
                self.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
        }, completion: nil)
        
    }

    
}

class Util {
    
    static func stringFromDate(date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: date)
        return dateStr
        
    }
    
    static func topViewController() -> UIViewController? {
        return topViewController(vc: UIApplication.shared.windows.last?.rootViewController)
    }
    
    private static func topViewController(vc:UIViewController?) -> UIViewController? {
        if let rootVC = vc {
            guard let presentedVC = rootVC.presentedViewController else {
                return rootVC
            }
            if let presentedNavVC = presentedVC as? UINavigationController {
                let lastVC = presentedNavVC.viewControllers.last
                return topViewController(vc: lastVC)
            }
            return topViewController(vc: presentedVC)
        }
        return nil
    }
    
}
