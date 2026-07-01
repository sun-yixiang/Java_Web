package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.dao.OrderDao;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/merchant-admin/dashboard")
public class MerchantDashboardServlet extends HttpServlet {
    private final MerchantDao merchantDao = new MerchantDao();
    private final DishDao dishDao = new DishDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        int merchantId = user.getMerchantId();
        req.setAttribute("merchant", merchantDao.findById(merchantId));
        req.setAttribute("dishCount", dishDao.findByMerchantId(merchantId, null).size());
        req.setAttribute("orderCount", orderDao.findByMerchantId(merchantId).size());
        req.getRequestDispatcher("/merchant-admin/dashboard.jsp").forward(req, resp);
    }
}
