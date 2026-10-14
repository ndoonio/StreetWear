<aside class="admin-sidebar">

    <div class="admin-sidebar-logo">
        <div class="admin-sidebar-icon">SW</div>

        <div>
            <h2>Admin Panel</h2>
            <p>StreetWear</p>
        </div>
    </div>

    <nav class="admin-sidebar-menu">

        <a href="<%= request.getContextPath() %>/Admin/Home" class="admin-sidebar-link">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/Admin/Ordini" class="admin-sidebar-link">
            Gestione ordini
        </a>

    </nav>

    <a href="<%= request.getContextPath() %>/Home" class="admin-sidebar-back">
        Torna al sito
    </a>

</aside>