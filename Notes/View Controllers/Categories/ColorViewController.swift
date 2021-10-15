//
//  ColorViewController.swift
//  Notes
//
//  Created by claudia maciel on 10/14/21.
//

import UIKit

protocol ColorViewControllerDelegate {
    func controller(_ controller: ColorViewController, didPick color: UIColor)
}

class ColorViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var colorView: UIView!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    
    var color: UIColor = .white
    
    // MARK: - Delegate
    var delegate: ColorViewControllerDelegate?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose Color"
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Notify Delegate
        delegate?.controller(self, didPick: (colorView.backgroundColor ?? .white))
    }
    
    // MARK: - Methods
    
    private func setupView() {
        setupSliders()
        setupColorView()
    }
    
    private func setupSliders() {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        // Extract Components
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        // Configure Sliders
        redSlider.value = Float(r)
        blueSlider.value = Float(b)
        greenSlider.value = Float(g)
    }
    
    private func setupColorView() {
        updateColorView()
    }
    
    private func updateColorView() {
        // Create Color
        let color = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1.0)
        
        colorView.backgroundColor = color
    }
    
    // MARK: - Actions
    @IBAction func colorDidChange(_ sender: UISlider) {
        // updateColorView
        updateColorView()
    }
    

}
