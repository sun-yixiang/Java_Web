package com.campus.takeaway.servlet;

import com.campus.takeaway.dao.AddressDao;
import com.campus.takeaway.model.Address;
import com.campus.takeaway.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {
    private final AddressDao addressDao = new AddressDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        Address address = new Address();
        address.setUserId(user.getId());
        address.setReceiverName(req.getParameter("receiverName"));
        address.setPhone(req.getParameter("phone"));
        address.setDetail(req.getParameter("detail"));
        address.setDefaultAddress(false);
        addressDao.add(address);
        resp.sendRedirect(req.getContextPath() + "/checkout");
    }
}
