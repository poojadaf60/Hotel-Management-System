package com.org;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // 🔧 Change these to match your MySQL setup
    private static final String URL =
            "jdbc:mysql://localhost:3306/jdbc3?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "Pooja@#123";

    /**
     * Returns a database connection, or null if an error occurs.
     * Logs all errors to the server console for easy debugging.
     */
    public static Connection getConnection() {
        Connection con = null;
        try {
            // 1️⃣ Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL JDBC Driver loaded successfully.");

            // 2️⃣ Establish connection
            con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ DB Connection established to: " + URL);

        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found! Add mysql-connector-java.jar to classpath.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ Database connection error: " + e.getMessage());
            System.err.println("   → Check URL, username, password, and that MySQL is running.");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }

    // Optional: quick test method (you can call from main for testing)
    public static void main(String[] args) {
        Connection test = getConnection();
        if (test != null) {
            System.out.println("✅ Connection test passed.");
            try { test.close(); } catch (Exception e) {}
        } else {
            System.err.println("❌ Connection test failed.");
        }
    }
}