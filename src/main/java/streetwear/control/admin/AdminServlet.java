package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import streetwear.model.Order;
import streetwear.model.OrderDAO;
import streetwear.model.Product;
import streetwear.model.ProductDAO;

/*
 * Servlet della dashboard amministratore.
 */
@WebServlet("/Admin/Home")
public class AdminServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            /*
             * Prodotti totali reali dal database.
             */
            List<Product> prodotti = productDAO.doRetrieveAll();
            int prodottiTotali = prodotti.size();

            /*
             * Ordini totali reali dal database.
             */
            List<Order> ordini = orderDAO.doRetrieveAll(null, null, null);
            int ordiniTotali = ordini.size();

            /*
             * Checkout completati.
             * Qui conto gli ordini con stato Confermato.
             */
            int checkoutTotali = 0;

            for (Order ordine : ordini) {
                if (ordine.getStatoOrdine() != null &&
                    ordine.getStatoOrdine().equalsIgnoreCase("Confermato")) {

                    checkoutTotali++;
                }
            }

            /*
             * Ultimi ordini da mostrare nella tabella della dashboard.
             */
            List<Order> ultimiOrdini = new ArrayList<>();

            for (int i = 0; i < ordini.size() && i < 5; i++) {
                ultimiOrdini.add(ordini.get(i));
            }

            request.setAttribute("prodottiTotali", prodottiTotali);
            request.setAttribute("ordiniTotali", ordiniTotali);
            request.setAttribute("checkoutTotali", checkoutTotali);
            request.setAttribute("ultimiOrdini", ultimiOrdini);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-home.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            throw new ServletException("Errore durante il caricamento della dashboard admin.", e);
        }
    }
}