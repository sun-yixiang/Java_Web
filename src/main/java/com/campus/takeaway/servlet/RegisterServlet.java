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
    private static final String PHONE_PATTERN = "^1[3-9]\\d{9}$";
    private final UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = trim(req.getParameter("username"));
        String phone = trim(req.getParameter("phone"));
        if (phone == null || !phone.matches(PHONE_PATTERN)) {
            req.setAttribute("error", "请输入正确的 11 位中国大陆手机号。");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (userDao.existsByUsername(username)) {
            req.setAttribute("error", "用户名已存在");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(req.getParameter("password"));
        user.setRealName(trim(req.getParameter("realName")));
        user.setPhone(phone);
        userDao.register(user);
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
