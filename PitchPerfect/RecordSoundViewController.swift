//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Martina Klimova on 01/03/2017.
//  Copyright © 2017 Martina Klimova... All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
	var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var stopRecordingButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}



	@IBAction func recordAudio(_ sender: Any) {
		
		configureUI(recording: true)
		
		let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
		let recordingName = "recordedVoice.wav"
		let pathArray = [dirPath, recordingName]
		
		let filePath = URL(string: pathArray.joined(separator: "/"))
		print(filePath as Any)
		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
		
		try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
		audioRecorder.delegate = self
		audioRecorder.isMeteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}
	func configureUI(recording: Bool) {
		recordingLabel.text = recording ? "Recording in progress" : "Tap to Record"
		stopRecordingButton.isEnabled = recording
		recordButton.isEnabled = !recording
		
	}
	
	
		
	
	
	@IBAction func stopRecording(_ sender: Any) {
		configureUI(recording: false)
		audioRecorder.stop()
		let audioSession = AVAudioSession.sharedInstance()
		try! audioSession.setActive(false)
	}
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		if flag { performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) }
							else { print("recording was not successfull")
			
			}
}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "stopRecording" {
			let playSoundVC = segue.destination as! PlaySoundsViewController
			let recordedAudioURL = sender  as! URL
			playSoundVC.recordedAudioURL = recordedAudioURL
		}
	}
}
