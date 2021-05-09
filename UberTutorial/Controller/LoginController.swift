import UIKit

class LoginController: UIViewController {

    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "envelope")
        imageView.alpha = 0.87
        imageView.tintColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 30, height: 24)
        imageView.centerY(inView: view)
        
        view.addSubview(emailTextField)
        emailTextField.anchor(left: imageView.rightAnchor, right: view.rightAnchor, paddingLeft: 8)
        emailTextField.centerY(inView: imageView)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor,
                             bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             height: 0.75)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [
                                                                NSAttributedString.Key.foregroundColor : UIColor.lightGray
                                                             ])
        return textField
    }()
    
    //MARK: - Lificycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 25/255,
                                       green: 25/255,
                                       blue: 25/255,
                                       alpha: 1)
        
        view.addSubview(titleLabel)

        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: titleLabel.bottomAnchor,
                                  left: view.leftAnchor,
                                  right: view.rightAnchor,
                                  paddingTop: 40,
                                  paddingLeft: 16,
                                  paddingRight: 16,
                                  height: 50)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
