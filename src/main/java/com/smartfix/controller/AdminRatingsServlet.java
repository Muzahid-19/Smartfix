package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.modelcom.Rating;
import com.smartfix.modelcom.User;
import com.smartfix.service.RatingService;
import com.smartfix.service.impl.RatingServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/ratings")
public class AdminRatingsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private RatingService ratingService;

    @Override
    public void init() throws ServletException {

        ratingService = new RatingServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check session
        if (session == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get logged-in admin
        User admin =
                (User) session.getAttribute("user");

        // Check admin role
        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get all ratings
        List<Rating> ratings =
                ratingService.getAllRatings();

        // Send ratings to JSP
        request.setAttribute(
            "ratings",
            ratings
        );

        // Open ratings page
        request.getRequestDispatcher(
            "/admin/ratings.jsp"
        ).forward(request, response);
    }
}