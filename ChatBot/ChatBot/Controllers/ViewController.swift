//
//  ViewController.swift
//  ChatBot
//
//  Created by vishalthakur on 17/09/22.
//

import UIKit
import MessageUI
import MessageKit
import InputBarAccessoryView

class ViewController:  MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    //MARK: Variables
    
    let currentUser = Sender(senderId: "self", displayName: "Vishal")
    let otherUser = Sender(senderId: "other", displayName: "Priya")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var conversation = [Conversation]()
    var selectedMessage: Int = -1
    var messages = [TextMessage]()
    
    //MARK: Input methods
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        //Sending new message
        if selectedMessage == -1 {
            let conversation = Conversation(context: self.context)
            conversation.message = text
            conversation.displayName = Bool.random() ? currentUser.displayName : otherUser.displayName
            conversation.id = messages.count > 0 ? UUID().uuidString : messages.last?.messageId ?? "0"
            do{
                try context.save()
            }
            catch{
                
            }
            self.getMessages(true)
            inputBar.inputTextView.text = String()
            inputBar.inputTextView.resignFirstResponder()
            
        }
        //Editing a message
        else{
            let conv = conversation[selectedMessage]
            
            conv.message = text
            
            do{
                try context.save()
            }
            catch{
                
            }
            
            self.getMessages()
            inputBar.inputTextView.text = String()
            inputBar.inputTextView.resignFirstResponder()
            selectedMessage = -1
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackground()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        getMessages(true)
        
    }
    
    //MARK: Private methods
    
    ///Set Whatsapp style background.
    private func setBackground(){
        guard let image = UIImage(named: "image.png") else{
            return
        }
        self.view.backgroundColor = UIColor(patternImage: image)
        messagesCollectionView.backgroundColor = .clear
    }
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    ///Get messages from local storage
    /// - Parameters:
    ///   - firstLoad: indicating value so that screen scrolls to last message if required.
    private func getMessages(_ firstLoad: Bool = false){
        
        do{
            self.conversation = try context.fetch(Conversation.fetchRequest())
            self.messages.removeAll()
            setData()
            
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                if firstLoad{
                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: false)
                }
            }
            
        }
        catch{
            
        }
        
        
    }
    
    ///Modify data to be saved in messages array for local storage
    private func setData(){
        for item in self.conversation{
            
            //Need to workaround as forgot to add sender in coredata
            
            let name = item.displayName ?? "sender"
            let sender = currentSender().displayName == name ? currentUser : otherUser
            let id = "\(item.id)"
            let message = item.message ?? "message"
            messages.append(TextMessage(sender: sender, messageId: id, sentDate: Date().addingTimeInterval(-86400), kind: .text(message)))
        }
    }
    
    
    
}

extension ViewController: MessageCellDelegate,UITextViewDelegate{
    ///Edit the message.
    ///  - Parameters :
    ///     - cell : the corrresponding message to be edited
    func didTapEdit(in cell: MessageCollectionViewCell) {
        let indexPath = messagesCollectionView.indexPath(for: cell)!
        let message = messageForItem(at: indexPath, in: messagesCollectionView)
        selectedMessage = indexPath.section
        messageInputBar.inputTextView.text = getTheMessageText(messageKind: message.kind)
        messageInputBar.inputTextView.becomeFirstResponder()
        
    }
    
    ///Get message from the custom type "kind"
    func getTheMessageText(messageKind: MessageKind) -> String {
        if case .text(let value) = messageKind {
            return value
        }
        return ""
    }
    ///Set avatar image
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.displayName == currentUser.displayName{
        avatarView.set(avatar: Avatar(image: UIImage(systemName: "person.circle.fill"), initials: "VT"))
        }
        else{
            avatarView.set(avatar: Avatar(image: UIImage(systemName: "person.circle.fill"), initials: "PM"))
        }
    }
    
}
