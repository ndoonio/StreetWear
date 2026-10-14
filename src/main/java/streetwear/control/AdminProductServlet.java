package streetwear.control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import streetwear.model.Product;
import streetwear.model.ProductDAO;

@WebServlet("/admin/ProductManager")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO = new ProductDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action").trim() : "";
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                productDAO.doDelete(id);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti.jsp?msg=deleted");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product p = productDAO.doRetrieveByKey(id);
                request.setAttribute("productToEdit", p);
                request.getRequestDispatcher("/admin/modifica_prodotto.jsp").forward(request, response);
            } else {
                request.setAttribute("productList", productDAO.doRetrieveAll());
                request.getRequestDispatcher("/admin/prodotti.jsp").forward(request, response);
            }
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") != null ? request.getParameter("action").trim() : "";
        
        Product p = new Product();
        String idStr = request.getParameter("id") != null ? request.getParameter("id").trim() : "";
        if(!idStr.isEmpty()) {
            p.setIdProdotto(Integer.parseInt(idStr));
        }
        
        p.setNomeProdotto(request.getParameter("nome") != null ? request.getParameter("nome").trim() : "");
        p.setDescrizioneProdotto(request.getParameter("descrizione") != null ? request.getParameter("descrizione").trim() : "");
        
        String prezzoStr = request.getParameter("prezzo") != null ? request.getParameter("prezzo").trim() : "0.0";
        p.setPrezzo(Double.parseDouble(prezzoStr));
        
        p.setTaglia(request.getParameter("taglia") != null ? request.getParameter("taglia").trim() : "");
        p.setColore(request.getParameter("colore") != null ? request.getParameter("colore").trim() : "");
        p.setImmagineUrl(request.getParameter("immagineUrl") != null ? request.getParameter("immagineUrl").trim() : "");

        try {
            if ("update".equals(action)) {
                productDAO.doUpdate(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti.jsp?msg=updated");
            } else {
                productDAO.doSave(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti.jsp?msg=inserted");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}