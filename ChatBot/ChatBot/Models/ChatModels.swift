//
//  ChatModels.swift
//  ChatBot
//
//  Created by vishalthakur on 17/09/22.
//

import Foundation
import MessageKit

struct TextMessage: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}


struct Sender: SenderType{
    var senderId: String
    
    var displayName: String
}

