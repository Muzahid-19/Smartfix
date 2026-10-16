package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.User;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.impl.ComplaintServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/myComplaints")
public class MyComplaintsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;

    @Override
    public void init() throws ServletException {
        complaintService = new ComplaintServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("user") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get logged-in user
        User user = (User) session.getAttribute("user");

        int userId = user.getUserId();

        // Get complaints of this user
        List<Complaint> complaints =
                complaintService.getComplaintsByUserId(userId);

        // Send complaints to JSP
        request.setAttribute("complaints", complaints);

        request.getRequestDispatcher(
                "/user/my-complaints.jsp"
        ).forward(request, response);
    }
}