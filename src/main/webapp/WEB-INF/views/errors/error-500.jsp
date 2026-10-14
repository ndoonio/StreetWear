<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Errore del server | StreetWear</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

<%@ include file="../fragments/header.jsp" %>

<main class="error-page">

    <section class="error-card">

        <span class="error-code">500</span>

        <h1>Errore del server</h1>

        <p>
            Si è verificato un problema interno. Riprova più tardi oppure torna alla Home.
        </p>

        <div class="error-actions">
            <a href="<%= request.getContextPath() %>/Home" class="error-btn">
                Torna alla Home
            </a>

            <a href="<%= request.getContextPath() %>/Assistenza" class="error-btn secondary">
                Contatta assistenza
            </a>
        </div>

    </section>

</main>

<%@ include file="../fragments/footer.jsp" %>

</body>
</html>