//
//  ViewController.swift
//  Jamming
//
//  Created by Олег Самойлов on 10/04/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    private var lattice = Lattice()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var fieldSizeText: NSTextField!
    @IBOutlet weak var blockLengthText: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var runButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    static var isRunning = false
    
    @IBAction func stopAll(_ sender: NSButton) {
        ViewController.isRunning = false
        clearButton.isEnabled = true
    }
    
    private var timeOffset: TimeInterval?
    
    // MARK: - NSViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lattice.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.title = "Джаминг"
    }
    
    @IBOutlet weak var clearButton: NSButton!
    // MARK: - Actions
    
    @IBAction func clearAll(_ sender: Any) {
        Lattice.valuesForOneBig.removeAll()
        Lattice.valuesForTwoBig.removeAll()
        Lattice.codesForOneBig.removeAll()
        Lattice.codesForOneBig.removeAll()
        
        self.lattice.tableViewData.removeAll()
        self.lattice.blocks.removeAll()
        self.lattice.cells.removeAll()
        self.lattice.placeholders.removeAll()
        self.progressBar.doubleValue = 0.0
        clearButton.isEnabled = false
        tableView.reloadData()
    }
    
    var runner = DispatchQueue(label: "com.olejiksa.performer")

    @IBAction func didRunClick(_ sender: NSButton) {
        ViewController.isRunning = true
        self.clearButton.isEnabled = false
        
        if let n = Int(fieldSizeText.stringValue), let k = Int(blockLengthText.stringValue), k > 0, k <= n {
            runner.async {
                DispatchQueue.main.async {
                    self.runButton.isEnabled = false
                    self.stopButton.isEnabled = true
                    self.fieldSizeText.isEnabled = false
                    self.blockLengthText.isEnabled = false
                }
                
                Lattice.valuesForOneBig.removeAll()
                Lattice.valuesForTwoBig.removeAll()
                Lattice.codesForOneBig.removeAll()
                Lattice.codesForOneBig.removeAll()
                
                self.lattice.tableViewData.removeAll()
                self.lattice.blocks.removeAll()
                self.lattice.cells.removeAll()
                self.lattice.placeholders.removeAll()
                self.timeOffset = Date().timeIntervalSince1970
                self.lattice.create(fieldSize: n, blockLength: k)
                self.timeOffset = Date().timeIntervalSince1970 - self.timeOffset!
                
                DispatchQueue.main.async {
                    if ViewController.isRunning {
                        let alert = NSAlert()
                        alert.messageText = "Операция завершена"
                        alert.informativeText = "Время работы в секундах: \(self.timeOffset!)"
                        alert.alertStyle = .warning
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    } else {
                        let alert = NSAlert()
                        alert.messageText = "Операция прервана"
                        alert.informativeText = "Время работы в секундах: \(self.timeOffset!)"
                        alert.alertStyle = .warning
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    }
                    
                    self.runButton.isEnabled = true
                    self.fieldSizeText.isEnabled = true
                    self.blockLengthText.isEnabled = true
                    self.stopButton.isEnabled = false
                    self.clearButton.isEnabled = true
                    ViewController.isRunning = false
                }
            }
        } else {
            let alert = NSAlert()
            alert.messageText = "Ошибка"
            alert.informativeText = "Убедитесь в том, что значения N и K являются целыми положительными числами и K не превышает N."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    @IBAction func distribute(_ sender: NSMenuItem) {
        let mainStoryboard = NSStoryboard.init(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let controller = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "chart")) as! NSWindowController
        
        let chartVC = controller.contentViewController as? ChartViewController
        chartVC?.title = "Распределение степеней свободы"
        
        let window = NSApplication.shared.keyWindow
        window?.addTabbedWindow(controller.window!, ordered: .above)
    }
    
    @IBAction func timeline(_ sender: NSMenuItem) {
        let mainStoryboard = NSStoryboard.init(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let controller = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "chart2")) as! NSWindowController
        
        let chartVC = controller.contentViewController as? ChartViewController
        chartVC?.title = "Заполнение решетки"
        
        let window = NSApplication.shared.keyWindow
        window?.addTabbedWindow(controller.window!, ordered: .above)
    }
    
    @IBAction func menuItemClick(_ sender: NSMenuItem) {
        let mainStoryboard = NSStoryboard.init(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let controller = mainStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "chart3")) as! NSWindowController
        
        let chartVC = controller.contentViewController as? ChartViewController
        chartVC?.title = "Степеней свободы: \(sender.title)"
        
        let window = NSApplication.shared.keyWindow
        window?.addTabbedWindow(controller.window!, ordered: .above)
    }
    
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return lattice.blocks.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let tableViewData = lattice.tableViewData[row]
        
        var text = ""
        var cellIdentifier = ""
        
        if tableColumn == tableView.tableColumns[0] {
            text = tableViewData["Мест для ячейки"]!
            cellIdentifier = "firstID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = tableViewData["Координаты ячейки"]!
            cellIdentifier = "secondID"
        } else if tableColumn == tableView.tableColumns[3] {
            text = tableViewData["Ориентация"]!
            cellIdentifier = "thirdID"
        } else if tableColumn == tableView.tableColumns[5] {
            text = tableViewData["ρ заполнения решетки"]!
            cellIdentifier = "fourthID"
        } else if tableColumn == tableView.tableColumns[4] {
            text = tableViewData["Степеней свободы"]!
            cellIdentifier = "fifthID"
        } else if tableColumn == tableView.tableColumns[2] {
            text = tableViewData["Координаты хвоста"]!
            cellIdentifier = "sixthID"
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
}

extension ViewController: LatticeDelegate {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func incrementProgress(by value: Double) {
        DispatchQueue.main.async {
            self.progressBar.doubleValue = value
        }
    }
    
}
