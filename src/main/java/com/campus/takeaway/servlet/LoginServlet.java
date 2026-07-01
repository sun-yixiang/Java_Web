package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.UserDao;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = userDao.login(req.getParameter("username"), req.getParameter("password"));
        if (user == null) {
            req.setAttribute("error", "用户名或密码错误");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        req.getSession().setAttribute("user", user);
        if ("admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if ("merchant".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/merchant-admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
