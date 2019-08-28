# MidiNoteFormatter
A subclass of Formatter that can convert to and from midi note numbers and midi note strings

# USAGE

To convert a string representing a MIDI note into an Int you can use _MidiNoteFormatter()_ with default configuration
``` swift
let midiNote = MidiNoteFormatter().midiNoteValue(for:"A♯0").value
```
_MidiNoteFormatter_ will treat recognise # and ♯ as sharps and b and ♭ as flat

To convert an Int to string representing a MIDI note.
``` swift
let string = MidiNoteFormatter().stringFromDate(midiNote)
```

Whether to output accents as sharps or flats or both can be specified with the _accentStyle_ property, for example to require both sharps and flats be output
``` swift
let formatter = MidiNoteFormatter()
formatter.accentStyle = [.flat,.sharp]
```

To use ASCII characters instead of unicode characters for thhe accents set the property _asciiStyle_ to true
``` swift
let formatter = MidiNoteFormatter()
formatter.asciiStyle = true
```
