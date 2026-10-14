package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.UserDAO;

@WebServlet("/CheckEmail")
public class CheckEmailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null) {
            email = "";
        }

        email = email.trim().toLowerCase();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            boolean exists = false;

            if (!email.isEmpty()) {
                exists = userDAO.doRetrieveByEmail(email) != null;
            }

            response.getWriter().write("{\"exists\":" + exists + "}");

        } catch (SQLException e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"exists\":false,\"error\":true}");
        }
    }
}