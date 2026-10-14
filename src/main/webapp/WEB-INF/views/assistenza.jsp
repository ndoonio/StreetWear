<%--
    PAGINA ASSISTENZA
    - Include l'header e il footer comuni.
    - Invia nome, email e messaggio alla servlet /Assistenza con metodo POST.
    - Visualizza gli attributi request "successo" oppure "errore".
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        Assistenza | StreetWear
    </title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <%-- Inserisce l'header condiviso. --%>
    <%@ include file="fragments/header.jsp" %>

    <main class="page-wrap">
        <%-- Titolo della pagina. --%>
        <div class="page-title">
            <span class="eyebrow">
                Siamo qui per aiutarti
            </span>

            <h1>
                Assistenza
            </h1>

            <p>
                Compila il modulo e ti risponderemo il prima possibile.
            </p>
        </div>

        <%-- Sezione che contiene introduzione e modulo di assistenza. --%>
        <section class="auth-card">
            <div class="auth-intro">
                <span class="eyebrow">
                    Contattaci
                </span>

                <h1>
                    Come possiamo aiutarti?
                </h1>

                <p>
                    Scrivici per informazioni su prodotti,
                    ordini, spedizioni e resi.
                </p>
            </div>

            <form class="auth-form" action="<%= request.getContextPath() %>/Assistenza" method="post">
                <%-- Messaggio mostrato quando la richiesta viene inviata correttamente. --%>
                <% if (request.getAttribute("successo") != null) { %>
                    <p class="success-message">
                        <%= request.getAttribute("successo") %>
                    </p>
                <% } %>

                <%-- Messaggio mostrato quando uno dei campi non è valido. --%>
                <% if (request.getAttribute("errore") != null) { %>
                    <p class="form-message">
                        <%= request.getAttribute("errore") %>
                    </p>
                <% } %>

                <div class="form-group">
                    <label for="nomeAssistenza">
                        Nome
                    </label>

                    <input type="text" id="nomeAssistenza" name="nome" placeholder="Inserisci il tuo nome" required>

                    <small class="field-error"></small>
                </div>

                <div class="form-group">
                    <label for="emailAssistenza">
                        Email
                    </label>

                    <input type="email" id="emailAssistenza" name="email" placeholder="nome@esempio.it" required>

                    <small class="field-error"></small>
                </div>

                <div class="form-group">
                    <label for="messaggioAssistenza">
                        Messaggio
                    </label>

                    <textarea id="messaggioAssistenza" name="messaggio" rows="6" placeholder="Descrivi il problema..." required></textarea>
                </div>

                <button class="btn btn-primary full" type="submit">
                    Invia richiesta
                </button>
            </form>
        </section>
    </main>

    <%-- Inserisce il footer condiviso. --%>
    <%@ include file="fragments/footer.jsp" %>

    <script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>

