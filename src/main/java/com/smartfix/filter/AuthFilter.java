package com.smartfix.filter;

import java.io.IOException;

import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter({
    "/admin/*",
    "/staff/*",
    "/user/*",
    "/addComplaint",
    "/myComplaints"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        String requestURI =
                httpRequest.getRequestURI();

        String contextPath =
                httpRequest.getContextPath();

        String path =
                requestURI.substring(
                        contextPath.length()
                );

        /*
         * =====================================================
         * NO SESSION
         * =====================================================
         */

        if (session == null) {

            httpResponse.sendRedirect(
                    contextPath + "/login.jsp"
            );

            return;
        }

        /*
         * =====================================================
         * ADMIN URLS
         * =====================================================
         */

        if (path.startsWith("/admin/")) {

            User user =
                    (User) session.getAttribute("user");

            if (user == null ||
                user.getRole() == null ||
                !"ADMIN".equalsIgnoreCase(
                        user.getRole().trim()
                )) {

                httpResponse.sendRedirect(
                        contextPath + "/login.jsp"
                );

                return;
            }

            chain.doFilter(
                    request,
                    response
            );

            return;
        }

        /*
         * =====================================================
         * STAFF URLS
         * =====================================================
         */

        if (path.startsWith("/staff/")) {

            Staff staff =
                    (Staff) session.getAttribute("staff");

            if (staff == null) {

                httpResponse.sendRedirect(
                        contextPath + "/login.jsp"
                );

                return;
            }

            chain.doFilter(
                    request,
                    response
            );

            return;
        }

        /*
         * =====================================================
         * USER URLS
         * =====================================================
         */

        if (path.startsWith("/user/")) {

            User user =
                    (User) session.getAttribute("user");

            if (user == null ||
                user.getRole() == null ||
                !"USER".equalsIgnoreCase(
                        user.getRole().trim()
                )) {

                httpResponse.sendRedirect(
                        contextPath + "/login.jsp"
                );

                return;
            }

            chain.doFilter(
                    request,
                    response
            );

            return;
        }

        /*
         * =====================================================
         * ADD COMPLAINT
         * =====================================================
         */

        if ("/addComplaint".equals(path)) {

            User user =
                    (User) session.getAttribute("user");

            if (user == null ||
                user.getRole() == null ||
                !"USER".equalsIgnoreCase(
                        user.getRole().trim()
                )) {

                httpResponse.sendRedirect(
                        contextPath + "/login.jsp"
                );

                return;
            }

            chain.doFilter(
                    request,
                    response
            );

            return;
        }

        /*
         * =====================================================
         * MY COMPLAINTS
         * =====================================================
         */

        if ("/myComplaints".equals(path)) {

            User user =
                    (User) session.getAttribute("user");

            if (user == null ||
                user.getRole() == null ||
                !"USER".equalsIgnoreCase(
                        user.getRole().trim()
                )) {

                httpResponse.sendRedirect(
                        contextPath + "/login.jsp"
                );

                return;
            }

            chain.doFilter(
                    request,
                    response
            );

            return;
        }

        /*
         * =====================================================
         * ALLOW REQUEST
         * =====================================================
         */

        chain.doFilter(
                request,
                response
        );
    }
}