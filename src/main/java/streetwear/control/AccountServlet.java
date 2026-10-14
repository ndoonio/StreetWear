package streetwear.control;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import streetwear.model.User;

@WebServlet("/Account")
public class AccountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("utente");

        if (user == null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        request.setAttribute("utente", user);

        request.getRequestDispatcher("/WEB-INF/views/account.jsp")
               .forward(request, response);
    }
}