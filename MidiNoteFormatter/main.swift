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


for (i,n) in ["C3", "C♯3", "D3", "D♯3", "E3", "F3", "F♯3", "G3", "G♯3", "A3", "A♯3", "B3", "C4", "C♯4", "D4", "D♯4", "E4", "F4", "F♯4", "G4", "G♯4", "A4", "A♯4", "B4"].enumerated() {
  assert( theMidiNoteFormatter.string(forMidiNote:(48+i)) == n )
  assert( theMidiNoteFormatter.midiNoteValue(for:n).value == 48+i )
}

for m in 0...127 {
  assert( theMidiNoteFormatter.midiNoteValue(for:theMidiNoteFormatter.string(forMidiNote:m)).value == m )
}

theMidiNoteFormatter.accentStyle = [.flat]
for (i,n) in ["C3", "D♭3", "D3", "E♭3", "E3", "F3", "G♭3", "G3", "A♭3", "A3", "B♭3", "B3", "C4", "D♭4", "D4", "E♭4", "E4", "F4", "G♭4", "G4", "A♭4", "A4", "B♭4", "B4"].enumerated() {
  assert( theMidiNoteFormatter.string(forMidiNote:(48+i)) == n )
  assert( theMidiNoteFormatter.midiNoteValue(for:n).value == 48+i )
}

for m in 0...127 {
  assert( theMidiNoteFormatter.midiNoteValue(for:theMidiNoteFormatter.string(forMidiNote:m)).value == m )
}



