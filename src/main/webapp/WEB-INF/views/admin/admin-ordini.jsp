<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>


<%!
    private Object getValue(Object obj, String... methodNames) {
        if (obj == null) {
            return "";
        }

        for (String methodName : methodNames) {
            try {
                Method method = obj.getClass().getMethod(methodName);
                Object value = method.invoke(obj);

                if (value != null) {
                    return value;
                }
            } catch (Exception e) {
                // Provo il prossimo metodo
            }
        }

        return "";
    }

    private String safe(Object value) {
        if (value == null) {
            return "";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String formatEuro(Object value) {
        if (value == null || String.valueOf(value).trim().isEmpty()) {
            return "€ 0,00";
        }

        try {
            if (value instanceof Number) {
                NumberFormat nf = NumberFormat.getCurrencyInstance(Locale.ITALY);
                return nf.format(((Number) value).doubleValue());
            }

            String text = String.valueOf(value);

            if (text.contains("€")) {
                return text;
            }

            double number = Double.parseDouble(text.replace(",", "."));
            NumberFormat nf = NumberFormat.getCurrencyInstance(Locale.ITALY);
            return nf.format(number);

        } catch (Exception e) {
            return "€ " + String.valueOf(value);
        }
    }
%>

<%
    List<?> ordini = (List<?>) request.getAttribute("ordini");

    String cliente = (String) request.getAttribute("cliente");
    String dataDa = (String) request.getAttribute("dataDa");
    String dataA = (String) request.getAttribute("dataA");
    String erroreOrdini = (String) request.getAttribute("errore");

    if (cliente == null) {
        cliente = request.getParameter("cliente");
    }

    if (dataDa == null) {
        dataDa = request.getParameter("dataDa");
    }

    if (dataA == null) {
        dataA = request.getParameter("dataA");
    }

    if (cliente == null) {
        cliente = "";
    }

    if (dataDa == null) {
        dataDa = "";
    }

    if (dataA == null) {
        dataA = "";
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione ordini - Admin StreetWear</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

    <style>
        body {
            background: #f4f7f7;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .admin-orders-wrapper {
            min-height: 100vh;
            padding: 50px 70px;
        }

        .admin-orders-hero {
            background: linear-gradient(135deg, #ffffff, #dceeee);
            border-radius: 28px;
            padding: 35px 40px;
            margin-bottom: 30px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
        }

        .admin-label {
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #386b6b;
            font-size: 13px;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .admin-orders-hero h1 {
            margin: 0;
            font-size: 42px;
            color: #050505;
        }

        .admin-orders-hero p {
            margin-top: 10px;
            font-size: 17px;
            color: #333;
        }

        .back-link {
            display: inline-block;
            margin-top: 18px;
            color: #111;
            text-decoration: none;
            font-weight: 700;
        }

        .orders-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 35px 40px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
        }

        .orders-card h2 {
            margin-top: 0;
            margin-bottom: 25px;
            font-size: 30px;
            color: #050505;
        }

        .admin-alert-error {
            background: #fdeaea;
            color: #8f2d2d;
            border: 1px solid #f4c4c4;
            padding: 15px 18px;
            border-radius: 14px;
            margin-bottom: 25px;
            font-weight: 700;
        }

        .admin-filter-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 18px;
        }

        .admin-filter-table td {
            vertical-align: top;
        }

        .admin-filter-table .label-cell {
            width: 220px;
            padding-top: 14px;
            font-weight: 800;
            color: #1d2b2b;
            font-size: 15px;
        }

        .admin-filter-table input {
            width: 100%;
            max-width: 650px;
            padding: 14px 16px;
            border-radius: 14px;
            border: 1px solid #d5e0e0;
            background: #f9fbfb;
            font-size: 15px;
            outline: none;
            box-sizing: border-box;
        }

        .admin-filter-table input:focus {
            background: #ffffff;
            border-color: #7fb1b1;
            box-shadow: 0 0 0 4px rgba(127, 177, 177, 0.18);
        }

        .two-fields {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            max-width: 650px;
        }

        .form-actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn-primary-admin,
        .btn-secondary-admin {
            border: none;
            border-radius: 16px;
            padding: 15px 26px;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary-admin {
            background: #86b4b4;
            color: #000;
        }

        .btn-primary-admin:hover {
            background: #74a5a5;
        }

        .btn-secondary-admin {
            background: #eef4f4;
            color: #111;
            border: 1px solid #d5e0e0;
        }

        .btn-secondary-admin:hover {
            background: #e2ecec;
        }

        .orders-table-wrapper {
            overflow-x: auto;
        }

        .admin-orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            overflow: hidden;
            border-radius: 18px;
        }

        .admin-orders-table thead {
            background: #0d1115;
            color: #ffffff;
        }

        .admin-orders-table th {
            padding: 18px 16px;
            text-align: left;
            font-size: 14px;
            font-weight: 800;
        }

        .admin-orders-table td {
            padding: 18px 16px;
            border-bottom: 1px solid #e5eeee;
            font-size: 15px;
            color: #1e2a2a;
            background: #ffffff;
        }

        .admin-orders-table tbody tr:hover td {
            background: #f4fafa;
        }

        .order-id {
            font-weight: 900;
            color: #000;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 999px;
            background: #e6f1f1;
            color: #315f5f;
            font-weight: 800;
            font-size: 13px;
        }

        .details-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 9px 14px;
            border-radius: 12px;
            background: #86b4b4;
            color: #000;
            text-decoration: none;
            font-weight: 800;
            font-size: 14px;
        }

        .details-link:hover {
            background: #74a5a5;
        }

        .empty-row {
            text-align: center;
            padding: 35px !important;
            color: #6b7777 !important;
            font-weight: 600;
        }

        @media (max-width: 800px) {
            .admin-orders-wrapper {
                padding: 25px 18px;
            }

            .admin-orders-hero h1 {
                font-size: 32px;
            }

            .admin-filter-table,
            .admin-filter-table tbody,
            .admin-filter-table tr,
            .admin-filter-table td {
                display: block;
                width: 100%;
            }

            .admin-filter-table .label-cell {
                padding-top: 0;
                margin-bottom: 8px;
            }

            .two-fields {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-primary-admin,
            .btn-secondary-admin {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<%@ include file="../fragments/header.jsp" %>

<%@ include file="../fragments/messages.jsp" %>

<div class="admin-orders-wrapper">

    <div class="admin-orders-hero">
        <div class="admin-label">Pannello amministratore</div>

        <h1>Gestione ordini</h1>

        <p>Visualizza, filtra e controlla gli ordini effettuati dagli utenti.</p>

        <a class="back-link" href="<%= request.getContextPath() %>/Admin/Home">
            ← Torna alla dashboard
        </a>
    </div>

    <div class="orders-card">

        <div class="admin-label">Filtri ordini</div>

        <h2>Cerca ordini</h2>

        <% if (erroreOrdini != null && !erroreOrdini.trim().isEmpty()) { %>
    <div class="admin-alert-error">
        <%= safe(erroreOrdini) %>
    </div>
<% } %>

        <form action="<%= request.getContextPath() %>/Admin/Ordini" method="get">

            <table class="admin-filter-table">

                <tr>
                    <td class="label-cell">
                        <label for="cliente">Cliente</label>
                    </td>
                    <td>
                        <input
                            type="text"
                            id="cliente"
                            name="cliente"
                            placeholder="Email cliente oppure ID cliente"
                            value="<%= safe(cliente) %>">
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">
                        Intervallo date
                    </td>
                    <td>
                        <div class="two-fields">
                            <input
                                type="date"
                                id="dataDa"
                                name="dataDa"
                                value="<%= safe(dataDa) %>">

                            <input
                                type="date"
                                id="dataA"
                                name="dataA"
                                value="<%= safe(dataA) %>">
                        </div>
                    </td>
                </tr>

            </table>

            <div class="form-actions">
                <button type="submit" class="btn-primary-admin">
                    Filtra ordini
                </button>

                <a href="<%= request.getContextPath() %>/Admin/Ordini" class="btn-secondary-admin">
                    Reset
                </a>
            </div>

        </form>

    </div>

    <div class="orders-card">

        <div class="admin-label">Storico ordini</div>

        <h2>Lista ordini</h2>

        <div class="orders-table-wrapper">

            <table class="admin-orders-table">

                <thead>
                    <tr>
                        <th>ID ordine</th>
                        <th>ID cliente</th>
                        <th>Email</th>
                        <th>Data</th>
                        <th>Totale</th>
                        <th>Stato</th>
                        <th>Dettagli</th>
                    </tr>
                </thead>

                <tbody>

                    <% if (ordini == null || ordini.isEmpty()) { %>

                        <tr>
                            <td colspan="7" class="empty-row">
                                Nessun ordine presente al momento.
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Object ordine : ordini) { %>

                            <%
                                Object idOrdineObj = getValue(
                                        ordine,
                                        "getIdOrdine",
                                        "getIDOrdine",
                                        "getId",
                                        "getId_ordine"
                                );

                                String idOrdine = safe(idOrdineObj);

                                Object idCliente = getValue(
                                        ordine,
                                        "getIdUtente",
                                        "getIdCliente",
                                        "getId_utente",
                                        "getClienteId"
                                );

                                Object email = getValue(
                                        ordine,
                                        "getEmail",
                                        "getEmailCliente",
                                        "getClienteEmail"
                                );

                                Object data = getValue(
                                        ordine,
                                        "getDataOrdine",
                                        "getData",
                                        "getData_ordine"
                                );

                                Object totale = getValue(
                                        ordine,
                                        "getTotale",
                                        "getImportoTotale",
                                        "getPrezzoTotale"
                                );

                                Object stato = getValue(
                                        ordine,
                                        "getStatoOrdine",
                                        "getStato",
                                        "getStato_ordine"
                                );
                            %>

                            <tr>
                                <td class="order-id">
                                    #<%= idOrdine %>
                                </td>

                                <td>
                                    <%= safe(idCliente) %>
                                </td>

                                <td>
                                    <%= safe(email) %>
                                </td>

                                <td>
                                    <%= safe(data) %>
                                </td>

                                <td>
                                    <strong><%= formatEuro(totale) %></strong>
                                </td>

                                <td>
                                    <span class="status-badge">
                                        <%= safe(stato) %>
                                    </span>
                                </td>

                                <td>
                                    <a class="details-link"
   										href="<%= request.getContextPath() %>/Admin/Ordine?idOrdine=<%= idOrdine %>&id=<%= idOrdine %>">
   										Apri
									</a>
                                </td>
                            </tr>

                        <% } %>

                    <% } %>

                </tbody>

            </table>

        </div>

    </div>

</div>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>