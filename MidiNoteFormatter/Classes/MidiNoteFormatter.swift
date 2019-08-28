//
//  MidiNoteFormatter.swift
//  Intonation
//
//  Created by Nathaniel Day on 6/06/18.
//  Copyright © 2018 Nathan Day. All rights reserved.
//

import Foundation

/// A Formatter subclass that converts between midi note nuber values and their textual representations.
///
/// Instances of MidiNoteFormatter format the textual representation of NSNumber objects
/// and convert textual representations of numeric values into NSNumber objects. The representation
/// are midi note number from 0 to 127.
class MidiNoteFormatter: Formatter {

  /// The predefined midi note name accent styles used by the accentStyle property.
  enum AccentStyle : CustomStringConvertible {
    case flat
    case sharp
    case natural
    var description: String {
      switch self {
      case .flat: return "♭"
      case .sharp: return "♯"
      case .natural: return "♮"
      }
    }
    var ascii: String {
      switch self {
      case .flat: return "b"
      case .sharp: return "#"
      case .natural: return " "
      }
    }
  }

  /// The midi note formatter style used by the receiver.
  ///
  /// Styles are a set of values for accent styles. Valid styles are .flat, .sharp, .natural.
  /// Used when generating string's whether accent notes should be named as sharp, flat or both, whether natural
  ///  notes should be explicitly label natural or not.
  /// The default value is [.sharp].
  public var    accentStyle : Set<AccentStyle> = [.sharp]

  /// ASCII string only
  ///
  /// Instead of using unicode characters ♭, ♯, and ♮ use b, # and ' '
  /// The default value is false.
  public var    asciiStyle : Bool = false

  private func noteString( note aNote: Int, accentStyle aAccentStyle : AccentStyle? ) -> String {
    let    flatNoteNames = ["C", "D", "D", "E", "E", "F", "G", "G", "A", "A", "B", "B"]
    let    shartNoteNames = ["C", "C", "D", "D", "E", "F", "F", "G", "G", "A", "A", "B"]
    let    noteNames = aAccentStyle == .sharp ? shartNoteNames : flatNoteNames
    let    accent = asciiStyle ? aAccentStyle?.ascii : aAccentStyle?.description
    return "\(noteNames[aNote])\(accent ?? "")"
  }

  /// Returns a string containing the formatted value of the provided midi note number.
  ///
  /// - Parameter anMidiNote: An NSNumber object that is parsed to create the returned string object.
  /// - Returns: A string containing the formatted value of number using the receiver’s current settings.
  open func string(forMidiNote anMidiNote: Int) -> String {
    var    theResult = ""
    let    theNoteNumber = anMidiNote%12
    let    theOctave = anMidiNote/12 - 1
    let    theAccidental = (theNoteNumber%2 == 1) != (theNoteNumber>4)
    if theAccidental {
      if accentStyle.isSuperset(of:[.flat,.sharp]) {
        theResult = noteString(note: theNoteNumber, accentStyle: .sharp) + "/" + noteString(note: theNoteNumber, accentStyle: .flat) + "\(theOctave)"
      } else if accentStyle.contains(.flat) {
        theResult = noteString(note: theNoteNumber, accentStyle: .flat) + "\(theOctave)"
      } else if accentStyle.contains(.sharp) {
        theResult = noteString(note: theNoteNumber, accentStyle: .sharp) + "\(theOctave)"
      }
    }
    else if accentStyle.contains(.natural) {
      theResult = noteString(note: theNoteNumber, accentStyle: .natural) + "\(theOctave)"
    } else {
      theResult = noteString(note: theNoteNumber, accentStyle: nil) + "\(theOctave)"
    }
    return theResult
  }

  /// overrides the Formatter implementation to turn a NSNumber into a String
  open override func string(for anObj: Any?) -> String? {
    guard let theObj = anObj as? NSNumber  else {
      return nil
    }
    return string(forMidiNote:theObj.intValue)
  }

  /// Returns an (value:Int?,error:String?) tuple created by parsing a given string.
  ///
  /// If a string is not a valid note name, parsing will fail. Any leading or trailing space separator
  /// characters in a string are ignored. For example, the strings “ A4”, “A4 ”, and “A4” all produce
  /// the number 69.
  /// - Parameter aString: A String object that is parsed to generate the returned number object.
  /// - Returns: An NSNumber object created by parsing string using the receiver’s format, or nil
  /// if no single number could be parsed.
  open func midiNoteValue(for aString: String ) -> (value:Int?,error:String?) {
    var    theResult = 0
    let    theScanner = Scanner(string:aString)
    let    theValidNoteCharacters = "cdefgabCDEFGAB"
    if let theNoteName = theScanner.scanCharacters(from:CharacterSet(charactersIn:theValidNoteCharacters) ) {
      guard let theChar = theNoteName.first else {
        return (nil,"internal error")
      }
      var   theNoteNumber = (theValidNoteCharacters.firstIndex(of: theChar)?.utf16Offset(in: theValidNoteCharacters))!%7*2;
      var   theOctave = 0
      if theNoteNumber > 4 {    // no e sharp/ f flat
        theNoteNumber -= 1
      }

      switch theNoteName.count {
      case 1:
        switch theScanner.scanCharacters(from:CharacterSet(charactersIn:"#b♯♭♮") ) {
        case "#"?, "♯"?:
          theNoteNumber += 1
        case "b"?, "♭"?:
          theNoteNumber -= 1
        default:
          break
        }
      case 2 where theNoteName.hasSuffix("b"):    // if we matched a second character that is a b treat it as a flat
          theNoteNumber -= 1
      default:
        return (value:nil,error:"invalid string")
      }

      if( theScanner.scanInt(&theOctave) ) {
        if theNoteNumber >= 12 {
          theNoteNumber = theNoteNumber%12
          theOctave += 1
        }
        while theNoteNumber < 0 {
          theNoteNumber += 12
          theOctave -= 1
        }
      } else {
        theOctave = 4
      }
      theResult = theNoteNumber+(theOctave+1)*12
    }
    else {
      guard let theIntegerValue = Int(aString) else {
        return (nil,"invalid string")
      }
      theResult = theIntegerValue
    }

    if theResult < 0 || theResult > 127 {
      return (value:theResult,error:"out of bounds value \(theResult)")
    }
    return (value:theResult,error:nil)
  }

  /// overrides the Formatter implementation to turn a String into a NSNumber
  open override func getObjectValue(_ anObj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for aString: String, errorDescription anError: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    let theResult = midiNoteValue(for: aString )

    if let theValue = theResult.value {
      anObj?.pointee = NSNumber(value:theValue)
    }
    if let theError = theResult.error {
      anError?.pointee = NSString(string:theError)
    }
    return theResult.error == nil
  }

}
