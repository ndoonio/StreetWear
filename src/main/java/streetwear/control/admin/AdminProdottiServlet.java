package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.Product;
import streetwear.model.ProductDAO;

@WebServlet("/Admin/Prodotti")
public class AdminProdottiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO prodottoDAO;

    @Override
    public void init() throws ServletException {
        prodottoDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Product> prodotti = prodottoDAO.doRetrieveAll();

            request.setAttribute("prodotti", prodotti);

            request.getRequestDispatcher("/WEB-INF/views/admin/admin-prodotti.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            throw new ServletException("Errore durante il caricamento dei prodotti admin.", e);
        }
    }
}