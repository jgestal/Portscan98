//
//  ViewController.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 26/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

enum ScanState {
    case stop
    case running
    case pause
}

class PortscanViewController: UIViewController {
    
    
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var startSocketTextField: UITextField!
    @IBOutlet weak var endSocketTextField: UITextField!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var progressViewController: W98ProgressViewController!
    
    var state : ScanState = .stop
    var index = 0
    var openSocketCounter = 0
    var openSockets = [UInt16]()
    var target = ""
    var startAt = 0
    var endAt = 0
    var completed = false
    var startDate : Date?
    var acumTime : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kDialogProgressViewControllerID" {
            progressViewController = segue.destination as! W98ProgressViewController
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if sender.tag == 0 {
            _ = validateHost()
        }
    }
    
    @IBAction func textFieldEditingDidEnd(_ sender: UITextField) {
        
        func adjustTextFieldSocketNumber(text: String, defaultNumber: Int) -> String {
            var number = Int(text) ?? defaultNumber
            if number < MIN_SOCKET_NUMBER { number = MIN_SOCKET_NUMBER }
            if number > MAX_SOCKET_NUMBER { number = MAX_SOCKET_NUMBER }
            return String(number)
        }
        
        // Start Socket
        if sender.tag == 1 {
            sender.text = adjustTextFieldSocketNumber(text: sender.text!, defaultNumber: MIN_SOCKET_NUMBER)
        }
            
            // End Socket
        else if sender.tag == 2 {
            sender.text = adjustTextFieldSocketNumber(text: sender.text!, defaultNumber: MAX_SOCKET_NUMBER)
        }
    }
    
    func validateSockets() -> Bool {
        
        let start = Int(startSocketTextField.text!) ?? MIN_SOCKET_NUMBER
        let end = Int(endSocketTextField.text!) ?? MAX_SOCKET_NUMBER
        
        if start <= end {
            startSocketTextField.textColor = .black
            endSocketTextField.textColor = .black
            return true
        } else {
            startSocketTextField.textColor = .red
            endSocketTextField.textColor = .red
            return false
        }
    }
    
    func validateHost() -> Bool {
        if String.isValidHost(hostStr: hostTextField.text!) {
            hostTextField.textColor = UIColor.black
            return true
        } else {
            hostTextField.textColor = UIColor.red
            return false
        }
    }
    
    //*****************************
    // MARK: - Button Actions
    //*****************************
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Credits", message: "App created by Juan Gestal (juan@gestal.es) \n https://www.gestal.es/", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        guard validateSockets() else {
            let alert = UIAlertController.init(title: "Error", message: "You must provide a valid range of sockets (\(MIN_SOCKET_NUMBER) - \(MAX_SOCKET_NUMBER)).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard validateHost() else {
            let alert = UIAlertController.init(title: "Error", message: "You must provide a valid host or IP to scan.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        target = hostTextField.text!
        if state == .running {
            pauseScan()
        } else if state == .pause {
            continueScan()
        } else if state == .stop {
            startScan()
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        if state == .stop {
            clean()
            stopButton.setTitle("STOP", for: .normal)
        } else {
            stopScan()
            stopButton.setTitle("CLEAR", for: .normal)
        }
    }
    
    //*****************************
    // MARK: - UI Update
    //*****************************
    
    @objc func updateUI() {
        
        if state == .running {
            startButton.setTitle("PAUSE", for: .normal)
            stopButton.setTitle("STOP", for: .normal)
        } else if state == .pause {
            startButton.setTitle("CONTINUE", for: .normal)
            stopButton.setTitle("STOP", for: .normal)
        } else if state == .stop {
            startButton.setTitle("START", for: .normal)
        }
        
        if state == .stop {
            startSocketTextField.isEnabled = true
            endSocketTextField.isEnabled = true
            hostTextField.isEnabled = true
            
        } else {
            startSocketTextField.isEnabled = false
            endSocketTextField.isEnabled = false
            hostTextField.isEnabled = false
            
            timeLabel.text = "Time: " + elapsedTime()
            let total = endAt - startAt + 1
            let progress = CGFloat(index - openSocketCounter) / CGFloat(total)
            progressViewController.updateProgress(progress)
        }
    }
    
    func elapsedTime () -> String {
        if let startDate = startDate {
            let elapsed = Date().timeIntervalSince(startDate) + acumTime
            return String(Int(elapsed))
        }
        else if acumTime > 0 {
            return String(Int(acumTime))
        } else {
            return ""
        }
    }
    
    //*****************************
    // MARK: - Main Functions
    //*****************************
    
    func clean() {
        progressViewController.updateProgress(0)
        statusLabel.text = "Looking:"
        timeLabel.text = "Time:"
        openSockets = [UInt16]()
        tableView.reloadData()
        
    }
    
    func startScan() {
        startAt = Int(startSocketTextField.text!) ?? MIN_SOCKET_NUMBER
        endAt = Int(endSocketTextField.text!) ?? MAX_SOCKET_NUMBER
        index = 0
        acumTime = 0
        openSocketCounter = 0
        openSockets = [UInt16]()
        tableView.reloadData()
        continueScan()
    }
    
    func continueScan() {
        state = .running
        startDate = Date()
        openNext()
        updateUI()
    }
    
    func pauseScan() {
        state = .pause
        updateAcumtime()
        updateUI()
    }
    
    func stopScan() {
        startSocketTextField.isEnabled = false
        endSocketTextField.isEnabled = false
        hostTextField.isEnabled = false
        state = .stop
        updateAcumtime()
        updateUI()
    }
    
    func updateAcumtime() {
        if let startDate = startDate {
            acumTime += Date().timeIntervalSince(startDate)
        }
        startDate = nil
    }
    
    func foundedSocketOpen(host: String, port: UInt16) {
        print("*** Founded Socket Open: \(port)")
        if state != .stop {
            openSockets.append(port)
            openSockets = openSockets.sorted()
            tableView.reloadData()
            updateUI()
        }
    }
    
    func socketClosed() {
        if state != .stop {
            openSocketCounter -= 1
            openNext()
        }
        
        if startAt + index > endAt && openSocketCounter == 0 {
            state = .stop
            statusLabel.text = "Scan completed"
            print("*** Scan Completed")
            stopScan()
        }
        updateUI()
    }
    
    
    func openNext() {
        
        let next = startAt + index
        
        if state == .running && next <= endAt && openSocketCounter < MAX_CURRENT_CONNECTIONS {
            print("*** Open Next: \(next)")
            openSocketCounter += 1
            statusLabel.text = "Looking: \(next)"
            openSocket(host: target, port: UInt16(next), timeout: TIMEOUT)
            index += 1
            openNext()
        }
        updateUI()
    }
}

//*****************************
// MARK: - TextFieldDelegate
//*****************************

extension PortscanViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//*****************************
// MARK: - TableView
//*****************************

extension PortscanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SocketOpenTableViewCell.reuseID, for: indexPath) as! SocketOpenTableViewCell
        let nSocket = Int(openSockets[indexPath.row])
        
        cell.socketLabel.text = String(nSocket)
        cell.descriptionLabel.text = SocketInfo.shared.sockets[nSocket] ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openSockets.count
    }
}

//*****************************
// MARK: - GDAsyncSocket
//*****************************

extension PortscanViewController: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        foundedSocketOpen(host: host, port: port)
        sock.disconnect()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        socketClosed()
        if let error = err  {
            print("*** Socket did Disconnect: \(error.localizedDescription)")
        }
    }
    
    func openSocket(host: String, port: UInt16, timeout: TimeInterval)
    {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try socket.connect(toHost: host, onPort: port, withTimeout: timeout)
        } catch let error {
            print("*** Open Socket Error: \(error.localizedDescription)")
        }
    }
}



