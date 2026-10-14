<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


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

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">

    <!-- Serve per rendere la pagina responsive su telefono/tablet -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Registrazione - StreetWear</title>

    <!-- Collegamento al CSS principale -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <!-- Header comune del sito -->
    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>
    

    <main class="auth-page">

        <section class="auth-card">

            <h1>Crea account</h1>

            <p>
                Registrati per acquistare prodotti, gestire il carrello e visualizzare lo storico ordini.
            </p>

            <%
                String errore = (String) request.getAttribute("errore");
                String successo = (String) request.getAttribute("successo");

                if (errore != null) {
            %>

                <div class="form-message error">
                    <%= safe(errore) %>
                </div>

            <%
                } else if (successo != null) {
            %>

                <div class="form-message success">
                    <%= safe(successo) %>
                </div>

            <%
                }
            %>

            <!-- Messaggio gestito da JavaScript lato client -->
            <div id="formMessage" class="form-message"></div>

            <!-- 
                Il form invia i dati alla Servlet RegistrazioneServlet.
                novalidate disattiva la validazione HTML automatica,
                così usiamo la nostra validazione JavaScript personalizzata.
            -->
            <form 
                action="<%= request.getContextPath() %>/Registrazione" 
                method="post" 
                id="registrazioneForm"
                novalidate>

                <!-- Campo nome -->
                <div class="form-group">
                    <label for="nome">Nome</label>

                    <input 
                        type="text" 
                        id="nome" 
                        name="nome" 
                        placeholder="Inserisci il tuo nome"
                        maxlength="30">

                    <small class="input-error" id="nomeError"></small>
                </div>

                <!-- Campo cognome -->
                <div class="form-group">
                    <label for="cognome">Cognome</label>

                    <input 
                        type="text" 
                        id="cognome" 
                        name="cognome" 
                        placeholder="Inserisci il tuo cognome"
                        maxlength="30">

                    <small class="input-error" id="cognomeError"></small>
                </div>

                <!-- Campo email -->
                <div class="form-group">
                    <label for="email">Email</label>

                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        placeholder="esempio@email.com"
                        maxlength="80">

                    <small class="input-error" id="emailError"></small>
                </div>

                <!-- Campo password -->
                <div class="form-group">
                    <label for="password">Password</label>

                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        placeholder="Minimo 8 caratteri"
                        maxlength="64">

                    <small class="input-error" id="passwordError"></small>
                </div>

                <!-- Campo conferma password -->
                <div class="form-group">
                    <label for="confermaPassword">Conferma password</label>

                    <input 
                        type="password" 
                        id="confermaPassword" 
                        name="confermaPassword" 
                        placeholder="Ripeti la password"
                        maxlength="64">

                    <small class="input-error" id="confermaPasswordError"></small>
                </div>

                <!-- Checkbox privacy obbligatoria -->
                <div class="form-check">
                    <input 
                        type="checkbox" 
                        id="privacy" 
                        name="privacy">

                    <label for="privacy">
                        Accetto l’informativa sulla privacy
                    </label>
                </div>

                <small class="input-error" id="privacyError"></small>

                <!-- 
                    Bottone comunque abilitato per inviare il form anche in assenza di JS
                    (La validazione server-side nella Servlet RegistrationServlet penserà a bloccarlo)
                -->
                <button 
                    type="submit" 
                    id="btnRegistrazione">
                    Crea account
                </button>

                <p class="auth-link">
                    Hai già un account?
                    <a href="<%= request.getContextPath() %>/Login">Accedi</a>
                </p>

            </form>

        </section>

    </main>

    <!-- Footer comune del sito -->
    <%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

    <!-- Collegamento al JavaScript -->
    <script src="<%= request.getContextPath() %>/js/script.js"></script>

</body>
</html>