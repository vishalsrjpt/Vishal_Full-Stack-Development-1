package com.jobfinder.servlet;

import com.jobfinder.dao.JobDAO;
import com.jobfinder.exception.JobFinderException;
import com.jobfinder.model.Job;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/jobs/search")
public class JobSearchServlet extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        String keyword = req.getParameter("q");

        try (PrintWriter out = res.getWriter()) {
            if (keyword == null || keyword.trim().isEmpty()) { out.print("[]"); return; }

            List<Job> jobs = jobDAO.searchJobs(keyword);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < jobs.size(); i++) {
                Job j = jobs.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                    .append("\"id\":").append(j.getId()).append(",")
                    .append("\"title\":\"").append(esc(j.getTitle())).append("\",")
                    .append("\"company\":\"").append(esc(j.getCompany())).append("\",")
                    .append("\"location\":\"").append(esc(j.getLocation())).append("\",")
                    .append("\"salary\":\"").append(j.getFormattedSalary()).append("\",")
                    .append("\"type\":\"").append(esc(j.getJobType())).append("\"")
                    .append("}");
            }
            out.print(json.append("]").toString());
        } catch (JobFinderException e) {
            res.setStatus(500);
            res.getWriter().print("{\"error\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private String esc(String s) {
        return s == null ? "" : s.replace("\"", "\\\"");
    }
}