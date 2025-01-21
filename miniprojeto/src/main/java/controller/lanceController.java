package controller;

import dao.ProdutoDAO;
import model.Produto;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class LanceController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProdutoDAO produtoDAO = new ProdutoDAO();
        List<Produto> produtos = produtoDAO.listarProdutos();
        request.setAttribute("produtos", produtos);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/lances.jsp");
        dispatcher.forward(request, response);
    }
}
