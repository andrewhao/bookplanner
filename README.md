Bookplanner
===========

[![Code Climate](https://codeclimate.com/github/andrewhao/bookplanner/badges/gpa.svg)](https://codeclimate.com/github/andrewhao/bookplanner)
[![Test Coverage](https://codeclimate.com/github/andrewhao/bookplanner/badges/coverage.svg)](https://codeclimate.com/github/andrewhao/bookplanner/coverage)
[![Issue Count](https://codeclimate.com/github/andrewhao/bookplanner/badges/issue_count.svg)](https://codeclimate.com/github/andrewhao/bookplanner)
[![Circle CI](https://circleci.com/gh/andrewhao/bookplanner.svg?style=svg)](https://circleci.com/gh/andrewhao/bookplanner)

Developed in partnership with Faith Network, an Oakland nonprofit
serving local schools.

This project is tracked and managed at: https://www.pivotaltracker.com/n/projects/1185744

### Abstract

This mobile-based application is designed to help volunteers organize a
book bag distribution rotation. Each week, students rotate among a set
of book bags to take home. A classroom volunteer then manually rotates
book bags between students.

Each student may be assigned each book bag at most once.

Students each week bring back their book bags. If they fail to bring
back the bag, they lose eligibility to receive a new bag until they
bring it in during the next week(s).

If classrooms run out of unique book bags to complete a plan assignment,
the volunteer may add more bags to the classroom.

### Features

This application tracks classroom book bag inventories by managing:

* A group of classrooms
* The distribution of students per classroom
* The distribution of book bags among classrooms

The application, each week, will generate a plan for the week. This plan
is the unique set of student-bag assignments that satisfy the
requirements in the abstract.

### Assigning book bags

Book bags are assigned by weekly, incremental "plan"s per classroom.

When a classroom plan is generated, a unique constraint satisfaction
problem is posed:

```
For each student eligible for a new book bag,
  From the pool of available, unassigned bags,
    Assign a book bag such that the student has a new bag that s/he has
not received before
Such that all students in eligibility have a new bag.
```

If this problem cannot be solvable, then the administrator must add a
new bag (or several) to the classroom such that a new plan can be
generated.


## Copying production to sandbox

Sometimes, it is good to have a production-like copy of data for
testing/troubleshooting. The script to copy production Postgres data to
the sandbox Postgres DB is located at:

    $ script/production-to-staging.sh

## Boxen development

If you develop on a Boxen-based dev environment (as I do), then you need
to set the `POSTGRES_PORT` environment variable to your local postgres
port.

    $ export POSTGRES_PORT=15432
