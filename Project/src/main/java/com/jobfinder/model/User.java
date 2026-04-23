package com.jobfinder.model;

import java.io.Serializable;

public class User implements Serializable {

    private int    id;
    private String name;
    private String email;
    private String password;
    private String role;
    private String skills;
    private String location;
    private int    streak;
    private int    level;

    public User() {}

    public User(String name, String email, String password, String role) {
        this.name     = name.trim();
        this.email    = email.trim().toLowerCase();
        this.password = password;
        this.role     = role;
    }

    public int    getId()               { return id; }
    public void   setId(int id)         { this.id = id; }
    public String getName()             { return name; }
    public void   setName(String n)     { this.name = n.trim(); }
    public String getEmail()            { return email; }
    public void   setEmail(String e)    { this.email = e.trim().toLowerCase(); }
    public String getPassword()         { return password; }
    public void   setPassword(String p) { this.password = p; }
    public String getRole()             { return role; }
    public void   setRole(String r)     { this.role = r; }
    public String getSkills()           { return skills; }
    public void   setSkills(String s)   { this.skills = s; }
    public String getLocation()         { return location; }
    public void   setLocation(String l) { this.location = l; }
    public int    getStreak()           { return streak; }
    public void   setStreak(int s)      { this.streak = s; }
    public int    getLevel()            { return level; }
    public void   setLevel(int l)       { this.level = l; }

    public boolean hasSkill(String skill) {
        if (this.skills == null) return false;
        return this.skills.toLowerCase().contains(skill.toLowerCase().trim());
    }
}