import UIKit
import Firebase
import GeoFire

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private var location = LocationHandler.shared.locationManager.location
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView.inputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView.inputContainerView(image: UIImage(systemName: "person")!, textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView.inputContainerView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView.inputContainerView(image: UIImage(systemName: "person.crop.square.fill")!,
                                             segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField.textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    private let fullNameTextField: UITextField = {
        return UITextField.textField(withPlaceholder: "Full name", isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField.textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider", "Driver"])
        sc.backgroundColor = .backgrooundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handeleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                        attributes: [
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                            NSAttributedString.Key.foregroundColor: UIColor.lightGray
                                                        ])
        attributedTitle.append(NSAttributedString(string: "Login",
                                                  attributes: [
                                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                    NSAttributedString.Key.foregroundColor: UIColor.mainBlue
                                                  ]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func handeleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
            if let error = error {
                print("DEBUG: Sign up error \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullName": fullName,
                          "accountType": accountTypeIndex,
                          "password": password] as [String: Any]
            
            if accountTypeIndex == 1 {
                let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
                guard let location = location else { return }
                geofire.setLocation(location, forKey: uid) { error in
                    uploadUserDataAndShowHomeController(uid: uid, values: values)
                }
            }
            uploadUserDataAndShowHomeController(uid: uid, values: values)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper functions
    
    private func uploadUserDataAndShowHomeController(uid: String, values: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(values) { [weak self] (error, ref) in
            guard let navVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                return
            }
            guard let homeVC = navVC.viewControllers.first as? HomeController else { return }
            homeVC.configure()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .backgrooundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 40,
                     paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(alreadyHaveHaveAccountButton)
        alreadyHaveHaveAccountButton.centerX(inView: view)
        alreadyHaveHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     height: 32)
    }
}
