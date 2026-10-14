package streetwear.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

public class OrderDAO {

    

    // Costruttore vuoto (usa DBConnectionPool)
    public OrderDAO() {}

    private Connection getConnection() throws SQLException {
        return DBConnectionPool.getConnection();
    }
        
    private void releaseConnection(Connection con) {
        DBConnectionPool.releaseConnection(con);
    }

    /**
     * Recupera un singolo ordine per ID.
     */
    public synchronized Order doRetrieveByKey(int idOrdine) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        Order order = null;

        String sql = "SELECT o.*, u.Email FROM ordine o JOIN utente u ON o.ID_utente = u.ID_utente WHERE o.ID_ordine = ?";

        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idOrdine);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = new Order();
                order.setIdOrdine(rs.getInt("ID_ordine"));
                order.setIdUtente(rs.getInt("ID_utente"));
                order.setEmailCliente(rs.getString("Email"));
                order.setDataOrdine(rs.getTimestamp("Data_ordine"));
                order.setStatoOrdine(rs.getString("Stato_ordine"));

                order.setRighe(doRetrieveRowsByOrder(idOrdine));
            }
        } finally {
            try { if (ps != null) ps.close(); } finally { releaseConnection(con); }
        }
        return order;
    }

    /**
     * Recupera le righe associate a un ordine (Rettificato in PUBLIC per la Servlet).
     */
    public synchronized ArrayList<OrderRow> doRetrieveRowsByOrder(int idOrdine) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        ArrayList<OrderRow> rows = new ArrayList<>();
        String sql = "SELECT r.*, p.Nome_prodotto FROM riga_ordine r LEFT JOIN prodotto p ON r.ID_prodotto = p.ID_prodotto WHERE r.ID_ordine = ?";
        
        try {
            con = getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idOrdine);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderRow row = new OrderRow();
                row.setIdRiga(rs.getInt("ID_riga"));
                row.setIdOrdine(rs.getInt("ID_ordine"));
                row.setIdProdotto((Integer) rs.getObject("ID_prodotto"));
                row.setNomeProdottoStorico(rs.getString("Nome_prodotto") != null ? rs.getString("Nome_prodotto") : "[Prodotto Eliminato]");
                row.setQuantita(rs.getInt("Quantita"));
                row.setPrezzoStorico(rs.getDouble("Prezzo_storico"));
                row.setIvaStorica(rs.getInt("IVA_storica"));
                rows.add(row);
            }
        } finally {
            try { if (ps != null) ps.close(); } finally { releaseConnection(con); }
        }
        return rows;
    }

    /**
     * Salva un ordine e le sue righe con transazione SQL.
     */
    public synchronized void doSave(Order order) throws SQLException {
        Connection con = null;
        PreparedStatement psOrder = null;
        PreparedStatement psRow = null;

        String insertOrderSQL = "INSERT INTO ordine (ID_utente, Data_ordine, Stato_ordine) VALUES (?, ?, ?)";
        String insertRowSQL = "INSERT INTO riga_ordine (ID_ordine, ID_prodotto, Quantita, Prezzo_storico, IVA_storica) VALUES (?, ?, ?, ?, ?)";

        try {
            con = getConnection();
            con.setAutoCommit(false);

            psOrder = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getIdUtente());
            psOrder.setTimestamp(2, order.getDataOrdine());
            psOrder.setString(3, order.getStatoOrdine());
            psOrder.executeUpdate();

            ResultSet generatedKeys = psOrder.getGeneratedKeys();
            int idOrdineGenerato = -1;
            if (generatedKeys.next()) {
                idOrdineGenerato = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Errore: Impossibile recuperare l'ID dell'ordine.");
            }

            psRow = con.prepareStatement(insertRowSQL);
            for (OrderRow row : order.getRighe()) {
                psRow.setInt(1, idOrdineGenerato);
                if (row.getIdProdotto() != null) {
                    psRow.setInt(2, row.getIdProdotto());
                } else {
                    psRow.setNull(2, java.sql.Types.INTEGER);
                }
                psRow.setInt(3, row.getQuantita());
                psRow.setDouble(4, row.getPrezzoStorico());
                psRow.setInt(5, row.getIvaStorica());
                psRow.addBatch();
            }

            psRow.executeBatch();
            con.commit();

        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    throw ex;
                }
            }
            throw e;
        } finally {
            try { if (psOrder != null) psOrder.close(); } finally {
                try { if (psRow != null) psRow.close(); } finally {
                    releaseConnection(con);
                }
            }
        }
    }

    /**
     * Recupera la lista di tutti gli ordini (con filtri opzionali).
     */
    public synchronized List<Order> doRetrieveAll(String startDate, String endDate, String emailCliente) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT o.*, u.Email FROM ordine o JOIN utente u ON o.ID_utente = u.ID_utente WHERE 1=1";

        if (startDate != null && !startDate.trim().isEmpty()) sql += " AND o.Data_ordine >= ?";
        if (endDate != null && !endDate.trim().isEmpty()) sql += " AND o.Data_ordine <= ?";
        if (emailCliente != null && !emailCliente.trim().isEmpty()) sql += " AND u.Email LIKE ?";

        sql += " ORDER BY o.Data_ordine DESC";

        try {
            con = getConnection();
            ps = con.prepareStatement(sql);

            int paramIndex = 1;
            if (startDate != null && !startDate.trim().isEmpty()) ps.setString(paramIndex++, startDate + " 00:00:00");
            if (endDate != null && !endDate.trim().isEmpty()) ps.setString(paramIndex++, endDate + " 23:59:59");
            if (emailCliente != null && !emailCliente.trim().isEmpty()) ps.setString(paramIndex++, "%" + emailCliente + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setIdOrdine(rs.getInt("ID_ordine"));
                o.setIdUtente(rs.getInt("ID_utente"));
                o.setEmailCliente(rs.getString("Email"));
                o.setDataOrdine(rs.getTimestamp("Data_ordine"));
                o.setStatoOrdine(rs.getString("Stato_ordine"));

                o.setRighe(doRetrieveRowsByOrder(o.getIdOrdine()));
                orders.add(o);
            }
        } finally {
            try { if (ps != null) ps.close(); } finally { releaseConnection(con); }
        }
        return orders;
    }
}