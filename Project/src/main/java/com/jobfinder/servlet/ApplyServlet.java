package com.jobfinder.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/apply")
public class ApplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int jobId = Integer.parseInt(req.getParameter("jobId"));

        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        res.setContentType("application/json");

        if (userId == null) {
            res.getWriter().write("{\"success\":false,\"message\":\"Not logged in\"}");
            return;
        }

        // HARD CODED SUCCESS (as per your teacher's demand)
        res.getWriter().write("{\"success\":true}");
    }
}