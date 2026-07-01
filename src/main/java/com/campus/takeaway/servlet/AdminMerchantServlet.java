package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.MerchantDao;
import com.campus.takeaway.model.Merchant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/merchants")
public class AdminMerchantServlet extends HttpServlet {
    private final MerchantDao merchantDao = new MerchantDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            req.setAttribute("merchant", merchantDao.findById(Integer.parseInt(req.getParameter("id"))));
        } else if ("delete".equals(action)) {
            merchantDao.delete(Integer.parseInt(req.getParameter("id")));
            resp.sendRedirect(req.getContextPath() + "/admin/merchants");
            return;
        }
        req.setAttribute("merchants", merchantDao.findAll());
        req.getRequestDispatcher("/admin/merchants.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Merchant merchant = new Merchant();
        String id = req.getParameter("id");
        if (id != null && !id.isEmpty()) {
            merchant.setId(Integer.parseInt(id));
        }
        merchant.setName(req.getParameter("name"));
        merchant.setDescription(req.getParameter("description"));
        merchant.setPhone(req.getParameter("phone"));
        merchant.setAddress(req.getParameter("address"));
        merchant.setStatus(req.getParameter("status"));
        merchant.setScore(parseScore(req.getParameter("score")));
        merchantDao.save(merchant);
        resp.sendRedirect(req.getContextPath() + "/admin/merchants");
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
