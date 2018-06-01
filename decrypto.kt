import java.io.FileInputStream
import java.io.File
import java.io.FileWriter

import javax.crypto.Cipher
import javax.crypto.CipherInputStream
import javax.crypto.CipherOutputStream
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec


fun main(args: Array<String>) {
  val fis = FileInputStream("./encrypto.byte")
  val key = SecretKeySpec("0123456789ABCDEF".toByteArray(), "AES")
  val iv = ByteArray(16)
  fis.read(iv)
  val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
  val ivspec = IvParameterSpec(iv)
  cipher.init(Cipher.DECRYPT_MODE, key, ivspec)
  val cis = CipherInputStream(fis, cipher)
  val reader = cis.bufferedReader()

  val file = File("./after.json")
  val fw = FileWriter(file)
  var line: String? = reader.readLine()
  while (line != null) {
    fw.write(line)
    line = reader.readLine()
  }
  reader.close()
  fw.close()
}
