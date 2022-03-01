//
//  DataManager.swift
//  peer-to-peer-talk
//
//  Created by Simon Italia on 01/03/22.
//

import Foundation
import MultipeerConnectivity

struct DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    private enum Key {
        static let user = "User"
        static let userPeerId = "UserPeerId"
    }

    func getUser() -> User {
        
        // attempt to retrieve user from storage
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.object(forKey: Key.user) as? Data {
            do {
                let user = try decoder.decode(User.self, from: data)
                print("DataManager.getUser success")
                return user
                
            } catch let error {
                fatalError("DataManager.getUser from data error: \(error)")
            }
        }
        
        // create user if no user exists in storage
        return createUser()
    }
    
    private func createUser() -> User {
        
        //create user
        let user = User()
        
        // attempt to save user
        save(user: user)  { result in
            
            // if user save succeeds, create peer id
            switch result {
            case .success:
                savePeerId(for: user) { result in
                    switch result {
                    case .success:
                        print("DataManager.save peerId success")
                    
                    case .failure(let error):
                        fatalError("DataManager.save peerId error: \(error)")
                    }
                }
            
            case .failure(let error):
                fatalError("DataManager.save user error: \(error)")
            }
        }
        
        // return new user if peer id is created succesfully
        return user
    }
    
    private func save(user: User, result: @escaping (Result<Bool, Error>) -> Void) {
         
         // save new user object as json data
         let encoder = JSONEncoder()
         do {
             let data = try encoder.encode(user)
             UserDefaults.standard.set(data, forKey: Key.user)
             print("DataManager.saveUser success")
             result(.success(true))
         
         } catch let error {
            result(.failure(error))
         }
    }
    
    private func savePeerId(for user: User, result: @escaping (Result<Bool, Error>) -> Void) {
        let peerId = MCPeerID(displayName: user.name)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: peerId, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: Key.userPeerId)
            print("DataManager.savePeerId success")
            result(.success(true))
            
        } catch let error {
            result(.failure(error))
        }
    }
    
    func getPeerId(for user: User) -> MCPeerID {
        
        // get peer id from storage
        guard let data = UserDefaults.standard.object(forKey: Key.userPeerId) as? Data
        else {
            fatalError("DataManager.getPeerId data error")
        }

        // transform to MCPeerID type and return if successful
        do {
            if let peerId = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? MCPeerID {
                
                print("DataManager.getPeerId success")
                return peerId
            }

        } catch let error {
            fatalError("DataManager.getPeerId error: \(error)")
        }
        
        fatalError("DataManager.getPeerId for user error")
    }
}
