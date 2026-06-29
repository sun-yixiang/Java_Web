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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final DishDao dishDao = new DishDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<Integer, CartItem> cart = getCart(req);
        Object cartMessage = req.getSession().getAttribute("cartMessage");
        if (cartMessage != null) {
            req.setAttribute("cartMessage", cartMessage);
            req.getSession().removeAttribute("cartMessage");
        }
        boolean removedUnavailableItem = false;
        for (Integer dishId : new ArrayList<>(cart.keySet())) {
            if (dishDao.findAvailableById(dishId) == null) {
                cart.remove(dishId);
                removedUnavailableItem = true;
            }
        }
        if (removedUnavailableItem) {
            req.setAttribute("cartMessage", "购物车中有菜品已下架或商家已关闭，已自动移除。");
        }
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
            Dish dish = dishDao.findAvailableById(dishId);
            if (dish == null) {
                req.getSession().setAttribute("cartMessage", "该菜品已下架或商家已关闭，暂时不能加入购物车。");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }
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
            } else if (cart.containsKey(dishId)) {
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
