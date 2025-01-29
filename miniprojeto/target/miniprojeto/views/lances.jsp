<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Produto" %>

<%
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Leilão</title>
    <script>
        setInterval(() => {
            location.reload(); // Atualiza os lances automaticamente
        }, 5000); // Atualiza a cada 5 segundos
    </script>
</head>
<body>
    <h1>Produtos em Leilão</h1>
    <ul>
        <c:forEach var="produto" items="${produtos}">
            <li>${produto.nome} - Valor mínimo: ${produto.valorMinimo}</li>
        </c:forEach>
    </ul>
    
    <div class="container">
        <!-- Formulário para cadastrar um lance -->
        <div class="left">
            <h2>Fazer um Lance</h2>
            <form action="/miniprojeto/lances" method="post">
                <label for="produto">Produto:</label>
                <select id="produto" name="idProduto" required>
                    <option value="">Selecione um produto</option>
                    <% for (Produto produto : produtos) { %>
                        <option value="<%= produto.getId() %>"><%= produto.getNome() %></option>
                    <% } %>
                </select>
                <br><br>
                
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nomeParticipante" required>
                <br><br>

                <label for="valor">Valor do Lance:</label>
                <input type="number" step="0.01" id="valor" name="valor" required>
                <br><br>

                <button type="submit">Enviar Lance</button>
            </form>
        </div>

        <!-- Select para escolher um produto e exibir os lances -->
        <div class="right">
            <h2>Lances do Produto</h2>
            <table border="1">
                <thead>
                    <tr>
                        <th>Nome</th>
                        <th>Valor</th>
                        <th>Data</th>
                    </tr>
                </thead>
                <tbody id="lancesTable">
                    <tr><td colspan="3">Selecione um produto para ver os lances</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $("#produto").change(function() {
                let produtoId = $(this).val();
                
                if (produtoId) {
                    $.ajax({
                        url: "lances?produtoId=" + produtoId,
                        method: "GET",
                        success: function(response) {
                            let tableBody = $("#lancesTable");
                            tableBody.empty();

                            if (response.length === 0) {
                                tableBody.append("<tr><td colspan='3'>Nenhum lance encontrado</td></tr>");
                            } else {
                                response.forEach(lance => {
                                    tableBody.append("<tr><td>" + lance.nomeParticipante + "</td><td>R$ " + lance.valor.toFixed(2) + "</td><td>" + lance.dataLance + "</td></tr>");
                                });
                            }
                        },
                        error: function() {
                            alert("Erro ao carregar os lances");
                        }
                    });
                } else {
                    $("#lancesTable").html("<tr><td colspan='3'>Selecione um produto para ver os lances</td></tr>");
                }
            });
        });
    </script>
</body>
</html>
