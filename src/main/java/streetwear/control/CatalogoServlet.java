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

@WebServlet({"/Catalogo", "/Ricerca"})
public class CatalogoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Leggo i valori che arrivano dai filtri già presenti nella catalogo.jsp.
         * NON sto cambiando la grafica, sto solo facendo funzionare i filtri lato servlet.
         */
        String ricerca = getValue(request, "ricerca").toLowerCase();
        String categoria = getValue(request, "categoria").toLowerCase();
        String taglia = getValue(request, "taglia").toLowerCase();
        String ordinamento = getValue(request, "ordinamento");

        double prezzoMax = parseDouble(request.getParameter("prezzoMax"), 250);

        List<Product> prodotti = new ArrayList<>();

        try {
            prodotti = productDAO.doRetrieveAll();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Product> risultati = new ArrayList<>();

        for (Product prodotto : prodotti) {

            String nomeProdotto = safe(prodotto.getNomeProdotto()).toLowerCase();
            String descrizioneProdotto = safe(prodotto.getDescrizioneProdotto()).toLowerCase();
            String categoriaProdotto = safe(prodotto.getCategoria()).toLowerCase();
            String tagliaProdotto = safe(prodotto.getTaglia()).toLowerCase();
            String coloreProdotto = safe(prodotto.getColore()).toLowerCase();

            /*
             * Filtro ricerca testuale.
             * Se ricerca è vuota, passa tutto.
             */
            boolean ricercaOk =
                    ricerca.isEmpty()
                    || nomeProdotto.contains(ricerca)
                    || descrizioneProdotto.contains(ricerca)
                    || categoriaProdotto.contains(ricerca)
                    || coloreProdotto.contains(ricerca);

            /*
             * Filtro categoria.
             * Funziona con Felpe, Maglie, Scarpe.
             */
            boolean categoriaOk = true;

            if (!categoria.isEmpty()) {

                if ("felpe".equals(categoria)) {
                    categoriaOk =
                            categoriaProdotto.contains("felpa")
                            || categoriaProdotto.contains("felpe")
                            || nomeProdotto.contains("felpa")
                            || nomeProdotto.contains("hoodie");
                } else if ("maglie".equals(categoria)) {
                    categoriaOk =
                            categoriaProdotto.contains("maglia")
                            || categoriaProdotto.contains("maglie")
                            || categoriaProdotto.contains("t-shirt")
                            || categoriaProdotto.contains("tshirt")
                            || nomeProdotto.contains("maglia")
                            || nomeProdotto.contains("t-shirt")
                            || nomeProdotto.contains("tshirt");
                } else if ("scarpe".equals(categoria)) {
                    categoriaOk =
                            categoriaProdotto.contains("scarpa")
                            || categoriaProdotto.contains("scarpe")
                            || categoriaProdotto.contains("sneaker")
                            || categoriaProdotto.contains("sneakers")
                            || nomeProdotto.contains("scarpa")
                            || nomeProdotto.contains("scarpe")
                            || nomeProdotto.contains("sneaker")
                            || nomeProdotto.contains("sneakers");
                } else {
                    categoriaOk = categoriaProdotto.equals(categoria);
                }
            }

            /*
             * Filtro taglia.
             * Se taglia è vuota, passa tutto.
             */
            boolean tagliaOk =
                    taglia.isEmpty()
                    || tagliaProdotto.equals(taglia)
                    || tagliaProdotto.contains(taglia);

            /*
             * Filtro prezzo.
             */
            boolean prezzoOk = prodotto.getPrezzo() <= prezzoMax;

            if (ricercaOk && categoriaOk && tagliaOk && prezzoOk) {
                risultati.add(prodotto);
            }
        }

        /*
         * Ordinamento.
         */
        if ("prezzoAsc".equals(ordinamento)) {

            risultati.sort((p1, p2) -> Double.compare(p1.getPrezzo(), p2.getPrezzo()));

        } else if ("prezzoDesc".equals(ordinamento)) {

            risultati.sort((p1, p2) -> Double.compare(p2.getPrezzo(), p1.getPrezzo()));

        } else {

            risultati.sort((p1, p2) -> Integer.compare(p2.getIdProdotto(), p1.getIdProdotto()));
        }

        /*
         * Rimando alla JSP gli stessi valori, così i filtri restano selezionati.
         */
        request.setAttribute("prodotti", risultati);
        request.setAttribute("prezzoMax", prezzoMax);

        request.getRequestDispatcher("/WEB-INF/views/catalogo.jsp")
               .forward(request, response);
    }

    private String getValue(HttpServletRequest request, String name) {

        String value = request.getParameter(name);

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    private String safe(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    private double parseDouble(String value, double defaultValue) {

        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}