
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
import com.smartfix.service.impl.ComplaintServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/complaints")
public class StaffComplaintsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        complaintService = new ComplaintServiceImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Get logged-in staff
        Staff staff = (Staff) session.getAttribute("staff");

        if (staff == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int staffId = staff.getStaffId();

        // Get complaints assigned to this staff member
        List<Complaint> complaints =
            complaintService.getComplaintsByStaffId(staffId);

        // Prevent null-list problems in the JSP
        if (complaints == null) {
            complaints = new java.util.ArrayList<>();
        }

        // Build a map: complaint ID -> complaint owner's room number
        Map<Integer, String> roomNumbers = new HashMap<>();

        for (Complaint complaint : complaints) {

            String roomNumber = "Not provided";

            try {
                User complaintUser =
                    userDAO.getUserById(complaint.getUserId());

                if (complaintUser != null
                        && complaintUser.getRoomNumber() != null
                        && !complaintUser.getRoomNumber()
                            .trim().isEmpty()) {

                    roomNumber =
                        complaintUser.getRoomNumber().trim();
                }

            } catch (Exception e) {
                System.err.println(
                    "Could not retrieve room number for complaint ID: "
                    + complaint.getComplaintId()
                );

                e.printStackTrace();
            }

            roomNumbers.put(
                complaint.getComplaintId(),
                roomNumber
            );
        }

        // Debug output
        System.out.println("========================================");
        System.out.println("STAFF COMPLAINTS PAGE");
        System.out.println("STAFF ID: " + staffId);
        System.out.println("STAFF NAME: " + staff.getName());
        System.out.println("ASSIGNED COMPLAINTS: " + complaints.size());
        System.out.println("ROOM NUMBER ENTRIES: " + roomNumbers.size());
        System.out.println("========================================");

        // Send data to JSP
        request.setAttribute("complaints", complaints);
        request.setAttribute("staff", staff);
        request.setAttribute("roomNumbers", roomNumbers);

        // Open staff complaints page
        request.getRequestDispatcher(
            "/staff/complaints.jsp"
        ).forward(request, response);
    }
}
