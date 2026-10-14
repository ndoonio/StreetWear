package streetwear.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

public class DBConnectionPool {
    private static List<Connection> freeDbConnections = new LinkedList<>();

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver DB non trovato: " + e.getMessage());
        }
    }

   
private static synchronized Connection createNewConnection()
        throws SQLException {

    String dbUrl = "jdbc:mysql://localhost:3306/streetwear?serverTimezone=UTC";
    String dbUser = "root";

    // Recupera la password dalle variabili d'ambiente
    String dbPassword = System.getenv("STREETWEAR_DB_PASSWORD");

    if (dbPassword == null || dbPassword.isEmpty()) {
        throw new SQLException(
            "Variabile STREETWEAR_DB_PASSWORD non configurata"
        );
    }

    return DriverManager.getConnection(dbUrl, dbUser, dbPassword);
}


    public static synchronized Connection getConnection() throws SQLException {
        Connection connection;
        if (!freeDbConnections.isEmpty()) {
            connection = freeDbConnections.get(0);
            freeDbConnections.remove(0);
            try {
                if (connection.isClosed()) {
                    connection = getConnection();
                }
            } catch (SQLException e) {
                connection = getConnection();
            }
        } else {
            connection = createNewConnection();
        }
        return connection;
    }

    public static synchronized void releaseConnection(Connection connection) {
        if (connection != null) {
            freeDbConnections.add(connection);
        }
    }
}