# Swift.String

If you get confused with relationships between Swift strings and their unicode represantations this article is for you.

In C, C++, JavaScript you can easily get integer code of the given letter and work with a string as with an array of integer numbers. It may be useful in some algorithms to represent a string that way, but I couldn't figure out how to do it in Swift. I was expecting something like this:

    let helloString = "Hello"
    let eCode = helloString.codePoint(at: 1) // expected String method
    print("'e' =", eCode) // 'e' = 101

but eventually I finished with this:

    ```Swift
    let eIndex = helloString.index(after: helloString.startIndex)
    let eCode = helloString[eIndex].unicodeScalars.first?.value
    print("'e' =", eCode!) // 'e' = 101
    ```

Let's figure this out.

## Unicode
[Unicode standard][Unicode standard] describes more than 137.000 characters and the ways of working with them. Put simple, Unicode defines a huge table of different characters:

*Table1 Unicode simplified characters table*
| Code           |  ...  |  41 |  42 |  43 |  ...  | 416 | 417 | 418 |  ...  |
|----------------|:-----:|:---:|:---:|:---:|:-----:|:---:|:---:|:---:|:-----:|
| **Character**  |**...**|**A**|**B**|**C**|**...**|**Ж**|**З**|**И**|**...**|


each of which has its corresponding integer value. Those characters are called **Unicode scalars** because they are from Unicode and they are primitive: there is one to one relationship between integer code and a character.

I wouldn't be writting this article if it was all Unicode standard defines. There is also a list of rules how to handle Unicode scalars to get characters that are not in the table. Yes, people generated much more characters than can fit in the table:

    ```Swift
    let flag = "🇺🇸" // comprises of two Unicode scalars
    let eWithAccent = "é" // may be encoded with one Unicode scalar or with two
    ```

With the table and rules of joining Unicode scalars we can get a way to mirror any character into one or more integer values. For any scalar Unicode standard reserves [21 bits][Unicode standard FAQ] to encode it. Our computers mostly work with Integers of length: 8, 16, 32, ... bits. So Unicode standard also describes how to encode unicode strings with integers of length 8 and 16 bits, defining UTF-8 and UTF-16 encodings respectively.

![Picture 1][DifferentEncodings Picture]
*Picture 1 One character in different encodings*

## Swift.String
> "All problems in computer science can be solved by another level of indirection" [David Wheeler][David Wheeler quote]

Swift strings fully support Unicode. It means that string "Flag-🇺🇸" has a length (count) of 6 characters. It is especially  convinient if you ever tried to get number of characters in some other languages - when you see 6 characters and get length of 9!

Thus, Swift.String type encapsulates all the complexity of [Unicode standard][Unicode standard] (feel free to open it and read). And that's great, but how can we get coveted integer values of the string's characters? Let's consider the relationships among different types around String type:

```Swift
let string = "Hi 😀"

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


// Array of characters
let characters: [Character] = Array(string)
// characters = ["H", "i", " ", "😀"]

// Character unicodeScalars property
let charScalarsView: Character.UnicodeScalarView = characters[0].unicodeScalars
let charScalars: [Unicode.Scalar] = Array(charScalarsView)
let charValues: [UInt32] = charScalars.map{ $0.value }
// charValues = [72]
```
 

![Picture 2][StringTypesScheme Picture]
*Picture 2 Schematic presentation*

In the listing and scheme above we see types Swift engineers developed to connect human-readable String as an array of characters and its integer representations while encoded. The best way to get acquainted with them closer is to read official [Swift.String documentation][Swift.String documentation]

## Conclusion
What initially seemed to me as an inconvenience of working with Swift.String type now I see as a rigth way to abstract out String as an array of letters from its representation in different encodings. 
1. String is a sequence of characters
1. Each character may be encoded with one or more Unicode scalars
1. Each Unicode scalar requires at max 21 bits but there are UTF-8 and UTF-16 encodings that developed to be represent those 21 bits in shorter integer types
1. Swift.String and Swift.Character have 'unicodeScalars' property to get sequence of Unicode scalars
1. Using Array initializer with this UnicodeScalar type we can get an array of UInt32 integers which encodes given string

        let string = "Hello 🌎"
        let scalars = Array(string.unicodeScalars).map { $0.value }
        print(scalars) // [72, 101, 108, 108, 111, 32, 127758]
       




[Unicode standard]:http://www.unicode.org/versions/Unicode11.0.0/
[Unicode standard FAQ]:http://www.unicode.org/faq//utf_bom.html#UTF32
[David Wheeler quote]:https://en.wikipedia.org/wiki/Indirection
[Swift.String documentation]:https://developer.apple.com/documentation/swift/string
[StringTypesScheme Picture]:pict/StringTypes.png
[DifferentEncodings Picture]:pict/DifferentEncodings.png

