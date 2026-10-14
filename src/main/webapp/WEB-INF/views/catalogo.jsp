<%--
    PAGINA CATALOGO
    - Legge dalla request la lista filtrata dei prodotti.
    - Mantiene nei controlli i filtri già scelti dall'utente.
    - Mostra ricerca, ordinamento, filtri e schede prodotto.
    - Ogni pulsante "Aggiungi" invia un POST alla servlet /Carrello.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Locale" %>
<%@ page import="streetwear.model.Product" %>
<%@ include file="/WEB-INF/views/fragments/messages.jsp" %>

<%
    List<Product> prodotti = (List<Product>) request.getAttribute("prodotti");

    if (prodotti == null) {
        prodotti = Collections.emptyList();
    }

    String cat = request.getParameter("categoria");
    String tag = request.getParameter("taglia");
    String ord = request.getParameter("ordinamento");
    String ric = request.getParameter("ricerca");

    double max = request.getAttribute("prezzoMax") == null
            ? 250
            : (Double) request.getAttribute("prezzoMax");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Catalogo | StreetWear</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <%@ include file="fragments/header.jsp" %>

    <main class="page-wrap">

        <div class="page-title">
            <span class="eyebrow">Collezione completa</span>
            <h1>Catalogo</h1>
            <p>Trova il capo che racconta il tuo stile.</p>
        </div>

        <div class="catalog-layout">

            <%-- FILTRI LATERALI: QUESTA È LA PARTE CHE VOLEVI TENERE --%>
            <aside class="filters">

                <div class="filter-head">
                    <h2>Filtri</h2>
                    <a href="<%= request.getContextPath() %>/Catalogo">Azzera</a>
                </div>

                <form id="filtersForm" action="<%= request.getContextPath() %>/Catalogo" method="get">

                    <fieldset>
                        <legend>Categoria</legend>

                        <%
                            String[] categorie = {"Felpe", "Maglie", "Scarpe"};

                            for (String c : categorie) {
                        %>

                            <label>
                                <input 
                                    type="radio" 
                                    name="categoria" 
                                    value="<%= c %>" 
                                    <%= c.equalsIgnoreCase(cat) ? "checked" : "" %>>

                                <%= c %>
                            </label>

                        <%
                            }
                        %>
                    </fieldset>

                    <fieldset>
                        <legend>Taglia</legend>

                        <div class="size-options">

                            <%
                                String[] taglie = {"S", "M", "L", "XL"};

                                for (String t : taglie) {
                            %>

                                <label>
                                    <input 
                                        type="radio" 
                                        name="taglia" 
                                        value="<%= t %>" 
                                        <%= t.equalsIgnoreCase(tag) ? "checked" : "" %>>

                                    <span><%= t %></span>
                                </label>

                            <%
                                }
                            %>

                        </div>
                    </fieldset>

                    <fieldset>
                        <legend>Prezzo massimo</legend>

                        <input 
                            type="range" 
                            id="prezzo" 
                            name="prezzoMax" 
                            min="20" 
                            max="250" 
                            value="<%= (int) max %>">

                        <p>
                            Fino a
                            <strong>
                                <span id="valorePrezzo"><%= (int) max %></span>€
                            </strong>
                        </p>
                    </fieldset>

                    <%-- Mantiene ricerca e ordinamento quando applico i filtri --%>
                    <input type="hidden" name="ricerca" value="<%= ric == null ? "" : ric %>">
                    <input type="hidden" name="ordinamento" value="<%= ord == null ? "recenti" : ord %>">

                    <button class="btn btn-primary full" type="submit">
                        Applica filtri
                    </button>

                </form>

            </aside>

            <%-- CONTENUTO PRINCIPALE --%>
            <section class="catalog-content">

                <%-- Barra ricerca originale del catalogo --%>
                <form class="search-bar" action="<%= request.getContextPath() %>/Catalogo" method="get" role="search">

                    <input 
                        id="searchInput" 
                        name="ricerca" 
                        type="search" 
                        value="<%= ric == null ? "" : ric %>" 
                        placeholder="Cerca felpe, scarpe, t-shirt..." 
                        autocomplete="off">

                    <%-- Mantiene i filtri quando cerco --%>
                    <input type="hidden" name="categoria" value="<%= cat == null ? "" : cat %>">
                    <input type="hidden" name="taglia" value="<%= tag == null ? "" : tag %>">
                    <input type="hidden" name="prezzoMax" value="<%= (int) max %>">
                    <input type="hidden" name="ordinamento" value="<%= ord == null ? "recenti" : ord %>">

                    <button class="btn btn-primary" type="submit">
                        Cerca
                    </button>

                    <div id="searchSuggestions" class="suggestions" hidden></div>

                </form>

                <div class="results-head">

                    <p>
                        <strong><%= prodotti.size() %></strong>
                        prodotti
                    </p>

                    <%-- Ordinamento --%>
                    <form action="<%= request.getContextPath() %>/Catalogo" method="get">

                        <%-- Mantiene ricerca e filtri quando cambio ordinamento --%>
                        <input type="hidden" name="ricerca" value="<%= ric == null ? "" : ric %>">
                        <input type="hidden" name="categoria" value="<%= cat == null ? "" : cat %>">
                        <input type="hidden" name="taglia" value="<%= tag == null ? "" : tag %>">
                        <input type="hidden" name="prezzoMax" value="<%= (int) max %>">

                        <select name="ordinamento" aria-label="Ordina prodotti" onchange="this.form.submit()">

                            <option value="recenti" <%= ord == null || "recenti".equals(ord) ? "selected" : "" %>>
                                Più recenti
                            </option>

                            <option value="prezzoAsc" <%= "prezzoAsc".equals(ord) ? "selected" : "" %>>
                                Prezzo crescente
                            </option>

                            <option value="prezzoDesc" <%= "prezzoDesc".equals(ord) ? "selected" : "" %>>
                                Prezzo decrescente
                            </option>

                        </select>

                    </form>

                </div>

                <% if (prodotti.isEmpty()) { %>

                    <div class="empty-state">
                        <h2>Nessun prodotto trovato</h2>
                        <p>Prova a modificare ricerca o filtri.</p>
                    </div>

                <% } else { %>

                    <div class="product-grid compact">

                        <% for (Product p : prodotti) { 

                            String immagine = p.getImmagineUrl();

                            if (immagine == null || immagine.trim().isEmpty()) {
                                immagine = "t-shirt.jpg";
                            }

                            if (!immagine.startsWith("images/")) {
                                immagine = "images/" + immagine;
                            }
                        %>

                            <article class="product-card">

                                <a 
                                    href="<%= request.getContextPath() %>/Prodotto?id=<%= p.getIdProdotto() %>" 
                                    class="product-image">

                                    <img 
                                        src="<%= request.getContextPath() %>/<%= immagine %>" 
                                        alt="<%= p.getNomeProdotto() %>">
                                </a>

                                <div class="product-info">

                                    <small>
                                        Taglia: <%= p.getTaglia() %> | Colore: <%= p.getColore() %>
                                    </small>

                                    <h3>
                                        <%= p.getNomeProdotto() %>
                                    </h3>

                                    <div class="product-bottom">

                                        <strong>
                                            €<%= String.format(Locale.ITALY, "%.2f", p.getPrezzo()) %>
                                        </strong>

                                    </div>

                                    <div class="card-actions">

                                        <a 
                                            class="btn btn-outline" 
                                            href="<%= request.getContextPath() %>/Prodotto?id=<%= p.getIdProdotto() %>">
                                            Dettagli
                                        </a>

                                        <form action="<%= request.getContextPath() %>/Carrello" method="post">

                                            <input type="hidden" name="azione" value="aggiungi">
                                            <input type="hidden" name="idProdotto" value="<%= p.getIdProdotto() %>">
                                            <input type="hidden" name="quantita" value="1">

                                            <button class="btn btn-primary" type="submit">
                                                Aggiungi
                                            </button>

                                        </form>

                                    </div>

                                </div>

                            </article>

                        <% } %>

                    </div>

                <% } %>

            </section>

        </div>

    </main>

    <%@ include file="fragments/footer.jsp" %>

    <script src="<%= request.getContextPath() %>/js/script.js"></script>

</body>
</html>