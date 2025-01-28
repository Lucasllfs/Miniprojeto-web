package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionFactory {
    //host: emjd1.h.filess.io
    //database: miniprojeto_doghungarm
    //port: 3307
    private static final String URL = "jdbc:mysql://emjd1.h.filess.io:3307/miniprojeto_doghungarm";
    private static final String USER = "miniprojeto_doghungarm";
    private static final String PASSWORD = "34b732d4339c7c69803ecabcd8df5640949baa5f";

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao conectar ao banco de dados", e);
        }
    }
}
