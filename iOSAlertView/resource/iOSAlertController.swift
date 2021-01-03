//
//  iOSAlertController.swift
//  iOSAlertView
//
//  Created by mac on 15/12/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

enum StatusType{
    case success
    case error
    case none
}

class iOSAlertController: UIViewController {
    
    //MARK: - DECLARE
    
    var userAction:((_ callback: Bool) -> Void)? = nil
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var message_lbl: UILabel!
    
    var backgroundColor: UIColor = .black
    var backgroundOpacity: CGFloat = 0.5

    
    var titleMessage: String = ""
    var message: String = ""
    var statusType: StatusType = .success
    
    var animationType: AnimationType = .bounceUp

    //MARK: - LIFECYCLE
    
    convenience init(title: String, message: String, animationType: AnimationType = .scale) {
        
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      //  view.backgroundColor = backgroundColor.withAlphaComponent(backgroundOpacity)
    
        if statusType == .success{
            title_lbl.text = titleMessage
            title_lbl.textColor = #colorLiteral(red: 0.1171835735, green: 0.6489965916, blue: 0.2086822093, alpha: 1)
        }else{
            title_lbl.text = titleMessage
            title_lbl.textColor = #colorLiteral(red: 0.8726132512, green: 0.0768373087, blue: 0.07286302, alpha: 1)
        }
        message_lbl.text = message
        
       
        alertView.layer.shadowColor = #colorLiteral(red: 0.07449653, green: 0.07451746613, blue: 0.07449520379, alpha: 1)
        alertView.layer.shadowOpacity = 0.4
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowRadius = 15
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating(type: self.animationType)
    }
    
    
    func Alert(title: String, message: String, animationType: AnimationType, statusType: StatusType, action: ((_ value: Bool) -> Void)? = nil) {
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.titleMessage = title
        self.message = message
        userAction = action
        self.statusType = statusType
        self.animationType = animationType
        guard let viewController = Util.topViewController()else{return}
        viewController.present(self, animated: true, completion: nil)
        
    }
    
    
    private func startAnimating(type: AnimationType) {
       
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
            self.alertView.transform = .identity
     
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

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 0
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
