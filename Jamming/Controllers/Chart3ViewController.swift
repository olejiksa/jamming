//
//  Chart3ViewController.swift
//  Jamming
//
//  Created by Олег Самойлов on 09/05/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Cocoa
import Charts

class Chart3ViewController: NSViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.maxValue = Double(Lattice.codesForOneBig.count-1)
        // Do any additional setup after loading the view.
        makeChart(0)
    }
    
    @IBOutlet weak var slider: NSSlider!
    
    func makeChart(_ value: Int) {
        guard Lattice.codesForOneBig.count > 0 else { return }
        
        // Do any additional setup after loading the view.
        let xArray: [Int]
        switch picker.selectedItem?.title {
        case "0":
            xArray = Array(1..<2)
        case "1":
            xArray = Array(1...4)
        case "2":
            xArray = Array(1...6)
        case "3":
            xArray = Array(1...4)
        case "4":
            xArray = Array(1..<2)
        default:
            xArray = [Int]()
        }
        
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.decimalSeparator = "."
        
        var ys1, ys2: [Double]
        var yse1, yse2: [BarChartDataEntry]
        
        ys1 = [0.0]
        ys2 = [0.0]
        
        switch picker.selectedItem?.title {
        case "0":
            ys1[0] = Lattice.valuesForOneBig[value][0]
            ys2[0] = Lattice.valuesForTwoBig[value][0]
        case "1":
            ys1 = [0.0, 0.0, 0.0, 0.0]
            ys2 = [0.0, 0.0, 0.0, 0.0]
            
            for i in 0..<Lattice.codesForOneBig[value].count {
                let val = Lattice.codesForOneBig[value][i]
                switch val {
                case "N":
                    ys1[0] += 1.0
                case "E":
                    ys1[1] += 1.0
                case "S":
                    ys1[2] += 1.0
                case "W":
                    ys1[3] += 1.0
                default:
                    break
                }
            }
            
            for i in 0..<Lattice.codesForTwoBig[value].count {
                let val = Lattice.codesForTwoBig[value][i]
                switch val {
                case "N":
                    ys2[0] += 1.0
                case "E":
                    ys2[1] += 1.0
                case "S":
                    ys2[2] += 1.0
                case "W":
                    ys2[3] += 1.0
                default:
                    break
                }
            }
        case "2":
            ys1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            ys2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            
            for i in 0..<Lattice.codesForOneBig[value].count {
                let val = Lattice.codesForOneBig[value][i]
                switch val.sorted() {
                case "NE".sorted():
                    ys1[0] += 1.0
                case "NS".sorted():
                    ys1[1] += 1.0
                case "NW".sorted():
                    ys1[2] += 1.0
                case "ES".sorted():
                    ys1[3] += 1.0
                case "EW".sorted():
                    ys1[4] += 1.0
                case "SW".sorted():
                    ys1[5] += 1.0
                default:
                    break
                }
            }
            
            for i in 0..<Lattice.codesForTwoBig[value].count {
                let val = Lattice.codesForTwoBig[value][i]
                switch val.sorted() {
                case "NE".sorted():
                    ys2[0] += 1.0
                case "NS".sorted():
                    ys2[1] += 1.0
                case "NW".sorted():
                    ys2[2] += 1.0
                case "ES".sorted():
                    ys2[3] += 1.0
                case "EW".sorted():
                    ys2[4] += 1.0
                case "SW".sorted():
                    ys2[5] += 1.0
                default:
                    break
                }
            }
        case "3":
            ys1 = [0.0, 0.0, 0.0, 0.0]
            ys2 = [0.0, 0.0, 0.0, 0.0]
            
            for i in 0..<Lattice.codesForOneBig[value].count {
                let val = Lattice.codesForOneBig[value][i]
                switch val.sorted() {
                case "NES".sorted():
                    ys1[0] += 1.0
                case "NEW".sorted():
                    ys1[1] += 1.0
                case "NSW".sorted():
                    ys1[2] += 1.0
                case "ESW".sorted():
                    ys1[3] += 1.0
                default:
                    break
                }
            }
            
            for i in 0..<Lattice.codesForTwoBig[value].count {
                let val = Lattice.codesForTwoBig[value][i]
                switch val.sorted() {
                case "NES".sorted():
                    ys2[0] += 1.0
                case "NEW".sorted():
                    ys2[1] += 1.0
                case "NSW".sorted():
                    ys2[2] += 1.0
                case "ESW".sorted():
                    ys2[3] += 1.0
                default:
                    break
                }
            }
        case "4":
            ys1[0] = Lattice.valuesForOneBig[value][4]
            ys2[0] = Lattice.valuesForTwoBig[value][4]
        default:
            break
        }
        
        yse1 = ys1.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
        yse2 = ys2.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
        
        let data = BarChartData()
        let ds1 = BarChartDataSet(values: yse1, label: "Hello")
        ds1.colors = [NSUIColor.systemBlue]
        ds1.valueFormatter = DefaultValueFormatter.init(formatter: fmt)
        data.addDataSet(ds1)
        
        let ds2 = BarChartDataSet(values: yse2, label: "World")
        ds2.colors = [NSUIColor.systemRed]
        ds2.valueFormatter = DefaultValueFormatter.init(formatter: fmt)
        data.addDataSet(ds2)
        
        let barWidth = 0.4
        let barSpace = 0.05
        let groupSpace = 0.1
        
        data.barWidth = barWidth
        self.barChartView.xAxis.axisMinimum = Double(xArray[0])
        self.barChartView.xAxis.axisMaximum = Double(xArray[0]) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(xArray.count)

        data.groupBars(fromX: Double(xArray[0]), groupSpace: groupSpace, barSpace: barSpace)
        
        barChartView.data = data
        barChartView.gridBackgroundColor = NSUIColor.white
        barChartView.chartDescription?.text = ""
        
        let months: [String]
        switch picker.selectedItem?.title {
        case "0":
            months = ["0", "0"]
        case "1":
            months = ["0", "N", "E", "S", "W"]
        case "2":
            months = ["0", "NE", "NS", "NW", "ES", "EW", "SW"]
        case "3":
            months = ["0", "NES", "NEW", "NSW", "ESW"]
        case "4":
            months = ["0", "NESW"]
        default:
            months = [String]()
        }
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.xAxis.granularity = 1

        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)
        
        barChartView.drawGridBackgroundEnabled = false
        barChartView.legend.enabled = false
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawAxisLineEnabled = true
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.gridColor = NSUIColor.clear
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.animate(yAxisDuration: 0.5, easingOption: .easeInOutQuart)
    }
    
    @IBAction func degreeChanging(_ sender: NSPopUpButton) {
        makeChart(Int(slider.intValue))
    }
    
    @IBOutlet weak var picker: NSPopUpButton!
    @IBAction func sliderChanging(_ sender: NSSlider) {
        makeChart(Int(slider.intValue))
    }
    
}

