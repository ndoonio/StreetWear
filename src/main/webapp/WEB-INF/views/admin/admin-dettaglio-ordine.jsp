<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="streetwear.model.Order" %>
<%@ page import="streetwear.model.OrderRow" %>

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
    Order ordine = (Order) request.getAttribute("ordine");
    if (ordine == null) {
        ordine = (Order) request.getAttribute("order");
    }

    @SuppressWarnings("unchecked")
    List<OrderRow> righeOrdine = (List<OrderRow>) request.getAttribute("righeOrdine");

    if (righeOrdine == null && ordine != null) {
        righeOrdine = ordine.getRighe();
    }

    double totaleOrdine = 0.0;

    if (righeOrdine != null) {
        for (OrderRow riga : righeOrdine) {
            totaleOrdine += riga.getPrezzoStorico() * riga.getQuantita();
        }
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dettaglio ordine - StreetWear</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

    <style>
        .admin-detail-page {
            max-width: 1500px;
            margin: 40px auto;
            padding: 0 24px;
        }

        .admin-detail-hero {
            background: #eaf5f5;
            border-radius: 26px;
            padding: 34px 38px;
            margin-bottom: 26px;
        }

        .admin-detail-label {
            font-size: 13px;
            letter-spacing: 2px;
            text-transform: uppercase;
            font-weight: 700;
            color: #3d6a73;
            margin-bottom: 8px;
        }

        .admin-detail-hero h1 {
            margin: 0 0 8px 0;
            font-size: 52px;
            line-height: 1.05;
            font-weight: 800;
            color: #000;
        }

        .admin-detail-hero p {
            margin: 6px 0;
            color: #42535a;
            font-size: 16px;
        }

        .admin-detail-back {
            display: inline-block;
            margin-top: 14px;
            color: #111;
            font-weight: 700;
            text-decoration: none;
        }

        .admin-detail-card {
            background: #ffffff;
            border-radius: 24px;
            padding: 30px 30px 24px 30px;
            margin-bottom: 24px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.04);
        }

        .admin-detail-card h2 {
            margin: 6px 0 22px 0;
            font-size: 24px;
            font-weight: 800;
            color: #000;
        }

        .admin-summary-table {
            width: 100%;
            max-width: 820px;
            border-collapse: separate;
            border-spacing: 0 14px;
        }

        .admin-summary-table td:first-child {
            width: 240px;
            font-weight: 700;
            color: #111;
            padding-right: 18px;
            vertical-align: middle;
        }

        .admin-summary-box {
            width: 100%;
            min-height: 52px;
            border: 1px solid #d6e0e0;
            border-radius: 12px;
            background: #f9fcfc;
            display: flex;
            align-items: center;
            padding: 0 16px;
            font-size: 15px;
            color: #223338;
        }

        .admin-status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 14px;
            border-radius: 999px;
            background: #dfeeee;
            color: #2e6570;
            font-weight: 700;
            font-size: 13px;
        }

        .admin-total-pill {
            display: inline-block;
            background: #050914;
            color: #fff;
            padding: 7px 14px;
            border-radius: 10px;
            font-weight: 700;
        }

        .admin-products-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            overflow: hidden;
            border-radius: 18px;
        }

        .admin-products-table thead th {
            background: #050914;
            color: #fff;
            text-align: left;
            padding: 18px 16px;
            font-size: 15px;
            font-weight: 700;
        }

        .admin-products-table thead th:first-child {
            border-top-left-radius: 18px;
        }

        .admin-products-table thead th:last-child {
            border-top-right-radius: 18px;
        }

        .admin-products-table tbody td {
            padding: 18px 16px;
            border-bottom: 1px solid #e3ebeb;
            font-size: 15px;
            color: #1f2e33;
            background: #fff;
        }

        .admin-products-table tbody tr:last-child td {
            border-bottom: none;
        }

        .admin-products-table tbody td strong {
            color: #000;
        }

        .admin-detail-actions {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 22px;
        }

        .admin-btn-primary,
        .admin-btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 48px;
            padding: 0 20px;
            border-radius: 14px;
            text-decoration: none;
            font-weight: 700;
            font-size: 15px;
            border: none;
            cursor: pointer;
        }

        .admin-btn-primary {
            background: #8db8b8;
            color: #000;
        }

        .admin-btn-primary:hover {
            opacity: 0.92;
        }

        .admin-btn-secondary {
            background: #eef3f3;
            color: #000;
            border: 1px solid #d5dede;
        }

        @media print {
            header,
            footer,
            .no-print {
                display: none !important;
            }

            .admin-detail-page {
                max-width: 100%;
                margin: 0;
                padding: 0;
            }

            .admin-detail-card,
            .admin-detail-hero {
                box-shadow: none;
                border: 1px solid #ddd;
            }
        }

        @media (max-width: 900px) {
            .admin-detail-hero h1 {
                font-size: 36px;
            }

            .admin-summary-table,
            .admin-summary-table tbody,
            .admin-summary-table tr,
            .admin-summary-table td {
                display: block;
                width: 100%;
            }

            .admin-summary-table tr {
                margin-bottom: 12px;
            }

            .admin-summary-table td:first-child {
                margin-bottom: 6px;
            }

            .admin-products-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>

    <main class="admin-detail-page">

        <% if (ordine != null) { %>

            <section class="admin-detail-hero">
                <div class="admin-detail-label">Pannello amministratore</div>
                <h1>Dettaglio ordine #<%= ordine.getIdOrdine() %></h1>
                <p><strong>Fattura ordine StreetWear</strong></p>
                <p>Visualizza il riepilogo dell'ordine e i prodotti acquistati dal cliente.</p>

                <a href="<%= request.getContextPath() %>/Admin/Ordini" class="admin-detail-back no-print">
                    ← Torna agli ordini
                </a>
            </section>

            <section class="admin-detail-card">
                <div class="admin-detail-label">Riepilogo ordine</div>
                <h2>Informazioni ordine</h2>

                <table class="admin-summary-table">
                    <tbody>
                        <tr>
                            <td>ID ordine</td>
                            <td>
                                <div class="admin-summary-box">#<%= ordine.getIdOrdine() %></div>
                            </td>
                        </tr>

                        <tr>
                            <td>ID cliente</td>
                            <td>
                                <div class="admin-summary-box"><%= ordine.getIdUtente() %></div>
                            </td>
                        </tr>

                        <tr>
                            <td>Email cliente</td>
                            <td>
                                <div class="admin-summary-box"><%= safe(ordine.getEmailCliente()) %></div>
                            </td>
                        </tr>

                        <tr>
                            <td>Data ordine</td>
                            <td>
                                <div class="admin-summary-box"><%= ordine.getDataOrdine() %></div>
                            </td>
                        </tr>

                        <tr>
                            <td>Stato</td>
                            <td>
                                <div class="admin-summary-box">
                                    <span class="admin-status-badge"><%= safe(ordine.getStatoOrdine()) %></span>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>Totale ordine</td>
                            <td>
                                <div class="admin-summary-box">
                                    <span class="admin-total-pill">
                                        € <%= String.format(Locale.ITALY, "%.2f", totaleOrdine) %>
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </section>

            <section class="admin-detail-card">
                <div class="admin-detail-label">Prodotti acquistati</div>
                <h2>Lista prodotti</h2>

                <table class="admin-products-table">
                    <thead>
                        <tr>
                            <th>Prodotto</th>
                            <th>Quantità</th>
                            <th>Prezzo unitario</th>
                            <th>IVA</th>
                            <th>Totale riga</th>
                        </tr>
                    </thead>
                    <tbody>

                        <% if (righeOrdine != null && !righeOrdine.isEmpty()) { %>
                            <% for (OrderRow riga : righeOrdine) { 
                                   String nomeProdotto = riga.getNomeProdottoStorico();
                                   int quantita = riga.getQuantita();
                                   double prezzoUnitario = riga.getPrezzoStorico();
                                   int iva = riga.getIvaStorica();
                                   double totaleRiga = prezzoUnitario * quantita;
                            %>
                                <tr>
                                    <td><strong><%= safe(nomeProdotto) %></strong></td>
                                    <td><%= quantita %></td>
                                    <td>€ <%= String.format(Locale.ITALY, "%.2f", prezzoUnitario) %></td>
                                    <td><%= iva %>%</td>
                                    <td>€ <%= String.format(Locale.ITALY, "%.2f", totaleRiga) %></td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="5">Nessun prodotto presente in questo ordine.</td>
                            </tr>
                        <% } %>

                    </tbody>
                </table>

                <div class="admin-detail-actions no-print">
                    <button type="button" class="admin-btn-primary" onclick="window.print()">
                        Stampa fattura
                    </button>

                    <a href="<%= request.getContextPath() %>/Admin/Ordini" class="admin-btn-primary">
                        ← Torna alla lista ordini
                    </a>

                    <a href="<%= request.getContextPath() %>/Admin/Home" class="admin-btn-secondary">
                        Dashboard
                    </a>
                </div>
            </section>

        <% } else { %>

            <section class="admin-detail-card">
                <div class="admin-detail-label">Pannello amministratore</div>
                <h2>Ordine non trovato</h2>
                <p>Non è stato possibile caricare il dettaglio dell'ordine.</p>

                <div class="admin-detail-actions no-print">
                    <a href="<%= request.getContextPath() %>/Admin/Ordini" class="admin-btn-primary">
                        Torna agli ordini
                    </a>
                </div>
            </section>

        <% } %>

    </main>

    <%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>