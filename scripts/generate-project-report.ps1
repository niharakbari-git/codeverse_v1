param(
    [string]$StudentName = "Akbari Nihar",
    [string]$EnrollmentNo = "[Your Enrollment Number]",
    [string]$InstituteName = "NEW L. J. INSTITUTE OF ENGINEERING AND TECHNOLOGY",
    [string]$BranchSemester = "Computer Engineering, Semester VIII",
    [string]$AcademicYear = "2025-26",
    [string]$GuideName = "[Guide Name]",
    [string]$CompanyName = "Academic Project (CodeVerse)",
    [string]$OutputDir = "project-report-output"
)

$ErrorActionPreference = "Stop"

$projectTitle = "CodeVerse: Hackathon Management and Collaboration Platform"
$today = Get-Date -Format "dd/MM/yyyy"

function Join-Lines {
    param([string[]]$Lines)
    return ($Lines -join "`r`n")
}

$documents = [ordered]@{}

$documents["0 - Title page.docx"] = Join-Lines @(
    "A PROJECT REPORT",
    "",
    "ON",
    "",
    $projectTitle,
    "",
    "Submitted by",
    $StudentName,
    "Enrollment Number: $EnrollmentNo",
    "",
    "Guided by",
    $GuideName,
    "",
    "Submitted to",
    "Gujarat Technological University",
    "",
    "In fulfillment for the award of degree of Bachelor of Engineering",
    "in",
    $BranchSemester,
    "Academic Year: $AcademicYear",
    "",
    $InstituteName,
    "",
    "Date: $today"
)

$documents["1 - CERTIFICATE 1.docx"] = Join-Lines @(
    $InstituteName,
    "",
    "CERTIFICATE",
    "",
    "This is to certify that the project report submitted along with the internship/project entitled",
    "'$projectTitle'",
    "has been completed by $StudentName under my guidance in partial fulfillment",
    "of the requirements for the Bachelor of Engineering degree.",
    "",
    "Date: $today",
    "Place: Ahmedabad",
    "",
    "Signature and Name of Guide:",
    $GuideName,
    "",
    "Signature and Name of H.O.D:",
    "[HOD Name]",
    "",
    "Signature and Name of Principal:",
    "[Principal Name]",
    "",
    "Seal of Institute"
)

$documents["1 - CERTIFICATE 2.docx"] = Join-Lines @(
    "INTERNSHIP / PROJECT COMPLETION CERTIFICATE",
    "",
    "This is to certify that $StudentName (Enrollment No: $EnrollmentNo)",
    "has successfully completed the project work on:",
    "'$projectTitle'",
    "during the academic year $AcademicYear.",
    "",
    "Organization / Department: $CompanyName",
    "Duration: [Start Date] to [End Date]",
    "",
    "External Guide Signature: ____________________",
    "Internal Guide Signature: ____________________"
)

$documents["2- DECLARATION.docx"] = Join-Lines @(
    "DECLARATION",
    "",
    "I hereby declare that the project report titled '$projectTitle'",
    "submitted to Gujarat Technological University for the award of Bachelor of Engineering",
    "is a record of original work carried out by me.",
    "",
    "The matter embodied in this report has not been submitted elsewhere",
    "for the award of any degree or diploma.",
    "",
    "Name of Student: $StudentName",
    "Enrollment Number: $EnrollmentNo",
    "Date: $today",
    "Signature of Student: ____________________"
)

$documents["3 - ACKNOWLEDGEMENTS.docx"] = Join-Lines @(
    "ACKNOWLEDGEMENT",
    "",
    "I express my sincere gratitude to my internal guide $GuideName",
    "for continuous guidance, valuable suggestions, and support throughout this project.",
    "",
    "I am thankful to the faculty members of $InstituteName",
    "for providing the environment and resources required for successful completion of this work.",
    "",
    "I also thank my parents, friends, and team members for their encouragement and support.",
    "",
    "Name of Student: $StudentName",
    "Enrollment Number: $EnrollmentNo",
    "Date: $today",
    "Signature of Student: ____________________"
)

$documents["4 - TABLE OF CONTENTS.docx"] = Join-Lines @(
    "TABLE OF CONTENTS",
    "",
    "Title Page",
    "Certificate 1",
    "Certificate 2",
    "Declaration",
    "Acknowledgements",
    "Abstract",
    "Chapter 1: Introduction of Project and Company Profile",
    "Chapter 2: System Requirements",
    "Chapter 3: Work Sheet Report",
    "Chapter 4: Front End of System",
    "Chapter 5: Back End of System",
    "Chapter 6: System Analysis and System Design",
    "Chapter 7: Data Dictionary",
    "Chapter 8: Testing",
    "Chapter 9: Snapshot of Website",
    "Chapter 10: Advantages and Limitations",
    "Chapter 11: Conclusion and Future Enhancement",
    "Chapter 12: Bibliography"
)

$documents["5 - ABSTRACT.docx"] = Join-Lines @(
    "ABSTRACT",
    "",
    "Project Title: $projectTitle",
    "Student Name: $StudentName",
    "Enrollment No: $EnrollmentNo",
    "",
    "CodeVerse is a role-based web application designed to streamline end-to-end hackathon management.",
    "The system supports four user roles: Admin, Organizer, Participant, and Judge.",
    "",
    "Key modules include user authentication, profile management, category and hackathon management,",
    "team creation, hackathon applications, judge assignments, scorecards, and payment processing.",
    "The platform is built using Spring Boot, JSP, JSTL, MySQL, and Maven, with SMTP-based email",
    "support and Cloudinary integration for profile image uploads.",
    "",
    "The application improves transparency and efficiency by centralizing workflows like",
    "registration, application tracking, judging, and result publishing.",
    "",
    "Keywords: Hackathon, Team Management, Judge Evaluation, Spring Boot, JSP, MySQL"
)

$documents["CHAPTER 1 INTRODUCTION(1-5).docx"] = Join-Lines @(
    "CHAPTER 1",
    "INTRODUCTION OF PROJECT AND COMPANY PROFILE",
    "",
    "1.1 Introduction",
    "CodeVerse is a web-based platform developed to digitize the hackathon lifecycle.",
    "It helps institutions and organizations run hackathons from announcement to final results.",
    "",
    "1.1.1 Company Profile",
    "This project was developed as an academic internship/project with focus on real-world",
    "software engineering practices and role-based workflow automation.",
    "",
    "1.1.2 Company Products",
    "The core output is a full-stack web platform for hackathon operations:",
    "- User and role management",
    "- Event and category management",
    "- Team and application workflows",
    "- Judge evaluation and scoring",
    "- Payment and notification support",
    "",
    "1.1.3 Company Mission and Vision",
    "Mission: Build reliable systems that simplify event management.",
    "Vision: Enable transparent, scalable, and student-friendly hackathon ecosystems.",
    "",
    "1.2 Introduction of the Project",
    "CodeVerse addresses limitations of manual tracking through a centralized role-based system.",
    "",
    "1.2.1 Purpose of the Project",
    "- Automate hackathon registration and participation workflows",
    "- Reduce manual errors and communication gaps",
    "- Provide real-time status visibility for all stakeholders",
    "",
    "1.2.2 Functional Requirements",
    "- Secure signup/login and session management",
    "- Admin CRUD for users, categories, and hackathons",
    "- Participant team creation and application submission",
    "- Organizer-side application review and judge assignment",
    "- Judge score entry and result generation",
    "- Payment handling for paid hackathons",
    "",
    "1.2.3 Problems in Existing System",
    "- Manual spreadsheets and email chains",
    "- Delayed status updates",
    "- Non-standard evaluation process",
    "- Difficulty in audit and reporting",
    "",
    "1.2.4 Main Modules",
    "- Authentication Module",
    "- User and Role Management",
    "- Hackathon Management",
    "- Team and Application Module",
    "- Judge Assignment and Scorecard Module",
    "- Payment and Notification Module"
)

$documents["CHAPTER 2 SYSTEM REQUIREMENTS(6-8).docx"] = Join-Lines @(
    "CHAPTER 2",
    "SYSTEM REQUIREMENTS",
    "",
    "2.1 Hardware and Software Requirements",
    "",
    "2.1.1 Server-Side Requirements",
    "Hardware:",
    "- Intel i5 or higher",
    "- 8 GB RAM minimum (16 GB recommended)",
    "- 20 GB free disk space",
    "",
    "Software:",
    "- Java 17",
    "- Maven 3.8+",
    "- MySQL 8.x",
    "- Apache Tomcat (embedded via Spring Boot)",
    "- OS: Windows/Linux/macOS",
    "",
    "2.1.2 Developer-Side Requirements",
    "- IDE: IntelliJ IDEA / VS Code / Eclipse",
    "- Git",
    "- Postman or browser-based testing",
    "- Chrome/Edge browser",
    "",
    "2.1.3 User-Side Requirements",
    "- Modern browser (Chrome, Edge, Firefox)",
    "- Stable internet connection",
    "- JavaScript enabled",
    "",
    "2.2 Software Stack Used in CodeVerse",
    "- Backend: Spring Boot 4.0.2, Spring MVC, Spring Data JPA",
    "- Frontend: JSP, JSTL, HTML, CSS, JavaScript",
    "- Database: MySQL",
    "- Build Tool: Maven",
    "- Mail: SMTP (Gmail)",
    "- File Hosting: Cloudinary",
    "- Payment Gateway: Authorize.net SDK"
)

$documents["CHAPTER 3 WORK SHEET REPORT(9-16).docx"] = Join-Lines @(
    "CHAPTER 3",
    "WORK SHEET REPORT",
    "",
    "3.1 Weekly Work Progress (12 Weeks)",
    "",
    "Week 1: Java basics, logic building, ER diagram",
    "Week 2: Data dictionary, use case diagram, UML, SRS",
    "Week 3: Table design finalization, PK-FK relationships, schema creation, sample data",
    "Week 4: Project structure setup, DB integration, controller-service flow, JSP servlet understanding",
    "Week 5: Registration/login flow, session handling, validation, forgot password",
    "Week 6: Admin dashboard, user management, category management, role-based controls",
    "Week 7: Hackathon create/list/view, registration rules, status and date handling",
    "Week 8: Participant dashboard, my applications, apply flow, status tracking",
    "Week 9: Organizer module, judge assignment logic, review flow, result handling",
    "Week 10: Payment page, card integration, transaction validation, payment status",
    "Week 11: UI improvements, mail templates, bug fixing, date formatting updates",
    "Week 12: Final testing, cleanup, optimization, documentation and submission",
    "",
    "3.2 Outcome of Worksheet Activities",
    "The iterative week-wise execution helped in continuous delivery of modules and",
    "early bug detection. By week 12, all major functional and role-based flows were stabilized."
)

$documents["CHAPTER 4  FRONT END OF SYSTEM(17-23).docx"] = Join-Lines @(
    "CHAPTER 4",
    "FRONT END OF SYSTEM",
    "",
    "4.1 About Front End",
    "The user interface of CodeVerse is built using JSP pages with JSTL tags, HTML, CSS, and JavaScript.",
    "Role-based views are separated for admin, organizer, participant, and judge.",
    "",
    "4.1.1 About HTML/JSP",
    "- JSP view resolution with prefix /WEB-INF/views/ and suffix .jsp",
    "- Reusable page sections and server-side rendered forms",
    "- Dynamic content rendering through JSTL and model attributes",
    "",
    "4.1.2 About CSS",
    "- Custom styles for dashboard pages and forms",
    "- Responsive layout practices for desktop and laptop usage",
    "- Status badges and visual hierarchy for tables/lists",
    "",
    "4.1.3 About JavaScript",
    "- Form-level validation and interaction helpers",
    "- Dynamic field behavior (for example, event type and location rules)",
    "- Client-side usability enhancements",
    "",
    "4.2 Major Frontend Pages",
    "- Login, Signup, Forget Password, Reset Password",
    "- AdminDashboard, ListUser, ListCategory, ListHackathon",
    "- Participant Home, Hackathon Details, MyApplications, MyTeams",
    "- Organizer Applications, JudgeAssignments, Results",
    "- Judge Dashboard and Scorecards"
)

$documents["CHAPTER 5 BACK END OF SYSTEM(24-34).docx"] = Join-Lines @(
    "CHAPTER 5",
    "BACK END OF SYSTEM",
    "",
    "5.1 About Back End",
    "CodeVerse backend follows layered architecture with Controllers, Services, Repositories,",
    "Entities, DTOs, Filters, and Utility classes.",
    "",
    "5.2 Backend Technologies",
    "- Java 17",
    "- Spring Boot 4.0.2",
    "- Spring MVC",
    "- Spring Data JPA (Hibernate)",
    "- MySQL Database",
    "- Maven Build",
    "",
    "5.3 Core Backend Features",
    "- Session-based authentication with role checks",
    "- BCrypt password hashing",
    "- CSRF protection filter",
    "- Role-based route guarding via AuthFilter",
    "- Mail service for welcome and reset flows",
    "- Payment processing integration",
    "",
    "5.4 Database Handling",
    "- Datasource URL configured for MySQL database codeversse",
    "- JPA ddl-auto set to update",
    "- SQL logging enabled for debugging",
    "",
    "5.5 Important Controller Groups",
    "- SessionController: authentication and account recovery",
    "- AdminController: dashboard and administration",
    "- Participant controllers: home, teams, applications",
    "- Organizer controllers: applications, judge assignment, profile",
    "- JudgeController: assignments and scorecards",
    "- PaymentController: credit card charge flow"
)

$documents["CHAPTER 6 SYSTEM ANALYSIS AND SYSTEM DESIGN(35-43).docx"] = Join-Lines @(
    "CHAPTER 6",
    "SYSTEM ANALYSIS AND SYSTEM DESIGN",
    "",
    "6.1 System Analysis",
    "Existing hackathon processes often rely on spreadsheets and disconnected communication.",
    "CodeVerse analyzes these gaps and provides a unified workflow platform.",
    "",
    "6.2 SDLC Model Used",
    "An iterative-incremental approach was used:",
    "- Requirement gathering and planning",
    "- Design and implementation in modules",
    "- Testing and feedback after each sprint/week",
    "- Final integration and stabilization",
    "",
    "6.3 Requirement Categories",
    "Functional:",
    "- User authentication",
    "- Hackathon and category management",
    "- Team/application workflows",
    "- Judge assignment and scoring",
    "- Payment and communication",
    "",
    "Non-functional:",
    "- Usability",
    "- Security",
    "- Maintainability",
    "- Scalability",
    "",
    "6.4 High-Level Architecture",
    "Presentation Layer: JSP + JSTL",
    "Business Layer: Spring Services",
    "Persistence Layer: Spring Data Repositories + MySQL",
    "Security/Filter Layer: AuthFilter + CsrfFilter",
    "",
    "6.5 Basic Class/Entity Design",
    "Major entity classes: UserEntity, UserTypeEntity, HackathonEntity, HackathonApplicationEntity,",
    "TeamEntity, TeamMemberEntity, JudgeAssignmentEntity, JudgeScoreEntity, CategoryEntity, UserDetailEntity."
)

$documents["CHAPTER 7 DATA DICTIONARY(44-48).docx"] = Join-Lines @(
    "CHAPTER 7",
    "DATA DICTIONARY",
    "",
    "7.1 Introduction",
    "This chapter defines key database tables and fields used in CodeVerse.",
    "",
    "7.2 List of Core Tables",
    "",
    "7.2.1 users",
    "- user_id (PK)",
    "- first_name, last_name",
    "- email (unique), password",
    "- user_type_id (FK)",
    "- profile_pic_url, created_at, otp, active",
    "",
    "7.2.2 user_types",
    "- user_type_id (PK)",
    "- user_type (ADMIN, ORGANIZER, PARTICIPANT, JUDGE)",
    "",
    "7.2.3 categories",
    "- category_id (PK)",
    "- category_name",
    "- active",
    "",
    "7.2.4 hackathon",
    "- hackathon_id (PK)",
    "- title, description, status",
    "- event_type, location",
    "- registration_start_date, registration_end_date",
    "- min_team_size, max_team_size",
    "- payment",
    "- user_id (organizer FK), user_type_id (eligibility FK), category_id (FK)",
    "",
    "7.2.5 teams",
    "- team_id (PK)",
    "- team_name",
    "- hackathon_id (FK)",
    "- leader_user_id (FK)",
    "",
    "7.2.6 team_members",
    "- team_member_id (PK)",
    "- team_id (FK)",
    "- member_user_id (FK)",
    "- role (LEADER/MEMBER)",
    "",
    "7.2.7 hackathon_applications",
    "- application_id (PK)",
    "- hackathon_id (FK), team_id (FK), participant_user_id (FK)",
    "- status, payment_status, applied_at",
    "- submission_url, submission_description",
    "- frontend_github_link, backend_github_link",
    "",
    "7.2.8 judge_assignments",
    "- judge_assignment_id (PK)",
    "- hackathon_id (FK)",
    "- judge_user_id (FK)",
    "- assigned_by_user_id (FK)",
    "- assigned_at",
    "",
    "7.2.9 judge_scores",
    "- judge_score_id (PK)",
    "- application_id (FK)",
    "- judge_id (FK)",
    "- score, remarks"
)

$documents["CHAPTER 8 TESTING(49-59).docx"] = Join-Lines @(
    "CHAPTER 8",
    "TESTING",
    "",
    "8.1 Testing Plan",
    "Testing was conducted at module level and integrated flow level.",
    "",
    "8.2 Testing Strategies",
    "- Functional testing for each role",
    "- Integration testing across signup, login, apply, assign, score workflows",
    "- Validation testing for forms and edge cases",
    "- Security checks for unauthorized access and session handling",
    "",
    "8.3 Testing Methods",
    "- Manual UI tests on JSP pages",
    "- Controller/service flow checks using realistic data",
    "- Build verification using Maven compile",
    "",
    "8.4 Sample Test Cases",
    "TC-01: Valid signup creates participant account",
    "Expected: User created, redirect to login, success message shown",
    "",
    "TC-02: Invalid login credentials",
    "Expected: Authentication failed message, login page remains",
    "",
    "TC-03: Participant applies to hackathon with valid team",
    "Expected: Application status set and visible in My Applications",
    "",
    "TC-04: Organizer assigns judge to own hackathon",
    "Expected: Assignment created and visible in judge module",
    "",
    "TC-05: Judge submits scorecard",
    "Expected: Score persisted and reflected in results module",
    "",
    "TC-06: Access protected URL without login",
    "Expected: Redirect to login page",
    "",
    "TC-07: FREE hackathon payment status",
    "Expected: Payment status automatically set to WAIVED"
)

$documents["CHAPTER 9 SNAPSHOT OF WEBSITE(60-72).docx"] = Join-Lines @(
    "CHAPTER 9",
    "SNAPSHOT OF WEBSITE",
    "",
    "9.1 Admin Side",
    "- Admin Login Page",
    "- Admin Dashboard",
    "- User Management (List/Add/Edit/View)",
    "- Category Management",
    "- Hackathon Management",
    "",
    "9.2 Participant Side",
    "- Participant Home",
    "- Hackathon Details",
    "- My Teams",
    "- My Applications",
    "",
    "9.3 Organizer Side",
    "- Organizer Dashboard",
    "- Application Review",
    "- Judge Assignment",
    "- Results",
    "",
    "9.4 Judge Side",
    "- Judge Dashboard",
    "- My Assignments",
    "- Scorecard Entry",
    "",
    "Note: Insert actual screenshots in this chapter before final print submission.",
    "Each section can include captioned images with page-level numbering."
)

$documents["CHAPTER 10 ADVANTAGES(73-75).docx"] = Join-Lines @(
    "CHAPTER 10",
    "ADVANTAGES",
    "",
    "10.1 Advantages",
    "- Centralized role-based hackathon management",
    "- Faster and transparent application tracking",
    "- Better coordination between organizer and judges",
    "- Structured result and scorecard process",
    "- Improved data consistency through database-backed workflows",
    "- Scalable architecture for future modules",
    "",
    "10.2 Limitations",
    "- Heavy dependency on internet and server availability",
    "- Manual testing effort is still significant",
    "- Advanced analytics and notifications can be improved",
    "- Snapshot chapter still requires final image insertion"
)

$documents["CHAPTER 11 CONCLUSION AND FUTURE ENHANCEMENT(76-78).docx"] = Join-Lines @(
    "CHAPTER 11",
    "CONCLUSION AND FUTURE ENHANCEMENT",
    "",
    "11.1 Conclusion",
    "CodeVerse successfully implements a complete hackathon workflow platform",
    "with role-based access and process automation for administration, participation,",
    "evaluation, and result management.",
    "",
    "The project demonstrates practical software engineering practices including layered design,",
    "secure session handling, database normalization, and modular development.",
    "",
    "11.2 Future Enhancement",
    "- Add real-time notifications using WebSocket",
    "- Add advanced analytics dashboards",
    "- Add file upload versioning for submissions",
    "- Integrate plagiarism checks for code submissions",
    "- Add REST API and mobile app support",
    "- Add automated test suite and CI pipeline"
)

$documents["CHAPTER 12 BIBLIOGRAPHY(79-81).docx"] = Join-Lines @(
    "CHAPTER 12",
    "BIBLIOGRAPHY",
    "",
    "Course Outcome Mapping",
    "- CO1: Problem identification, formulation, and software solution",
    "- CO2: Design and implementation using team-based engineering practice",
    "- CO3: Technical communication through documentation and presentation",
    "- CO4: Application of engineering and management principles",
    "",
    "Books",
    "1. Rajib Mall, Fundamentals of Software Engineering",
    "2. Ian Sommerville, Software Engineering",
    "3. Craig Walls, Spring in Action",
    "4. Head First Design Patterns",
    "",
    "Web References",
    "1. Spring Boot Reference Documentation - https://docs.spring.io/spring-boot/docs/current/reference/html/",
    "2. Spring Data JPA Reference - https://docs.spring.io/spring-data/jpa/docs/current/reference/html/",
    "3. MySQL Documentation - https://dev.mysql.com/doc/",
    "4. JSTL and JSP Guides - https://jakarta.ee/specifications/tags/",
    "5. Authorize.net API Docs - https://developer.authorize.net/api/reference/",
    "6. Cloudinary Documentation - https://cloudinary.com/documentation"
)

$workspaceRoot = Get-Location
$targetRoot = Join-Path $workspaceRoot $OutputDir
New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Escape-XmlText {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return [System.Security.SecurityElement]::Escape($Value)
}

function New-DocxFromText {
    param(
        [string]$Path,
        [string]$Text
    )

    if (Test-Path $Path) {
        Remove-Item $Path -Force
    }

    $contentTypes = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>
"@

    $rels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>
"@

    $docRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>
"@

    $paragraphs = @()
    $lines = $Text -split "`r?`n"
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            $paragraphs += "<w:p/>"
        }
        else {
            $escapedLine = Escape-XmlText $line
            $paragraphs += '<w:p><w:r><w:t xml:space="preserve">' + $escapedLine + '</w:t></w:r></w:p>'
        }
    }

    $documentXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    $($paragraphs -join "`n    ")
    <w:sectPr>
      <w:pgSz w:w="12240" w:h="15840"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/>
    </w:sectPr>
  </w:body>
</w:document>
"@

    $archive = [System.IO.Compression.ZipFile]::Open($Path, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        $entry = $archive.CreateEntry("[Content_Types].xml")
        $writer = New-Object System.IO.StreamWriter($entry.Open(), [System.Text.Encoding]::UTF8)
        $writer.Write($contentTypes)
        $writer.Dispose()

        $entry = $archive.CreateEntry("_rels/.rels")
        $writer = New-Object System.IO.StreamWriter($entry.Open(), [System.Text.Encoding]::UTF8)
        $writer.Write($rels)
        $writer.Dispose()

        $entry = $archive.CreateEntry("word/document.xml")
        $writer = New-Object System.IO.StreamWriter($entry.Open(), [System.Text.Encoding]::UTF8)
        $writer.Write($documentXml)
        $writer.Dispose()

        $entry = $archive.CreateEntry("word/_rels/document.xml.rels")
        $writer = New-Object System.IO.StreamWriter($entry.Open(), [System.Text.Encoding]::UTF8)
        $writer.Write($docRels)
        $writer.Dispose()
    }
    finally {
        $archive.Dispose()
    }
}

foreach ($name in $documents.Keys) {
    $path = Join-Path $targetRoot $name
    New-DocxFromText -Path $path -Text $documents[$name]
}

$mergedPath = Join-Path $targetRoot "CodeVerse-Final-Merged-Report.docx"
$mergedText = @()
foreach ($name in $documents.Keys) {
    $mergedText += "============================================================"
    $mergedText += $name
    $mergedText += "============================================================"
    $mergedText += $documents[$name]
    $mergedText += ""
    $mergedText += ""
}

New-DocxFromText -Path $mergedPath -Text ($mergedText -join "`r`n")

Write-Host "Report documents generated at: $targetRoot"
Write-Host "Merged report: $mergedPath"
