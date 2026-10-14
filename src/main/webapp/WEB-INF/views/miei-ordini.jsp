<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="streetwear.model.Order" %>

<%
    List<Order> ordini = (List<Order>) request.getAttribute("ordini");

    if (ordini == null) {
        ordini = new java.util.ArrayList<Order>();
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>I miei ordini | StreetWear</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

    <style>
        .orders-page {
            min-height: calc(100vh - 76px);
            padding: 70px 20px;
            background: #f3f5f4;
        }

        .orders-card {
            width: min(1050px, 100%);
            margin: 0 auto;
            background: #ffffff;
            border-radius: 28px;
            padding: 40px;
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.10);
        }

        .orders-card h1 {
            font-size: 42px;
            margin-bottom: 10px;
        }

        .orders-card p {
            color: #5f6666;
            margin-bottom: 30px;
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 18px;
            overflow: hidden;
        }

        .orders-table th {
            background: #0f1115;
            color: #ffffff;
            text-align: left;
            padding: 16px;
        }

        .orders-table td {
            padding: 16px;
            border-bottom: 1px solid #e5eeee;
        }

        .orders-table tr:hover td {
            background: #f4fafa;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 13px;
            border-radius: 999px;
            background: #e6f1f1;
            color: #315f5f;
            font-weight: 900;
        }

        .empty-orders {
            text-align: center;
            padding: 35px !important;
            color: #5f6666;
            font-weight: 800;
        }

        .back-link-orders {
            display: inline-block;
            margin-top: 28px;
            padding: 13px 22px;
            border-radius: 999px;
            background: #85adad;
            color: #000;
            font-weight: 900;
            text-decoration: none;
        }
    </style>
</head>

<body>

<%@ include file="fragments/header.jsp" %>

<main class="orders-page">

    <section class="orders-card">

        <span class="eyebrow">Area personale</span>

        <h1>I miei ordini</h1>

        <p>Qui trovi lo storico degli ordini effettuati con il tuo account.</p>

        <table class="orders-table">

            <thead>
                <tr>
                    <th>ID ordine</th>
                    <th>Data</th>
                    <th>Totale</th>
                    <th>Stato</th>
                </tr>
            </thead>

            <tbody>

                <% if (ordini.isEmpty()) { %>

                    <tr>
                        <td colspan="4" class="empty-orders">
                            Non hai ancora effettuato ordini.
                        </td>
                    </tr>

                <% } else { %>

                    <% for (Order ordine : ordini) { %>

                        <tr>
                            <td>#<%= ordine.getIdOrdine() %></td>

                            <td><%= ordine.getDataOrdine() %></td>

                            <td>
                                € <%= String.format("%.2f", ordine.getTotale()) %>
                            </td>

                            <td>
                                <span class="status-badge">
                                    <%= ordine.getStatoOrdine() %>
                                </span>
                            </td>
                        </tr>

                    <% } %>

                <% } %>

            </tbody>

        </table>

        <a href="<%= request.getContextPath() %>/Account" class="back-link-orders">
            Torna al mio account
        </a>

    </section>

</main>

<%@ include file="fragments/footer.jsp" %>

</body>
</html>