package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.Order;
import streetwear.model.OrderDAO;
import streetwear.model.OrderRow;
import streetwear.model.Product;
import streetwear.model.ProductDAO;
import streetwear.model.User;

@WebServlet("/Checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Integer idUtente = recuperaIdUtente(session);

        if (idUtente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, Integer> carrello = (Map<Integer, Integer>) session.getAttribute("carrello");

        try {
            List<Product> prodottiCheckout = caricaProdottiDalCarrello(carrello);
            double totaleCheckout = calcolaTotale(prodottiCheckout, carrello);

            request.setAttribute("prodottiCheckout", prodottiCheckout);
            request.setAttribute("quantitaCheckout", carrello);
            request.setAttribute("totaleCheckout", totaleCheckout);

            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Errore durante il caricamento del checkout.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Integer idUtente = recuperaIdUtente(session);

        if (idUtente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, Integer> carrello = (Map<Integer, Integer>) session.getAttribute("carrello");

        if (carrello == null || carrello.isEmpty()) {
            session.setAttribute("errore", "Il carrello è vuoto.");
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        try {
            ArrayList<OrderRow> righeOrdine = new ArrayList<OrderRow>();

            for (Map.Entry<Integer, Integer> entry : carrello.entrySet()) {

                int idProdotto = entry.getKey();
                int quantita = entry.getValue();

                if (quantita <= 0) {
                    continue;
                }

                Product prodotto = productDAO.doRetrieveByKey(idProdotto);

                if (prodotto == null) {
                    continue;
                }

                OrderRow row = new OrderRow();

                row.setIdProdotto(prodotto.getIdProdotto());
                row.setNomeProdottoStorico(prodotto.getNomeProdotto());
                row.setQuantita(quantita);
                row.setPrezzoStorico(prodotto.getPrezzo());
                row.setIvaStorica((int) Math.round(prodotto.getIva()));

                righeOrdine.add(row);
            }

            if (righeOrdine.isEmpty()) {
                session.setAttribute("errore", "Nessun prodotto valido nel carrello.");
                response.sendRedirect(request.getContextPath() + "/Carrello");
                return;
            }

            Order ordine = new Order();

            ordine.setIdUtente(idUtente);
            ordine.setDataOrdine(new Timestamp(System.currentTimeMillis()));
            ordine.setStatoOrdine("Confermato");
            ordine.setRighe(righeOrdine);

            orderDAO.doSave(ordine);

            carrello.clear();
            session.removeAttribute("carrello");

            session.setAttribute("cartCount", 0);
            session.setAttribute("quantitaCarrello", 0);
            session.setAttribute("carrelloCount", 0);

            session.setAttribute("messaggio", "Ordine completato con successo.");

            response.sendRedirect(request.getContextPath() + "/Checkout");

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Errore durante il salvataggio dell'ordine.", e);
        }
    }

    private List<Product> caricaProdottiDalCarrello(Map<Integer, Integer> carrello) throws SQLException {

        List<Product> prodotti = new ArrayList<Product>();

        if (carrello == null || carrello.isEmpty()) {
            return prodotti;
        }

        for (Integer idProdotto : carrello.keySet()) {
            Product prodotto = productDAO.doRetrieveByKey(idProdotto);

            if (prodotto != null) {
                prodotti.add(prodotto);
            }
        }

        return prodotti;
    }

    private double calcolaTotale(List<Product> prodotti, Map<Integer, Integer> carrello) {

        double totale = 0;

        if (prodotti == null || carrello == null) {
            return totale;
        }

        for (Product prodotto : prodotti) {
            int quantita = 1;

            if (carrello.get(prodotto.getIdProdotto()) != null) {
                quantita = carrello.get(prodotto.getIdProdotto());
            }

            totale += prodotto.getPrezzo() * quantita;
        }

        return totale;
    }

    private Integer recuperaIdUtente(HttpSession session) {

        Object idObj = session.getAttribute("idUtente");

        if (idObj instanceof Integer) {
            return (Integer) idObj;
        }

        if (idObj != null) {
            try {
                return Integer.parseInt(String.valueOf(idObj));
            } catch (NumberFormatException e) {
                return null;
            }
        }

        User user = (User) session.getAttribute("utente");

        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        if (user != null) {
            return user.getIdUtente();
        }

        return null;
    }
}