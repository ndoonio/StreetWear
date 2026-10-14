<%--
    Footer condiviso tra le pagine del sito.
    I collegamenti usano request.getContextPath() per funzionare
    correttamente anche se cambia il nome del progetto.
--%>
<footer class="site-footer">
    <div class="footer-grid">
        <div>
            <a href="<%= request.getContextPath() %>/Home" class="logo-txt">
                Street
                <span>Wear</span>
            </a>

            <p>
                Il tuo stile, la tua strada.
            </p>
        </div>

        <div>
            <h3>
                Esplora
            </h3>

            <a href="<%= request.getContextPath() %>/Home">
                Home
            </a>

            <a href="<%= request.getContextPath() %>/Catalogo">
                Catalogo
            </a>
        </div>

        <div>
            <h3>
                Supporto
            </h3>

            <a href="<%= request.getContextPath() %>/Assistenza">
                Assistenza
            </a>

            <a href="<%= request.getContextPath() %>/Carrello">
                Carrello
            </a>
        </div>
    </div>

    <p class="footer-copy">
        &copy; 2026 StreetWear - Progetto TSW
    </p>
</footer>
