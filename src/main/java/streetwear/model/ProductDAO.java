package streetwear.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

public class ProductDAO {

    private DataSource ds;

    /*
     * Costruttore standard.
     * Usa DBConnectionPool.
     */
    public ProductDAO() {}

    /*
     * Costruttore con DataSource.
     * Lo lasciamo per compatibilità con eventuali servlet vecchie.
     */
    public ProductDAO(DataSource ds) {
        this.ds = ds;
    }

    private Connection getConnection() throws SQLException {
        return DBConnectionPool.getConnection();
    }

    private void releaseConnection(Connection con) {
        DBConnectionPool.releaseConnection(con);
    }

    /*
     * CANCELLAZIONE LOGICA.
     * Il prodotto non viene eliminato fisicamente dal database.
     * Viene solo impostato Attivo = FALSE.
     */
    public synchronized void doDeleteLogical(int idProdotto) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "UPDATE prodotto SET Attivo = FALSE WHERE ID_prodotto = ?";

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);
            ps.setInt(1, idProdotto);

            ps.executeUpdate();

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }
    }

    /*
     * CANCELLAZIONE FISICA.
     * La teniamo nel DAO, ma NON deve essere usata dall'admin.
     */
    public synchronized void doDelete(int idProdotto) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "DELETE FROM prodotto WHERE ID_prodotto = ?";

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);
            ps.setInt(1, idProdotto);

            ps.executeUpdate();

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }
    }

    /*
     * Inserisce un nuovo prodotto.
     */
    public synchronized void doSave(Product product) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "INSERT INTO prodotto "
                   + "(Nome_prodotto, Descrizione_prodotto, Prezzo, Taglia, Colore, Immagine, Categoria, IVA, Quantita, Attivo) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);

            ps.setString(1, product.getNomeProdotto());
            ps.setString(2, product.getDescrizioneProdotto());
            ps.setDouble(3, product.getPrezzo());
            ps.setString(4, product.getTaglia());
            ps.setString(5, product.getColore());
            ps.setString(6, product.getImmagineUrl());
            ps.setString(7, product.getCategoria());
            ps.setDouble(8, product.getIva());
            ps.setInt(9, product.getQuantita());
            ps.setBoolean(10, product.isAttivo());

            ps.executeUpdate();

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }
    }

    /*
     * Aggiorna un prodotto.
     */
    public synchronized void doUpdate(Product product) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;

        String sql = "UPDATE prodotto SET "
                   + "Nome_prodotto = ?, "
                   + "Descrizione_prodotto = ?, "
                   + "Prezzo = ?, "
                   + "Taglia = ?, "
                   + "Colore = ?, "
                   + "Immagine = ?, "
                   + "Categoria = ?, "
                   + "IVA = ?, "
                   + "Quantita = ?, "
                   + "Attivo = ? "
                   + "WHERE ID_prodotto = ?";

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);

            ps.setString(1, product.getNomeProdotto());
            ps.setString(2, product.getDescrizioneProdotto());
            ps.setDouble(3, product.getPrezzo());
            ps.setString(4, product.getTaglia());
            ps.setString(5, product.getColore());
            ps.setString(6, product.getImmagineUrl());
            ps.setString(7, product.getCategoria());
            ps.setDouble(8, product.getIva());
            ps.setInt(9, product.getQuantita());
            ps.setBoolean(10, product.isAttivo());
            ps.setInt(11, product.getIdProdotto());

            ps.executeUpdate();

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }
    }

    /*
     * Recupera un prodotto per ID.
     * Recupera solo prodotti attivi.
     * Così un utente non può aprire un prodotto eliminato tramite link diretto.
     */
    public synchronized Product doRetrieveByKey(int idProdotto) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        Product p = null;

        String sql = "SELECT * FROM prodotto WHERE ID_prodotto = ? AND Attivo = TRUE";

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);
            ps.setInt(1, idProdotto);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = extractProductFromResultSet(rs);
            }

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }

        return p;
    }

    /*
     * Recupera tutti i prodotti attivi.
     */
    public synchronized List<Product> doRetrieveAll() throws SQLException {
        return doRetrieveAll(null);
    }

    /*
     * Recupera tutti i prodotti attivi con ordinamento opzionale.
     */
    public synchronized List<Product> doRetrieveAll(String order) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        List<Product> list = new ArrayList<Product>();

        String sql = "SELECT * FROM prodotto WHERE Attivo = TRUE";

        if (order != null && !order.trim().isEmpty()) {
            sql += " ORDER BY " + order;
        }

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProductFromResultSet(rs));
            }

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }

        return list;
    }

    /*
     * Ricerca prodotti attivi per nome, categoria o descrizione.
     */
    public synchronized List<Product> doRetrieveByKeyword(String keyword) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        List<Product> list = new ArrayList<Product>();

        String sql = "SELECT * FROM prodotto "
                   + "WHERE Attivo = TRUE "
                   + "AND (LOWER(Nome_prodotto) LIKE LOWER(?) "
                   + "OR LOWER(Categoria) LIKE LOWER(?) "
                   + "OR LOWER(Descrizione_prodotto) LIKE LOWER(?))";

        try {
            con = getConnection();

            ps = con.prepareStatement(sql);

            String searchPattern = "%" + keyword + "%";

            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProductFromResultSet(rs));
            }

        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
            } finally {
                releaseConnection(con);
            }
        }

        return list;
    }

    /*
     * Metodo privato che trasforma una riga del database in un oggetto Product.
     */
    private Product extractProductFromResultSet(ResultSet rs) throws SQLException {
        Product p = new Product();

        p.setIdProdotto(rs.getInt("ID_prodotto"));
        p.setNomeProdotto(rs.getString("Nome_prodotto"));
        p.setDescrizioneProdotto(rs.getString("Descrizione_prodotto"));
        p.setPrezzo(rs.getDouble("Prezzo"));
        p.setTaglia(rs.getString("Taglia"));
        p.setColore(rs.getString("Colore"));
        p.setImmagineUrl(rs.getString("Immagine"));
        p.setCategoria(rs.getString("Categoria"));
        p.setIva(rs.getDouble("IVA"));
        p.setQuantita(rs.getInt("Quantita"));
        p.setAttivo(rs.getBoolean("Attivo"));

        return p;
    }
}