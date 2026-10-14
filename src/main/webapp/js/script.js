document.addEventListener("DOMContentLoaded", function () {

    /* ==========================================================================
       1. CONTEXT PATH AUTOMATICO
       ========================================================================== */
    var scriptTag = null;
    for (var i = 0; i < document.scripts.length; i++) {
        if (/\/js\/script\.js(?:\?|$)/.test(document.scripts[i].src)) {
            scriptTag = document.scripts[i];
            break;
        }
    }
    var contextPath = scriptTag ? new URL(scriptTag.src).pathname.replace(/\/js\/script\.js$/, "") : "";

    /* ==========================================================================
       2. MENU MOBILE
       ========================================================================== */
    var menuButton = document.querySelector(".menu-toggle");
    var menu = document.getElementById("mainMenu");

    if (menuButton && menu) {
        menuButton.addEventListener("click", function () {
            var open = menu.classList.toggle("open");
            menuButton.setAttribute("aria-expanded", String(open));
        });
    }

    /* ==========================================================================
       3. TOGGLE PASSWORD (MOSTRA / NASCONDI)
       ========================================================================== */
    var toggleButtons = document.querySelectorAll(".toggle-password");
    for (var j = 0; j < toggleButtons.length; j++) {
        toggleButtons[j].addEventListener("click", function () {
            var input = document.getElementById(this.dataset.target);
            if (!input) return;
            var show = input.type === "password";
            input.type = show ? "text" : "password";
            this.textContent = show ? "Nascondi" : "Mostra";
        });
    }

    /* ==========================================================================
       4. FILTRO PREZZO (CATALOGO)
       ========================================================================== */
    var prezzo = document.getElementById("prezzo");
    var valorePrezzo = document.getElementById("valorePrezzo");

    if (prezzo && valorePrezzo) {
        prezzo.addEventListener("input", function () {
            valorePrezzo.textContent = prezzo.value;
        });
    }

    /* ==========================================================================
       5. VALIDAZIONE FORM DI LOGIN
       ========================================================================== */
    var loginForm = document.getElementById("loginForm");
    if (loginForm) {
        var emailRegexSimple = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        loginForm.addEventListener("submit", function (event) {
            var email = document.getElementById("loginEmail");
            var password = document.getElementById("loginPassword");

            var validEmail = setErrorSimple(email, emailRegexSimple.test(email.value.trim()) ? "" : "Inserisci un indirizzo email valido.");
            var validPassword = setErrorSimple(password, password.value.length >= 8 ? "" : "La password deve contenere almeno 8 caratteri.");

            if (!validEmail || !validPassword) {
                event.preventDefault();
            }
        });
    }

    function setErrorSimple(input, message) {
        if (!input) return true;
        var box = document.getElementById(input.id + "Error");
        input.classList.toggle("input-danger", Boolean(message));
        if (box) box.textContent = message;
        return !message;
    }

	/* ==========================================================================
	   6. VALIDAZIONE AVANZATA FORM DI REGISTRAZIONE + AJAX EMAIL
	   ========================================================================== */
	const regForm = document.getElementById("registrazioneForm") || document.getElementById("registrationForm");

	if (regForm) {
	    const nome = document.getElementById("nome");
	    const cognome = document.getElementById("cognome");
	    const email = document.getElementById("email") || document.getElementById("regEmail");
	    const password = document.getElementById("password") || document.getElementById("regPassword");
	    const confermaPassword = document.getElementById("confermaPassword") || document.getElementById("confirmPassword");
	    const privacy = document.getElementById("privacy");
	    const btnRegistrazione = document.getElementById("btnRegistrazione");
	    const formMessage = document.getElementById("formMessage") || document.getElementById("registrationMessage");

	    let emailGiaRegistrata = false;
	    let controlloEmailInCorso = false;
	    let emailTimer = null;
	    let ultimaEmailControllata = "";

	    function setError(input, errorId, message) {
	        if (!input) return;

	        const error = document.getElementById(errorId);

	        input.classList.remove("input-success");
	        input.classList.add("input-danger");

	        if (error) {
	            error.textContent = message;
	        }
	    }

	    function setSuccess(input, errorId) {
	        if (!input) return;

	        const error = document.getElementById(errorId);

	        input.classList.remove("input-danger");
	        input.classList.add("input-success");

	        if (error) {
	            error.textContent = "";
	        }
	    }

	    function setInfo(input, errorId, message) {
	        if (!input) return;

	        const error = document.getElementById(errorId);

	        input.classList.remove("input-danger");
	        input.classList.remove("input-success");

	        if (error) {
	            error.textContent = message;
	        }
	    }

	    function validateNome() {
	        if (!nome) return true;

	        const value = nome.value.trim();

	        if (value.length === 0) {
	            setError(nome, "nomeError", "Il nome è obbligatorio.");
	            return false;
	        }

	        if (value.length < 2 || value.length > 30) {
	            setError(nome, "nomeError", "Il nome deve contenere tra 2 e 30 caratteri.");
	            return false;
	        }

	        setSuccess(nome, "nomeError");
	        return true;
	    }

	    function validateCognome() {
	        if (!cognome) return true;

	        const value = cognome.value.trim();

	        if (value.length === 0) {
	            setError(cognome, "cognomeError", "Il cognome è obbligatorio.");
	            return false;
	        }

	        if (value.length < 2 || value.length > 30) {
	            setError(cognome, "cognomeError", "Il cognome deve contenere tra 2 e 30 caratteri.");
	            return false;
	        }

	        setSuccess(cognome, "cognomeError");
	        return true;
	    }

	    function validateEmailBase() {
	        if (!email) return true;

	        const value = email.value.trim();
	        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
	        const errorId = email.id + "Error";

	        if (value.length === 0) {
	            setError(email, errorId, "L'email è obbligatoria.");
	            return false;
	        }

	        if (value.length > 80 || !emailRegex.test(value)) {
	            setError(email, errorId, "Inserisci un'email valida.");
	            return false;
	        }

	        return true;
	    }

	    function validateEmailCompleta() {
	        if (!email) return true;

	        const errorId = email.id + "Error";

	        if (!validateEmailBase()) {
	            return false;
	        }

	        if (controlloEmailInCorso) {
	            setInfo(email, errorId, "Controllo email in corso...");
	            return false;
	        }

	        if (emailGiaRegistrata) {
	            setError(email, errorId, "Email già registrata.");
	            return false;
	        }

	        setSuccess(email, errorId);
	        return true;
	    }

	    function controllaEmailAjax() {
	        if (!email) return;

	        const value = email.value.trim().toLowerCase();
	        const errorId = email.id + "Error";

	        emailGiaRegistrata = false;

	        clearTimeout(emailTimer);

	        if (!validateEmailBase()) {
	            aggiornaStatoBottone();
	            return;
	        }

	        if (value === ultimaEmailControllata && !emailGiaRegistrata) {
	            validateEmailCompleta();
	            aggiornaStatoBottone();
	            return;
	        }

	        controlloEmailInCorso = true;
	        setInfo(email, errorId, "Controllo email in corso...");
	        aggiornaStatoBottone();

	        emailTimer = setTimeout(function () {
	            fetch(contextPath + "/CheckEmail?email=" + encodeURIComponent(value), {
	                method: "GET",
	                headers: {
	                    "Accept": "application/json"
	                }
	            })
	            .then(function (response) {
	                if (!response.ok) {
	                    throw new Error("Errore controllo email");
	                }

	                return response.json();
	            })
	            .then(function (data) {
	                controlloEmailInCorso = false;
	                ultimaEmailControllata = value;

	                if (data.exists === true) {
	                    emailGiaRegistrata = true;
	                    setError(email, errorId, "Email già registrata.");
	                } else {
	                    emailGiaRegistrata = false;
	                    setSuccess(email, errorId);
	                }

	                aggiornaStatoBottone();
	            })
	            .catch(function () {
	                controlloEmailInCorso = false;
	                emailGiaRegistrata = false;

	                setInfo(email, errorId, "Impossibile controllare l'email ora.");
	                aggiornaStatoBottone();
	            });
	        }, 400);
	    }

	    function validatePassword() {
	        if (!password) return true;

	        const value = password.value.trim();
	        const contieneMaiuscola = /[A-Z]/.test(value);
	        const contieneMinuscola = /[a-z]/.test(value);
	        const contieneNumero = /[0-9]/.test(value);
	        const contieneSpeciale = /[!@#$%^&*(),.?":{}|<>]/.test(value);
	        const errorId = password.id + "Error";

	        if (value.length === 0) {
	            setError(password, errorId, "La password è obbligatoria.");
	            return false;
	        }

	        if (value.length < 8 || value.length > 64) {
	            setError(password, errorId, "La password deve contenere tra 8 e 64 caratteri.");
	            return false;
	        }

	        if (!contieneMaiuscola || !contieneMinuscola || !contieneNumero || !contieneSpeciale) {
	            setError(password, errorId, "Maiuscola, minuscola, numero e carattere speciale.");
	            return false;
	        }

	        setSuccess(password, errorId);
	        return true;
	    }

	    function validateConfermaPassword() {
	        if (!confermaPassword || !password) return true;

	        const passwordValue = password.value.trim();
	        const confermaValue = confermaPassword.value.trim();
	        const errorId = confermaPassword.id + "Error";

	        if (confermaValue.length === 0) {
	            setError(confermaPassword, errorId, "Conferma la password.");
	            return false;
	        }

	        if (passwordValue !== confermaValue) {
	            setError(confermaPassword, errorId, "Le password non coincidono.");
	            return false;
	        }

	        setSuccess(confermaPassword, errorId);
	        return true;
	    }

	    function validatePrivacy() {
	        if (!privacy) return true;

	        const privacyError = document.getElementById("privacyError");

	        if (!privacy.checked) {
	            if (privacyError) {
	                privacyError.textContent = "Devi accettare l'informativa sulla privacy.";
	            }

	            return false;
	        }

	        if (privacyError) {
	            privacyError.textContent = "";
	        }

	        return true;
	    }

	    function controllaForm() {
	        const nomeValido = validateNome();
	        const cognomeValido = validateCognome();
	        const emailValida = validateEmailCompleta();
	        const passwordValida = validatePassword();
	        const confermaPasswordValida = validateConfermaPassword();
	        const privacyValida = validatePrivacy();

	        return nomeValido &&
	               cognomeValido &&
	               emailValida &&
	               passwordValida &&
	               confermaPasswordValida &&
	               privacyValida;
	    }

	    function aggiornaStatoBottone() {
	        if (btnRegistrazione) {
	            btnRegistrazione.disabled = !controllaForm();
	        }
	    }

	    if (nome) {
	        nome.addEventListener("input", aggiornaStatoBottone);
	    }

	    if (cognome) {
	        cognome.addEventListener("input", aggiornaStatoBottone);
	    }

	    if (email) {
	        email.addEventListener("input", function () {
	            ultimaEmailControllata = "";
	            controllaEmailAjax();
	        });
	    }

	    if (password) {
	        password.addEventListener("input", aggiornaStatoBottone);
	    }

	    if (confermaPassword) {
	        confermaPassword.addEventListener("input", aggiornaStatoBottone);
	    }

	    if (privacy) {
	        privacy.addEventListener("change", aggiornaStatoBottone);
	    }

	    regForm.addEventListener("submit", function (event) {
	        if (nome) nome.value = nome.value.trim();
	        if (cognome) cognome.value = cognome.value.trim();
	        if (email) email.value = email.value.trim();

	        if (!controllaForm()) {
	            event.preventDefault();

	            if (formMessage) {
	                formMessage.className = "form-message error";
	                formMessage.textContent = "Correggi gli errori prima di continuare.";
	            }
	        }
	    });

	    aggiornaStatoBottone();
	}

    /* ==========================================================================
       7. RICERCA PRODOTTI (SUGGERIMENTI AJAX)
       ========================================================================== */
    var search = document.getElementById("searchInput");
    var suggestions = document.getElementById("searchSuggestions");
    var searchTimer;

    if (search && suggestions) {
        search.addEventListener("input", function () {
            clearTimeout(searchTimer);
            var query = search.value.trim();

            if (query.length < 2) {
                suggestions.hidden = true;
                return;
            }

            searchTimer = setTimeout(function () {
                fetch(contextPath + "/SuggerimentiRicerca?q=" + encodeURIComponent(query), {
                    headers: { Accept: "application/json" }
                })
                .then(function (response) {
                    if (!response.ok) return null;
                    return response.json();
                })
                .then(function (items) {
                    if (!items) return;
                    suggestions.innerHTML = "";
                    items.slice(0, 5).forEach(function (item) {
                        var a = document.createElement("a");
                        a.href = contextPath + "/Prodotto?id=" + encodeURIComponent(item.id);
                        a.textContent = item.nome;
                        suggestions.appendChild(a);
                    });
                    suggestions.hidden = items.length === 0;
                })
                .catch(function () {
                    suggestions.hidden = true;
                });
            }, 300);
        });
    }

    /* ==========================================================================
       8. CALCOLO DINAMICO CARRELLO
       ========================================================================== */
    var quantities = document.querySelectorAll(".cart-quantity");

    function updateCartPreview() {
        if (!quantities.length) return;
        var subtotal = 0;
        quantities.forEach(function (input) {
            subtotal += Number(input.dataset.price) * Math.max(1, Number(input.value) || 1);
        });
        var shipping = subtotal >= 80 ? 0 : 5.90;

        var subtotalBox = document.getElementById("cartSubtotal");
        var totalBox = document.getElementById("cartTotal");

        if (subtotalBox) {
            subtotalBox.textContent = subtotal.toLocaleString("it-IT", { style: "currency", currency: "EUR" });
        }
        if (totalBox) {
            totalBox.textContent = (subtotal + shipping).toLocaleString("it-IT", { style: "currency", currency: "EUR" });
        }
    }

    quantities.forEach(function (input) {
        input.addEventListener("input", updateCartPreview);
    });

});