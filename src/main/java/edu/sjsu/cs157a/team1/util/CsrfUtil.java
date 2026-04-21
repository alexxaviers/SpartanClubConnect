package edu.sjsu.cs157a.team1.util;

import javax.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.util.UUID;

public final class CsrfUtil {

    private static final String SESSION_KEY = "csrfToken";

    private CsrfUtil() {
    }

    public static String getToken(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_KEY);
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute(SESSION_KEY, token);
        }
        return token;
    }

    public static boolean isValid(HttpSession session, String submittedToken) {
        if (session == null || submittedToken == null) {
            return false;
        }
        String sessionToken = (String) session.getAttribute(SESSION_KEY);
        if (sessionToken == null) {
            return false;
        }
        return MessageDigest.isEqual(
                sessionToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                submittedToken.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    }
}
