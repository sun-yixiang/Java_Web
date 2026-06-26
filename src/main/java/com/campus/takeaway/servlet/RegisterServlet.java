package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.UserDao;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        if (userDao.existsByUsername(username)) {
            req.setAttribute("error", "用户名已存在");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(req.getParameter("password"));
        user.setRealName(req.getParameter("realName"));
        user.setPhone(req.getParameter("phone"));
        userDao.register(user);
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
