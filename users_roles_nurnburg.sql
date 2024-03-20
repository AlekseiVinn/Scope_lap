--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE nurnburg_driver;
ALTER ROLE nurnburg_driver WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
-- CREATE ROLE postgres;
-- ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:lcMY2whHmvhlRq01bxPaVw==$eI4DXsBNAEC8lxfCZfUi2mX9Dk+GHuv3aSrcPpDxW5c=:SXbbYAHK2Q9sFtQH0+b86Md/nOtj+8uE6Uz4DGsk8eY=';
CREATE ROLE stig;
ALTER ROLE stig WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:nHIOCLXBRcxUbq1o2aEGQw==$oUFBFccVodiBZC0HkRHejBO6RPanpQnpwiYrQqWe+V0=:9KwgZeU4DYz8FTUikun20dl4qh+DnuAgppo8wcwa8s8=';

--
-- User Configurations
--


--
-- Role memberships
--

GRANT nurnburg_driver TO stig GRANTED BY postgres;




--
-- Tablespaces
--

CREATE TABLESPACE my_tablespace1 OWNER postgres LOCATION E'E:\\Database\\Lab04';
CREATE TABLESPACE my_scopelap OWNER postgres LOCATION E'E:\\Database\\scope_lap';


--
-- PostgreSQL database cluster dump complete
--

