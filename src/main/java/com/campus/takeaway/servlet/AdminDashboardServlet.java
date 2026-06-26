package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.dao.OrderDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final MerchantDao merchantDao = new MerchantDao();
    private final DishDao dishDao = new DishDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("merchantCount", merchantDao.findAll().size());
        req.setAttribute("dishCount", dishDao.findAll(null).size());
        req.setAttribute("orderCount", orderDao.findAll().size());
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
