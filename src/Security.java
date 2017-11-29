

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class Security {

	public static String genhash_SHA256(String  str) throws NoSuchAlgorithmException{
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		byte[] hash = digest.digest( str.getBytes(StandardCharsets.UTF_8));
		String password = Base64.getEncoder().encodeToString(hash);
		return password;		
	}
}
