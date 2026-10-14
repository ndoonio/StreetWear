package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import streetwear.model.Product;
import streetwear.model.ProductDAO;

/**
 * Restituisce in formato JSON i suggerimenti per la barra di ricerca.
 */
@WebServlet("/SuggerimentiRicerca")
public class SuggerimentiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAO();

    /**
     * Cerca i prodotti il cui nome contiene il testo inserito.
     */
    @Override
    protected void doGet(HttpServletRequest r, HttpServletResponse p)
            throws ServletException, IOException {

        // Recupera il testo cercato oppure usa una stringa vuota.
        String q = r.getParameter("q") == null
                ? ""
                : r.getParameter("q").toLowerCase();

        // La risposta viene inviata come JSON.
        p.setContentType("application/json;charset=UTF-8");

        StringBuilder j = new StringBuilder("[");

        List<Product> tutti = new ArrayList<>();
        try {
            tutti = new ArrayList<>(productDAO.doRetrieveAll());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Scorre tutti i prodotti e aggiunge quelli compatibili.
        for (Product x : tutti) {
            String nome = x.getNomeProdotto() != null ? x.getNomeProdotto() : "";
            if (nome.toLowerCase().contains(q)) {
                if (j.length() > 1) {
                    j.append(',');
                }

                j.append("{\"id\":")
                        .append(x.getIdProdotto())
                        .append(",\"nome\":\"")
                        .append(nome.replace("\"", "\\\""))
                        .append("\"}");
            }
        }

        // Chiude l'array JSON.
        j.append(']');

        p.getWriter().write(j.toString());
    }
}