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

        String syncMessage = syncCartWithStock(cart);
        if (syncMessage != null) {
            req.setAttribute("cartMessage", syncMessage);
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
            addItem(req, resp, cart, dishId);
            return;
        } else if ("update".equals(action)) {
            updateItem(req, cart, dishId);
        } else if ("delete".equals(action)) {
            cart.remove(dishId);
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void addItem(HttpServletRequest req, HttpServletResponse resp, Map<Integer, CartItem> cart, int dishId)
            throws IOException {
        Dish dish = dishDao.findAvailableById(dishId);
        if (dish == null || dish.getStock() <= 0) {
            req.getSession().setAttribute("cartMessage", "该菜品已下架、售罄或商家已关闭，暂时不能加入购物车。");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        CartItem item = cart.get(dishId);
        if (item == null) {
            cart.put(dishId, new CartItem(dish, 1));
        } else if (item.getQuantity() >= dish.getStock()) {
            item.setDish(dish);
            item.setQuantity(dish.getStock());
            req.getSession().setAttribute("cartMessage", "该菜品库存只有 " + dish.getStock() + " 份，不能继续增加。");
        } else {
            item.setDish(dish);
            item.setQuantity(item.getQuantity() + 1);
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void updateItem(HttpServletRequest req, Map<Integer, CartItem> cart, int dishId) {
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        if (quantity <= 0) {
            cart.remove(dishId);
            return;
        }
        if (!cart.containsKey(dishId)) {
            return;
        }

        Dish dish = dishDao.findAvailableById(dishId);
        if (dish == null || dish.getStock() <= 0) {
            cart.remove(dishId);
            req.getSession().setAttribute("cartMessage", "该菜品已下架、售罄或商家已关闭，已从购物车移除。");
            return;
        }

        CartItem item = cart.get(dishId);
        item.setDish(dish);
        if (quantity > dish.getStock()) {
            item.setQuantity(dish.getStock());
            req.getSession().setAttribute("cartMessage", "该菜品库存只有 " + dish.getStock() + " 份，已为你调整到最大可购买数量。");
        } else {
            item.setQuantity(quantity);
        }
    }

    private String syncCartWithStock(Map<Integer, CartItem> cart) {
        boolean removedUnavailableItem = false;
        boolean adjustedQuantity = false;
        for (Integer dishId : new ArrayList<>(cart.keySet())) {
            Dish latestDish = dishDao.findAvailableById(dishId);
            CartItem item = cart.get(dishId);
            if (latestDish == null || latestDish.getStock() <= 0) {
                cart.remove(dishId);
                removedUnavailableItem = true;
            } else {
                item.setDish(latestDish);
                if (item.getQuantity() > latestDish.getStock()) {
                    item.setQuantity(latestDish.getStock());
                    adjustedQuantity = true;
                }
            }
        }
        if (removedUnavailableItem) {
            return "购物车中有菜品已下架、售罄或商家已关闭，已自动移除。";
        }
        if (adjustedQuantity) {
            return "部分菜品数量超过当前库存，已自动调整为最大可购买数量。";
        }
        return null;
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
