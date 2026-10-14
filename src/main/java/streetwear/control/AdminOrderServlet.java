package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import streetwear.model.OrderDAO;

@WebServlet("/admin/OrderManager")
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO = new OrderDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String startDate = request.getParameter("startDate") != null ? request.getParameter("startDate").trim() : "";
        String endDate = request.getParameter("endDate") != null ? request.getParameter("endDate").trim() : "";
        String emailCliente = request.getParameter("emailCliente") != null ? request.getParameter("emailCliente").trim() : "";

        try {
            request.setAttribute("orderList", orderDAO.doRetrieveAll(startDate, endDate, emailCliente));
            request.getRequestDispatcher("/admin/ordini.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}