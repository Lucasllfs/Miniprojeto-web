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
            #statusMessage { margin: 1rem 0; padding: 1rem; border-radius: 4px; display: none; }
            .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
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
                <div id="lanceTimer" class="timer">Próximo lance em: <span id="tempoLance"></span> segundos</div>
                <form id="formLance" onsubmit="return false;">
                    <div style="margin-bottom: 1rem;">
                        <label for="produto">Produto:</label>
                        <select id="produto" name="idProduto" required>
                            <option value="">Selecione um produto</option>
                            <% for (Produto produto : (List<Produto>) request.getAttribute("produtos")) { %>
                            <option 
                              value="<%= produto.getId() %>" 
                              data-valor-minimo="<%= produto.getValorMinimo() %>" <!-- Novo atributo -->
                            >
                              <%= produto.getNome() %>
                            </option>
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
                <div id="statusMessage"></div>
            </div>
    
            <div class="right">
                <h2>Lances do Produto</h2>
                <div id="lancesContainer">
                    <p class="loading">Selecione um produto para visualizar os lances</p>
                </div>
                <div id="atualizacaoTimer" class="timer">Próxima atualização em: <span id="tempoAtualizacao"></span> segundos</div>

            </div>
        </div>
    
        <script>
            const TEMPO_VISUALIZACAO_LANCES = 20000; // 20 segundos escondido e 20 visualizado
            const TEMPO_ATUALIZACAO_LANCES = 3000; // 3 segundos
            const TEMPO_BLOQUEIO_LANCE = 10000; // 10 segundos

            let podeVerLances = true;
            let podeFazerLance = true;
            let proximaAtualizacao = Date.now() + TEMPO_ATUALIZACAO_LANCES;
            let desbloqueioLance = Date.now();
        
            $(document).ready(function () {
                // Atualizar lista de lances a cada 20 segundos
                setInterval(atualizarLances, TEMPO_ATUALIZACAO_LANCES);


        
                // Temporizador para atualizar os contadores de tempo
                setInterval(atualizarTemporizador, 1000);
        
                $('#formLance').submit(function (e) {
                e.preventDefault();
    if (!podeFazerLance) return;

    const produtoId = $('#produto').val();
    const nome = $('#nome').val();
    const valor = parseFloat($('#valor').val()); // Convertemos para número
    const status = $('#statusMessage');
    
    // Captura o valor mínimo do produto selecionado
    const valorMinimo = parseFloat(
        $('#produto option:selected').data('valor-minimo') || 0
    );

    // Validação do valor
    if (valor <= valorMinimo) {
        status.html(`Erro: O lance deve ser maior que o valor mínimo`)
            .removeClass()
            .addClass('error')
            .show();
        setTimeout(() => status.hide(), 5000);
        return; // Impede o envio
    }

    $.ajax({
        url: '${pageContext.request.contextPath}/lances',
        method: 'POST',
        data: {
            idProduto: produtoId,
            nomeParticipante: nome,
            valor: valor
        },
        success: function () {
            $('#nome').val('');
            $('#valor').val('');
            status.html('Lance registrado com sucesso!')
                .removeClass()
                .addClass('success')
                .show();
            setTimeout(() => status.hide(), 3000);

            podeFazerLance = false;
            desbloqueioLance = Date.now() + TEMPO_BLOQUEIO_LANCE;
            $('#formLance button').prop('disabled', true);
        },
        error: function (xhr) {
            status.html('Erro: ' + xhr.responseText)
                .removeClass()
                .addClass('error')
                .show();
            setTimeout(() => status.hide(), 5000);
        }
    });
});
            });
        
            function atualizarLances() {
                const produtoId = $('#produto').val();
                if (!produtoId) return;
        
                const container = $('#lancesContainer');
                container.html('<p class="loading">Carregando lances...</p>');
        
                $.ajax({
                    url: '${pageContext.request.contextPath}/lances',
                    method: 'GET',
                    data: { produtoId: produtoId },
                    dataType: 'json',
                    success: function (lances) {
                        if (!lances || lances.length === 0) {
                            container.html('<p class="loading">Nenhum lance encontrado</p>');
                            return;
                        }
        
                        lances.sort((a, b) => b.valor - a.valor);
        
                        const table = $('<table>').append(
                            $('<thead>').append(
                                $('<tr>').append(
                                    $('<th>').text('Participante'),
                                    $('<th>').text('Valor'),
                                    $('<th>').text('Data')
                                )
                            ),
                            $('<tbody>')
                        );
        
                        lances.forEach(lance => {
                            const row = $('<tr>').addClass('lance-item');
                            const nome = lance.nomeParticipante || 'Anônimo';
                            const valor = lance.valor?.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' }) || 'R$ 0,00';
                            const data = lance.dataLance ? new Date(lance.dataLance).toLocaleString('pt-BR') : '--/--/---- --:--';
        
                            row.append(
                                $('<td>').text(nome),
                                $('<td>').text(valor),
                                $('<td>').text(data)
                            );
        
                            table.find('tbody').append(row);
                        });
        
                        container.html(table);
                    },
                    error: function () {
                        container.html('<p class="error">Erro ao carregar lances</p>');
                    }
                });
        
                // Atualiza o tempo da próxima atualização de lances
                proximaAtualizacao = Date.now() + TEMPO_ATUALIZACAO_LANCES;
            }
        
            function atualizarTemporizador() {
                const agora = Date.now();
        
                // Calcula o tempo restante para a próxima atualização dos lances
                let tempoRestanteAtualizacao = Math.max(0, Math.ceil((proximaAtualizacao - agora) / 1000));
                $('#tempoAtualizacao').text(tempoRestanteAtualizacao);
        
                // Calcula o tempo restante para o desbloqueio do botão de lance
                let tempoRestanteLance = Math.max(0, Math.ceil((desbloqueioLance - agora) / 1000));
                $('#tempoLance').text(tempoRestanteLance);
        
                if (tempoRestanteLance === 0 && !podeFazerLance) {
                    podeFazerLance = true;
                    $('#formLance button').prop('disabled', false);
                }
        
                if (tempoRestanteAtualizacao === 0) {
                    atualizarLances();
                    if (podeVerLances) {
                        //tirar visualizacao dos lances
                        $('#lancesContainer').prop('hidden', true);
                    }
                    podeVerLances = !podeVerLances;
                }
            }
        </script>
        
    </body>
    </html>