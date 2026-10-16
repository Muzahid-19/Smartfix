package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;
import com.smartfix.service.StaffService;
import com.smartfix.service.impl.StaffServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/staff")
public class AdminStaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ================================
        // SESSION CHECK
        // ================================

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // ================================
        // ADMIN CHECK
        // ================================

        User admin =
                (User) session.getAttribute("user");

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // ================================
        // GET STAFF
        // ================================

        List<Staff> staffList =
                staffService.getAllStaff();

        // ================================
        // DEBUG
        // ================================

        System.out.println(
            "========================================"
        );

        System.out.println(
            "ADMIN STAFF PAGE"
        );

        System.out.println(
            "STAFF LIST = " +
            (staffList == null
                ? "NULL"
                : staffList.size())
        );

        System.out.println(
            "========================================"
        );

        // ================================
        // SEND TO JSP
        // ================================

        request.setAttribute(
            "staffList",
            staffList
        );

        // ================================
        // FORWARD
        // ================================

        request.getRequestDispatcher(
            "/admin/staff.jsp"
        ).forward(
            request,
            response
        );
    }
}