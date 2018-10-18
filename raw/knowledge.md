# Swift.String

## Goal

Clarify dependencies between neighbour Swift String classes

## Tasks

- develop **func codePointAt(_ pos:Int) -> Int** for String
- how interact classes String, Character, Unicode
- How encoding works: UTF-8, UTF-16, UTF-32

## Terms
1. Unicode scalar value (combine or solely creates a Character)

## [Swift.String][Swift String Docs]
> A string is a series of characters

> Comparing strings for equality using the equal-to operator (==) or a relational operator (like < or >=) is always performed using Unicode canonical representation. As a result, different representations of a string compare as being equal.

    let cafe1 = "Cafe\u{301}"
    let cafe2 = "Café"
    print(cafe1 == cafe2)

    The Unicode scalar value "\u{301}" modifies the preceding character to include an accent, so "e\u{301}" has the same canonical representation as the single Unicode scalar value "é".

> A string is a collection of extended grapheme clusters, which approximate human-readable characters. Many individual characters, such as “é”, “김”, and “🇮🇳”, can be made up of multiple Unicode scalar values. These scalar values are combined by Unicode’s boundary algorithms into extended grapheme clusters, represented by the Swift Character type. Each element of a string is represented by a Character instance.

> If you need to access the contents of a string as encoded in different Unicode encodings, use one of the string’s unicodeScalars, utf16, or utf8 properties. Each property provides access to a view of the string as a series of code units, each encoded in a different Unicode encoding.

### Unicode Scalar View

    let cafe = "Cafe\u{301} du 🌍"
    print(cafe)
    // Prints "Café du 🌍"
 ---
    print(cafe.unicodeScalars.count)
    // Prints "10"
    print(Array(cafe.unicodeScalars))
    // Prints "["C", "a", "f", "e", "\u{0301}", " ", "d", "u", " ", "\u{0001F30D}"]"
    print(cafe.unicodeScalars.map { $0.value })
    // Prints "[67, 97, 102, 101, 769, 32, 100, 117, 32, 127757]"

### UTF16 View
The elements of the utf16 view are the code units for the string when encoded in UTF-16. These elements match those accessed through indexed NSString APIs.

    let nscafe = cafe as NSString
    print(nscafe.length)
    // Prints "11"
    print(nscafe.character(at: 3))
    // Prints "101"

### UTF8 View
The elements of the utf8 view are the code units for the string when encoded in UTF-8. This representation matches the one used when String instances are passed to C APIs.

    let cLength = strlen(cafe)
    print(cLength)
    // Prints "14"


### Methods
1. String().unicodeScalars: String.UnicodeScalarView
1. String().utf16: String.UTF16View
1. String().utf8: String.UTF8View
1. Array(String()) -> [Character]
1. String().count -> Int - number of characters, not Unicode scalars
1. String().samePosition(in:)
1. String.init(_:within:)
1. String.init(Unicode.Scalar)

### Swift.String.UnicodeScalarView
Array of 'Unicode.Scalar' elements
> You can access a string’s view of Unicode scalar values by using its unicodeScalars property. Unicode scalar values are the 21-bit codes that are the basic unit of Unicode. Each scalar value is represented by a Unicode.Scalar instance and is equivalent to a UTF-32 code unit.

### Swift.String.UTF16View
Array of UInt16
>You can access a string’s view of UTF-16 code units by using its utf16 property. A string’s UTF-16 view encodes the string’s Unicode scalar values as 16-bit integers. 

### Swift.String.UTF8View
Array of UInt8
>You can access a string’s view of UTF-8 code units by using its utf8 property. A string’s UTF-8 view encodes the string’s Unicode scalar values as 8-bit integers.

>A string’s Unicode scalar values can be up to 21 bits in length. To represent those scalar values using 8-bit integers, more than one UTF-8 code unit is often required.

>In the encoded representation of a Unicode scalar value, each UTF-8 code unit after the first is called a *continuation byte*.

### Swift.String.Encoding
Defines convertion between Data <-> String

Swift.String(data:,encoding:) needs to know how to interpret the given flow of bytes

## Swift.Character
>A single extended grapheme cluster that approximates a user-perceived character.

>Because each character in a string can be made up of one or more Unicode scalar values, the number of characters in a string may not match the length of the Unicode scalar value representation or the length of the string in a particular binary representation.

> Every *Character* instance is composed of one or more Unicode scalar values that are grouped together as an extended grapheme cluster.

### Methods
1. Character.init(Unicode.Scalar)
1. Character().unicodeScalars: Character.UnicodeScalarView

## Unicode.Scalar
> The Unicode.Scalar type, representing a single Unicode scalar value, is the element type of a string’s unicodeScalars collection.

### Methods
1. Unicode.Scalar().isASCII: Bool
1. Unicode.utf16: Unicode.Scalar.UTF16View
1. Unicode.Scalar().value: UInt32


## [Java Script Strings][javascript MT strings]
> In JavaScript, the textual data is stored as strings. There is no separate type for a single character.
>
> The internal format for strings is always UTF-16, it is not tied to the page encoding.


> str.codePointAt(pos) - Returns the code for the character at position pos

> String.fromCodePoint(code) - Creates a character by its numeric code

> The same-looking letter may be located differently in different alphabets

> Most symbols have a 2-byte code. Letters in most european languages, numbers, and even most hieroglyphs, have a 2-byte representation.
But 2 bytes only allow 65536 combinations and that’s not enough for every possible symbol. So rare symbols are encoded with a pair of 2-byte characters called “a surrogate pair”.
The length of such symbols is 2
> Note that pieces of the surrogate pair have no meaning without each other. So the alerts in the example above actually display garbage.

> Diactrical marks
>
> This provides great flexibility, but also an interesting problem: two characters may visually look the same, but be represented with different unicode compositions.

     alert( 'S\u0307\u0323' ); // Ṩ, S + dot above + dot below
     alert( 'S\u0323\u0307' ); // Ṩ, S + dot below + dot above

     alert( 'S\u0307\u0323' == 'S\u0323\u0307' ); // false

> To solve this, there exists a “unicode normalization” algorithm that brings each string to the single “normal” form.




## Sources
[1] [JavaScript Modern Tutorila][javascript modern tutorial]

[javascript MT]: https://javascript.info
[javascript MT strings]: https://javascript.info/string
[javascript MT Surrogate pairs]: https://javascript.info/string#surrogate-pairs
[javascript MT Diactrical marks and normalization]: https://javascript.info/string#diacritical-marks-and-normalization

[Unicode standard]:http://www.unicode.org/versions/Unicode11.0.0/
[Unicode normalization forms]:http://www.unicode.org/reports/tr15/
[Unicode FAQ]:http://www.unicode.org/faq//utf_bom.html#UTF32

[Swift String Docs]:https://developer.apple.com/documentation/swift/string
[Swift String Book]:https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html