package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;



import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import streetwear.model.Order;
import streetwear.model.OrderRow;
import streetwear.model.OrderDAO;

@WebServlet("/Admin/Ordine")
public class AdminDettaglioOrdineServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {

        /*
         * OrderDAO usa già DBConnectionPool,
         * quindi non devo più passargli il DataSource.
         */
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idOrdine = Integer.parseInt(request.getParameter("id"));

            Order ordine = orderDAO.doRetrieveByKey(idOrdine);

            if (ordine == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            ArrayList<OrderRow> dettagli = orderDAO.doRetrieveRowsByOrder(idOrdine);

            request.setAttribute("ordine", ordine);
            request.setAttribute("dettagli", dettagli);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-dettaglio-ordine.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}