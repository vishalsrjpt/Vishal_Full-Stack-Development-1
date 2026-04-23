package com.jobfinder.servlet;

import com.jobfinder.dao.UserDAO;
import com.jobfinder.exception.JobFinderException;
import com.jobfinder.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name  = req.getParameter("name");
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");
        String role  = req.getParameter("role");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Name is required."); 
            req.getRequestDispatcher("/index.html").forward(req, res); return;
        }
        if (pass == null || pass.length() < 6) {
            req.setAttribute("error", "Password min 6 characters.");
            req.getRequestDispatcher("/index.html").forward(req, res); return;
        }

        try {
            User user = new User(name, email, pass, role != null ? role : "seeker");
            if (userDAO.registerUser(user)) {
                res.sendRedirect(req.getContextPath() + "/index.html?registered=true");
            } else {
                req.setAttribute("error", "Registration failed.");
                req.getRequestDispatcher("/index.html").forward(req, res);
            }
        } catch (JobFinderException e) {
            req.setAttribute("error", e.getErrorCode() == 409
                ? "Email already registered." : "Error: " + e.getMessage());
            req.getRequestDispatcher("/index.html").forward(req, res);
        }
    }
}