package com.jobfinder.servlet;

import com.jobfinder.dao.UserDAO;
import com.jobfinder.exception.JobFinderException;
import com.jobfinder.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String pass  = req.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
            pass  == null || pass.trim().isEmpty()) {
            req.setAttribute("error", "All fields required.");
            req.getRequestDispatcher("/index.html").forward(req, res);
            return;
        }

        try {
            User user = userDAO.loginUser(email, pass);
            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/index.html").forward(req, res);
                return;
            }
            HttpSession session = req.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("userRole",   user.getRole());
            session.setAttribute("userId",     user.getId());

            switch (user.getRole()) {
                case "recruiter" -> res.sendRedirect(req.getContextPath() + "/jsp/recruiter-dashboard.jsp");
                case "admin"     -> res.sendRedirect(req.getContextPath() + "/jsp/admin-dashboard.jsp");
                default          -> res.sendRedirect(req.getContextPath() + "/jsp/seeker-dashboard.jsp");
            }
        } catch (JobFinderException e) {
            req.setAttribute("error", "Server error: " + e.getMessage());
            req.getRequestDispatcher("/index.html").forward(req, res);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/index.html");
    }
}