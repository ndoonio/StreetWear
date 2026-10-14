package streetwear.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/*
 * DAO per la tabella utente.
 *
 * ATTENZIONE:
 * Qui NON usiamo Eta perché nel tuo database reale
 * la colonna Eta non esiste.
 */
public class UserDAO {

    /*
     * Salva un nuovo utente nel database.
     */
	public synchronized void doSave(User user) throws SQLException {

	    String sql = "INSERT INTO utente "
	               + "(Nome, Cognome, Email, Pwd, Ruolo, Ordine_effettuati) "
	               + "VALUES (?, ?, ?, ?, ?, ?)";

	    Connection connection = null;
	    PreparedStatement preparedStatement = null;

	    try {
	        connection = DBConnectionPool.getConnection();

	        preparedStatement = connection.prepareStatement(sql);

	        preparedStatement.setString(1, user.getNome());
	        preparedStatement.setString(2, user.getCognome());
	        preparedStatement.setString(3, user.getEmail());

	        /*
	         
	Qui salvo la password già hashata dalla RegistrationServlet.
	NON hashare qui dentro, altrimenti la password viene hashata due volte.*/
	    preparedStatement.setString(4, user.getPwd());

	        /*
	         
	Se per qualche motivo il ruolo è null,
	lo imposto comunque a "cliente".*/
	    String ruolo = user.getRuolo();

	        if (ruolo == null || ruolo.trim().isEmpty()) {
	            ruolo = "cliente";
	        }

	        preparedStatement.setString(5, ruolo);

	        /*
	         
	Un nuovo utente parte con 0 ordini effettuati.*/
	      preparedStatement.setInt(6, 0);

	        preparedStatement.executeUpdate();

	    } finally {

	        if (preparedStatement != null) {
	            preparedStatement.close();
	        }

	        DBConnectionPool.releaseConnection(connection);
	    }
	}

    /*
     * Controlla se una email è già registrata.
     */
    public boolean emailExists(String email) throws SQLException {

        String sql = "SELECT ID_utente FROM utente WHERE Email = ?";

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, email);

            resultSet = preparedStatement.executeQuery();

            return resultSet.next();

        } finally {

            if (resultSet != null) {
                resultSet.close();
            }

            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DBConnectionPool.releaseConnection(connection);
        }
    }

    /*
     * Recupera un utente tramite email.
     * Serve per il login.
     */
    public User doRetrieveByEmail(String email) throws SQLException {

        String sql = "SELECT ID_utente, Nome, Cognome, Email, Pwd, Ruolo "
                   + "FROM utente "
                   + "WHERE Email = ?";

        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = DBConnectionPool.getConnection();

            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, email);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {

                User user = new User();

                user.setIdUtente(resultSet.getInt("ID_utente"));
                user.setNome(resultSet.getString("Nome"));
                user.setCognome(resultSet.getString("Cognome"));
                user.setEmail(resultSet.getString("Email"));
                user.setPwd(resultSet.getString("Pwd"));
                user.setRuolo(resultSet.getString("Ruolo"));

                return user;
            }

            return null;

        } finally {

            if (resultSet != null) {
                resultSet.close();
            }

            if (preparedStatement != null) {
                preparedStatement.close();
            }

            DBConnectionPool.releaseConnection(connection);
        }
    }
}