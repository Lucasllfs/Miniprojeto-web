package model;

import java.time.LocalDateTime;

public class Lance {
    private int id;
    private int idProduto;
    private String nomeParticipante;
    private double valor;
    private LocalDateTime dataLance;

    // Construtores
    public Lance() {}

    public Lance(int id, int idProduto, String nomeParticipante, double valor, LocalDateTime dataLance) {
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

    public int getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(int idProduto) {
        this.idProduto = idProduto;
    }

    public String getNomeParticipante() {
        return nomeParticipante;
    }

    public void setNomeParticipante(String nomeParticipante) {
        this.nomeParticipante = nomeParticipante;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public LocalDateTime getDataLance() {
        return dataLance;
    }

    public void setDataLance(LocalDateTime dataLance) {
        this.dataLance = dataLance;
    }
}