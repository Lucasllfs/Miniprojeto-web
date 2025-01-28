package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
    private static final String URL = "jdbc:mysql://emjd1.h.filess.io:3307/miniprojeto_doghungarm?useSSL=false&serverTimezone=UTC";
    private static final String USER = "miniprojeto_doghungarm";
    private static final String PASSWORD = "34b732d4339c7c69803ecabcd8df5640949baa5f";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Carrega o driver explicitamente
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver JDBC não encontrado!", e);
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao conectar ao banco de dados", e);
        }
    }
}
