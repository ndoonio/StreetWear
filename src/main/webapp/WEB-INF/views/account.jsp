<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="streetwear.model.User" %>

<%
    User utente = (User) request.getAttribute("utente");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Il mio account | StreetWear</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

    <style>
        .account-page {
            min-height: calc(100vh - 76px);
            padding: 70px 20px;
            background: #f3f5f4;
        }

        .account-card {
            width: min(850px, 100%);
            margin: 0 auto;
            background: #ffffff;
            border-radius: 28px;
            padding: 40px;
            box-shadow: 0 16px 45px rgba(0, 0, 0, 0.10);
        }

        .account-card h1 {
            font-size: 42px;
            margin-bottom: 10px;
        }

        .account-card p {
            color: #5f6666;
            margin-bottom: 30px;
        }

        .account-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 16px;
        }

        .account-table td {
            padding: 16px;
            background: #f8fbfb;
            border-radius: 14px;
        }

        .account-table td:first-child {
            width: 220px;
            font-weight: 900;
            color: #476b6b;
        }

        .account-actions {
            margin-top: 30px;
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .account-btn {
            padding: 13px 22px;
            border-radius: 999px;
            background: #85adad;
            color: #000;
            font-weight: 900;
            text-decoration: none;
        }

        .account-btn.dark {
            background: #000;
            color: #fff;
        }
    </style>
</head>

<body>

<%@ include file="fragments/header.jsp" %>

<main class="account-page">

    <section class="account-card">

        <span class="eyebrow">Area personale</span>

        <h1>Gestisci account</h1>

        <p>Qui puoi visualizzare le informazioni principali del tuo profilo.</p>

        <table class="account-table">

            <tr>
                <td>ID utente</td>
                <td><%= utente.getIdUtente() %></td>
            </tr>

            <tr>
                <td>Nome</td>
                <td><%= utente.getNome() %></td>
            </tr>

            <tr>
                <td>Cognome</td>
                <td><%= utente.getCognome() %></td>
            </tr>

            <tr>
                <td>Email</td>
                <td><%= utente.getEmail() %></td>
            </tr>

            <tr>
                <td>Ruolo</td>
                <td><%= utente.getRuolo() %></td>
            </tr>

        </table>

        <div class="account-actions">
            <a href="<%= request.getContextPath() %>/MieiOrdini" class="account-btn">
                Vedi i miei ordini
            </a>

            <a href="<%= request.getContextPath() %>/Logout" class="account-btn dark">
                Esci
            </a>
        </div>

    </section>

</main>

<%@ include file="fragments/footer.jsp" %>

</body>
</html>