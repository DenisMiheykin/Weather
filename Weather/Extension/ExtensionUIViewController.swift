import UIKit

extension UIViewController {
    
    func showAlertWhenCityIsEmpty() {
        self.showAlert(title: "City is empty", message: "Fill in the \"City\" field to perform your search", handler: {_ in } )
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actionTitle: String = "OK", style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        
        showAlert(title: title, message: message, preferredStyle: preferredStyle, actions: [(actionTitle, style, handler)])
        
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? )]) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for element in actions {
            alert.addAction(UIAlertAction(title: element.title, style: element.style, handler: element.handler))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
