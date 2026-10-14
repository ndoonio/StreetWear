<%--
    PAGINA CARRELLO
    - Legge dalla request una Map<ID prodotto, quantità>.
    - Calcola il subtotale lato server recuperando i prodotti dal Database.
    - Per ogni prodotto crea un form per aggiornare o rimuovere la quantità.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.SQLException" %>
<%@ page import="streetwear.model.*" %>
<%@ page import="streetwear.control.*" %>



<%
/*
 * Recupera il carrello passato dalla servlet.
 * Se non esiste, utilizza una mappa vuota.
 */
Map<Integer, Integer> cart = (Map<Integer, Integer>) request.getAttribute("carrello");

if (cart == null) {
    cart = Collections.emptyMap();
}

/*
 * Inizializza il DAO per accedere al DB e calcola il subtotale.
 */
ProductDAO productDAO = new ProductDAO();
double totale = 0;

for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
    Product x = null;
    try {
        x = productDAO.doRetrieveByKey(e.getKey());
    } catch (SQLException ex) {
        ex.printStackTrace();
    }

    if (x != null) {
        totale += x.getPrezzo() * e.getValue();
    }
}
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Carrello | StreetWear</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <%@ include file="fragments/header.jsp" %>
    <%@ include file="/WEB-INF/views/fragments/messages.jsp" %>

    <main class="page-wrap">
        <div class="page-title">
            <span class="eyebrow">Il tuo ordine</span>
            <h1>Carrello</h1>
        </div>

        <%-- Se il carrello è vuoto mostra il relativo messaggio. --%>
        <% if (cart.isEmpty()) { %>
            <section class="empty-state">
                <h2>Il carrello è vuoto</h2>
                <p>Aggiungi un prodotto dal catalogo per iniziare.</p>
                <a class="btn btn-primary" href="<%= request.getContextPath() %>/Catalogo">
                    Vai al catalogo
                </a>
            </section>
        <% } else { %>
            <%-- Se il carrello contiene prodotti mostra lista e riepilogo. --%>
            <div class="cart-layout">
                <section class="cart-list">
                    <% for (Map.Entry<Integer, Integer> e : cart.entrySet()) { %>
                        <%
                        Product x = null;
                        try {
                            x = productDAO.doRetrieveByKey(e.getKey());
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }

                        if (x == null) continue;
                        %>

                        <article class="cart-item">
                            <img src="<%= request.getContextPath() %>/images/<%= x.getImmagineUrl() %>" alt="<%= x.getNomeProdotto() %>">

                            <div class="cart-item-info">
                                <small>Taglia: <%= x.getTaglia() %> | Colore: <%= x.getColore() %></small>
                                <h2><%= x.getNomeProdotto() %></h2>
                                <strong>€<%= String.format(Locale.ITALY, "%.2f", x.getPrezzo()) %></strong>
                            </div>

                            <%-- Form per aggiornare o rimuovere il prodotto. --%>
                            <form class="cart-controls" action="<%= request.getContextPath() %>/Carrello" method="post">
                                <input type="hidden" name="idProdotto" value="<%= x.getIdProdotto() %>">

                                <label>
                                    Quantità
                                    <input class="cart-quantity" type="number" name="quantita" min="1" max="10" value="<%= e.getValue() %>" data-price="<%= x.getPrezzo() %>">
                                </label>

                                <button class="btn-update" type="submit" name="azione" value="aggiorna">
                                    Aggiorna
                                </button>

                                <button class="remove-btn" type="submit" name="azione" value="rimuovi">
                                    Rimuovi
                                </button>
                            </form>
                        </article>
                    <% } %>
                </section>

                <%-- Riepilogo economico del carrello. --%>
                <aside class="order-summary">
                    <h2>Riepilogo</h2>

                    <div>
                        <span>Subtotale</span>
                        <strong id="cartSubtotal">
                            €<%= String.format(Locale.ITALY, "%.2f", totale) %>
                        </strong>
                    </div>

                    <div>
                        <span>Spedizione</span>
                        <strong><%= totale >= 80 ? "Gratuita" : "€5,90" %></strong>
                    </div>

                    <div class="total">
                        <span>Totale</span>
                        <strong id="cartTotal">
                            €<%= String.format(Locale.ITALY, "%.2f", totale + (totale >= 80 ? 0 : 5.90)) %>
                        </strong>
                    </div>

                    <a class="btn btn-primary full" href="<%= request.getContextPath() %>/Checkout">
                        Procedi al checkout
                    </a>

                    <a class="continue-link" href="<%= request.getContextPath() %>/Catalogo">
                        ← Continua lo shopping
                    </a>
                </aside>
            </div>
        <% } %>
    </main>

    <%@ include file="fragments/footer.jsp" %>

    <script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>