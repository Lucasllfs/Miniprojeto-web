package controller;

import dao.LanceDAO;
import dao.ProdutoDAO;
import model.Lance;
import model.Produto;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import com.google.gson.Gson;

public class LanceController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String produtoId = request.getParameter("produtoId");

        if (produtoId != null && !produtoId.isEmpty()) {
            // Retorna os lances em formato JSON
            try {
                int id = Integer.parseInt(produtoId);
                LanceDAO lanceDAO = new LanceDAO();
                List<Lance> lances = lanceDAO.listarLancesPorProduto(id);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(new Gson().toJson(lances));
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID do produto inválido");
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
