-- Drop the schema if it exists
-- DROP SCHEMA peex CASCADE;

-- Create schema peex with authorization
CREATE SCHEMA peex AUTHORIZATION sebitas;

-- Create the company table
CREATE TABLE peex.company (
    idcompany SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL
);

-- Create the cost center table
CREATE TABLE peex.costcenter (
    idcostcenter SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL
);

-- Create the document table
CREATE TABLE peex.document (
    iddocument SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    validfrom DATE NOT NULL,
    validuntil DATE,
    documentcontents BYTEA,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL
);

-- Create the time category table
CREATE TABLE peex.timecategory (
    idtimecategory SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create the calendar table
CREATE TABLE peex.calendar (
    idcalendar SERIAL PRIMARY KEY,
    idcompany INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    validuntil DATE NOT NULL,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT calendar_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

-- Create the client table
CREATE TABLE peex.client (
    idclient SERIAL PRIMARY KEY,
    idcompany INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT client_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

-- Create the holiday table
CREATE TABLE peex.holiday (
    idholiday SERIAL PRIMARY KEY,
    idcalendar INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT holiday_idcalendar_fkey FOREIGN KEY (idcalendar) REFERENCES peex.calendar(idcalendar)
);

-- Create the role table
CREATE TABLE peex.role (
    idrole SERIAL PRIMARY KEY,
    idcompany INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT role_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

-- Create the user table
CREATE TABLE peex.user (
    iduser SERIAL PRIMARY KEY,
    idcompany INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT user_email_key UNIQUE (email),
    CONSTRAINT user_username_key UNIQUE (username),
    CONSTRAINT user_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

-- Create the project table
CREATE TABLE peex.project (
    idproject SERIAL PRIMARY KEY,
    idclient INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    startdate DATE NOT NULL,
    enddate DATE,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    idprojectmanager INT NOT NULL,
    CONSTRAINT project_idclient_fkey FOREIGN KEY (idclient) REFERENCES peex.client(idclient),
    CONSTRAINT project_idprojectmanager_fkey FOREIGN KEY (idprojectmanager) REFERENCES peex.user(iduser)
);

-- Create the project cost center table
CREATE TABLE peex.projectcostcenter (
    idprojectcostcenter SERIAL PRIMARY KEY,
    idproject INT NOT NULL,
    idcostcenter INT NOT NULL,
    CONSTRAINT projectcostcenter_idcostcenter_fkey FOREIGN KEY (idcostcenter) REFERENCES peex.costcenter(idcostcenter),
    CONSTRAINT projectcostcenter_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject)
);

-- Create the project document table
CREATE TABLE peex.projectdocument (
    idprojectdocument SERIAL PRIMARY KEY,
    idproject INT NOT NULL,
    iddocument INT NOT NULL,
    CONSTRAINT projectdocument_iddocument_fkey FOREIGN KEY (iddocument) REFERENCES peex.document(iddocument),
    CONSTRAINT projectdocument_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject)
);

-- Create the tasks table
CREATE TABLE peex.tasks (
    idtask SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    work VARCHAR(255),
    idproject INT NOT NULL,
    startdate DATE NOT NULL,
    enddate DATE,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT tasks_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject)
);

-- Create the timesheet table
CREATE TABLE peex.timesheet (
    idtimesheet SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    idproject INT NOT NULL,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    iduser INT NOT NULL,
    CONSTRAINT timesheet_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject),
    CONSTRAINT timesheet_iduser_fkey FOREIGN KEY (iduser) REFERENCES peex.user(iduser)
);

-- Create the timesheet cost center table
CREATE TABLE peex.timesheetcostcenter (
    idtimesheetcostcenter SERIAL PRIMARY KEY,
    idtimesheet INT NOT NULL,
    idcostcenter INT NOT NULL,
    CONSTRAINT timesheetcostcenter_idcostcenter_fkey FOREIGN KEY (idcostcenter) REFERENCES peex.costcenter(idcostcenter),
    CONSTRAINT timesheetcostcenter_idtimesheet_fkey FOREIGN KEY (idtimesheet) REFERENCES peex.timesheet(idtimesheet)
);

-- Create the timesheet hour table
CREATE TABLE peex.timesheethour (
    idtimesheethour SERIAL PRIMARY KEY,
    idtimesheet INT NOT NULL,
    iduser INT NOT NULL,
    idtimecategory INT NOT NULL,
    idtask INT,
    quantity INT NOT NULL,
    idprojectmanager INT NOT NULL,
    createdat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL,
    CONSTRAINT timesheethour_idprojectmanager_fkey FOREIGN KEY (idprojectmanager) REFERENCES peex.user(iduser),
    CONSTRAINT timesheethour_idtask_fkey FOREIGN KEY (idtask) REFERENCES peex.tasks(idtask),
    CONSTRAINT timesheethour_idtimecategory_fkey FOREIGN KEY (idtimecategory) REFERENCES peex.timecategory(idtimecategory),
    CONSTRAINT timesheethour_idtimesheet_fkey FOREIGN KEY (idtimesheet) REFERENCES peex.timesheet(idtimesheet),
    CONSTRAINT timesheethour_iduser_fkey FOREIGN KEY (iduser) REFERENCES peex.user(iduser)
);

-- Create the user project role table
CREATE TABLE peex.userprojectrole (
    iduserprojectrole SERIAL PRIMARY KEY,
    idrole INT NOT NULL,
    idproject INT NOT NULL,
    iduser INT NOT NULL,
    CONSTRAINT userprojectrole_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject),
    CONSTRAINT userprojectrole_idrole_fkey FOREIGN KEY (idrole) REFERENCES peex.role(idrole),
    CONSTRAINT userprojectrole_iduser_fkey FOREIGN KEY (iduser) REFERENCES peex.user(iduser)
);
