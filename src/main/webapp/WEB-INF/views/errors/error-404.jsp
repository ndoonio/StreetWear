<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Pagina non trovata | StreetWear</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

<%@ include file="../fragments/header.jsp" %>

<main class="error-page">

    <section class="error-card">

        <span class="error-code">404</span>

        <h1>Pagina non trovata</h1>

        <p>
            La pagina che stai cercando non esiste oppure è stata spostata.
        </p>

        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/Home" class="error-btn">
                Torna alla Home
            </a>

            <a href="<%= request.getContextPath() %>/Catalogo" class="error-btn secondary">
                Vai al catalogo
            </a>
        </div>

    </section>

</main>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>