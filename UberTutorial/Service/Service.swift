import Firebase

fileprivate let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")

struct Service {
    
    static let shared = Service()

    private init() {}
    
    func fetchUserData(completion: @escaping (User) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
