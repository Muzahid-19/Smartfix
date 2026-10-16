package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/profile")
public class StaffProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // No session
        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Get logged-in staff
        Staff staff = (Staff) session.getAttribute("staff");

        // Staff not logged in
        if (staff == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Send staff object to JSP
        request.setAttribute("staff", staff);

        // Open profile page
        request.getRequestDispatcher(
            "/staff/profile.jsp"
        ).forward(request, response);
    }
}