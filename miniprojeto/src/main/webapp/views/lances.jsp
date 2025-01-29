<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c" %> <%@ page import="java.util.List" %> <%@ page
import="model.Produto" %> <% List<Produto>
  produtos = (List<Produto
    >) request.getAttribute("produtos"); %>
    <!DOCTYPE html>
<html>
<head>
    <title>Leilão</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .container { display: flex; gap: 2rem; margin-top: 2rem; }
        .left, .right { flex: 1; padding: 1rem; border: 1px solid #ddd; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; }
        .loading { color: #666; padding: 1rem; }
        .error { color: #dc3545; padding: 1rem; }
        .lance-item:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>Produtos em Leilão</h1>
    <ul>
        <c:forEach var="produto" items="${produtos}">
            <li>${produto.nome} - Valor mínimo: ${produto.valorMinimo}</li>
        </c:forEach>
    </ul>

    <div class="container">
        <div class="left">
            <h2>Fazer Lance</h2>
            <form action="/miniprojeto/lances" method="post">
                <div style="margin-bottom: 1rem;">
                    <label for="produto">Produto:</label>
                    <select id="produto" name="idProduto" required style="width: 100%; padding: 0.5rem;">
                        <option value="">Selecione um produto</option>
                        <% for (Produto produto : (List<Produto>)request.getAttribute("produtos")) { %>
                            <option value="<%= produto.getId() %>"><%= produto.getNome() %></option>
                        <% } %>
                    </select>
                </div>

                <div style="margin-bottom: 1rem;">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nomeParticipante" required style="width: 100%; padding: 0.5rem;">
                </div>

                <div style="margin-bottom: 1rem;">
                    <label for="valor">Valor do Lance:</label>
                    <input type="number" step="0.01" id="valor" name="valor" required 
                           style="width: 100%; padding: 0.5rem;">
                </div>

                <button type="submit" style="padding: 0.5rem 1rem; background-color: #007bff; color: white; border: none; border-radius: 4px;">
                    Enviar Lance
                </button>
            </form>
        </div>

        <div class="right">
            <h2>Lances do Produto</h2>
            <div id="lancesContainer">
                <p class="loading">Selecione um produto para visualizar os lances</p>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        $('#produto').change(function() {
            const produtoId = $(this).val();
            const container = $('#lancesContainer');
            container.html('<p class="loading">Carregando lances...</p>');

            if (!produtoId) {
                container.html('<p class="loading">Selecione um produto</p>');
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/lances',
                method: 'GET',
                data: { produtoId: produtoId },
                dataType: 'json',
                success: function(lances) {
                    console.log('Dados recebidos:', lances);
                    
                    if (!lances || lances.length === 0) {
                        container.html('<p class="loading">Nenhum lance encontrado</p>');
                        return;
                    }

                    // Ordenar por valor descendente
                    lances.sort((a, b) => b.valor - a.valor);

                    // Construir tabela
                    const table = $('<table>')
                        .append($('<thead>')
                            .append($('<tr>')
                                .append($('<th>').text('Participante'))
                                .append($('<th>').text('Valor'))
                                .append($('<th>').text('Data'))
                            )
                        );

                    const tbody = $('<tbody>');
                    
                    lances.forEach(lance => {
                        console.log('Processando lance:', lance);
                        
                        const row = $('<tr>').addClass('lance-item');
                        const nome = lance.nomeParticipante || 'Anônimo';
                        const valor = lance.valor?.toLocaleString('pt-BR', {
                            style: 'currency',
                            currency: 'BRL'
                        }) || 'R$ 0,00';
                        
                        const data = lance.dataLance 
                            ? new Date(lance.dataLance).toLocaleString('pt-BR')
                            : '--/--/---- --:--';

                        row.append(
                            $('<td>').text(nome),
                            $('<td>').text(valor),
                            $('<td>').text(data)
                        );

                        tbody.append(row);
                    });

                    table.append(tbody);
                    container.html(table);
                },
                error: function(xhr, status, error) {
                    console.error('Erro na requisição:', status, error);
                    container.html('<p class="error">Erro ao carregar lances</p>');
                }
            });
        });
    });
    </script>
</body>
</html>