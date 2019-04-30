import Foundation

let inputUrl: URL = URL(fileURLWithPath: "/Users/usayuki/Desktop/crypto/package.json")
let inputData = try! Data(contentsOf: inputUrl)
let key = "mzw7zb856re2rr9z".data(using: .utf8)!
let keyLength = key.count
let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
if validKeyLengths.contains(keyLength) {
  let ivSize = kCCBlockSizeAES128
  let cryptLength = size_t(ivSize + inputData.count + kCCBlockSizeAES128)
  var cryptData = Data(count: cryptLength)
  let status = cryptData.withUnsafeMutableBytes { ivBytes in
    SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
  }
  if status == 0 {
    var numBytesEncrypted: size_t = 0
    let options = CCOptions(kCCOptionPKCS7Padding)
    let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
      inputData.withUnsafeBytes { dataBytes in
        key.withUnsafeBytes { keyBytes in
          CCCrypt(
            CCOperation(kCCEncrypt),
            CCAlgorithm(kCCAlgorithmAES),
            options,
            keyBytes,
            keyLength,
            cryptBytes,
            dataBytes,
            inputData.count,
            cryptBytes + kCCBlockSizeAES128,
            cryptLength,
            &numBytesEncrypted
          )
        }
      }
    }
    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
      cryptData.count = numBytesEncrypted + ivSize
    } else {
      print("Encryption failed")
    }
    let outputUrl: URL = URL(fileURLWithPath: "/Users/ishikawamasayuki/Desktop/crypto/package.byte")
    try cryptData.write(to: outputUrl)
  }
}
