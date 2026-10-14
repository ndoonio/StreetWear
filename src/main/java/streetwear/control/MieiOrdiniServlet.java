package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import streetwear.model.Order;
import streetwear.model.OrderDAO;
import streetwear.model.User;

@WebServlet("/MieiOrdini")
public class MieiOrdiniServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

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

        try {
            /*
             * Uso l'email dell'utente loggato per recuperare solo i suoi ordini.
             * Il tuo OrderDAO già usa doRetrieveAll(dataDa, dataA, cliente).
             */
            List<Order> ordini = orderDAO.doRetrieveAll(null, null, user.getEmail());

            request.setAttribute("ordini", ordini);

            request.getRequestDispatcher("/WEB-INF/views/miei-ordini.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            throw new ServletException("Errore durante il caricamento dei tuoi ordini.", e);
        }
    }
}