<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <!-- Formulário para dar lances -->
</body>
</html>
