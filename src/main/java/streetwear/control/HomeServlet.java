package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import streetwear.model.Product;
import streetwear.model.ProductDAO;

@WebServlet("/Home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> prodotti = new ArrayList<>();

        try {
            prodotti = productDAO.doRetrieveAll();
        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute(
                    "dbWarning",
                    "Database non collegato: la home viene caricata senza prodotti."
            );
        }

        request.setAttribute("prodotti", prodotti);

        request.getRequestDispatcher("/WEB-INF/views/home.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}