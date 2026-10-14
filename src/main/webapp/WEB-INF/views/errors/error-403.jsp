<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Accesso negato | StreetWear</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

<%@ include file="../fragments/header.jsp" %>

<main class="error-page">

    <section class="error-card">

        <span class="error-code">403</span>

        <h1>Accesso negato</h1>

        <p>
            Non hai i permessi necessari per visualizzare questa pagina.
        </p>

        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/Home" class="error-btn">
                Torna alla Home
            </a>

            <a href="<%= request.getContextPath() %>/Login" class="error-btn secondary">
                Accedi
            </a>
        </div>

    </section>

</main>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>