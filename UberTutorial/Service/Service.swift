import Firebase

fileprivate let DB_REF = Database.database().reference()
fileprivate let REF_USERS = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    private let currentUid = Auth.auth().currentUser?.uid
    
    private init() {}
    
    func fetchUserData(completion: @escaping (User) -> Void) {
        guard let currentUid = currentUid else { return }
        
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(User(dictionary: dictionary))
        }
    }
}
