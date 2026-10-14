<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Login - StreetWear</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

    <%@ include file="/WEB-INF/views/fragments/header.jsp" %>

    <%@ include file="/WEB-INF/views/fragments/messages.jsp" %>

    <main class="auth-page">

        <section class="auth-card">

            <div class="auth-left">
                <p class="section-label">Bentornato</p>

                <h1>
                    Accedi al<br>
                    tuo<br>
                    account.
                </h1>

                <p>
                    Ritrova ordini, preferiti e il tuo stile.
                </p>
            </div>

            <div class="auth-right">

                <form action="<%= request.getContextPath() %>/Login" method="post" class="auth-form">

                    <div class="form-group">
                        <label for="email">Email</label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="nome@esempio.it"
                            required>
                    </div>

                    <div class="form-group password-group">
                        <label for="password">Password</label>

                        <div class="password-wrapper">
                            <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Inserisci la password"
                                required>

                            <button type="button" class="show-password-btn" onclick="togglePassword()">
                                Mostra
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary auth-submit">
                        Accedi
                    </button>

                    <p class="auth-switch">
                        Non hai un account?
                        <a href="<%= request.getContextPath() %>/Registrazione">
                            Registrati
                        </a>
                    </p>

                </form>

            </div>

        </section>

    </main>

    <%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

    <script>
        function togglePassword() {
            var passwordInput = document.getElementById("password");
            var button = document.querySelector(".show-password-btn");

            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                button.textContent = "Nascondi";
            } else {
                passwordInput.type = "password";
                button.textContent = "Mostra";
            }
        }
    </script>

</body>
</html>