CREATE ROLE demouser LOGIN PASSWORD 'demopasswd';
GRANT admin TO demouser; /* Now, "demouser" can log into DB Console and use defaultdb */
