package streetwear.control.admin;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import streetwear.model.ProductDAO;

@WebServlet("/Admin/EliminaProdotto")
public class AdminEliminaProdottoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("idProdotto");

        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = request.getParameter("id");
        }

        HttpSession session = request.getSession(true);

        if (idParam == null || idParam.trim().isEmpty()) {
            session.setAttribute("errore", "ID prodotto mancante.");
            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
            return;
        }

        try {
            int idProdotto = Integer.parseInt(idParam);

            productDAO.doDeleteLogical(idProdotto);

            session.setAttribute("messaggio", "Prodotto eliminato correttamente dal catalogo.");

            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");

        } catch (NumberFormatException e) {

            session.setAttribute("errore", "ID prodotto non valido.");
            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");

        } catch (SQLException e) {

            e.printStackTrace();

            session.setAttribute("errore", "Errore durante l'eliminazione del prodotto.");
            response.sendRedirect(request.getContextPath() + "/Admin/Prodotti");
        }
    }
}