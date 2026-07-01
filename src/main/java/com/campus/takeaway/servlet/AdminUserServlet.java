package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.dao.UserDao;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();
    private final MerchantDao merchantDao = new MerchantDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("users", userDao.findAll());
        req.setAttribute("merchants", merchantDao.findAll());
        req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = trim(req.getParameter("username"));
        if (username == null || username.isEmpty() || userDao.existsByUsername(username)) {
            req.setAttribute("error", "用户名不能为空，且不能与已有账号重复");
            doGet(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(req.getParameter("password"));
        user.setRealName(trim(req.getParameter("realName")));
        user.setPhone(trim(req.getParameter("phone")));
        user.setRole(req.getParameter("role"));
        if ("merchant".equals(user.getRole())) {
            user.setMerchantId(Integer.parseInt(req.getParameter("merchantId")));
        }
        userDao.save(user);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
