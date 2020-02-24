//
//  ManageTimerViewController.swift
//  LocalNotificationTimerApp
//
//  Created by Tiffany Obi on 2/20/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import UserNotifications


class ManageTimerViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications = [UNNotificationRequest]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let center = UNUserNotificationCenter.current()
    private let pendingNotifications = PendingNotification()
    private var refreshControl: UIRefreshControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications()
        configureRefreshControl()
        tableView.dataSource = self
        center.delegate = self
        checkNotificationAuthorization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let setTimerVC = segue.destination as? SetTimerViewController else {
            fatalError("could not downcast to SetTimerViewControler")
        }
       
        
        setTimerVC.delegate = self
        print("Success")
    }

    
    private func configureRefreshControl(){
    refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadNotifications), for: .valueChanged)
    }
    
    @objc private func loadNotifications() {
        pendingNotifications.getPendingNotifications { (requests) in
            self.notifications = requests
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func checkNotificationAuthorization() {//the settings var will give us imformation if we are authorized
      center.getNotificationSettings { (settings) in
        if settings.authorizationStatus == .authorized {
          print("app is authorized for notifications")
        } else {
          //if we will prone the user for permission
          self.requestNotificationPermissions()
        }
      }
    }

    private func requestNotificationPermissions(){
      center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
          
          if let error = error {
              print("error \(error)")
              return
          }
          
          if granted {
              print("access granted")
          } else {
              print("access denied")
          }
          
      }
    }
}

extension ManageTimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.content.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
}

extension ManageTimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

extension ManageTimerViewController: SetTimerControllerDelegate {
    func didCreateNotification(_ setTimerViewController: SetTimerViewController) {

        loadNotifications()
    }
    
    
}
