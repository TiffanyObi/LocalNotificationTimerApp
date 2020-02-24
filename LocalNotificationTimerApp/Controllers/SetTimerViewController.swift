//
//  SetTimerViewController.swift
//  LocalNotificationTimerApp
//
//  Created by Tiffany Obi on 2/20/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol SetTimerControllerDelegate: AnyObject {
    
    func didCreateNotification(_ setTimerViewController: SetTimerViewController)
}


class SetTimerViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var timerPickerView: UIPickerView!
    
    @IBOutlet weak var startTimerButton: UIButton!
    
     weak var delegate: SetTimerControllerDelegate?
    
    private var timeDetails = ["Hours", "Minutes", "Seconds"]
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5
    private var message = "Timer Finished" {
        didSet {
            message = titleTextField.text ?? "No Message"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        timerPickerView.dataSource = self
        timerPickerView.delegate = self
    }
    
    private func createLocalNotifications(with message: String){
            let content = UNMutableNotificationContent()
            content.title = message
            content.sound = .default // only works in the background and when phone is not on silent
            //Todo: userInfo dict. can hold additional data
            //Todo:
            //create identifier =
            let identifier = UUID().uuidString
            if let imageURL = Bundle.main.url(forResource: "swift-logo", withExtension: "png") {
                
                do {
                    
            let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
                    
                    content.attachments = [attachment]
                    
                } catch {
                    print("error with attachment \(error)")
                }
            
            } else {
                print("image resource could not be found")
            }
            
            
            // create trigger
            // there are 3 possible triggers for local notifications : timeInterval, calender, location
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            //creat request
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            //add request to the UNNotification center
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("error adding request \(error)")
                } else {
                    print("request was succesfully added")
            }
        }
    }
    
   
    
    
    @IBAction func startTimerButtonPressed(_ sender: UIButton) {
        (0...2).forEach {
            timeInterval += Double(timerPickerView.selectedRow(inComponent: $0))
        }
        createLocalNotifications(with: message)
        print(message)
        delegate?.didCreateNotification(self)
        dismiss(animated: true, completion: nil)
    }
    
  
}

extension SetTimerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return timeDetails.count
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return 24
        case 1:
            return 60
        case 2:
            return 60
        default:
            return 0
        }

    }
}

extension SetTimerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if row != 1 {
                return "\(row) \(timeDetails[component])"
            } else {
                return" \(row) Hour"
            }
        case 1:
            
            if row != 1 {
           return "\(row) \(timeDetails[component])"
            } else {
                return "\(row) Minute"
            }
        case 2:
            
            if row != 1 {
            return "\(row) \(timeDetails[component])"
            } else {
                return "\(row) Second"
            }
        default:
            return nil
        }
    }
}

extension SetTimerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let timerMessage = textField.text,
            textField.text != nil else {
                return
        }
        message = timerMessage
     
    }
    
}
