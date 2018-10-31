//
//  main.swift
//  MidiNoteFormatter
//
//  Created by Nathaniel Day on 31/10/18.
//  Copyright © 2018 Nathaniel Day. All rights reserved.
//

import Foundation

let		theMidiNoteFormatter = MidiNoteFormatter();
theMidiNoteFormatter.accentStyle = [.sharp];

print("Midi number ot note name");
for m in 60...71 {
	print( "midi # \(m) = \(theMidiNoteFormatter.string(forMidiNote:m))");
}

print("\nNote name to Midi number");
for n in ["C3", "C♯3", "D3", "D♯3", "E3", "F3", "F♯3", "G3", "G♯3", "A3", "A♯3", "B3"] {
	let		r = theMidiNoteFormatter.midiNoteValue(for:n);
	if let m = r.value {
		print( "note \(n) = \(m)");
	} else {
		print( "error = \(r.error!)");
	}
}
