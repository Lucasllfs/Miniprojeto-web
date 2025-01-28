package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionFactory {
    private static final String URL = "jdbc:mysql://sql10.freesqldatabase.com:3306/sql10758945";
    private static final String USER = "sql10758945";
    private static final String PASSWORD = "aDNK1m3HRp";

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao conectar ao banco de dados", e);
        }
    }
}
