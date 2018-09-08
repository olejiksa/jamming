//
//  Chart2ViewController.swift
//  Jamming
//
//  Created by Олег Самойлов on 08/05/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Cocoa
import Charts

class Chart2ViewController: NSViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        makeChart()
    }
    
    func makeChart() {
        guard Lattice.valuesForOneBig.count > 0 else { return }
        
        var ys0 = [Double]()
        for i in 0..<Lattice.valuesForOneBig.count {
            ys0.append(Lattice.valuesForOneBig[i][0])
            ys0.append(Lattice.valuesForTwoBig[i][0])
        }
        
        var ys1 = [Double]()
        for i in 0..<Lattice.valuesForOneBig.count {
            ys1.append(Lattice.valuesForOneBig[i][1])
            ys1.append(Lattice.valuesForTwoBig[i][1])
        }
        
        var ys2 = [Double]()
        for i in 0..<Lattice.valuesForOneBig.count {
            ys2.append(Lattice.valuesForOneBig[i][2])
            ys2.append(Lattice.valuesForTwoBig[i][2])
        }
        
        var ys3 = [Double]()
        for i in 0..<Lattice.valuesForOneBig.count {
            ys3.append(Lattice.valuesForOneBig[i][3])
            ys3.append(Lattice.valuesForTwoBig[i][3])
        }
        
        var ys4 = [Double]()
        for i in 0..<Lattice.valuesForOneBig.count {
            ys4.append(Lattice.valuesForOneBig[i][4])
            ys4.append(Lattice.valuesForTwoBig[i][4])
        }
        
        let yse0 = ys0.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse3 = ys3.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse4 = ys4.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        let data = LineChartData()
        
        let ds0 = LineChartDataSet(values: yse0, label: "Горизонтальные")
        ds0.drawValuesEnabled = false
        ds0.colors = [NSUIColor.systemBlue]
        ds0.circleRadius = 1.0
        ds0.circleColors = [NSUIColor.systemBlue]
        ds0.circleHoleColor = NSUIColor.systemBlue
        data.addDataSet(ds0)
        
        let ds1 = LineChartDataSet(values: yse1, label: "Горизонтальные")
        ds1.drawValuesEnabled = false
        ds1.colors = [NSUIColor.systemGreen]
        ds1.circleRadius = 1.0
        ds1.circleColors = [NSUIColor.systemBlue]
        ds1.circleHoleColor = NSUIColor.systemBlue
        data.addDataSet(ds1)
        
        let ds2 = LineChartDataSet(values: yse2, label: "Вертикальные")
        ds2.colors = [NSUIColor.systemOrange]
        ds2.drawValuesEnabled = false
        ds2.circleRadius = 1.0
        ds2.circleColors = [NSUIColor.systemRed]
        ds2.circleHoleColor = NSUIColor.systemRed
        data.addDataSet(ds2)
        
        let ds3 = LineChartDataSet(values: yse3, label: "Вертикальные")
        ds3.colors = [NSUIColor.systemPink]
        ds3.drawValuesEnabled = false
        ds3.circleRadius = 1.0
        ds3.circleColors = [NSUIColor.systemRed]
        ds3.circleHoleColor = NSUIColor.systemRed
        data.addDataSet(ds3)
        
        let ds4 = LineChartDataSet(values: yse4, label: "Вертикальные")
        ds4.colors = [NSUIColor.systemPurple]
        ds4.drawValuesEnabled = false
        ds4.circleRadius = 1.0
        ds4.circleColors = [NSUIColor.systemRed]
        ds4.circleHoleColor = NSUIColor.systemRed
        data.addDataSet(ds4)
        
        self.lineChartView.data = data
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.drawMarkers = false
        lineChartView.legend.enabled = false
        
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.chartDescription?.text = ""
        
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.decimalSeparator = "."
        lineChartView.xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.gridColor = NSUIColor.clear
        lineChartView.xAxis.drawGridLinesEnabled = false
    }
    
}
