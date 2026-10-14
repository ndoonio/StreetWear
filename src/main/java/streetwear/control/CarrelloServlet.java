package streetwear.control;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Gestisce il carrello salvato nella sessione dell'utente.
 */
@WebServlet("/Carrello")
public class CarrelloServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Recupera il carrello dalla sessione.
     * Se non esiste, crea una nuova mappa vuota.
     */
    @SuppressWarnings("unchecked")
    private Map<Integer, Integer> cart(HttpSession s) {
        Map<Integer, Integer> c =
                (Map<Integer, Integer>) s.getAttribute("carrello");

        if (c == null) {
            c = new LinkedHashMap<>();
            s.setAttribute("carrello", c);
        }

        return c;
    }

    /**
     * Mostra la pagina del carrello.
     */
    @Override
    protected void doGet(HttpServletRequest r, HttpServletResponse p)
            throws ServletException, IOException {

        // Passa il carrello alla JSP.
        r.setAttribute("carrello", cart(r.getSession()));

        r.getRequestDispatcher("/WEB-INF/views/carrello.jsp")
                .forward(r, p);
    }

    /**
     * Gestisce aggiunta, rimozione e aggiornamento delle quantità.
     */
    @Override
    protected void doPost(HttpServletRequest r, HttpServletResponse p)
            throws IOException {

        Map<Integer, Integer> c = cart(r.getSession());

        int id = parse(r.getParameter("idProdotto"), 0);
        String a = r.getParameter("azione");

        // Aggiunge il prodotto incrementando la quantità fino a un massimo di 10.
     // Aggiunge il prodotto incrementando la quantità fino a un massimo di 10.
        if ("aggiungi".equals(a) && id > 0) {
            c.put(
                    id,
                    Math.min(
                            10,
                            c.getOrDefault(id, 0)
                                    + Math.max(
                                            1,
                                            parse(r.getParameter("quantita"), 1)
                                    )
                    )
            );

            r.getSession().setAttribute("messaggio", "Prodotto aggiunto al carrello.");

        } else if ("rimuovi".equals(a)) {
            // Rimuove completamente il prodotto dal carrello.
            c.remove(id);

        } else if ("aggiorna".equals(a)) {
            // Aggiorna la quantità oppure rimuove il prodotto se è minore o uguale a zero.
            int q = parse(r.getParameter("quantita"), 1);

            if (q <= 0) {
                c.remove(id);
            } else {
                c.put(id, Math.min(10, q));
            }
        }

        // Torna alla pagina del carrello.
        p.sendRedirect(r.getContextPath() + "/Carrello");
    }

    /**
     * Converte una stringa in intero.
     * In caso di errore restituisce il valore di default.
     */
    private int parse(String v, int d) {
        try {
            return Integer.parseInt(v);
        } catch (Exception e) {
            return d;
        }
    }
}