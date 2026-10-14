package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import streetwear.model.PasswordUtils;
import streetwear.model.User;
import streetwear.model.UserDAO;

/*
 * Servlet per login e apertura pagina login.
 */
@WebServlet("/Login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = getParameterTrim(request, "email");
        String password = getParameterTrim(request, "password");

        if (email.isEmpty() || password.isEmpty()) {

            request.setAttribute("errore", "Email e password sono obbligatorie.");

            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);

            return;
        }

        try {
            User user = userDAO.doRetrieveByEmail(email);

            if (user == null) {

                request.setAttribute("errore", "Email o password errati.");

                request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                       .forward(request, response);

                return;
            }

            boolean passwordCorretta = PasswordUtils.verifyPassword(password, user.getPwd());

            if (!passwordCorretta) {

                request.setAttribute("errore", "Email o password errati.");

                request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                       .forward(request, response);

                return;
            }

            /*
             * Login corretto.
             */
            HttpSession session = request.getSession(true);

            /*
             * Salvo i dati utente in sessione.
             *
             * Metto sia "user" sia "utente" per evitare problemi
             * con JSP/servlet che usano nomi diversi.
             */
            session.setAttribute("user", user);
            session.setAttribute("utente", user);

            session.setAttribute("idUtente", user.getIdUtente());
            session.setAttribute("nome", user.getNome());
            session.setAttribute("ruolo", user.getRuolo());

            if ("admin".equalsIgnoreCase(user.getRuolo())) {
                response.sendRedirect(request.getContextPath() + "/Admin/Home");
            } else {
                response.sendRedirect(request.getContextPath() + "/Home");
            }

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute("errore", "Errore durante il login. Controlla la connessione al database.");

            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
        }
    }

    private String getParameterTrim(HttpServletRequest request, String name) {

        String value = request.getParameter(name);

        if (value == null) {
            return "";
        }

        return value.trim();
    }
}