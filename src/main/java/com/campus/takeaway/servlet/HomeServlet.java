package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.AnnouncementDao;
import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.dao.MerchantDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private final DishDao dishDao = new DishDao();
    private final MerchantDao merchantDao = new MerchantDao();
    private final AnnouncementDao announcementDao = new AnnouncementDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        req.setAttribute("dishes", dishDao.findAvailable(keyword));
        req.setAttribute("merchants", merchantDao.findAll());
        req.setAttribute("announcements", announcementDao.findLatest());
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
