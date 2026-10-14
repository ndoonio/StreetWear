<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    /*
     * Recupero l'utente dalla sessione.
     * Uso sia "utente" sia "user" perché nel progetto alcune pagine
     * potrebbero usare nomi diversi.
     */
    Object headerAccountObj = session.getAttribute("utente");

    if (headerAccountObj == null) {
        headerAccountObj = session.getAttribute("user");
    }

    /*
     * Nome da mostrare nel bottone account.
     */
    String headerNomeAccount = (String) session.getAttribute("nome");

    if (headerNomeAccount == null || headerNomeAccount.trim().isEmpty()) {
        headerNomeAccount = "Account";
    }

    /*
     * Numero prodotti nel carrello.
     */
    int headerCartCount = 0;

    Object headerCartCountObj = session.getAttribute("cartCount");

    if (headerCartCountObj == null) {
        headerCartCountObj = session.getAttribute("quantitaCarrello");
    }

    if (headerCartCountObj == null) {
        headerCartCountObj = session.getAttribute("carrelloCount");
    }

    if (headerCartCountObj != null) {
        try {
            headerCartCount = Integer.parseInt(String.valueOf(headerCartCountObj));
        } catch (NumberFormatException e) {
            headerCartCount = 0;
        }
    }
%>

<header class="site-header">

    <nav class="navbar">

        <a href="<%= request.getContextPath() %>/Home" class="logo-txt">
            Street<span>Wear</span>
        </a>

        <button class="menu-toggle" type="button" aria-label="Apri menu">
            <span></span>
            <span></span>
            <span></span>
        </button>

        <div class="nav-links">

            <a href="<%= request.getContextPath() %>/Home">
                Home
            </a>

            <a href="<%= request.getContextPath() %>/Catalogo">
                Catalogo
            </a>

            <a href="<%= request.getContextPath() %>/Assistenza">
                Assistenza
            </a>

            <a href="<%= request.getContextPath() %>/Carrello">
                Carrello
                <span class="cart-count"><%= headerCartCount %></span>
            </a>

            <% if (headerAccountObj != null) { %>

                <div class="account-dropdown">

                    <button type="button" class="account-dropdown-btn">
                        <%= headerNomeAccount %>
                        <span>v</span>
                    </button>

                    <div class="account-dropdown-menu">

                       <a href="<%= request.getContextPath() %>/Account">
    						Gestisci account
							</a>

						<a href="<%= request.getContextPath() %>/MieiOrdini">
    						I miei ordini
							</a>

                        <a href="<%= request.getContextPath() %>/Logout" class="logout-link">
                            Esci
                        </a>

                    </div>

                </div>

            <% } else { %>

                <a href="<%= request.getContextPath() %>/Login" class="nav-cta">
                    Account
                </a>

            <% } %>

        </div>

    </nav>

</header>