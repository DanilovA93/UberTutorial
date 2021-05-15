import UIKit
import Firebase
import MapKit

class HomeController: UIViewController {
    
    //MARK: - Properties

    private let mapView = MKMapView()
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if let _ = Auth.auth().currentUser?.uid {
            configureUI()
        } else {
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Sign out failed \(error)")
        }
    }
    
    //MARK: Helper functions
    
    func configureUI() {
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
}
