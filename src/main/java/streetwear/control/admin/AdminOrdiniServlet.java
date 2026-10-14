package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import streetwear.model.Order;
import streetwear.model.OrderDAO;

/*
 * Servlet per visualizzare e filtrare tutti gli ordini dal pannello admin.
 */
@WebServlet("/Admin/Ordini")
public class AdminOrdiniServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO ordineDAO;

    @Override
    public void init() throws ServletException {

        /*
         * Inizializzo il DAO una sola volta.
         *
         * NON uso DataSource qui, perché OrderDAO deve usare DBConnectionPool,
         * come ProductDAO e UserDAO.
         */
        ordineDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Parametri dei filtri della pagina admin.
         */
        String cliente = request.getParameter("cliente");
        String dataDa = request.getParameter("dataDa");
        String dataA = request.getParameter("dataA");

        try {
            /*
             * Recupero tutti gli ordini.
             *
             * Il tuo OrderDAO usa questo ordine:
             * doRetrieveAll(dataDa, dataA, cliente)
             */
            List<Order> ordini = ordineDAO.doRetrieveAll(dataDa, dataA, cliente);

            request.setAttribute("ordini", ordini);
            request.setAttribute("cliente", cliente);
            request.setAttribute("dataDa", dataDa);
            request.setAttribute("dataA", dataA);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-ordini.jsp")
                   .forward(request, response);

        } catch (IllegalArgumentException e) {

            request.setAttribute("errore", "Le date inserite non sono valide.");

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-ordini.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            e.printStackTrace();

            throw new ServletException("Errore durante il caricamento degli ordini admin.", e);
        }
    }
}