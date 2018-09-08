//
//  ChartViewController
//  Jamming
//
//  Created by Олег Самойлов on 13/04/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Cocoa
import Charts

class ChartViewController: NSViewController {
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.title = "Распределение степеней свободы"
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.maxValue = Double(Lattice.valuesForOneBig.count - 1)
        
        // Do any additional setup after loading the view.
        makeChart(0)
    }
    
    @IBAction func didSaveClick(_ sender: NSButton) {
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["png"]
        panel.beginSheetModal(for: self.view.window!) { (result) -> Void in
            if result == NSApplication.ModalResponse.OK
            {
                if let path = panel.url?.path
                {
                    let _ = self.lineChartView.save(to: path, format: .png, compressionQuality: 1.0)
                }
            }
        }
    }
    
    func makeChart(_ value: Int) {
        guard Lattice.valuesForOneBig.count > 0 else { return }
        
        let ys1 = Lattice.valuesForOneBig[value]
        let ys2 = Lattice.valuesForTwoBig[value]
        
        let yse1 = ys1.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: y) }
        
        let data = LineChartData()
        let ds1 = LineChartDataSet(values: yse1, label: "Горизонтальные")
        ds1.drawValuesEnabled = false
        ds1.colors = [NSUIColor.systemBlue]
        ds1.circleRadius = 3.0
        ds1.circleColors = [NSUIColor.systemBlue]
        ds1.circleHoleColor = NSUIColor.systemBlue
        data.addDataSet(ds1)
        
        let ds2 = LineChartDataSet(values: yse2, label: "Вертикальные")
        ds2.colors = [NSUIColor.systemRed]
        ds2.drawValuesEnabled = false
        ds2.circleRadius = 3.0
        ds2.circleColors = [NSUIColor.systemRed]
        ds2.circleHoleColor = NSUIColor.systemRed
        data.addDataSet(ds2)
        
        let gradientColors = [NSColor.systemBlue.cgColor, NSColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { return }
        ds1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        ds1.drawFilledEnabled = true
        
        let gradientColors2 = [NSColor.systemRed.cgColor, NSColor.clear.cgColor] as CFArray
        guard let gradient2 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors2, locations: colorLocations) else { return }
        ds2.fill = Fill.fillWithLinearGradient(gradient2, angle: 90.0)
        ds2.drawFilledEnabled = true
        
        self.lineChartView.data = data
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.drawMarkers = false
        lineChartView.legend.enabled = false
        lineChartView.chartDescription?.text = ""
        
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.decimalSeparator = "."
        lineChartView.leftAxis.axisMinimum = 0.0
        lineChartView.xAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)
        lineChartView.xAxis.labelCount = 4
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: fmt)
        lineChartView.xAxis.axisMaximum = 4.0
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.gridColor = NSUIColor.clear
        lineChartView.xAxis.drawGridLinesEnabled = false
    }
    
    @IBAction func sliderActing(_ sender: NSSlider) {
        makeChart(Int(slider.intValue))
    }
    
}
