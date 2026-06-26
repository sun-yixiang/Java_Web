package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.model.CartItem;
import com.campus.takeaway.model.Dish;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final DishDao dishDao = new DishDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Integer, CartItem> cart = getCart(req);
        BigDecimal total = cart.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        req.setAttribute("cart", cart);
        req.setAttribute("total", total);
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        int dishId = Integer.parseInt(req.getParameter("dishId"));
        Map<Integer, CartItem> cart = getCart(req);

        if ("add".equals(action)) {
            Dish dish = dishDao.findById(dishId);
            CartItem item = cart.get(dishId);
            if (item == null) {
                cart.put(dishId, new CartItem(dish, 1));
            } else {
                item.setQuantity(item.getQuantity() + 1);
            }
        } else if ("update".equals(action)) {
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            if (quantity <= 0) {
                cart.remove(dishId);
            } else {
                cart.get(dishId).setQuantity(quantity);
            }
        } else if ("delete".equals(action)) {
            cart.remove(dishId);
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    @SuppressWarnings("unchecked")
    private Map<Integer, CartItem> getCart(HttpServletRequest req) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) req.getSession().getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            req.getSession().setAttribute("cart", cart);
        }
        return cart;
    }
}
