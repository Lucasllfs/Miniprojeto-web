package controller;

import dao.LanceDAO;
import dao.ProdutoDAO;
import model.Lance;
import model.Produto;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

public class LanceController extends HttpServlet {
   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String produtoId = request.getParameter("produtoId");

    if (produtoId != null && !produtoId.isEmpty()) {
        try {
            int id = Integer.parseInt(produtoId);
            LanceDAO lanceDAO = new LanceDAO();
            List<Lance> lances = lanceDAO.listarLancesPorProduto(id);

            // Configurar o Gson para serializar LocalDateTime
            Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (date, type, context) ->
                    new JsonPrimitive(date.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME))) // Formato ISO
                .create();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(lances));

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
        }
    } else {
            // Carrega os produtos na página de lances
            ProdutoDAO produtoDAO = new ProdutoDAO();
            List<Produto> produtos = produtoDAO.listarProdutos();
            request.setAttribute("produtos", produtos);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/lances.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idProduto = Integer.parseInt(request.getParameter("idProduto"));
        String nomeParticipante = request.getParameter("nomeParticipante");
        double valor = Double.parseDouble(request.getParameter("valor"));

        Lance lance = new Lance();
        lance.setIdProduto(idProduto);
        lance.setNomeParticipante(nomeParticipante);
        lance.setValor(valor);
        lance.setDataLance(LocalDateTime.now());

        LanceDAO lanceDAO = new LanceDAO();
        lanceDAO.inserirLance(lance);

        // Redireciona para a página de lances
        response.sendRedirect("/miniprojeto/lances");
    }

    
}
