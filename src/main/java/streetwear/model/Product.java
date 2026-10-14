package streetwear.model;

import java.io.Serializable;

public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idProdotto;
    private String nomeProdotto;
    private String descrizioneProdotto;
    private String categoria;
    private double prezzo;
    private String taglia;
    private String colore;
    private String immagineUrl;
    private double iva = 22.00;
    private int quantita = 0;
    private boolean attivo = true;

    public Product() {}

    // --- ID ---
    public int getIdProdotto() { return idProdotto; }
    public void setIdProdotto(int idProdotto) { this.idProdotto = idProdotto; }

    // --- NOME ---
    public String getNomeProdotto() { return nomeProdotto; }
    public void setNomeProdotto(String nomeProdotto) { this.nomeProdotto = nomeProdotto; }

    // --- DESCRIZIONE ---
    public String getDescrizioneProdotto() { return descrizioneProdotto; }
    public void setDescrizioneProdotto(String descrizioneProdotto) { this.descrizioneProdotto = descrizioneProdotto; }
    public String getDescrizione() { return descrizioneProdotto; }
    public void setDescrizione(String descrizione) { this.descrizioneProdotto = descrizione; }

    // --- CATEGORIA ---
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    // --- PREZZO ---
    public double getPrezzo() { return prezzo; }
    public void setPrezzo(double prezzo) { this.prezzo = prezzo; }

    // --- TAGLIA ---
    public String getTaglia() { return taglia; }
    public void setTaglia(String taglia) { this.taglia = taglia; }

    // --- COLORE ---
    public String getColore() { return colore; }
    public void setColore(String colore) { this.colore = colore; }

    // --- IMMAGINE ---
    public String getImmagineUrl() { return immagineUrl; }
    public void setImmagineUrl(String immagineUrl) { this.immagineUrl = immagineUrl; }
    public String getImmagine() { return immagineUrl; }
    public void setImmagine(String immagine) { this.immagineUrl = immagine; }

    // --- IVA ---
    public double getIva() { return iva; }
    public void setIva(double iva) { this.iva = iva; }

    // --- QUANTITA ---
    public int getQuantita() { return quantita; }
    public void setQuantita(int quantita) { this.quantita = quantita; }

    // --- ATTIVO ---
    public boolean isAttivo() { return attivo; }
    public void setAttivo(boolean attivo) { this.attivo = attivo; }
}