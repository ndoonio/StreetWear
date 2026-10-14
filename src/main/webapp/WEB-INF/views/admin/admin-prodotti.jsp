<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="streetwear.model.Product" %>

<%!
    private String safe(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;");
    }

    private String safeJs(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("\\", "\\\\")
                    .replace("'", "\\'")
                    .replace("\"", "\\\"")
                    .replace("\n", "")
                    .replace("\r", "");
    }
%>

<%
    @SuppressWarnings("unchecked")
    List<Product> prodotti = (List<Product>) request.getAttribute("prodotti");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Admin - Prodotti</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>

    <%@ include file="/WEB-INF/views/fragments/messages.jsp" %>

    <main class="admin-layout">

        <%@ include file="/WEB-INF/views/fragments/admin-sidebar.jsp" %>

        <section class="admin-content">

            <div class="admin-prodotti-center-action">
                <a href="<%= request.getContextPath() %>/Admin/NuovoProdotto" class="admin-prodotti-add-btn">
                    Aggiungi prodotto
                </a>
            </div>

            <table class="admin-table">

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Immagine</th>
                        <th>Nome</th>
                        <th>Prezzo</th>
                        <th>IVA</th>
                        <th>Categoria</th>
                        <th>Taglia</th>
                        <th>Colore</th>
                        <th>Quantità</th>
                        <th>Attivo</th>
                        <th>Azioni</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (prodotti != null && !prodotti.isEmpty()) { %>

                        <% for (Product prodotto : prodotti) { %>

                            <tr>
                                <td>
                                    <%= prodotto.getIdProdotto() %>
                                </td>

                                <td>
                                    <%
                                        String immagine = prodotto.getImmagineUrl();

                                        if (immagine != null && !immagine.trim().isEmpty()) {
                                    %>

                                        <img
                                            class="admin-product-img"
                                            src="<%= request.getContextPath() %>/images/<%= safe(immagine) %>"
                                            alt="Prodotto">

                                    <% } else { %>

                                        Nessuna

                                    <% } %>
                                </td>

                                <td>
                                    <%= safe(prodotto.getNomeProdotto()) %>
                                </td>

                                <td>
                                    € <%= String.format("%.2f", prodotto.getPrezzo()) %>
                                </td>

                                <td>
                                    <%= String.format("%.0f", prodotto.getIva()) %>%
                                </td>

                                <td>
                                    <%= safe(prodotto.getCategoria()) %>
                                </td>

                                <td>
                                    <%= safe(prodotto.getTaglia()) %>
                                </td>

                                <td>
                                    <%= safe(prodotto.getColore()) %>
                                </td>

                                <td>
                                    <%= prodotto.getQuantita() %>
                                </td>

                                <td>
                                    <%= prodotto.isAttivo() ? "Sì" : "No" %>
                                </td>

                                <td class="admin-actions-cell">

                                    <a href="<%= request.getContextPath() %>/Admin/ModificaProdotto?id=<%= prodotto.getIdProdotto() %>">
                                        Modifica
                                    </a>

                                    <form
                                        action="<%= request.getContextPath() %>/Admin/EliminaProdotto"
                                        method="post"
                                        class="admin-delete-form"
                                        onsubmit="return confermaEliminazioneProdotto('<%= safeJs(prodotto.getNomeProdotto()) %>');">

                                        <input
                                            type="hidden"
                                            name="idProdotto"
                                            value="<%= prodotto.getIdProdotto() %>">

                                        <button type="submit" class="admin-delete-btn">
                                            Elimina
                                        </button>

                                    </form>

                                </td>
                            </tr>

                        <% } %>

                    <% } else { %>

                        <tr>
                            <td colspan="11">
                                Nessun prodotto presente.
                            </td>
                        </tr>

                    <% } %>

                </tbody>

            </table>

        </section>

    </main>

    <%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

    <script>
        function confermaEliminazioneProdotto(nomeProdotto) {
            return confirm(
                "Sei sicuro di voler eliminare il prodotto \"" + nomeProdotto + "\" dal catalogo?"
            );
        }
    </script>

</body>
</html>