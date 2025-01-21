package model;

import java.util.Date;

public class Bid {
    private int id;
    private int idProduto;
    private String nomeParticipante;
    private double valor;
    private LocalDateTime dataLance;

    // Construtores
    public Bid() {}

    public Bid(int id, int idProduto, int nomeParticipante, double valor, Date dataLance) {
        this.id = id;
        this.idProduto = idProduto;
        this.nomeParticipante = nomeParticipante;
        this.valor = valor;
        this.dataLance = dataLance;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getidProduto() {
        return idProduto;
    }
    public void setidProduto(int idProduto) {
        this.idProduto = idProduto;
    }
    public int getnomeParticipante() {
        return nomeParticipante;
    }
    public void setnomeParticipante(int nomeParticipante) {
        this.nomeParticipante = nomeParticipante;
    }
    public double getvalor() {
        return valor;
    }
    public void setvalor(double valor) {
        this.valor = valor;
    }
    public Date getdataLance() {
        return dataLance;
    }
    public void setdataLance(Date dataLance) {
        this.dataLance = dataLance;
    }
}