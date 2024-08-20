-- CREATE SCHEMA
CREATE SCHEMA peex AUTHORIZATION sebitas;

-- CREATE TABLES
CREATE TABLE peex.company (
	idcompany serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT company_pkey PRIMARY KEY (idcompany)
);

CREATE TABLE peex.costcenter (
	idcostcenter serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT costcenter_pkey PRIMARY KEY (idcostcenter)
);

CREATE TABLE peex.document (
	iddocument serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	validfrom date NOT NULL,
	validuntil date NULL,
	documentcontents bytea NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT document_pkey PRIMARY KEY (iddocument)
);

CREATE TABLE peex.timecategory (
	idtimecategory serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT timecategory_pkey PRIMARY KEY (idtimecategory)
);

CREATE TABLE peex.calendar (
	idcalendar serial4 NOT NULL,
	idcompany int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	validuntil date NOT NULL,
	enabled bool NOT NULL,
	CONSTRAINT calendar_pkey PRIMARY KEY (idcalendar),
	CONSTRAINT calendar_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

CREATE TABLE peex.client (
	idclient serial4 NOT NULL,
	idcompany int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT client_pkey PRIMARY KEY (idclient),
	CONSTRAINT client_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

CREATE TABLE peex.holiday (
	idholiday serial4 NOT NULL,
	idcalendar int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	"date" date NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT holiday_pkey PRIMARY KEY (idholiday),
	CONSTRAINT holiday_idcalendar_fkey FOREIGN KEY (idcalendar) REFERENCES peex.calendar(idcalendar)
);

CREATE TABLE peex.role (
	idrole serial4 NOT NULL,
	idcompany int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT role_pkey PRIMARY KEY (idrole),
	CONSTRAINT role_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

CREATE TABLE peex.user (
	iduser serial4 NOT NULL,
	idcompany int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	lastname varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	username varchar(255) NOT NULL,
	"password" varchar(255) NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT user_email_key UNIQUE (email),
	CONSTRAINT user_pkey PRIMARY KEY (iduser),
	CONSTRAINT user_username_key UNIQUE (username),
	CONSTRAINT user_idcompany_fkey FOREIGN KEY (idcompany) REFERENCES peex.company(idcompany)
);

CREATE TABLE peex.project (
	idproject serial4 NOT NULL,
	idclient int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	startdate date NOT NULL,
	enddate date NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	idprojectmanager int4 NOT NULL,
	CONSTRAINT project_pkey PRIMARY KEY (idproject),
	CONSTRAINT project_idclient_fkey FOREIGN KEY (idclient) REFERENCES peex.client(idclient),
	CONSTRAINT project_idprojectmanager_fkey FOREIGN KEY (idprojectmanager) REFERENCES peex.user(iduser)
);

CREATE TABLE peex.projectcostcenter (
	idprojectcostcenter serial4 NOT NULL,
	idproject int4 NOT NULL,
	idcostcenter int4 NOT NULL,
	CONSTRAINT projectcostcenter_pkey PRIMARY KEY (idprojectcostcenter),
	CONSTRAINT projectcostcenter_idcostcenter_fkey FOREIGN KEY (idcostcenter) REFERENCES peex.costcenter(idcostcenter),
	CONSTRAINT projectcostcenter_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject)
);

CREATE TABLE peex.projectdocument (
	idprojectdocument serial4 NOT NULL,
	idproject int4 NOT NULL,
	iddocument int4 NOT NULL,
	CONSTRAINT projectdocument_pkey PRIMARY KEY (idprojectdocument),
	CONSTRAINT projectdocument_iddocument_fkey FOREIGN KEY (iddocument) REFERENCES peex.document(iddocument),
	CONSTRAINT projectdocument_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject)
);

CREATE TABLE peex.tasks (
	idtask serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	description text NULL,
	"work" varchar(255) NULL,
	idproject int4 NOT NULL,
	startdate date NOT NULL,
	enddate date NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT tasks_pkey PRIMARY KEY (idtask),
	CONSTRAINT tasks_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject)
);

CREATE TABLE peex.timesheet (
	idtimesheet serial4 NOT NULL,
	iduser int4 NOT NULL,
	period date NOT NULL,
	approved bool NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT timesheet_pkey PRIMARY KEY (idtimesheet),
	CONSTRAINT timesheet_iduser_fkey FOREIGN KEY (iduser) REFERENCES peex.user(iduser)
);

CREATE TABLE peex.timesheetcostcenter (
	idtimesheetcostcenter serial4 NOT NULL,
	idtimesheet int4 NOT NULL,
	idcostcenter int4 NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT timesheetcostcenter_pkey PRIMARY KEY (idtimesheetcostcenter),
	CONSTRAINT timesheetcostcenter_idcostcenter_fkey FOREIGN KEY (idcostcenter) REFERENCES peex.costcenter(idcostcenter),
	CONSTRAINT timesheetcostcenter_idtimesheet_fkey FOREIGN KEY (idtimesheet) REFERENCES peex.timesheet(idtimesheet)
);

CREATE TABLE peex.timesheethour (
	idtimesheethour serial4 NOT NULL,
	idtimesheetcostcenter int4 NOT NULL,
	idproject int4 NOT NULL,
	"date" date NOT NULL,
	amount int4 NOT NULL,
	idtimecategory int4 NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT timesheethour_pkey PRIMARY KEY (idtimesheethour),
	CONSTRAINT timesheethour_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject),
	CONSTRAINT timesheethour_idtimecategory_fkey FOREIGN KEY (idtimecategory) REFERENCES peex.timecategory(idtimecategory),
	CONSTRAINT timesheethour_idtimesheetcostcenter_fkey FOREIGN KEY (idtimesheetcostcenter) REFERENCES peex.timesheetcostcenter(idtimesheetcostcenter)
);

CREATE TABLE peex.userprojectrole (
	iduserprojectrole serial4 NOT NULL,
	idrole int4 NOT NULL,
	idproject int4 NOT NULL,
	iduser int4 NOT NULL,
	createdat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updatedat timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enabled bool NOT NULL,
	CONSTRAINT userprojectrole_pkey PRIMARY KEY (iduserprojectrole),
	CONSTRAINT userprojectrole_idproject_fkey FOREIGN KEY (idproject) REFERENCES peex.project(idproject),
	CONSTRAINT userprojectrole_idrole_fkey FOREIGN KEY (idrole) REFERENCES peex.role(idrole),
	CONSTRAINT userprojectrole_iduser_fkey FOREIGN KEY (iduser) REFERENCES peex.user(iduser)
);
