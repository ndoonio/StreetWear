package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.Product;
import streetwear.model.ProductDAO;

@WebServlet("/Admin/NuovoProdotto")
public class AdminNuovoProdottoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("modalita", "nuovo");

        request.getRequestDispatcher("/WEB-INF/views/admin/admin-form-prodotto.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);

        try {
            Product prodotto = leggiProdottoDaRequest(request);

            productDAO.doSave(prodotto);

            session.setAttribute("messaggio", "Prodotto inserito correttamente.");

            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");

        } catch (Exception e) {
            e.printStackTrace();

            session.setAttribute("errore", "Errore durante l'inserimento del prodotto.");

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
        prodotto.setAttivo(true);

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