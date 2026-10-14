package streetwear.control;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import streetwear.model.User;

/*
 * Filtro che protegge tutta l'area amministratore.
 * Intercetta tutte le richieste che iniziano con /Admin/.
 */
@WebFilter("/Admin/*")
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        /*
         * Non serve inizializzare nulla.
         */
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        /*
         * Caso 1:
         * Nessuna sessione = utente non loggato.
         */
        if (session == null) {
            HttpSession nuovaSessione = httpRequest.getSession(true);
            nuovaSessione.setAttribute("errore", "Devi effettuare il login per accedere all'area admin.");

            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login");
            return;
        }

        /*
         * Recupero il ruolo dalla sessione.
         */
        String ruolo = null;

        Object ruoloObj = session.getAttribute("ruolo");

        if (ruoloObj != null) {
            ruolo = String.valueOf(ruoloObj);
        }

        /*
         * Se il ruolo non è salvato direttamente in sessione,
         * provo a recuperarlo dall'oggetto User.
         */
        if (ruolo == null || ruolo.trim().isEmpty()) {

            Object userObj = session.getAttribute("utente");

            if (userObj == null) {
                userObj = session.getAttribute("user");
            }

            if (userObj instanceof User) {
                User user = (User) userObj;
                ruolo = user.getRuolo();
            }
        }

        /*
         * Caso 2:
         * Utente loggato, ma non admin.
         */
        if (ruolo == null || !"admin".equalsIgnoreCase(ruolo.trim())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        /*
         * Caso 3:
         * Utente admin.
         * Può continuare verso la servlet richiesta.
         */
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        /*
         * Non serve chiudere nulla.
         */
    }
}