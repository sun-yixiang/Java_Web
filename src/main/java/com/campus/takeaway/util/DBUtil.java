package com.campus.takeaway.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {
    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new RuntimeException("db.properties not found");
            }
            PROPERTIES.load(input);
            Class.forName(PROPERTIES.getProperty("driver"));
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Database configuration load failed", e);
        }
    }

    private DBUtil() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                PROPERTIES.getProperty("url"),
                PROPERTIES.getProperty("username"),
                PROPERTIES.getProperty("password")
        );
    }
}
