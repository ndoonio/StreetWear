<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/fragments/messages.jsp" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>
        StreetWear | Home
    </title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />
</head>
<body>
    <%@ include file="fragments/header.jsp" %>

    <main>
        <%-- Sezione principale della homepage. --%>
        <section class="hero">
            <div class="hero-content">
                <span class="eyebrow">
                    Nuova collezione 2026
                </span>

                <h1>
                    Indossa la tua
                    <em>identità.</em>
                </h1>

                <p>
                    Capi streetwear selezionati per chi non segue la strada: la crea.
                </p>

                <a class="btn btn-primary" href="<%= request.getContextPath() %>/Catalogo">
                    Scopri la collezione
                </a>
            </div>

            <div class="hero-art">
                <span>
                    STREET
                </span>
            </div>
        </section>

        <%-- Fascia con i principali vantaggi del negozio. --%>
        <section class="promo-strip">
            <span>
                Spedizione gratuita sopra 80€
            </span>

            <span>
                Reso entro 30 giorni
            </span>

            <span>
                Pagamenti sicuri
            </span>
        </section>

        <%-- Prodotti messi in evidenza nella homepage. --%>
        <section class="section-wrap">
            <div class="section-heading">
                <div>
                    <span class="eyebrow">
                        In primo piano
                    </span>

                    <h2>
                        Scelti per te
                    </h2>
                </div>

                <a href="<%= request.getContextPath() %>/Catalogo">
                    Vedi tutto &rarr;
                </a>
            </div>

            <div class="product-grid">
                <article class="product-card">
                    <a href="<%= request.getContextPath() %>/Prodotto?id=1" class="product-image">
                        <span class="badge">
                            Novità
                        </span>

                        <img src="<%= request.getContextPath() %>/images/FelpaOversize.jpg" alt="Felpa Oversize" />
                    </a>

                    <div class="product-info">
                        <small>
                            Felpe
                        </small>

                        <h3>
                            Felpa Oversize
                        </h3>

                        <p>
                            Vestibilità ampia e cotone premium.
                        </p>

                        <div class="product-bottom">
                            <strong>
                                €69,90
                            </strong>

                            <a class="btn-icon" href="<%= request.getContextPath() %>/Prodotto?id=1" aria-label="Dettagli Felpa Oversize">
                                &rarr;
                            </a>
                        </div>
                    </div>
                </article>

                <article class="product-card">
                    <a href="<%= request.getContextPath() %>/Prodotto?id=2" class="product-image">
                        <img src="<%= request.getContextPath() %>/images/t-shirt.jpg" alt="T-Shirt Graphic" />
                    </a>

                    <div class="product-info">
                        <small>
                            Maglie
                        </small>

                        <h3>
                            T-Shirt Graphic
                        </h3>

                        <p>
                            Stampa urban su jersey morbido.
                        </p>

                        <div class="product-bottom">
                            <strong>
                                €34,90
                            </strong>

                            <a class="btn-icon" href="<%= request.getContextPath() %>/Prodotto?id=2">
                                &rarr;
                            </a>
                        </div>
                    </div>
                </article>

                <article class="product-card">
                    <a href="<%= request.getContextPath() %>/Prodotto?id=3" class="product-image">
                        <span class="badge dark">
                            Best seller
                        </span>

                        <img src="<%= request.getContextPath() %>/images/hoodiezip.jpg" alt="Sneakers Urban" />
                    </a>

                    <div class="product-info">
                        <small>
                            Felpa
                        </small>

                        <h3>
                            Hoodie Essential Zip
                        </h3>

                        <p>
                            Felpa con cappuccio e zip integrale metallica.
                        </p>

                        <div class="product-bottom">
                            <strong>
                                €79,90
                            </strong>

                            <a class="btn-icon" href="<%= request.getContextPath() %>/Prodotto?id=3">
                                &rarr;
                            </a>
                        </div>
                    </div>
                </article>
            </div>
        </section>

        <%-- Banner che porta al catalogo completo. --%>
        <section class="category-banner">
            <div>
                <span class="eyebrow">
                    Trova il tuo fit
                </span>

                <h2>
                    Stile senza regole.
                </h2>

                <p>
                    Filtra per categoria, taglia e colore.
                </p>
            </div>

            <a class="btn btn-light" href="<%= request.getContextPath() %>/Catalogo">
                Vai al catalogo
            </a>
        </section>
    </main>

    <%@ include file="fragments/footer.jsp" %>

    <script src="<%= request.getContextPath() %>/js/script.js"></script>
</body>
</html>
