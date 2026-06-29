package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.DishDao;
import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.model.Merchant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/merchant")
public class MerchantServlet extends HttpServlet {
    private final MerchantDao merchantDao = new MerchantDao();
    private final DishDao dishDao = new DishDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int merchantId;
        try {
            merchantId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Merchant merchant = merchantDao.findById(merchantId);
        if (merchant == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        req.setAttribute("merchant", merchant);
        req.setAttribute("dishes", dishDao.findAvailableByMerchantId(merchantId));
        req.getRequestDispatcher("/merchant.jsp").forward(req, resp);
    }
}
