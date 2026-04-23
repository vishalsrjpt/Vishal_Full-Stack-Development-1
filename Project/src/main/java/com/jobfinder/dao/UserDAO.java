package com.jobfinder.dao;

import com.jobfinder.db.DBConnection;
import com.jobfinder.exception.JobFinderException;
import com.jobfinder.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean registerUser(User user) throws JobFinderException {
        String sql = "INSERT INTO users (name,email,password,role,skills,location) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getSkills());
            ps.setString(6, user.getLocation());
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            throw new JobFinderException("Email already registered.", 409, e);
        } catch (SQLException e) {
            throw new JobFinderException("Registration error: " + e.getMessage(), 500, e);
        }
    }

    public User loginUser(String email, String password) throws JobFinderException {
        String sql = "SELECT * FROM users WHERE email=? AND password=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
            return null;
        } catch (SQLException e) {
            throw new JobFinderException("Login error: " + e.getMessage(), 500, e);
        }
    }

    public List<User> getAllSeekers() throws JobFinderException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role='seeker'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            throw new JobFinderException("Fetch error: " + e.getMessage(), 500, e);
        }
        return list;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setSkills(rs.getString("skills"));
        u.setLocation(rs.getString("location"));
        u.setStreak(rs.getInt("streak"));
        u.setLevel(rs.getInt("level"));
        return u;
    }
}