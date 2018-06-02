import Foundation

let inputUrl: URL = URL(fileURLWithPath: "/Users/ishikawamasayuki/Desktop/crypto/package.byte")
let inputData = try! Data(contentsOf: inputUrl)
let key = "mzw7zb856re2rr9z".data(using: .utf8)!
let keyLength = key.count
let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
if validKeyLengths.contains(keyLength) {
  let ivSize = kCCBlockSizeAES128
  let clearLength = size_t(inputData.count - ivSize)
  var clearData = Data(count: clearLength)
  var numBytesDecrypted: size_t = 0
  let options = CCOptions(kCCOptionPKCS7Padding)
  let cryptStatus = clearData.withUnsafeMutableBytes { cryptBytes in
    inputData.withUnsafeBytes { dataBytes in
      key.withUnsafeBytes { keyBytes in
        CCCrypt(
          CCOperation(kCCDecrypt),
          CCAlgorithm(kCCAlgorithmAES128),
          options,
          keyBytes,
          keyLength,
          dataBytes,
          dataBytes + kCCBlockSizeAES128,
          clearLength,
          cryptBytes,
          clearLength,
          &numBytesDecrypted
        )
      }
    }
  }
  if UInt32(cryptStatus) == UInt32(kCCSuccess) {
    clearData.count = numBytesDecrypted
  } else {
    print("Decryption failed:", cryptStatus)
  }
  let outputUrl: URL = URL(fileURLWithPath: "/Users/ishikawamasayuki/Desktop/crypto/output.json")
  try clearData.write(to: outputUrl)
}
