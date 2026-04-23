package com.jobfinder.dao;

import com.jobfinder.db.DBConnection;
import com.jobfinder.exception.JobFinderException;
import com.jobfinder.model.Job;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAO {

    public int postJob(Job job) throws JobFinderException {
        String sql = "INSERT INTO jobs (title,company,salary_min,salary_max,location,description,skills_req,job_type,recruiter_id) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, job.getTitle());
            ps.setString(2, job.getCompany());
            ps.setDouble(3, job.getSalaryMin());
            ps.setDouble(4, job.getSalaryMax());
            ps.setString(5, job.getLocation());
            ps.setString(6, job.getDescription());
            ps.setString(7, job.getSkillsRequired());
            ps.setString(8, job.getJobType());
            ps.setInt(9,    job.getRecruiterId());
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) {
                if (k.next()) return k.getInt(1);
            }
        } catch (SQLException e) {
            throw new JobFinderException("Post job error: " + e.getMessage(), 500, e);
        }
        return -1;
    }

    public List<Job> searchJobs(String keyword) throws JobFinderException {
        List<Job> results = new ArrayList<>();
        String q = "%" + keyword.trim().toLowerCase() + "%";
        String sql = "SELECT * FROM jobs WHERE LOWER(title) LIKE ? OR LOWER(company) LIKE ? OR LOWER(location) LIKE ? OR LOWER(skills_req) LIKE ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 1; i <= 4; i++) ps.setString(i, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) results.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new JobFinderException("Search error: " + e.getMessage(), 500, e);
        }
        return results;
    }

    public List<Job> getAllJobs() throws JobFinderException {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM jobs ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) jobs.add(mapRow(rs));
        } catch (SQLException e) {
            throw new JobFinderException("Fetch error: " + e.getMessage(), 500, e);
        }
        return jobs;
    }

    public boolean deleteJob(int jobId) throws JobFinderException {
        String sql = "DELETE FROM jobs WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new JobFinderException("Delete error: " + e.getMessage(), 500, e);
        }
    }

    private Job mapRow(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setId(rs.getInt("id"));
        j.setTitle(rs.getString("title"));
        j.setCompany(rs.getString("company"));
        j.setSalaryMin(rs.getDouble("salary_min"));
        j.setSalaryMax(rs.getDouble("salary_max"));
        j.setLocation(rs.getString("location"));
        j.setDescription(rs.getString("description"));
        j.setSkillsRequired(rs.getString("skills_req"));
        j.setJobType(rs.getString("job_type"));
        j.setRecruiterId(rs.getInt("recruiter_id"));
        return j;
    }
}