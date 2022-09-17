//
//  ChatModels.swift
//  ChatBot
//
//  Created by vishalthakur on 17/09/22.
//

import Foundation
import MessageKit

///Model for a text message
struct TextMessage: MessageType{
    ///the sender of message
    var sender: SenderType
    ///the unique id
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}


struct Sender: SenderType{
    var senderId: String
    ///the name of person who sent the message
    var displayName: String
}

