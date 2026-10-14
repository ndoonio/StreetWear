package streetwear.control;

import java.io.IOException;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Gestisce la pagina di assistenza e l'invio del relativo modulo.
 */
@WebServlet("/Assistenza")
public class AssistenzaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Mostra la pagina JSP dell'assistenza.
     */
    protected void doGet(HttpServletRequest r, HttpServletResponse p)
            throws ServletException, IOException {

        r.getRequestDispatcher("/WEB-INF/views/assistenza.jsp")
                .forward(r, p);
    }

    /**
     * Controlla che i campi del modulo siano stati compilati.
     */
    protected void doPost(HttpServletRequest r, HttpServletResponse p)
            throws ServletException, IOException {

        // Imposta la codifica dei dati ricevuti dal form.
        r.setCharacterEncoding("UTF-8");

        // Se almeno un campo è vuoto viene mostrato un messaggio di errore.
        if (empty(r, "nome") || empty(r, "email") || empty(r, "messaggio"))
            r.setAttribute("errore", "Compila correttamente tutti i campi.");
        else
            // In caso contrario viene mostrato il messaggio di successo.
            r.setAttribute(
                    "successo",
                    "Richiesta inviata correttamente. Ti risponderemo presto."
            );

        // Torna alla stessa pagina mostrando il risultato dell'operazione.
        doGet(r, p);
    }

    /**
     * Restituisce true quando il parametro non esiste oppure è vuoto.
     */
    private boolean empty(HttpServletRequest r, String n) {
        return r.getParameter(n) == null
                || r.getParameter(n).trim().isEmpty();
    }
}
