package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.AddressDao;
import com.campus.takeaway.dao.OrderDao;
import com.campus.takeaway.model.CartItem;
import com.campus.takeaway.model.Order;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final AddressDao addressDao = new AddressDao();
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Integer, CartItem> cart = getCart(req);
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        User user = (User) req.getSession().getAttribute("user");
        BigDecimal total = calcTotal(cart);
        req.setAttribute("addresses", addressDao.findByUserId(user.getId()));
        req.setAttribute("cart", cart);
        req.setAttribute("total", total);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Integer, CartItem> cart = getCart(req);
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        User user = (User) req.getSession().getAttribute("user");
        Order order = new Order();
        order.setOrderNo("CT" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS")));
        order.setUserId(user.getId());
        order.setAddressId(Integer.parseInt(req.getParameter("addressId")));
        order.setTotalAmount(calcTotal(cart));
        order.setStatus("created");
        order.setRemark(req.getParameter("remark"));
        orderDao.createOrder(order, cart);
        cart.clear();
        resp.sendRedirect(req.getContextPath() + "/orders");
    }

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpServletRequest req) {
        return (Map<Integer, CartItem>) req.getSession().getAttribute("cart");
    }

    private BigDecimal calcTotal(Map<Integer, CartItem> cart) {
        return cart.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
