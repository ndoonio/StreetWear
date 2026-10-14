<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="streetwear.model.Order" %>

<%
    List<Order> ultimiOrdini = (List<Order>) request.getAttribute("ultimiOrdini");

    if (ultimiOrdini == null) {
        ultimiOrdini = new java.util.ArrayList<Order>();
    }
%>

<%
    Integer prodottiTotali = (Integer) request.getAttribute("prodottiTotali");
    Integer ordiniTotali = (Integer) request.getAttribute("ordiniTotali");
    Integer checkoutTotali = (Integer) request.getAttribute("checkoutTotali");

    if (prodottiTotali == null) {
        prodottiTotali = 0;
    }

    if (ordiniTotali == null) {
        ordiniTotali = 0;
    }

    if (checkoutTotali == null) {
        checkoutTotali = 0;
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Admin - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>

<div class="admin-wrapper">

    <aside class="admin-sidebar">

        <div class="admin-logo">
            <div class="admin-logo-box">SW</div>

            <div>
                <h2>Admin Panel</h2>
                <p>StreetWear</p>
            </div>
        </div>

        <nav class="admin-menu">
            <a href="<%= request.getContextPath() %>/Admin/Home">🏠 Dashboard</a>
            <a href="<%= request.getContextPath() %>/Admin/Prodotti">👕 Gestione prodotti</a>
            <a href="<%= request.getContextPath() %>/Admin/NuovoProdotto">➕ Aggiungi prodotto</a>
            <a href="<%= request.getContextPath() %>/Admin/Ordini">📦 Gestione ordini</a>
            <a href="<%= request.getContextPath() %>/Home" class="logout">↩ Torna al sito</a>
        </nav>

    </aside>

    <main class="admin-content">

        <section class="admin-topbar">
            <div>
                <p class="admin-label">Pannello amministratore</p>
                <h1>Dashboard StreetWear</h1>
                <p>
                    Gestisci prodotti, ordini e contenuti principali del sito e-commerce.
                </p>
            </div>

            <a href="<%= request.getContextPath() %>/Admin/NuovoProdotto" class="admin-btn-primary">
                + Nuovo prodotto
            </a>
        </section>

        <section class="stats-grid">

            <article class="stat-card">
                <div class="stat-icon">👕</div>
                <div>
                    <p>Prodotti totali</p>
                    <h2><%= prodottiTotali %></h2>
                </div>
            </article>

            <article class="stat-card">
                <div class="stat-icon">📦</div>
                <div>
                    <p>Ordini totali</p>
                    <h2><%= ordiniTotali %></h2>
                </div>
            </article>

            <article class="stat-card">
                <div class="stat-icon">🛒</div>
                <div>
                    <p>Checkout</p>
                    <h2><%= checkoutTotali %></h2>
                </div>
            </article>

        </section>

        <section class="admin-panels">

            <article class="admin-panel">
                <h3>👕 Gestione prodotti</h3>
                <p>
                    Visualizza il catalogo, modifica prodotti esistenti,
                    elimina articoli e controlla le quantità disponibili.
                </p>
                <a href="<%= request.getContextPath() %>/Admin/Prodotti">Apri prodotti</a>
            </article>

            <article class="admin-panel">
                <h3>➕ Aggiungi prodotto</h3>
                <p>
                    Inserisci un nuovo capo nel catalogo con nome,
                    descrizione, prezzo, categoria, taglia e immagine.
                </p>
                <a href="<%= request.getContextPath() %>/Admin/NuovoProdotto">Inserisci</a>
            </article>

            <article class="admin-panel">
                <h3>📦 Gestione ordini</h3>
                <p>
                    Consulta gli ordini effettuati dagli utenti e filtra
                    lo storico per cliente o intervallo di date.
                </p>
                <a href="<%= request.getContextPath() %>/Admin/Ordini">Apri ordini</a>
            </article>

        </section>

        <section class="table-card">

            <div class="table-header">
                <div>
                    <p class="admin-label">Storico ordini</p>
                    <h2>Ultimi ordini</h2>
                </div>

                <a href="<%= request.getContextPath() %>/Admin/Ordini">Vedi tutti</a>
            </div>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID ordine</th>
                        <th>Cliente</th>
                        <th>Email</th>
                        <th>Data</th>
                        <th>Totale</th>
                        <th>Stato</th>
                        <th>Dettagli</th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <tbody>

    <% if (ultimiOrdini.isEmpty()) { %>

        <tr>
            <td colspan="7" class="admin-empty-row">
                Nessun ordine presente al momento.
            </td>
        </tr>

    <% } else { %>

        <% for (Order ordine : ultimiOrdini) { %>

            <tr>
                <td>
                    #<%= ordine.getIdOrdine() %>
                </td>

                <td>
                    <%= ordine.getIdUtente() %>
                </td>

                <td>
                    <%= ordine.getEmailCliente() %>
                </td>

                <td>
                    <%= ordine.getDataOrdine() %>
                </td>

                <td>
                    € <%= String.format("%.2f", ordine.getTotale()) %>
                </td>

                <td>
                    <%= ordine.getStatoOrdine() %>
                </td>

                <td>
                    <a href="<%= request.getContextPath() %>/Admin/Ordine?idOrdine=<%= ordine.getIdOrdine() %>&id=<%= ordine.getIdOrdine() %>">
                        Apri
                    </a>
                </td>
            </tr>

        <% } %>

    <% } %>

</tbody>
                    </tr>
                </tbody>
            </table>

        </section>

    </main>

</div>

</body>
</html>

 <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f3f5f5;
            color: #111111;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .admin-wrapper {
            min-height: 100vh;
            display: flex;
            background-color: #f3f5f5;
        }

        .admin-sidebar {
            width: 280px;
            background-color: #0f1115;
            color: white;
            padding: 28px 22px;
            min-height: 100vh;
            position: sticky;
            top: 0;
        }

        .admin-logo {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 36px;
        }

        .admin-logo-box {
            width: 52px;
            height: 52px;
            border-radius: 16px;
            background: linear-gradient(135deg, #85adad, #476b6b);
            color: #000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            font-size: 18px;
        }

        .admin-logo h2 {
            font-size: 22px;
        }

        .admin-logo p {
            font-size: 13px;
            color: #aab2b8;
            margin-top: 4px;
        }

        .admin-menu {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .admin-menu a {
            padding: 14px 16px;
            border-radius: 14px;
            color: #d7d7d7;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: 0.2s;
        }

        .admin-menu a:hover {
            background-color: rgba(133, 173, 173, 0.18);
            color: #ffffff;
            transform: translateX(4px);
        }

        .admin-menu .logout {
            margin-top: 28px;
            background-color: rgba(255, 255, 255, 0.08);
        }

        .admin-content {
            flex: 1;
            padding: 34px 46px;
        }

        .admin-topbar {
            background: linear-gradient(135deg, #ffffff, #c2d6d6);
            border-radius: 26px;
            padding: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 24px;
            box-shadow: 0 14px 35px rgba(0, 0, 0, 0.10);
            margin-bottom: 28px;
        }

        .admin-label {
            text-transform: uppercase;
            color: #476b6b;
            font-weight: 900;
            letter-spacing: 1px;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .admin-topbar h1 {
            font-size: 38px;
            margin-bottom: 10px;
        }

        .admin-topbar p {
            color: #444;
            line-height: 1.5;
        }

        .admin-btn-primary {
            background-color: #000000;
            color: #ffffff;
            padding: 14px 22px;
            border-radius: 999px;
            font-weight: 900;
            white-space: nowrap;
            transition: 0.2s;
        }

        .admin-btn-primary:hover {
            background-color: #476b6b;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
            margin-bottom: 28px;
        }

        .stat-card {
            background-color: #ffffff;
            border-radius: 22px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 18px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
        }

        .stat-icon {
            width: 62px;
            height: 62px;
            border-radius: 18px;
            background-color: #c2d6d6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }

        .stat-card p {
            color: #666;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .stat-card h2 {
            font-size: 36px;
        }

        .admin-panels {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
            margin-bottom: 28px;
        }

        .admin-panel {
            background-color: white;
            border-radius: 22px;
            padding: 26px;
            border-left: 7px solid #85adad;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
        }

        .admin-panel h3 {
            font-size: 22px;
            margin-bottom: 12px;
        }

        .admin-panel p {
            color: #555;
            line-height: 1.5;
            margin-bottom: 18px;
        }

        .admin-panel a {
            display: inline-block;
            background-color: #85adad;
            color: #000;
            padding: 11px 16px;
            border-radius: 12px;
            font-weight: 900;
        }

        .admin-panel a:hover {
            background-color: #476b6b;
            color: #ffffff;
        }

        .table-card {
            background-color: #ffffff;
            border-radius: 24px;
            padding: 26px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
        }

        .table-header h2 {
            font-size: 28px;
        }

        .table-header a {
            color: #476b6b;
            font-weight: 900;
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 16px;
        }

        .admin-table th {
            background-color: #0f1115;
            color: #ffffff;
            padding: 16px;
            text-align: left;
            font-size: 14px;
        }

        .admin-table td {
            padding: 16px;
            border-bottom: 1px solid #eeeeee;
        }

        .admin-table tbody tr:hover {
            background-color: #f5f8f8;
        }

        .empty-row {
            text-align: center;
            color: #666;
            padding: 28px !important;
        }

        @media (max-width: 1000px) {
            .admin-wrapper {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                min-height: auto;
                position: static;
            }

            .admin-content {
                padding: 24px;
            }

            .admin-topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .stats-grid,
            .admin-panels {
                grid-template-columns: 1fr;
            }
        }
    </style>