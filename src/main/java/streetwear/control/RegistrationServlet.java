package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.PasswordUtils;
import streetwear.model.User;
import streetwear.model.UserDAO;

@WebServlet("/Registrazione")
public class RegistrationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = getValue(request, "nome");
        String cognome = getValue(request, "cognome");
        String email = getValue(request, "email");
        String password = getValue(request, "password");
        String confermaPassword = getValue(request, "confermaPassword");

        if (nome.isEmpty() || cognome.isEmpty() || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errore", "Compila tutti i campi obbligatori.");
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp")
                   .forward(request, response);
            return;
        }

        if (!password.equals(confermaPassword)) {
            request.setAttribute("errore", "Le password non coincidono.");
            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp")
                   .forward(request, response);
            return;
        }

        try {
            User utenteEsistente = userDAO.doRetrieveByEmail(email);

            if (utenteEsistente != null) {
                request.setAttribute("errore", "Email già registrata.");
                request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp")
                       .forward(request, response);
                return;
            }

            User user = new User();

            user.setNome(nome);
            user.setCognome(cognome);
            user.setEmail(email);
            user.setPwd(PasswordUtils.hashPassword(password));
            user.setRuolo("utente");

            userDAO.doSave(user);

            HttpSession session = request.getSession(true);

            session.setAttribute(
                    "messaggio",
                    "Registrazione completata con successo! Ora puoi accedere."
            );

            response.sendRedirect(request.getContextPath() + "/Login");

        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute("errore", "Errore SQL: " + e.getMessage());

            request.getRequestDispatcher("/WEB-INF/views/registrazione.jsp")
                   .forward(request, response);
        }
    }

    private String getValue(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }
}