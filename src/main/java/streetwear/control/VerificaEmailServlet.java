package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import streetwear.model.UserDAO;

@WebServlet("/VerificaEmail")
public class VerificaEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        
        boolean giaPresente = false;
        try {
            // Gestiamo l'eccezione SQL con il try-catch
            giaPresente = (dao.doRetrieveByEmail(email) != null);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.setContentType("application/json;charset=UTF-8");
        // Restituisce true se disponibile, false se già usata nel DB
        response.getWriter().write("{\"disponibile\":" + (!giaPresente) + "}");
    }
}