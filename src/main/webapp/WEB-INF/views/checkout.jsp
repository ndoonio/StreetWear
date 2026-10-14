<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Locale" %>
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
%>

<%
    @SuppressWarnings("unchecked")
    List<Product> prodottiCheckout = (List<Product>) request.getAttribute("prodottiCheckout");

    @SuppressWarnings("unchecked")
    Map<Integer, Integer> quantitaCheckout = (Map<Integer, Integer>) request.getAttribute("quantitaCheckout");

    Double totaleCheckout = (Double) request.getAttribute("totaleCheckout");

    String messaggioCheckout = (String) request.getAttribute("messaggioCheckout");
    String erroreCheckout = (String) request.getAttribute("erroreCheckout");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Checkout - StreetWear</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>
    <%@ include file="/WEB-INF/views/fragments/messages.jsp" %>

    <main class="checkout-page">

        <section class="checkout-hero">
            <p class="section-label">Checkout</p>
            <h1>Conferma il tuo ordine</h1>
            <p>Controlla i prodotti nel carrello e completa l'acquisto.</p>
        </section>

        <% if (messaggioCheckout != null && !messaggioCheckout.trim().isEmpty()) { %>

            <div class="success-message">
                <%= safe(messaggioCheckout) %>
            </div>

        <% } %>

        <% if (erroreCheckout != null && !erroreCheckout.trim().isEmpty()) { %>

            <div class="form-message error" style="display:block;">
                <%= safe(erroreCheckout) %>
            </div>

        <% } %>

        <% if (prodottiCheckout != null && !prodottiCheckout.isEmpty()) { %>

            <section class="checkout-card">

                <h2>Riepilogo ordine</h2>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Prodotto</th>
                            <th>Prezzo unitario</th>
                            <th>IVA</th>
                            <th>Quantità</th>
                            <th>Totale riga</th>
                        </tr>
                    </thead>

                    <tbody>

                        <%
                            for (Product prodotto : prodottiCheckout) {

                                int quantita = 1;

                                if (quantitaCheckout != null &&
                                    quantitaCheckout.get(prodotto.getIdProdotto()) != null) {

                                    quantita = quantitaCheckout.get(prodotto.getIdProdotto());
                                }

                                double prezzo = prodotto.getPrezzo();
                                double iva = prodotto.getIva();
                                double totaleRiga = prezzo * quantita * (1 + iva / 100.0);
                        %>

                            <tr>
                                <td>
                                    <strong><%= safe(prodotto.getNomeProdotto()) %></strong>
                                </td>

                                <td>
                                    &euro; <%= String.format(Locale.ITALY, "%.2f", prezzo) %>
                                </td>

                                <td>
                                    <%= String.format(Locale.ITALY, "%.0f", iva) %>%
                                </td>

                                <td>
                                    <%= quantita %>
                                </td>

                                <td>
                                    &euro; <%= String.format(Locale.ITALY, "%.2f", totaleRiga) %>
                                </td>
                            </tr>

                        <%
                            }
                        %>

                    </tbody>
                </table>

                <div class="checkout-total-box">
                    <span>Totale ordine</span>

                    <strong>
                        &euro; <%= String.format(Locale.ITALY, "%.2f", totaleCheckout != null ? totaleCheckout : 0) %>
                    </strong>
                </div>

                <form action="<%= request.getContextPath() %>/Checkout" method="post">
                    <button class="btn btn-primary" type="submit">
                        Conferma ordine
                    </button>
                </form>

            </section>

        <% } else { %>

            <section class="checkout-card">
                <h2>Carrello vuoto</h2>

                <p>Non ci sono prodotti da acquistare.</p>

                <a href="<%= request.getContextPath() %>/Catalogo" class="btn btn-primary">
                    Vai al catalogo
                </a>
            </section>

        <% } %>

    </main>

    <%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>