package streetwear.model;

import java.io.Serializable;

public class OrderRow implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idRiga;
    private int idOrdine;
    private Integer idProdotto; // Integer per gestire il NULL se rimosso
    private String nomeProdottoStorico; // Alternativo per non perdere il nome al delete
    private int quantita;
    private double prezzoStorico;
    private int ivaStorica;

    public OrderRow() {}

    public int getIdRiga() { return idRiga; }
    public void setIdRiga(int idRiga) { this.idRiga = idRiga; }

    public int getIdOrdine() { return idOrdine; }
    public void setIdOrdine(int idOrdine) { this.idOrdine = idOrdine; }

    public Integer getIdProdotto() { return idProdotto; }
    public void setIdProdotto(Integer idProdotto) { this.idProdotto = idProdotto; }

    public String getNomeProdottoStorico() { return nomeProdottoStorico; }
    public void setNomeProdottoStorico(String nome) { this.nomeProdottoStorico = nome; }

    public int getQuantita() { return quantita; }
    public void setQuantita(int quantita) { this.quantita = quantita; }

    public double getPrezzoStorico() { return prezzoStorico; }
    public void setPrezzoStorico(double prezzo) { this.prezzoStorico = prezzo; }

    public int getIvaStorica() { return ivaStorica; }
    public void setIvaStorica(int iva) { this.ivaStorica = iva; }
}