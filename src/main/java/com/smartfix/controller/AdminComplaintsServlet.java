
package com.smartfix.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import com.smartfix.service.ComplaintService;
import com.smartfix.service.StaffService;

import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.StaffServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/complaints")
public class AdminComplaintsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private StaffService staffService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        complaintService = new ComplaintServiceImpl();
        staffService = new StaffServiceImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        // Check admin role
        User admin = (User) session.getAttribute("user");

        if (admin == null || admin.getRole() == null
                || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        // Get all complaints and staff
        List<Complaint> complaints =
                complaintService.getAllComplaints();

        List<Staff> staffList =
                staffService.getAllStaff();

        // Map complaint IDs to their users' room numbers
        Map<Integer, String> roomNumbers = new HashMap<>();

        if (complaints != null) {
            for (Complaint complaint : complaints) {

                User complaintUser =
                        userDAO.getUserById(complaint.getUserId());

                String roomNumber = "Not provided";

                if (complaintUser != null
                        && complaintUser.getRoomNumber() != null
                        && !complaintUser.getRoomNumber().trim().isEmpty()) {
                    roomNumber = complaintUser.getRoomNumber().trim();
                }

                roomNumbers.put(
                        complaint.getComplaintId(),
                        roomNumber);
            }
        }

        // Existing debug output
        System.out.println("========================================");
        System.out.println("ADMIN COMPLAINTS PAGE");
        System.out.println("TOTAL COMPLAINTS: "
                + (complaints == null ? "NULL" : complaints.size()));
        System.out.println("TOTAL STAFF: "
                + (staffList == null ? "NULL" : staffList.size()));

        if (staffList != null) {
            for (Staff staff : staffList) {
                System.out.println(
                        "STAFF ID: " + staff.getStaffId()
                        + " | NAME: " + staff.getName()
                        + " | EMAIL: " + staff.getEmail());
            }
        }

        System.out.println("========================================");

        // Send data to JSP
        request.setAttribute("complaints", complaints);
        request.setAttribute("staffList", staffList);
        request.setAttribute("roomNumbers", roomNumbers);

        // Open JSP
        request.getRequestDispatcher(
                "/admin/complaints.jsp")
                .forward(request, response);
    }
}
