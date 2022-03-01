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
                fatalError("DataManager.getUser error: \(error.localizedDescription)")
            }
        }
        
        // create user if no user exists in storage
        return createUser()
    }
    
    private func createUser() -> User {
        
        // create user
        let user = User()
        
        // save user and peerId
        save(user: user)
        savePeerId(for: user)
        
        // return user
        return user
    }
    
    private func save(user: User) {
         
         // save new user object as json data
         let encoder = JSONEncoder()
         do {
             let data = try encoder.encode(user)
             UserDefaults.standard.set(data, forKey: Key.user)
             print("DataManager.save user success")
            
         } catch {
             print("DataManager.save user data error \(error.localizedDescription)")
         }
    }
    
    private func savePeerId(for user: User) {
        let peerId = MCPeerID(displayName: user.name)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: peerId, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: Key.userPeerId)
            print("DataManager.save peerId success")
            
        } catch let error {
            print("DataManager.save peerId data error \(error.localizedDescription)")
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
        
        // fall through for any other errors
        fatalError("DataManager.getPeerId unkown error")
    }
    
    func update(user: User) {
        save(user: user)
    }
    
    func updatePeerId(for user: User) {
        savePeerId(for: user)
    }
}
