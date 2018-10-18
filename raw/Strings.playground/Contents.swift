import UIKit

let string = "Hi 😀"

// Array of characters
let characters: [Character] = Array(string)
// characters = ["H", "i", " ", "😀"]

// Character unicodeScalars property
let charScalarsView: Character.UnicodeScalarView = characters[0].unicodeScalars
let charScalars: [Unicode.Scalar] = Array(charScalarsView)
let charValues: [UInt32] = charScalars.map{ $0.value }
// charValues = [72]

// unicodeScalars property
let scalarsView: String.UnicodeScalarView = string.unicodeScalars
let arrayOfScalars: [Unicode.Scalar] = Array(scalarsView)
let valuesOfScalars: [UInt32] = arrayOfScalars.map { $0.value }
// valuesOfScalars = [72, 105, 32, 128512]

// utf16 property
let utf16View: String.UTF16View = string.utf16
let arrayOfWords: [UInt16] = Array(utf16View)
// arrayOfWords = [72, 105, 32, 55357, 56832]

// utf8 property
let utf8View: String.UTF8View = string.utf8
let arrayOfBytes: [UInt8] = Array(utf8View)
// arrayOfBytes = [72, 105, 32, 240, 159, 152, 128]


