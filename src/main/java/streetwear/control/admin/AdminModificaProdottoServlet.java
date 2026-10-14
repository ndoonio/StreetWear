package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.Product;
import streetwear.model.ProductDAO;

@WebServlet("/Admin/ModificaProdotto")
public class AdminModificaProdottoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
            return;
        }

        try {
            int idProdotto = Integer.parseInt(idParam);

            Product prodotto = productDAO.doRetrieveByKey(idProdotto);

            if (prodotto == null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("errore", "Prodotto non trovato.");

                response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
                return;
            }

            request.setAttribute("prodotto", prodotto);
            request.setAttribute("modalita", "modifica");

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-form-prodotto.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            HttpSession session = request.getSession(true);
            session.setAttribute("errore", "Errore durante il caricamento del prodotto.");

            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);

        try {
            int idProdotto = parseInt(request.getParameter("idProdotto"), 0);

            if (idProdotto <= 0) {
                idProdotto = parseInt(request.getParameter("id"), 0);
            }

            if (idProdotto <= 0) {
                session.setAttribute("errore", "ID prodotto non valido.");
                response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
                return;
            }

            Product prodotto = leggiProdottoDaRequest(request);
            prodotto.setIdProdotto(idProdotto);

            productDAO.doUpdate(prodotto);

            session.setAttribute("messaggio", "Prodotto modificato correttamente.");

            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");

        } catch (SQLException e) {
            e.printStackTrace();

            session.setAttribute("errore", "Errore durante la modifica del prodotto.");

            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
        }
    }

    private Product leggiProdottoDaRequest(HttpServletRequest request) {

        Product prodotto = new Product();

        prodotto.setNomeProdotto(getValue(request, "nomeProdotto"));
        prodotto.setDescrizioneProdotto(getValue(request, "descrizioneProdotto"));
        prodotto.setPrezzo(parseDouble(request.getParameter("prezzo"), 0));
        prodotto.setIva(parseDouble(request.getParameter("iva"), 22));
        prodotto.setCategoria(getValue(request, "categoria"));
        prodotto.setTaglia(getValue(request, "taglia"));
        prodotto.setColore(getValue(request, "colore"));
        prodotto.setQuantita(parseInt(request.getParameter("quantita"), 0));
        prodotto.setImmagineUrl(getValue(request, "immagine"));

        String attivoParam = request.getParameter("attivo");

        if (attivoParam == null) {
            prodotto.setAttivo(true);
        } else {
            prodotto.setAttivo(
                    "true".equalsIgnoreCase(attivoParam)
                    || "on".equalsIgnoreCase(attivoParam)
                    || "1".equals(attivoParam)
                    || "si".equalsIgnoreCase(attivoParam)
                    || "sì".equalsIgnoreCase(attivoParam)
            );
        }

        return prodotto;
    }

    private String getValue(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return Double.parseDouble(value.replace(",", "."));
        } catch (Exception e) {
            return defaultValue;
        }
    }
}