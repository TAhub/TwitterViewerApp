//
//  RainbowViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/30/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class RainbowViewController: UIViewController {

	@IBOutlet weak var wavelengthSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var accessToggle: UISwitch!
	@IBOutlet weak var wavelengthLabel: UILabel!
	@IBOutlet weak var saturationLabel: UILabel!
	@IBOutlet weak var accessabilityLabel: UILabel!
	
	@IBAction func changedAccess()
	{
		saveSettings()
		setLabels()
	}
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		loadSettings()
		setLabels()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		saveSettings()
	}
	
	private func setLabels()
	{
		wavelengthLabel.text = "Rainbow Wavelength"
		saturationLabel.text = "Rainbow Saturation"
		accessabilityLabel.text = "Hard-of-Hearing Accessibility Mode"
		
		if NSUserDefaults.standardUserDefaults().boolForKey("access")
		{
			wavelengthLabel.text = wavelengthLabel.text!.uppercaseString
			saturationLabel.text = saturationLabel.text!.uppercaseString
			accessabilityLabel.text = accessabilityLabel.text!.uppercaseString
		}
	}
	
	private func loadSettings()
	{
		let defaults = NSUserDefaults.standardUserDefaults()
		wavelengthSlider.setValue(defaults.floatForKey("wavelength"), animated: false)
		saturationSlider.setValue(defaults.floatForKey("saturation"), animated: false)
		accessToggle.setOn(defaults.boolForKey("access"), animated: false)
	}
	
	private func saveSettings()
	{
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setFloat(wavelengthSlider.value, forKey: "wavelength")
		defaults.setFloat(saturationSlider.value, forKey: "saturation")
		defaults.setBool(accessToggle.on, forKey: "access")
	}
}
