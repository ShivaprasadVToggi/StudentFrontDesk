# College Front Desk Management System

A Salesforce Lightning application for managing **Visitors**, **Student Enquiries**, and **Appointments** at a college front desk / reception. Built as a Salesforce DX (SFDX) metadata project — deployable to any Developer Edition or sandbox org.

> **Architecture note:** This is a **pure Salesforce metadata project** (no separate React/Node.js frontend or backend). All UI, logic, validation, and security run natively inside Salesforce via Lightning Experience, custom objects, list views, validation rules, and permission sets. There is no `node_modules` runtime — `package.json` exists only to pin the Salesforce CLI as a devDependency and provide convenience scripts.

---

## What's included (deployed & verified)

### Lightning Application
- **College Front Desk** (`College_Front_Desk`) — Lightning app with tabs: Home, Visitors, Student Enquiries, Appointments, Contacts, Tasks, Reports, Dashboards.

### Custom Objects (all with AutoNumber record names)
| Object | API Name | Name Format | Fields |
|---|---|---|---|
| Visitor | `Visitor__c` | `V-00000` | 12 (Name, Phone, Email, Type, Department, Purpose, Visit Date, Status, Person to Meet, Check-in/out Time, Reception Notes) |
| Student Enquiry | `Student_Enquiry__c` | `ENQ-00000` | 14 (Enquirer, Student ID, Phone, Email, Category, Subject, Department, Priority, Status, Description, Assigned Staff, Follow-up Date, Resolution Notes, Resolved Date) |
| Appointment | `Appointment__c` | `APT-00000` | 8 (Visitor, Phone, Department, Date/Time, Status, Staff Member, Purpose, Notes) |

### Tabs, Layouts, List Views
- 3 custom object tabs + 3 page layouts (all fields included).
- **16 list views**: Today's Visitors, Currently Checked In, Expected Visitors, Completed Visits, All Visitors; New / My Assigned / High Priority / Overdue Follow-ups / In Progress / Resolved / All Enquiries; Today's / Upcoming / Cancelled / All Appointments.

### Validation Rules (active)
1. **Visitor — Checkout After Checkin:** Check-out time cannot be earlier than check-in time.
2. **Student Enquiry — Resolution Notes Required:** Resolution notes are required before marking an enquiry `Resolved`.

### Permission Sets (assign to users)
- `College_Front_Desk_Receptionist` — full create/read/write on all three objects.
- `College_Front_Desk_Staff` — read/write, limited object access.
- `College_Front_Desk_Management` — full access + reports/dashboards.

### Automation (partial)
- **4 workflow field updates** exist in the org (created via Tooling API): set Check-in Time, set Check-out Time, set Resolved Date, auto-route Department from Enquiry Category. They are **not** in this source tree (created directly in the org). Retrieve them with `sf project retrieve start` after authenticating. Workflow rules / record-triggered flows to activate them are not yet active — recommended to build as record-triggered Flows.

### Not yet included
- Reports & Dashboard (list views already cover daily reception needs).
- Record-triggered Flows for auto-timestamps and follow-up Task creation.
- Apex tests (no Apex code in this project).

---

## Prerequisites

- **Node.js >= 18** (for the Salesforce CLI).
- **Salesforce CLI** (`sf`): `npm install -g @salesforce/cli`
- A Salesforce **Developer Edition** org (free) or sandbox.
- Git.

## Setup & deploy (after cloning with Antigravity)

```bash
# 1. Install dependencies (Salesforce CLI as dev tool)
npm install

# 2. Authenticate to your Salesforce org (web-based OAuth)
sf org login web -a cfd-dev --set-default

# 3. Deploy the metadata
npm run deploy
# (or) bash scripts/deploy.sh cfd-dev

# 4. In Salesforce Setup, assign permission sets to users:
#    Setup -> Permission Sets -> College_Front_Desk_Receptionist -> Manage Assignments
```

To pull the latest metadata (including the 4 field updates created directly in the org):
```bash
npm run retrieve
```

To validate without deploying:
```bash
npm run validate
```

## Environment variables

Copy `.env.example` to `.env` and fill in your org details. **Never commit `.env`.** The Salesforce CLI stores OAuth tokens in its own secure config (`.sf/`), which is gitignored.

## Project structure

```
college-front-desk/
├── force-app/main/default/
│   ├── applications/      # Lightning app (College_Front_Desk)
│   ├── layouts/           # 3 page layouts
│   ├── objects/           # 3 custom objects (fields, list views, validation rules)
│   ├── permissionsets/    # 3 permission sets
│   └── tabs/              # 3 custom object tabs
├── scripts/deploy.sh      # Deploy helper
├── package.json           # Dev tooling (sf CLI) + convenience scripts
├── sfdx-project.json      # SFDX project config (API v60.0)
├── .env.example           # Environment variable placeholders
├── .gitignore
└── README.md
```

## Connecting to Salesforce securely

1. `sf org login web` opens a browser; you log in with your Salesforce credentials.
2. Tokens are stored locally by the CLI (`.sf/`), never in source.
3. For CI/CD, use the JWT bearer flow or Salesforce's encrypted connected-app keys — do not hardcode tokens.

## Running tests / builds

There is no frontend build or Apex test suite in this project. Validation is performed via `sf project deploy start --check-only` (see `npm run validate`), which compiles and checks all metadata against the target org without applying changes.

## Known limitations

- Developer Edition org limits apply.
- The 4 workflow field updates were created directly in the org via Tooling API and are not yet in source — retrieve them to capture.
- Workflow rules / Flows to trigger auto-timestamps are not active (see Automation section).
- Reports & dashboards not yet built.

## License

Private — internal project.
