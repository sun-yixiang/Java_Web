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
import java.util.List;
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
        String addressId = req.getParameter("addressId");
        List<com.campus.takeaway.model.Address> addresses = addressDao.findByUserId(user.getId());
        if (addressId == null || addressId.trim().isEmpty()) {
            forwardCheckoutWithError(req, resp, cart, addresses, "请先新增并选择一个收货地址，再提交订单。");
            return;
        }
        int parsedAddressId;
        try {
            parsedAddressId = Integer.parseInt(addressId);
        } catch (NumberFormatException e) {
            forwardCheckoutWithError(req, resp, cart, addresses, "收货地址参数不正确，请重新选择地址。");
            return;
        }
        boolean addressBelongsToUser = addresses.stream().anyMatch(address -> address.getId() == parsedAddressId);
        if (!addressBelongsToUser) {
            forwardCheckoutWithError(req, resp, cart, addresses, "请选择当前账号下的有效收货地址。");
            return;
        }

        Order order = new Order();
        order.setOrderNo("CT" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS")));
        order.setUserId(user.getId());
        order.setAddressId(parsedAddressId);
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

    private void forwardCheckoutWithError(HttpServletRequest req, HttpServletResponse resp, Map<Integer, CartItem> cart,
                                          List<com.campus.takeaway.model.Address> addresses, String error)
            throws ServletException, IOException {
        req.setAttribute("addresses", addresses);
        req.setAttribute("cart", cart);
        req.setAttribute("total", calcTotal(cart));
        req.setAttribute("checkoutError", error);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }
}
