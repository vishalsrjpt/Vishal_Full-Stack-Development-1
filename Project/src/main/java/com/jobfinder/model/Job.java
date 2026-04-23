package com.jobfinder.model;

public class Job {

    private int    id;
    private String title;
    private String company;
    private double salaryMin;
    private double salaryMax;
    private String location;
    private String description;
    private String skillsRequired;
    private String jobType;
    private int    recruiterId;

    public Job() {}

    public int    getId()                     { return id; }
    public void   setId(int id)               { this.id = id; }
    public String getTitle()                  { return title; }
    public void   setTitle(String t)          { this.title = t.trim(); }
    public String getCompany()                { return company; }
    public void   setCompany(String c)        { this.company = c.trim(); }
    public double getSalaryMin()              { return salaryMin; }
    public void   setSalaryMin(double s)      { this.salaryMin = s; }
    public double getSalaryMax()              { return salaryMax; }
    public void   setSalaryMax(double s)      { this.salaryMax = s; }
    public String getLocation()               { return location; }
    public void   setLocation(String l)       { this.location = l; }
    public String getDescription()            { return description; }
    public void   setDescription(String d)    { this.description = d; }
    public String getSkillsRequired()         { return skillsRequired; }
    public void   setSkillsRequired(String s) { this.skillsRequired = s; }
    public String getJobType()                { return jobType; }
    public void   setJobType(String t)        { this.jobType = t; }
    public int    getRecruiterId()            { return recruiterId; }
    public void   setRecruiterId(int r)       { this.recruiterId = r; }

    public String getFormattedSalary() {
        int minL = (int)(salaryMin / 100000);
        int maxL = (int)(salaryMax / 100000);
        return "₹" + minL + "L – ₹" + maxL + "L";
    }
}