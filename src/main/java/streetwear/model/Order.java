package streetwear.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int idUtente;
    private String emailCliente; // Per facilitare la visualizzazione lato admin
    private Timestamp dataOrdine;
    private String statoOrdine;
    private List<OrderRow> righe = new ArrayList<>();

    public Order() {}

    public int getIdOrdine() { return idOrdine; }
    public void setIdOrdine(int idOrdine) { this.idOrdine = idOrdine; }

    public int getIdUtente() { return idUtente; }
    public void setIdUtente(int idUtente) { this.idUtente = idUtente; }

    public String getEmailCliente() { return emailCliente; }
    public void setEmailCliente(String emailCliente) { this.emailCliente = emailCliente; }

    public Timestamp getDataOrdine() { return dataOrdine; }
    public void setDataOrdine(Timestamp dataOrdine) { this.dataOrdine = dataOrdine; }

    public String getStatoOrdine() { return statoOrdine; }
    public void setStatoOrdine(String statoOrdine) { this.statoOrdine = statoOrdine; }

    public List<OrderRow> getRighe() { return righe; }
    public void setRighe(List<OrderRow> righe) { this.righe = righe; }
    
    public double getTotale() {
        double totale = 0;
        for(OrderRow r : righe) {
            totale += r.getPrezzoStorico() * r.getQuantita();
        }
        return totale;
    }
}