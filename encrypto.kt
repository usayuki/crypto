import java.io.FileInputStream
import java.io.FileOutputStream

import javax.crypto.Cipher
import javax.crypto.CipherInputStream
import javax.crypto.CipherOutputStream
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec


fun main(args: Array<String>) {
  val fis = FileInputStream("./before.json")
  val key = SecretKeySpec("0123456789ABCDEF".toByteArray(), "AES")
  val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
  cipher.init(Cipher.ENCRYPT_MODE, key)
  val fos = FileOutputStream("./encrypto.byte")
  val cos = CipherOutputStream(fos, cipher)
  fos.write(cipher.getIV())
  val a = ByteArray(8)
  var i = fis.read(a)
  while (i != -1) {
    cos.write(a, 0, i)
    i = fis.read(a)
  }
  cos.flush()
  cos.close()
}
