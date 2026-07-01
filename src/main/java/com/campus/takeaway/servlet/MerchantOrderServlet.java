package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.dao.OrderDao;
import com.campus.takeaway.model.Order;
import com.campus.takeaway.model.OrderItem;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/merchant-admin/orders")
public class MerchantOrderServlet extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();
    private final MerchantDao merchantDao = new MerchantDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        int merchantId = user.getMerchantId();
        List<Order> orders = orderDao.findByMerchantId(merchantId);
        Map<Integer, List<OrderItem>> orderItems = new HashMap<>();
        for (Order order : orders) {
            orderItems.put(order.getId(), orderDao.findItemsByMerchantId(order.getId(), merchantId));
        }
        req.setAttribute("merchant", merchantDao.findById(merchantId));
        req.setAttribute("orders", orders);
        req.setAttribute("orderItems", orderItems);
        req.getRequestDispatcher("/merchant-admin/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        orderDao.updateMerchantOrderStatus(
                Integer.parseInt(req.getParameter("id")),
                user.getMerchantId(),
                req.getParameter("status"));
        resp.sendRedirect(req.getContextPath() + "/merchant-admin/orders");
    }
}
