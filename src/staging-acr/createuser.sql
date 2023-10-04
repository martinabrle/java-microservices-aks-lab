SET aad_auth_validate_oids_in_tenant = OFF;
DROP USER IF EXISTS 'mysql_conn'@'%';
CREATE AADUSER 'mysql_conn' IDENTIFIED BY '91acaab7-681b-41c5-9c8c-b70644c392df';
GRANT ALL PRIVILEGES ON petclinic.* TO 'mysql_conn'@'%';
FLUSH privileges;
