package edu.sjsu.cs157a.team1.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean verifyPassword(String plainPassword, String storedHash) {
        return storedHash != null && BCrypt.checkpw(plainPassword, storedHash);
    }
}
