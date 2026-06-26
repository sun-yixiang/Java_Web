package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.OrderDao;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        req.setAttribute("orders", orderDao.findByUserId(user.getId()));
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
    }
}
