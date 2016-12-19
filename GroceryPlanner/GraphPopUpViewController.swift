//
//  GraphPopUpViewController.swift
//  GroceryPlanner
//
//  Created by Kanvi Khanna on 12/14/16.
//  Copyright © 2016 Prathyusha Makam Prasad. All rights reserved.
//

import UIKit
import CorePlot
import FirebaseAuth


class GraphPopUpViewController: UIViewController {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var hostView: CPTGraphHostingView!
    var expenses: [String:Float] = [:]
    var categories:[String] = []
    var amount:[Float] = []
    var total: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exitButton.transform = CGAffineTransform(scaleX: 1, y: -1);
        for(key,value) in expenses {
            categories.append(key)
            amount.append(value)
            total = total+value
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initPlot()
    }
    
    @IBAction func exitFromGraph(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func initPlot() {
        configureHostView()
        configureGraph()
        configureChart()
        configureLegend()
    }
    
    func configureHostView() {
        hostView.allowPinchScaling = false
    }
    
    func configureGraph() {
        // 1 - Create and configure the graph
        let graph = CPTXYGraph(frame: hostView.bounds)
        hostView.hostedGraph = graph
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        graph.axisSet = nil
        
        // 2 - Create text style
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontName = "HelveticaNeue-Bold"
        textStyle.fontSize = 16.0
        textStyle.textAlignment = .center
        
        // 3 - Set graph title and text style
        graph.title = ""
        graph.titleTextStyle = textStyle
        graph.titlePlotAreaFrameAnchor = CPTRectAnchor.top
    }
    
    func configureChart() {
        // 1 - Get a reference to the graph
        let graph = hostView.hostedGraph!
        
        // 2 - Create the chart
        let pieChart = CPTPieChart()
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
        pieChart.identifier = NSString(string: graph.title!)
        pieChart.startAngle = CGFloat(M_PI_4)
        pieChart.sliceDirection = .clockwise
        pieChart.labelOffset = -0.6 * pieChart.pieRadius
        
        // 3 - Configure border style
        let borderStyle = CPTMutableLineStyle()
        borderStyle.lineColor = CPTColor.clear()
        borderStyle.lineWidth = 2.0
        pieChart.borderLineStyle = borderStyle
        
        // 4 - Configure text style
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.textAlignment = .center
        pieChart.labelTextStyle = textStyle
        
        // 5 - Add chart to graph
        graph.add(pieChart)
    }
    
    func configureLegend() {
        // 1 - Get graph instance
        guard let graph = hostView.hostedGraph else { return }
        
        // 2 - Create legend
        let theLegend = CPTLegend(graph: graph)
        
        // 3 - Configure legend
        theLegend.numberOfColumns = 1
        theLegend.fill = CPTFill(color: CPTColor.white())
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 8
        theLegend.textStyle = textStyle
        
        // 4 - Add legend to graph
        graph.legend = theLegend
        if view.bounds.width > view.bounds.height {
            graph.legendAnchor = .right
            graph.legendDisplacement = CGPoint(x: -20, y: 0.0)
            
        } else {
            graph.legendAnchor = .bottomRight
            graph.legendDisplacement = CGPoint(x: -8.0, y: 8.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GraphPopUpViewController: CPTPieChartDataSource, CPTPieChartDelegate {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(expenses.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let amt = amount[Int(idx)]
        return amt
    }
    
    func dataLabel(for plot: CPTPlot, record idx: UInt) -> CPTLayer? {
        let value = amount[Int(idx)]
        let layer = CPTTextLayer(text: String(format: "\(categories[Int(idx)])\n%.2f", value))
        layer.textStyle = plot.labelTextStyle
        return layer
    }
    
    func sliceFill(for pieChart: CPTPieChart, record idx: UInt) -> CPTFill? {
        return nil
    }
    
    func legendTitle(for pieChart: CPTPieChart, record idx: UInt) -> String? {
        return categories[Int(idx)]
    }
  
}

