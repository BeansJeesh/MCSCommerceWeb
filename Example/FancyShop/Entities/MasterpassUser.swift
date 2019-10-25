//
//  MasterpassUser.swift
//  FancyShop
//
//  Created by Ishar, Sahil on 10/14/19.
//  Copyright © 2019 Mastercard. All rights reserved.
//

import UIKit

class MasterpassUser: NSObject, NSCoding {
    //MARK: Variables
    
    /// User identifier
    var userId: String?
    
    /// User username, used in the login
    var username: String?
    
    /// User first name
    var firstName: String?
    
    /// User last name
    var lastName: String?
    
    /// User pairingId
    var pairingId: String?
    
    /// User pairing transaction id
    var pairingTransactionId: String?
    
    /// Singleton instance
    static let sharedInstance : MasterpassUser = {
        if let instance = DataPersisterManager.sharedInstance.getMasterpassUser() {
            return instance
        }
        return MasterpassUser()
    }()
    // MARK: Initializers
    // Private initializer
    private override init() {
        super.init()
    }
    
    // MARK: Methods
    /// Saves the user
    func saveUser(){
        DataPersisterManager.sharedInstance.saveMasterpassUser()
    }
    
    /// Validates if the user is logged in or not
    ///
    /// - Returns: Boolean indicating if the user is logged in
    func isLoggedIn() -> Bool {
        return !(self.userId ?? "").isEmpty
    }
    
    /// Validates if the user has a pairing id
    ///
    /// - Returns: Boolean indicating if the user has a pairing id
    func userHasPairingId() -> Bool {
        return !(self.pairingId ?? "").isEmpty
    }
    
    /// Validates if the user has a transaction pairing id
    ///
    /// - Returns: Boolean indicating if the user has a transaction pairing id
    func userHasTransactionPairingId() -> Bool {
        return !(self.pairingTransactionId ?? "").isEmpty
    }
    
    
    /// Deletes all user properties
    func doLogout() {
        self.userId = nil
        self.username = nil
        self.firstName = nil
        self.lastName = nil
        self.pairingId = nil
        self.pairingTransactionId = nil
        self.saveUser()
    }
    
    //MARK: NSCoding
    
    /// NSCoding Initializer
    ///
    /// - Parameters:
    ///   - coder: NSCoder instance
    internal required init?(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeObject(forKey: "userId") as? String
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.pairingId = aDecoder.decodeObject(forKey: "pairingId") as? String
        self.pairingTransactionId = aDecoder.decodeObject(forKey: "pairingTransactionId") as? String
        super.init()
    }
    
    /// NSCoding Method
    ///
    /// - Parameter aCoder: NSCoder instance
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userId, forKey:"userId")
        aCoder.encode(self.username, forKey:"username")
        aCoder.encode(self.firstName, forKey:"firstName")
        aCoder.encode(self.lastName, forKey:"lastName")
        aCoder.encode(self.pairingId, forKey: "pairingId")
        aCoder.encode(self.pairingTransactionId, forKey: "pairingTransactionId")
    }
}
