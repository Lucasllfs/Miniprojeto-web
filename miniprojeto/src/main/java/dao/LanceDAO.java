package dao;

import model.Lance;
import util.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LanceDAO {

    public void inserirLance(Lance lance) {
        String sql = "INSERT INTO lances (id_produto, nome_participante, valor, data_lance) VALUES (?, ?, ?, NOW())";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lance.getIdProduto());
            stmt.setString(2, lance.getNomeParticipante());
            stmt.setDouble(3, lance.getValor());

            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inserir lance", e);
        }
    }

    public List<Lance> listarLancesPorProduto(int idProduto) {
        List<Lance> lances = new ArrayList<>();
        String sql = "SELECT * FROM lances WHERE id_produto = ? ORDER BY data_lance DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idProduto);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Lance lance = new Lance();
                lance.setId(rs.getInt("id"));
                lance.setIdProduto(rs.getInt("id_produto"));
                lance.setNomeParticipante(rs.getString("nome_participante"));
                lance.setValor(rs.getDouble("valor"));
                lance.setDataLance(rs.getTimestamp("data_lance").toLocalDateTime());

                lances.add(lance);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar lances", e);
        }

        return lances;
    }
}
