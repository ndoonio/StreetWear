<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Object swMessaggioObj = null;
    Object swErroreObj = null;

    if (request.getAttribute("messaggio") != null) {
        swMessaggioObj = request.getAttribute("messaggio");
    } else if (session.getAttribute("messaggio") != null) {
        swMessaggioObj = session.getAttribute("messaggio");
    } else if (session.getAttribute("messaggioAdmin") != null) {
        swMessaggioObj = session.getAttribute("messaggioAdmin");
    } else if (session.getAttribute("messaggioCheckout") != null) {
        swMessaggioObj = session.getAttribute("messaggioCheckout");
    }

    if (request.getAttribute("errore") != null) {
        swErroreObj = request.getAttribute("errore");
    } else if (session.getAttribute("errore") != null) {
        swErroreObj = session.getAttribute("errore");
    } else if (session.getAttribute("erroreAdmin") != null) {
        swErroreObj = session.getAttribute("erroreAdmin");
    } else if (session.getAttribute("erroreCheckout") != null) {
        swErroreObj = session.getAttribute("erroreCheckout");
    }

    session.removeAttribute("messaggio");
    session.removeAttribute("messaggioAdmin");
    session.removeAttribute("messaggioCheckout");

    session.removeAttribute("errore");
    session.removeAttribute("erroreAdmin");
    session.removeAttribute("erroreCheckout");
%>

<% if (swMessaggioObj != null && !String.valueOf(swMessaggioObj).trim().isEmpty()) { %>

    <div class="flash-message success"
         style="width:min(1100px, calc(100% - 32px));
                margin:22px auto;
                padding:16px 20px;
                border-radius:16px;
                font-size:15px;
                font-weight:800;
                box-sizing:border-box;
                background:#d9eee4;
                color:#245b45;
                border:1px solid #b8dec9;">
        <%= swMessaggioObj %>
    </div>

<% } %>

<% if (swErroreObj != null && !String.valueOf(swErroreObj).trim().isEmpty()) { %>

    <div class="flash-message error"
         style="width:min(1100px, calc(100% - 32px));
                margin:22px auto;
                padding:16px 20px;
                border-radius:16px;
                font-size:15px;
                font-weight:800;
                box-sizing:border-box;
                background:#f8d7da;
                color:#721c24;
                border:1px solid #efb6bd;">
        <%= swErroreObj %>
    </div>

<% } %>