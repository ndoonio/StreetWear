<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="streetwear.model.Product" %>

<%
    Product prodotto = (Product) request.getAttribute("prodotto");

    boolean modifica = prodotto != null;

    String titolo = modifica ? "Modifica prodotto" : "Aggiungi prodotto";

    String action = modifica
            ? request.getContextPath() + "/Admin/ModificaProdotto"
            : request.getContextPath() + "/Admin/NuovoProdotto";
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title><%= titolo %> - Admin StreetWear</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

    <style>
        body {
            background: #f4f7f7;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .admin-form-wrapper {
            min-height: 100vh;
            padding: 50px 70px;
        }

        .admin-form-hero {
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

        .admin-form-hero h1 {
            margin: 0;
            font-size: 42px;
            color: #050505;
        }

        .admin-form-hero p {
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

        .form-card {
            background: #ffffff;
            border-radius: 28px;
            padding: 35px 40px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
        }

        .form-card h2 {
            margin-top: 0;
            margin-bottom: 25px;
            font-size: 30px;
            color: #050505;
        }

        .admin-product-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 18px;
        }

        .admin-product-table td {
            vertical-align: top;
        }

        .admin-product-table .label-cell {
            width: 220px;
            padding-top: 14px;
            font-weight: 800;
            color: #1d2b2b;
            font-size: 15px;
        }

        .admin-product-table input,
        .admin-product-table textarea,
        .admin-product-table select {
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

        .admin-product-table textarea {
            height: 120px;
            resize: vertical;
        }

        .admin-product-table input:focus,
        .admin-product-table textarea:focus,
        .admin-product-table select:focus {
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

        .checkbox-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            color: #243232;
        }

        .checkbox-row input {
            width: 18px;
            height: 18px;
            accent-color: #7fb1b1;
        }

        .form-actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
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

        @media (max-width: 800px) {
            .admin-form-wrapper {
                padding: 25px 18px;
            }

            .admin-form-hero h1 {
                font-size: 32px;
            }

            .admin-product-table,
            .admin-product-table tbody,
            .admin-product-table tr,
            .admin-product-table td {
                display: block;
                width: 100%;
            }

            .admin-product-table .label-cell {
                padding-top: 0;
                margin-bottom: 8px;
            }

            .two-fields {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<%@ include file="../fragments/header.jsp" %>

<div class="admin-form-wrapper">

    <div class="admin-form-hero">
        <div class="admin-label">Pannello amministratore</div>

        <h1><%= titolo %></h1>

        <p>
            <%= modifica
                    ? "Aggiorna i dati del prodotto selezionato."
                    : "Inserisci un nuovo prodotto nel catalogo StreetWear." %>
        </p>

        <a class="back-link" href="<%= request.getContextPath() %>/Admin/Prodotti">
            ← Torna ai prodotti
        </a>
    </div>

    <div class="form-card">

        <div class="admin-label">Scheda prodotto</div>

        <h2>
            <%= modifica
                    ? "Modifica i dati del prodotto"
                    : "Compila i dati del nuovo prodotto" %>
        </h2>

        <form action="<%= action %>" method="post">

            <% if (modifica) { %>
                <input type="hidden" name="idProdotto" value="<%= prodotto.getIdProdotto() %>">
            <% } %>

            <table class="admin-product-table">

                <tr>
                    <td class="label-cell">
                        <label for="nomeProdotto">Nome prodotto</label>
                    </td>
                    <td>
                        <input
                            type="text"
                            id="nomeProdotto"
                            name="nomeProdotto"
                            placeholder="Es. Felpa Oversize"
                            required
                            value="<%= modifica ? prodotto.getNomeProdotto() : "" %>">
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">
                        <label for="categoria">Categoria</label>
                    </td>
                    <td>
                        <input
                            type="text"
                            id="categoria"
                            name="categoria"
                            placeholder="Es. Felpe"
                            required
                            value="<%= modifica ? prodotto.getCategoria() : "" %>">
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">
                        <label for="descrizioneProdotto">Descrizione</label>
                    </td>
                    <td>
                        <textarea
                            id="descrizioneProdotto"
                            name="descrizioneProdotto"
                            placeholder="Inserisci una descrizione del prodotto"
                            required><%= modifica ? prodotto.getDescrizioneProdotto() : "" %></textarea>
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">Prezzo e IVA</td>
                    <td>
                        <div class="two-fields">
                            <input
                                type="number"
                                name="prezzo"
                                step="0.01"
                                min="0"
                                placeholder="Prezzo, es. 49.90"
                                required
                                value="<%= modifica ? prodotto.getPrezzo() : "" %>">

                            <input
                                type="number"
                                name="iva"
                                step="0.01"
                                min="0"
                                placeholder="IVA, es. 22.00"
                                required
                                value="<%= modifica ? prodotto.getIva() : "22.00" %>">
                        </div>
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">Taglia e colore</td>
                    <td>
                        <div class="two-fields">
                            <select name="taglia" required>
                                <option value="">Seleziona taglia</option>
                                <option value="XS" <%= modifica && "XS".equalsIgnoreCase(prodotto.getTaglia()) ? "selected" : "" %>>XS</option>
                                <option value="S" <%= modifica && "S".equalsIgnoreCase(prodotto.getTaglia()) ? "selected" : "" %>>S</option>
                                <option value="M" <%= modifica && "M".equalsIgnoreCase(prodotto.getTaglia()) ? "selected" : "" %>>M</option>
                                <option value="L" <%= modifica && "L".equalsIgnoreCase(prodotto.getTaglia()) ? "selected" : "" %>>L</option>
                                <option value="XL" <%= modifica && "XL".equalsIgnoreCase(prodotto.getTaglia()) ? "selected" : "" %>>XL</option>
                            </select>

                            <input
                                type="text"
                                name="colore"
                                placeholder="Colore, es. Nero"
                                required
                                value="<%= modifica ? prodotto.getColore() : "" %>">
                        </div>
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">Quantità e immagine</td>
                    <td>
                        <div class="two-fields">
                            <input
                                type="number"
                                name="quantita"
                                min="0"
                                placeholder="Quantità disponibile"
                                required
                                value="<%= modifica ? prodotto.getQuantita() : "0" %>">

                            <input
                                type="text"
                                name="immagine"
                                placeholder="Nome immagine, es. hoodiezip.jpg"
                                required
                                value="<%= modifica ? prodotto.getImmagineUrl() : "" %>">
                        </div>
                    </td>
                </tr>

                <tr>
                    <td class="label-cell">Visibilità</td>
                    <td>
                        <label class="checkbox-row">
                            <input
                                type="checkbox"
                                name="attivo"
                                value="true"
                                <%= !modifica || prodotto.isAttivo() ? "checked" : "" %>>

                            Prodotto attivo e visibile nel catalogo
                        </label>
                    </td>
                </tr>

            </table>

            <div class="form-actions">
                <button type="submit" class="btn-primary-admin">
                    <%= modifica ? "Salva modifiche" : "Inserisci prodotto" %>
                </button>

                <a href="<%= request.getContextPath() %>/Admin/Prodotti" class="btn-secondary-admin">
                    Annulla
                </a>
            </div>

        </form>

    </div>

</div>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>