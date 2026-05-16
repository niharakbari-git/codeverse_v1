# Test Case Table - CodeVerse Hackathon Management Platform

## 1. User Registration & Authentication

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC001 | User Registration - Valid Data | Username: "john_doe", Email: "john@example.com", Password: "SecurePass123!", UserType: "Participant" | User account created successfully, confirmation email sent, redirects to login page |
| TC002 | User Registration - Duplicate Email | Email: "existing@example.com" (already exists in DB) | Error message: "Email already registered", registration fails |
| TC003 | User Registration - Invalid Email Format | Email: "invalid-email" | Error message: "Invalid email format", validation error shown |
| TC004 | User Registration - Weak Password | Password: "123" | Error message: "Password must be at least 8 characters", validation error shown |
| TC005 | User Login - Valid Credentials | Email: "john@example.com", Password: "SecurePass123!" | Login successful, redirect to dashboard, session created |
| TC006 | User Login - Invalid Email | Email: "nonexistent@example.com", Password: "SecurePass123!" | Error message: "Invalid credentials", login fails |
| TC007 | User Login - Wrong Password | Email: "john@example.com", Password: "WrongPass123!" | Error message: "Invalid credentials", login fails |
| TC008 | User Login - Account Locked | Email: "locked@example.com" (locked after 5 failed attempts) | Error message: "Account is locked. Please reset password" |
| TC009 | Password Reset - Valid Email | Email: "john@example.com" | Reset email sent, user receives link with token |
| TC010 | Password Reset - Invalid Email | Email: "nonexistent@example.com" | No email sent, no error displayed (security measure) |
| TC011 | Password Reset - Set New Password | Valid token, New Password: "NewSecurePass456!" | Password updated successfully, redirects to login |
| TC012 | User Logout | User logged in, clicks logout | Session destroyed, redirects to login page |

## 2. Admin Functions

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC013 | View All Users | Admin logs in, navigates to User Management | List of all users with pagination displayed |
| TC014 | Create New User | Admin enters: Username, Email, Password, UserType | User created successfully, confirmation message shown |
| TC015 | Edit User Details | Admin selects user, updates Name: "Jane Doe", Email: "jane@example.com" | User details updated, confirmation message shown |
| TC016 | Delete User | Admin selects user, clicks delete | User soft-deleted, record retained in audit log |
| TC017 | Approve Organizer Request | Admin views pending organizer requests, approves one | Organizer status updated to "Active", email notification sent |
| TC018 | Reject Organizer Request | Admin rejects organizer request with reason: "Invalid credentials" | Request status changed to "Rejected", email sent with reason |
| TC019 | View Dashboard Metrics | Admin views admin dashboard | Total users, hackathons, revenue, active participants displayed |
| TC020 | Generate User Report | Admin clicks "Generate Report", date range: "2026-01-01 to 2026-04-30" | CSV/PDF report downloaded with user statistics |

## 3. Organizer Functions

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC021 | Submit Organizer Onboarding | New user selects "Organizer", submits: Company name, website, description | Request created with "Pending" status, confirmation email sent |
| TC022 | View Organizer Dashboard | Organizer logs in | Dashboard showing organized hackathons, participants count, revenue |
| TC023 | Create New Hackathon | Organizer enters: Title: "AI Challenge 2026", Description, StartDate, EndDate, Budget | Hackathon created with "Draft" status |
| TC024 | Edit Hackathon Details | Organizer updates: Title, Description, Prize Pool | Changes saved, previous version stored in audit log |
| TC025 | Publish Hackathon | Organizer changes hackathon status to "Published" | Status updated, hackathon visible to all users, notifications sent |
| TC026 | Close Hackathon Registration | Organizer closes registration for a hackathon | Registration closed, no new participants accepted |
| TC027 | View Hackathon Participants | Organizer clicks on hackathon, views participants list | List of all joined participants with status |
| TC028 | Assign Judges | Organizer selects judges from list, assigns to hackathon | Judges assigned, notification emails sent to judges |
| TC029 | Download Participant Report | Organizer generates report for hackathon | Report with participant details, team info, submissions exported |

## 4. Participant Functions

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC030 | Browse Hackathons | User navigates to hackathons list | List of published hackathons with filters (category, status, date) displayed |
| TC031 | View Hackathon Details | Participant clicks on hackathon | Full details shown: description, schedule, prizes, rules, judge list |
| TC032 | Join Hackathon - Individual | Participant clicks "Join", selects "Individual" participation | User added to hackathon, status set to "Active" |
| TC033 | Join Hackathon - Team | Participant clicks "Join", selects "Team", creates team: Team name: "Code Warriors" | Team created, participant added as team leader |
| TC034 | Join Hackathon - Already Joined | Participant tries to join hackathon they're already in | Error message: "You are already registered for this hackathon" |
| TC035 | Invite Team Members | Team leader invites user by email: "member@example.com" | Invitation sent, invitee receives email with acceptance link |
| TC036 | Accept Team Invitation | Invitee clicks link in email | User added to team, status updated to "Active" |
| TC037 | Create Submission | Team submits: Project title, description, GitHub link, technologies | Submission created with timestamp, confirmation shown |
| TC038 | Upload Submission Files | User uploads file: "project.zip" (size: 45 MB, max: 100 MB) | File uploaded, scanned for malware, stored |
| TC039 | Submit Late - Closed | Participant tries to submit after deadline | Error message: "Submission deadline has passed" |
| TC040 | View Submission Status | Participant views their submission | Status shown: "Under Review", "Accepted", "Rejected", or "Pending Scores" |

## 5. Hackathon Management

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC041 | Create Hackathon with Categories | Organizer creates hackathon, assigns categories: "AI", "Web Dev", "Mobile" | Hackathon created with selected categories |
| TC042 | Set Prize Distribution | Organizer sets: 1st Place: $5000, 2nd: $3000, 3rd: $2000 | Prize distribution saved and displayed in hackathon details |
| TC043 | Set Participation Rules | Organizer sets: Max team size: 4, Allow remote: Yes, Requires college ID: No | Rules saved and shown to participants |
| TC044 | View Hackathon Timeline | Participant views hackathon calendar | Timeline shown with: Registration date, Kickoff, Submission deadline, Results |
| TC045 | Hackathon Search & Filter | User searches: "AI hackathon", filters by date range, category | Filtered results displayed matching criteria |
| TC046 | Archive Hackathon | Organizer archives completed hackathon | Hackathon status set to "Archived", moved from active list |

## 6. Team Management

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC047 | Create Team | User clicks "Create Team", enters: Team name: "Tech Titans", Description | Team created, user becomes team leader |
| TC048 | Leave Team | Team member clicks "Leave Team" on active hackathon | Member removed from team, audit log updated |
| TC049 | Remove Team Member | Team leader clicks remove button for member | Member removed, notification sent to removed member |
| TC050 | Disband Team | Team leader clicks "Disband Team" | Team deleted if no active submissions, members notified |
| TC051 | View Team Members | User clicks on team name | List of team members with roles displayed |
| TC052 | Update Team Profile | Team leader edits: Team description, profile image | Changes saved, members notified of update |

## 7. Submission & Judging

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC053 | Submit Project | Team submits: Title, description, GitHub link, demo link, video link | Submission recorded with timestamp, status "Submitted" |
| TC054 | Update Submission | Team updates submission before deadline | Previous version archived, new version active |
| TC055 | View All Submissions (Judge) | Judge logs in, views assigned hackathon | List of all submissions displayed with review status |
| TC056 | Score Submission | Judge scores submission: Criteria1: 8/10, Criteria2: 9/10, Comments: "Great work" | Score saved, visible to organizer and participant |
| TC057 | Verify Judge Assignment | System verifies judge assignment for hackathon | Judge assigned, can only view/score assigned hackathon submissions |
| TC058 | Calculate Final Scores | All judges submit scores for submissions | System calculates average, ranks teams, determines winners |
| TC059 | Announce Results | Organizer clicks "Announce Results" | Results published, emails sent to top 3 teams, status changed to "Results Announced" |

## 8. Payment & Transactions

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC060 | Process Payment - Valid Card | User enters: Card number: "4111111111111111", Expiry: "12/26", CVV: "123", Amount: "$50" | Payment processed, transaction recorded, receipt generated |
| TC061 | Process Payment - Invalid Card | Card number: "1234567890123456" | Error: "Invalid card number", payment declined |
| TC062 | Process Payment - Expired Card | Card expiry: "01/24" (past date) | Error: "Card expired", payment declined |
| TC063 | Process Payment - Insufficient Funds | Card has insufficient balance | Error: "Insufficient funds", payment declined, transaction logged |
| TC064 | View Transaction History | User views payment transactions | List of all transactions with date, amount, status, receipt link |
| TC065 | Download Receipt | User clicks download on transaction | Receipt PDF downloaded with transaction details |
| TC066 | Refund Transaction | Admin/Organizer processes refund for transaction | Refund initiated, status updated to "Refunded", original payment reversed |

## 9. Notifications & Communications

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC067 | Hackathon Announcement | Organizer sends announcement to all participants | Notification created, email sent, shown in user notification center |
| TC068 | Submission Deadline Reminder | System sends automatic reminder 24 hours before deadline | Email and in-app notification sent to all participants |
| TC069 | Judge Assignment Notification | Judge is assigned to hackathon | Notification email sent with hackathon details and instructions |
| TC070 | Winner Announcement Notification | Results are announced | Email sent to top 3 teams, notification in app |
| TC071 | View Notification History | User clicks Notifications | List of all notifications with timestamps and status |
| TC072 | Mark Notification as Read | User clicks on notification | Notification marked as read, visual indicator updated |

## 10. Error Handling & Security

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC073 | SQL Injection Prevention | Input in search field: `' OR '1'='1` | Input sanitized, treated as literal text, no unauthorized access |
| TC074 | XSS Prevention | Submission title contains: `<script>alert('XSS')</script>` | Script tags escaped, displayed as plain text |
| TC075 | Unauthorized Access - Direct URL | Non-admin tries to access `/admin/users` directly | Redirected to login or access denied page |
| TC076 | Session Timeout | User inactive for 30 minutes | Session expired, redirected to login on next action |
| TC077 | CSRF Token Validation | Form submitted without valid CSRF token | Request rejected, error message shown |
| TC078 | File Upload - Malicious File | User uploads: "virus.exe" | File blocked, error message: "File type not allowed" |
| TC079 | File Upload - Exceeds Size Limit | User uploads: "project.zip" (200 MB, limit: 100 MB) | Upload rejected, error: "File size exceeds maximum" |
| TC080 | Database Connection Loss | Database becomes unavailable during operation | Graceful error message, retry option offered |
| TC081 | Audit Log Recording | Admin performs action: delete user | Action logged with: timestamp, user, IP, action type, details |
| TC082 | Rate Limiting - Login Attempts | User makes 10 failed login attempts in 1 minute | Account temporarily locked for 15 minutes |

## 11. Performance & Data Integrity

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC083 | Concurrent Submissions | 10 teams submit simultaneously | All submissions recorded correctly, no data loss |
| TC084 | Large Participant List | Hackathon with 5000+ participants | Pagination works, load time < 3 seconds |
| TC085 | Database Backup Integrity | Backup created during active operations | Backup completes without corruption, restore successful |
| TC086 | Data Validation - Email Duplicate | System checks for duplicate emails during import | Duplicates skipped, valid records imported |

## 12. UI/UX & Usability

| Test Case ID | Description | Input | Expected Output |
|---|---|---|---|
| TC087 | Responsive Design - Mobile | Access application on mobile (375px width) | All elements visible, clickable, no horizontal scroll |
| TC088 | Responsive Design - Tablet | Access application on tablet (768px width) | Layout adapted, all features accessible |
| TC089 | Form Validation - Real-time | User types invalid email in form field | Error message appears immediately below field |
| TC090 | Form Reset | User clicks "Reset" button after filling form | All fields cleared, form back to initial state |

---

## Notes
- **Test Execution Priority**: High (TC001-TC040), Medium (TC041-TC070), Low (TC071-TC090)
- **Environment**: Development, Staging, Production
- **Tester Role**: QA Engineer, Automation Engineer
- **Estimated Execution Time**: 40-50 hours for manual testing
- **Automation Opportunity**: TC001-TC090 can be automated using Selenium/JUnit
