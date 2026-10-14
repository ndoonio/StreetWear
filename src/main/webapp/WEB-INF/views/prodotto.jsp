<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="streetwear.model.*" %>

<%
/* Recupera il prodotto passato dalla servlet. */
Product p = (Product) request.getAttribute("prodotto");

/* Se il prodotto è null (accesso diretto senza servlet), reindirizza al catalogo */
if (p == null) {
    response.sendRedirect(request.getContextPath() + "/Catalogo");
    return;
}

/* Gestione taglie e colori per il menu a scelta */
String[] taglie = (p.getTaglia() != null && !p.getTaglia().isEmpty()) 
                    ? p.getTaglia().split(",") 
                    : new String[]{"S", "M", "L", "XL"};

String[] colori = (p.getColore() != null && !p.getColore().isEmpty()) 
                    ? p.getColore().split(",") 
                    : new String[]{"Nero", "Bianco"};
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title><%= p.getNomeProdotto() %> | StreetWear</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <%@ include file="fragments/header.jsp" %>

    <main class="page-wrap">
        <%-- Percorso di navigazione della pagina prodotto. --%>
        <nav class="breadcrumbs">
            <a href="<%= request.getContextPath() %>/Home">Home</a>
            <span>/</span>
            <a href="<%= request.getContextPath() %>/Catalogo">Catalogo</a>
            <span>/</span>
            <span><%= p.getNomeProdotto() %></span>
        </nav>

        <section class="product-detail">
            <%-- Immagine principale del prodotto. --%>
            <div class="detail-image">
                <img src="<%= request.getContextPath() %>/images/<%= p.getImmagineUrl() %>" alt="<%= p.getNomeProdotto() %>">
            </div>

            <%-- Informazioni e form di acquisto del prodotto. --%>
            <div class="detail-info">
                <span class="eyebrow">
                    <%= p.getCategoria() != null ? p.getCategoria() : "Streetwear" %> / Collezione
                </span>

                <h1><%= p.getNomeProdotto() %></h1>

                <p class="detail-price">
                    €<%= String.format(Locale.ITALY, "%.2f", p.getPrezzo()) %>
                </p>

                <p class="detail-description">
                    <%= p.getDescrizione() != null ? p.getDescrizione() : "Capo di alta qualità della collezione StreetWear." %>
                </p>

                <form class="product-form" action="<%= request.getContextPath() %>/Carrello" method="post">
                    <input type="hidden" name="azione" value="aggiungi">
                    <input type="hidden" name="idProdotto" value="<%= p.getIdProdotto() %>">

                    <fieldset>
                        <legend>Taglia</legend>

                        <div class="choice-options">
                            <% for (String t : taglie) { 
                                t = t.trim();
                            %>
                                <label>
                                    <input type="radio" name="taglia" value="<%= t %>" required>
                                    <span><%= t %></span>
                                </label>
                            <% } %>
                        </div>
                    </fieldset>

                    <fieldset>
                        <legend>Colore</legend>

                        <select name="colore" required>
                            <option value="">Scegli il colore</option>

                            <% for (String c : colori) { 
                                c = c.trim();
                            %>
                                <option value="<%= c %>"><%= c %></option>
                            <% } %>
                        </select>
                    </fieldset>

                    <label class="quantity-label" for="quantita">Quantità</label>

                    <div class="purchase-row">
                        <input id="quantita" name="quantita" type="number" min="1" max="10" value="1">

                        <button class="btn btn-primary" type="submit">
                            Aggiungi al carrello
                        </button>
                    </div>
                </form>

                <div class="product-benefits">
                    <p>✓ Spedizione gratuita sopra 80€</p>
                    <p>✓ Reso semplice entro 30 giorni</p>
                    <p>✓ Pagamento protetto</p>
                </div>
            </div>
        </section>
    </main>

    <%@ include file="fragments/footer.jsp" %>

    <script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>