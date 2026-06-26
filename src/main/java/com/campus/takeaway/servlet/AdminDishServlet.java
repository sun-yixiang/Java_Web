package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.CategoryDao;
import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.model.Dish;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/dishes")
public class AdminDishServlet extends HttpServlet {
    private final DishDao dishDao = new DishDao();
    private final MerchantDao merchantDao = new MerchantDao();
    private final CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            req.setAttribute("dish", dishDao.findById(Integer.parseInt(req.getParameter("id"))));
        } else if ("delete".equals(action)) {
            dishDao.delete(Integer.parseInt(req.getParameter("id")));
            resp.sendRedirect(req.getContextPath() + "/admin/dishes");
            return;
        }
        req.setAttribute("dishes", dishDao.findAll(req.getParameter("keyword")));
        req.setAttribute("merchants", merchantDao.findAll());
        req.setAttribute("categories", categoryDao.findAll());
        req.getRequestDispatcher("/admin/dishes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Dish dish = new Dish();
        String id = req.getParameter("id");
        if (id != null && !id.isEmpty()) {
            dish.setId(Integer.parseInt(id));
        }
        dish.setMerchantId(Integer.parseInt(req.getParameter("merchantId")));
        dish.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        dish.setName(req.getParameter("name"));
        dish.setPrice(new BigDecimal(req.getParameter("price")));
        dish.setImageUrl(req.getParameter("imageUrl"));
        dish.setDescription(req.getParameter("description"));
        dish.setStock(Integer.parseInt(req.getParameter("stock")));
        dish.setStatus(req.getParameter("status"));
        dishDao.save(dish);
        resp.sendRedirect(req.getContextPath() + "/admin/dishes");
    }
}
