package streetwear.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import streetwear.model.Product;
import streetwear.model.ProductDAO;

@WebServlet("/Prodotto")
public class ProdottoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String idParam = req.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/Catalogo");
                return;
            }

            int id = Integer.parseInt(idParam);
            Product p = productDAO.doRetrieveByKey(id);

            if (p == null) {
                resp.sendRedirect(req.getContextPath() + "/Catalogo");
                return;
            }

            req.setAttribute("prodotto", p);

            // PERCORSO ESATTO basato sulla struttura del tuo progetto
            req.getRequestDispatcher("/WEB-INF/views/prodotto.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/Catalogo");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}