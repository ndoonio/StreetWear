package streetwear.model;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/*
 * Classe di utilità per gestire le password.
 *
 * La password NON viene salvata in chiaro nel database.
 * Nel database viene salvato questo formato:
 *
 * salt:hash
 *
 * Esempio:
 * abc123salt:xyz789hash
 */
public class PasswordUtils {

    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH = 256;

    /*
     * Genera l'hash della password.
     *
     * Questo metodo si usa SOLO in registrazione,
     * quando dobbiamo salvare una nuova password nel database.
     */
    public static String hashPassword(String password) {

        try {
            byte[] salt = generateSalt();

            byte[] hash = hashWithSalt(password, salt);

            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);

            return saltBase64 + ":" + hashBase64;

        } catch (Exception e) {
            throw new RuntimeException("Errore durante l'hashing della password.", e);
        }
    }

    /*
     * Verifica se la password inserita dall'utente è uguale
     * alla password hashata salvata nel database.
     *
     * Questo metodo si usa SOLO nel login.
     */
    public static boolean verifyPassword(String passwordInserita, String passwordSalvata) {

        try {
            /*
             * Se la password salvata è nulla o non contiene ":",
             * allora non è nel formato corretto salt:hash.
             */
            if (passwordSalvata == null || !passwordSalvata.contains(":")) {
                return false;
            }

            /*
             * Divido la password salvata in due parti:
             * - parte 0: salt
             * - parte 1: hash
             */
            String[] parti = passwordSalvata.split(":");

            if (parti.length != 2) {
                return false;
            }

            byte[] salt = Base64.getDecoder().decode(parti[0]);
            byte[] hashSalvato = Base64.getDecoder().decode(parti[1]);

            /*
             * Calcolo l'hash della password inserita usando
             * lo stesso salt salvato nel database.
             */
            byte[] hashCalcolato = hashWithSalt(passwordInserita, salt);

            /*
             * Confronto sicuro tra i due hash.
             */
            return MessageDigest.isEqual(hashSalvato, hashCalcolato);

        } catch (Exception e) {
            return false;
        }
    }

    /*
     * Metodo privato che calcola l'hash usando PBKDF2.
     */
    private static byte[] hashWithSalt(String password, byte[] salt) throws Exception {

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
        );

        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        return factory.generateSecret(spec).getEncoded();
    }

    /*
     * Genera un salt casuale.
     */
    private static byte[] generateSalt() {

        SecureRandom random = new SecureRandom();

        byte[] salt = new byte[16];

        random.nextBytes(salt);

        return salt;
    }
}