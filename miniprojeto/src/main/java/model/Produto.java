package model;

public class Produto {
    private int id;
    private String nome;
    private double valorMinimo;
    
    // Construtores
    public Produto() {}
    
    public Produto(int id, String nome, double valorMinimo) {
        this.id = id;
        this.nome = nome;
        this.valorMinimo = valorMinimo;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

     public void setNome(String nome) {
        this.nome = nome;
    }

    public void setValorMinimo(double valorMinimo) {
        this.valorMinimo = valorMinimo;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public double getValorMinimo() {
        return valorMinimo;
    }

}