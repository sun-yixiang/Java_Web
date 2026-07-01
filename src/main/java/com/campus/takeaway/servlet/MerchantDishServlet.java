package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.CategoryDao;
import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.model.Dish;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/merchant-admin/dishes")
public class MerchantDishServlet extends HttpServlet {
    private final DishDao dishDao = new DishDao();
    private final MerchantDao merchantDao = new MerchantDao();
    private final CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        int merchantId = user.getMerchantId();
        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            Dish dish = dishDao.findById(Integer.parseInt(req.getParameter("id")));
            if (dish == null || dish.getMerchantId() != merchantId) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "只能维护本商家的菜品");
                return;
            }
            req.setAttribute("dish", dish);
        } else if ("delete".equals(action)) {
            dishDao.deleteByMerchantId(Integer.parseInt(req.getParameter("id")), merchantId);
            resp.sendRedirect(req.getContextPath() + "/merchant-admin/dishes");
            return;
        }
        req.setAttribute("merchant", merchantDao.findById(merchantId));
        req.setAttribute("dishes", dishDao.findByMerchantId(merchantId, req.getParameter("keyword")));
        req.setAttribute("categories", categoryDao.findAll());
        req.getRequestDispatcher("/merchant-admin/dishes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        int merchantId = user.getMerchantId();
        Dish dish = new Dish();
        String id = req.getParameter("id");
        if (id != null && !id.isEmpty()) {
            Dish existing = dishDao.findById(Integer.parseInt(id));
            if (existing == null || existing.getMerchantId() != merchantId) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "只能维护本商家的菜品");
                return;
            }
            dish.setId(existing.getId());
        }
        dish.setMerchantId(merchantId);
        dish.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        dish.setName(req.getParameter("name"));
        dish.setPrice(new BigDecimal(req.getParameter("price")));
        dish.setImageUrl(req.getParameter("imageUrl"));
        dish.setDescription(req.getParameter("description"));
        dish.setStock(Integer.parseInt(req.getParameter("stock")));
        dish.setStatus(req.getParameter("status"));
        dish.setScore(parseScore(req.getParameter("score")));
        dishDao.save(dish);
        resp.sendRedirect(req.getContextPath() + "/merchant-admin/dishes");
    }

    private BigDecimal parseScore(String value) {
        try {
            BigDecimal score = new BigDecimal(value == null || value.trim().isEmpty() ? "0" : value.trim());
            if (score.compareTo(BigDecimal.ZERO) < 0) {
                return BigDecimal.ZERO;
            }
            BigDecimal max = new BigDecimal("5.0");
            return score.compareTo(max) > 0 ? max : score;
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }
}
