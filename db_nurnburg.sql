--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 15.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: func_create_driver(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_create_driver(firstname character varying, lastname character varying, login character varying DEFAULT NULL::character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO public.drivers (driver_firstname, driver_lastname, driver_login)
	VALUES (firstname,lastname,login);
 	RETURN 0;
 END;$$;


ALTER FUNCTION public.func_create_driver(firstname character varying, lastname character varying, login character varying) OWNER TO postgres;

--
-- Name: func_create_session(smallint, interval, integer, integer, date, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_create_session(conf_id smallint, _time interval, car_id integer, driver_id integer, _date date, note character varying DEFAULT NULL::character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$BEGIN
	INSERT INTO public.lap_session (
			track_conf_id, 
			lap_time,
			car_id,
			driver_id,
			date,
			session_note)
	VALUES (conf_id,
			_time,
			car_id,
			driver_id,
		   _date,
		   note);
 	RETURN 0;
 END;$$;


ALTER FUNCTION public.func_create_session(conf_id smallint, _time interval, car_id integer, driver_id integer, _date date, note character varying) OWNER TO postgres;

--
-- Name: func_get_driver_id(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_get_driver_id(_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	res_id integer;
BEGIN
	SELECT 
	lap_session.driver_id INTO res_id
	FROM lap_session WHERE lap_session.session_id = _id;
	RETURN res_id;
END;

$$;


ALTER FUNCTION public.func_get_driver_id(_id bigint) OWNER TO postgres;

--
-- Name: func_get_driver_name(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_get_driver_name(_login character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$DECLARE
	_name CHARACTER VARYING;
BEGIN
	SELECT 
	(drivers.driver_firstname::text || ' '::text) 
	|| drivers.driver_lastname::text INTO _name
	FROM drivers WHERE drivers.driver_login = _login;
	RETURN _name;
END;

$$;


ALTER FUNCTION public.func_get_driver_name(_login character varying) OWNER TO postgres;

--
-- Name: func_get_you_id(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_get_you_id(_login character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	res_id integer;
BEGIN
	SELECT 
	drivers.driver_id INTO res_id
	FROM drivers WHERE drivers.driver_login = _login;
	RETURN res_id;
END;

$$;


ALTER FUNCTION public.func_get_you_id(_login character varying) OWNER TO postgres;

--
-- Name: func_update_session(bigint, smallint, interval, integer, date, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.func_update_session(_sess_id bigint, conf_id smallint, _time interval, _car_id integer, _date date, note character varying DEFAULT NULL::character varying) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public.lap_session
	SET 	track_conf_id = conf_id, 
			lap_time = _time,
			car_id = _car_id,
			date = _date,
			session_note = note
	WHERE lap_session.session_id = _sess_id;
 	RETURN 0;
 END;
$$;


ALTER FUNCTION public.func_update_session(_sess_id bigint, conf_id smallint, _time interval, _car_id integer, _date date, note character varying) OWNER TO postgres;

--
-- Name: my_sessions(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.my_sessions(IN _login character varying)
    LANGUAGE sql
    AS $$SELECT 
		lap_session.session_id as "Session N",
		track_configuration.length "Track length", 
		lap_session.lap_time "Time",
		cars.car_name "Car",
		drivers.driver_firstname || ' ' || drivers.driver_lastname "Driver",
		lap_session.date "Date"
		FROM track_configuration 
		JOIN lap_session ON track_configuration.conf_id = lap_session.track_conf_id 
		JOIN cars ON lap_session.car_id = cars.car_id
		JOIN drivers ON lap_session.driver_id = drivers.driver_id
		WHERE drivers.driver_login = _login;

$$;


ALTER PROCEDURE public.my_sessions(IN _login character varying) OWNER TO postgres;

--
-- Name: proc_delete_session(bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.proc_delete_session(IN _id bigint)
    LANGUAGE sql
    AS $$DELETE FROM public.lap_session 
	WHERE session_id = _id;$$;


ALTER PROCEDURE public.proc_delete_session(IN _id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    car_id integer NOT NULL,
    car_name character varying NOT NULL,
    car_type_id smallint DEFAULT 1 NOT NULL,
    car_spec character varying
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- Name: all_cars; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_cars AS
 SELECT cars.car_id,
    cars.car_name
   FROM public.cars;


ALTER TABLE public.all_cars OWNER TO postgres;

--
-- Name: car_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_type (
    id smallint NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE public.car_type OWNER TO postgres;

--
-- Name: drivers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drivers (
    driver_id integer NOT NULL,
    driver_firstname character varying NOT NULL,
    driver_lastname character varying NOT NULL,
    driver_login character varying
);


ALTER TABLE public.drivers OWNER TO postgres;

--
-- Name: lap_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lap_session (
    session_id bigint NOT NULL,
    track_conf_id smallint DEFAULT 2 NOT NULL,
    lap_time interval NOT NULL,
    car_id integer NOT NULL,
    driver_id integer NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    session_note character varying
);


ALTER TABLE public.lap_session OWNER TO postgres;

--
-- Name: track_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.track_configuration (
    conf_id smallint NOT NULL,
    length smallint NOT NULL,
    description character varying
);


ALTER TABLE public.track_configuration OWNER TO postgres;

--
-- Name: all_sessions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_sessions AS
 SELECT lap_session.session_id AS "Session N",
    track_configuration.length AS "Track length",
    lap_session.lap_time AS "Time",
    cars.car_name AS "Car",
    car_type.description AS "Car type",
    (((drivers.driver_firstname)::text || ' '::text) || (drivers.driver_lastname)::text) AS "Driver",
    lap_session.date AS "Date",
    lap_session.session_note AS "Session note"
   FROM ((((public.track_configuration
     JOIN public.lap_session ON ((track_configuration.conf_id = lap_session.track_conf_id)))
     JOIN public.cars ON ((lap_session.car_id = cars.car_id)))
     JOIN public.car_type ON ((cars.car_type_id = car_type.id)))
     JOIN public.drivers ON ((lap_session.driver_id = drivers.driver_id)));


ALTER TABLE public.all_sessions OWNER TO postgres;

--
-- Name: car_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.car_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.car_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cars_car_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cars ALTER COLUMN car_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cars_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: compact_all_sessions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.compact_all_sessions AS
 SELECT lap_session.session_id AS "Session N",
    track_configuration.length AS "Track length",
    lap_session.lap_time AS "Time",
    cars.car_name AS "Car",
    (((drivers.driver_firstname)::text || ' '::text) || (drivers.driver_lastname)::text) AS "Driver",
    lap_session.date AS "Date"
   FROM (((public.track_configuration
     JOIN public.lap_session ON ((track_configuration.conf_id = lap_session.track_conf_id)))
     JOIN public.cars ON ((lap_session.car_id = cars.car_id)))
     JOIN public.drivers ON ((lap_session.driver_id = drivers.driver_id)))
  ORDER BY lap_session.date DESC;


ALTER TABLE public.compact_all_sessions OWNER TO postgres;

--
-- Name: drivers_driver_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.drivers ALTER COLUMN driver_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.drivers_driver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: get_length; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.get_length AS
 SELECT track_configuration.conf_id,
    ((((track_configuration.description)::text || ': '::text) || track_configuration.length) || 'm'::text) AS conf
   FROM public.track_configuration;


ALTER TABLE public.get_length OWNER TO postgres;

--
-- Name: lap_session_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.lap_session ALTER COLUMN session_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.lap_session_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: top_100_sessions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.top_100_sessions AS
 SELECT lap_session.session_id AS "Session N",
    track_configuration.length AS "Track length",
    lap_session.lap_time AS "Time",
    cars.car_name AS "Car",
    (((drivers.driver_firstname)::text || ' '::text) || (drivers.driver_lastname)::text) AS "Driver",
    lap_session.date AS "Date"
   FROM (((public.track_configuration
     JOIN public.lap_session ON ((track_configuration.conf_id = lap_session.track_conf_id)))
     JOIN public.cars ON ((lap_session.car_id = cars.car_id)))
     JOIN public.drivers ON ((lap_session.driver_id = drivers.driver_id)))
  ORDER BY lap_session.lap_time
 LIMIT 100;


ALTER TABLE public.top_100_sessions OWNER TO postgres;

--
-- Name: track_configuration_conf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.track_configuration ALTER COLUMN conf_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.track_configuration_conf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: your_sessions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.your_sessions AS
 SELECT lap_session.session_id AS "Session N",
    track_configuration.length AS "Track length",
    lap_session.lap_time AS "Time",
    cars.car_name AS "Car",
    (((drivers.driver_firstname)::text || ' '::text) || (drivers.driver_lastname)::text) AS "Driver",
    lap_session.date AS "Date"
   FROM (((public.track_configuration
     JOIN public.lap_session ON ((track_configuration.conf_id = lap_session.track_conf_id)))
     JOIN public.cars ON ((lap_session.car_id = cars.car_id)))
     JOIN public.drivers ON ((lap_session.driver_id = drivers.driver_id)))
  WHERE (((drivers.driver_firstname)::text = 'Jeremy'::text) AND ((drivers.driver_lastname)::text = 'Clarkson'::text));


ALTER TABLE public.your_sessions OWNER TO postgres;

--
-- Data for Name: car_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_type (id, description) FROM stdin;
1	Production/street-legal
2	Non-series/non-road-legal
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars (car_id, car_name, car_type_id, car_spec) FROM stdin;
1	Alfa Romeo 156 GTA (2002, 250 PS)	1	\N
2	Alfa Romeo 4C	1	\N
3	Alfa Romeo Giulia Quadrifoglio (2015)	1	\N
4	Alfa Romeo Stelvio Quadrifoglio (2018)	1	\N
5	Alpine A110 (2019, 1.8 T, 252 PS)	1	\N
6	Alpine A110 S (2020, 1.8 T, 292 PS)	1	\N
7	Apline A110S (2022, 1.8 T, 300 PS)	1	\N
8	Artega GT	1	\N
9	Aston Martin DB7 GT	1	\N
10	Aston Martin DB7 Vantage	1	\N
11	Aston Martin DB9 (2004, 456 PS)	1	\N
12	Aston Martin DBS	1	\N
13	Aston Martin V12 Vanquish	1	\N
14	Aston Martin V12 Vantage S	1	\N
15	Aston Martin V8 Vantage (2019)	1	\N
16	Aston Martin V8 Vantage (Mk1, 2005, 385 PS)	1	\N
17	Aston Martin V8 Vantage GT8 (2017, N/A 4.7, 446 PS)	1	\N
18	Audi R8 4.2 FSI Quattro (Mk1, Type 42, 2007, N/A 4.2, 420 PS)	1	\N
19	Audi R8 4.2 FSI R-Tronic	1	\N
20	Audi R8 Coupe 5.2 FSI Quattro (Mk1, Type 42, 2009, 525 PS)	1	\N
21	Audi R8 GT (Mk1, Typ 42, 2010)	1	\N
22	Audi R8 Plus (Mk1, Type 42, 2013, N/A 5.2, 550 PS)	1	\N
23	Audi R8 V10 Plus (4S, 2015)	1	\N
24	Audi RS Q8	1	\N
25	Audi RS3 (Typ 8Y, 2021, 2.5 T, 400 PS)	1	\N
26	Audi RS3 (Typ 8Y, 2022, 2.5 T, 400 PS)	1	\N
27	Audi RS3 Sportback (8P, 2011, 2.5 T, 340 PS)	1	\N
28	Audi RS4 (B7)	1	\N
29	Audi RS4 Avant (B5)	1	\N
30	Audi RS4 Avant (B9)	1	\N
31	Audi RS4 Avant Competition Plus (B9)	1	\N
32	Audi RS5 Coupe (8T)	1	\N
33	Audi RS6 (C5)	1	\N
34	Audi RS6 Avant (C7)	1	\N
35	Audi S1 (8X, 2014, 231 PS)	1	\N
36	Audi S3 (8L, 1999, 210 PS)	1	\N
37	Audi S4 (B5, 1998, 265 PS)	1	\N
38	Audi S4 Avant (B6)	1	\N
39	Audi S5	1	\N
40	Audi TT 1.8 T (Mk1, 8N, 1998)	1	\N
41	Audi TT Coupe (Mk2, 8J, 2007 2.0 TFSI, 200 PS)	1	\N
42	Audi TT RS (8S, 2017, 2.5 T, 400 PS)	1	\N
43	Audi TT RS (Mk2, 8J, 2010, 2.5 T, 340 PS)	1	\N
44	Audi TT S Coupe (Mk3, FV/8S, 2015, 2.0 T, 310 PS)	1	\N
45	Audi TTS Coupe (8J, 2008, 272 PS)	1	\N
46	Bentley Continental GT (Mk1, 2006, 560 PS)	1	\N
47	BMW 1 Series M Coupe (E82)	1	\N
48	BMW 335i Coupe (E92)	1	\N
49	BMW Alpina B10 3.2 (E39, 1998, 260 PS)	1	\N
50	BMW Alpina B3 (E46, 1999, 280 PS)	1	\N
51	BMW Alpina B3 (G20, 2021, 3.0 TT, 462 PS)	1	\N
52	BMW Alpina B3 Biturbo (F30, 2014, 3.0 BT, 410 PS)	1	\N
53	BMW Alpina B3 Biturbo Coupe (E92, 2008, 3.0 BT, 360 PS)	1	\N
54	BMW Alpina B3 Coupe GT3 (E92, 2012, 3.0 T, 408 PS)	1	\N
55	BMW Alpina B4 S Biturbo Coupe (F32, 2018, 3.0 BT, 440 PS)	1	\N
56	BMW Alpina B6 S (E63)	1	\N
57	BMW Alpina Roadster S (E85, 2005, 300 PS)	1	\N
58	BMW Aplina B4 Gran Coupe (G26, 2023, 3.0 TT, 495 PS)	1	\N
59	BMW M135i (F20, 2012)	1	\N
60	BMW M2 (F87)	1	\N
61	BMW M2 (F87, 2016, 3.0 T, 370 PS)	1	\N
62	BMW M2 (G87, 2023, 3.0 TT, 460 PS)	1	\N
63	BMW M2 Competition (F87)	1	\N
64	BMW M2 CS (F87, 2020)	1	\N
65	BMW M235i (F22, 2015, 3.0 T, 322 PS)	1	\N
66	BMW M240i xDrive (G42, 2022, 3.0 T, 374 PS)	1	\N
67	BMW M3 (E30)	1	\N
68	BMW M3 (E46)	1	\N
69	BMW M3 (E92)	1	\N
70	BMW M3 Competition Touring (G81, 2023, 3.0 TT, 510 PS)	1	\N
71	BMW M3 Coupe SMG (E36, facelift, 1997, 321 PS)	1	\N
72	BMW M3 CS (G80, 2023, 3.0 TT, 550 PS)	1	\N
73	BMW M3 CSL (E46, 2004)	1	\N
74	BMW M3 GTS (E92, 2010)	1	\N
75	BMW M3 Touring	1	\N
76	BMW M4 (F82, 2014, 431 PS)	1	\N
77	BMW M4 Competition (G82, 2021, 3.0 TT, 510 PS)	1	\N
78	BMW M4 Competition xDrive (G82, 2022, 3.0 TT, 510 PS)	1	\N
79	BMW M4 CS (F82, 2017, 3.0 TT, 460 PS)	1	\N
80	BMW M4 CSL (G82, 2022)	1	\N
81	BMW M4 CSL (G82, 2023, 3.0 TT, 550 PS)	1	\N
82	BMW M4 GTS (F82, 2015)	1	\N
83	BMW M4 GTS (F82, 2016)	1	\N
84	BMW M5 (E39)	1	\N
85	BMW M5 (E60)	1	\N
86	BMW M5 (F10)	1	\N
87	BMW M5 (F90)	1	\N
88	BMW M5 Competition (F10, 2014, 575 PS)	1	\N
89	BMW M5 Competition (F90, 2019, 625 PS)	1	\N
90	BMW M5 CS (F90, 2021)	1	\N
91	BMW M6 Cabrio (E64, 2007, 507 PS)	1	\N
92	BMW M6 Coupe (E63, 2005, 507 PS)	1	\N
93	BMW M6 Coupe (E63, 2006, 507 PS)	1	\N
94	BMW M8 Coupe Competition (F92, 2020, 625 PS)	1	\N
95	BMW X6 M (E71, 2009, 555 PS)	1	\N
96	BMW Z3 Coupe 3.0 (E36/8, 2001, 231 PS)	1	\N
97	BMW Z3 M Coupe (E36/8, 1998, 321 PS)	1	\N
98	BMW Z3 M Roadster (E36/7)	1	\N
99	BMW Z4 Coupe 3.0si (E86, facelift, 2006, 265 PS)	1	\N
100	BMW Z4 M40i (G29)	1	\N
101	BMW Z4 Roadster 3.0i SMG (E85, pre-facelift, 2003, 231 PS)	1	\N
102	BMW Z8 (E52, 2000, 400 PS)	1	\N
103	Bugatti EB110 SS	1	\N
104	Cadillac CTS-V (2009)	1	\N
105	Callaway C12 Coupe	1	\N
106	Caterham R500 Superlight	1	\N
107	Chevrolet Camaro Z/28 (2014)	1	\N
108	Chevrolet Camaro ZL1 (2012)	1	\N
109	Chevrolet Camaro ZL1 (2017)	1	\N
110	Chevrolet Camaro ZL1 1LE (2018)	1	\N
111	Chevrolet Cobalt SS Turbo	1	\N
112	Chevrolet Corvette (C6, 2005, N/A 6.0, 404 PS)	1	\N
113	Chevrolet Corvette (C8) (2020)	1	\N
114	Chevrolet Corvette C5	1	\N
115	Chevrolet Corvette C5 Commemorative Edition (2003, 344 PS)	1	\N
116	Chevrolet Corvette C6 Z06 (2012)	1	\N
117	Chevrolet Corvette C6 ZR1	1	\N
118	Chevrolet Corvette C6 ZR1 (2009)	1	\N
119	Chevrolet Corvette C6 ZR1 (2012)	1	\N
120	Chevrolet Corvette Z06 (C6, 2007, N/A 7.0, 512 PS	1	\N
121	Chevrolet Corvette Z06 (C7)	1	\N
122	Chrysler Viper GTS	1	\N
123	Cupra Formentor VZ5 (2023, 390 PS)	1	\N
124	Dodge Viper ACR (2009)	1	\N
125	Dodge Viper ACR (2010)	1	\N
126	Dodge Viper ACR (2017)	1	\N
127	Dodge Viper SRT-10 roadster (ZB)	1	\N
128	Donkervoort D8 180R (2001, 1.8T, 240 PS)	1	\N
129	Donkervoort D8 RS	1	\N
130	Ferrari 296 GTB	1	\N
131	Ferrari 360 Challenge Stradale F1	1	\N
132	Ferrari 360 Modena	1	\N
133	Ferrari 458 Italia	1	\N
134	Ferrari 458 Italia (570 PS, 2010)	1	\N
135	Ferrari 488 GTB	1	\N
136	Ferrari 488 Pista	1	\N
137	Ferrari 550 Maranello	1	\N
138	Ferrari 575M Maranello	1	\N
139	Ferrari 599 GTB Fiorano	1	\N
140	Ferrari 812 Superfast	1	\N
141	Ferrari California (Type F149, 2010, 460 PS)	1	\N
142	Ferrari Enzo	1	\N
143	Ferrari F12 Berlinetta (740 PS, 2014)	1	\N
144	Ferrari F355	1	\N
145	Ferrari F430 F1	1	\N
146	Ferrari F430 Scuderia	1	\N
147	Fiat Grande Punto Abarth Esseesse (2009, 180 PS)	1	\N
148	Ford Fiesta ST (Mk7, B479, 2020, 1.5 T, 200 PS)	1	\N
149	Ford Fiesta ST Edition (Mk7, B479, 2022, 1.5 T, 200 PS)	1	\N
150	Ford Focus RS (Mk III, 2016, 2.5 T, 350 PS)	1	\N
151	Ford Focus RS (Mk2, C307, 2009, 305 PS)	1	\N
152	Ford Focus ST	1	\N
153	Ford Focus ST (Mk4, C519, 2021, 2.3 T, 280 PS)	1	\N
154	Ford GT (Mk1, 2006, 550 PS)	1	\N
155	Ford Mustang GT (Mk6, S550, facelift, 2020, N/A 5.0, 450 PS)	1	\N
156	Ford Mustang GT Performance Pack	1	\N
157	Ford Mustang Mach 1 (Mk6, 2021, N/A 5.0, 460 PS)	1	\N
158	Gumpert Apollo Sport	1	\N
159	Holden VF SS Redline Ute	1	\N
160	Honda Civic Type R (FK2)	1	\N
161	Honda Civic Type R (FK8, 2018, 2.0 T, 320 PS)	1	\N
162	Honda Civic Type R S grade (FL5 available in select European countries)	1	\N
163	Honda Civic Type-R 2.0i LS	1	\N
164	Honda NSX (1 gen, 1997, 280 PS)	1	\N
165	Honda NSX (NA1)	1	\N
166	Honda NSX (NC1, 2016)	1	\N
167	Honda NSX-R (NA1)	1	\N
168	Honda NSX-R (NA2)	1	\N
169	Honda NSX-R (NA2, 2002, facelift, 280 PS)	1	\N
170	Honda S2000	1	\N
171	Hyundai Genesis Coupe 3.8L	1	\N
172	Hyundai i20 N Performance (Mk3, BC3/BI3, 2021, 1.6 T, 204 PS)	1	\N
173	Hyundai i30 N Performance Package (PD, facelift, 2022, 2.0 T, 280 PS)	1	\N
174	Hyundai i30 N Performance Package (PD, pre-facelift, 2018, 2.0 T, 275 PS)	1	\N
175	Hyundai Ioniq 5 N	1	\N
176	Jaguar XE SV Project 8 (2018)	1	\N
177	Jaguar XKR	1	\N
178	Jaguar XKR Coupe (X100, 1998, 363 PS)	1	\N
179	Jaguar XKR-S	1	\N
180	Koenigsegg CCR	1	\N
181	Koenigsegg CCX	1	\N
182	KTM X-Bow (2010, 2.0 T, 240 PS)	1	\N
183	KTM X-Bow RR	1	\N
184	Lamborghini Aventador LP700-4	1	\N
185	Lamborghini Aventador SuperVeloce LP750-4 (2015)	1	\N
186	Lamborghini Aventador SVJ LP770-4 (2018)	1	\N
187	BMW i8 by AC Schnitzer	2	\N
188	BMW M3 CSL (E46) by Loaded	2	\N
189	BMW M5 (F90) by AC Schnitzer	2	\N
190	BMW X5 (E53) LM	2	\N
191	Chery Riich G5 2.0T	2	\N
192	Electric Raceabout	2	\N
193	Ferrari 599XX	2	\N
194	Jaguar S-Type Diesel	2	\N
195	Jaguar XJ220 Prototype	2	\N
196	Lynk & Co 03 Cyan Concept	2	\N
197	McLaren P1 XP1 LM Prototype	2	\N
198	Volkswagen ID.R	2	\N
199	Mini E racer, Electric	2	\N
200	Mygale M12-SJ-Ford Ecoboost	2	\N
201	NIO EP9	2	\N
202	Nissan GT-R Nismo	2	\N
203	Pagani Zonda R	2	\N
204	Porsche 911 GT2 (996) by Edo Competition	2	\N
205	Porsche 911 GT3 RS MR (991.1) by Manthey Racing	2	\N
206	Porsche 919 Hybrid EVO	2	\N
207	Subaru Impreza WRX STi Sedan (2011) Prototype	2	\N
208	Subaru WRX STI Type RA NBR Special	2	\N
209	Tesla Model S Plaid Track Package	2	\N
210	Toyota Supra	2	\N
211	Toyota TMG EV P002	2	\N
212	Lamborghini Diablo GT	1	\N
213	Lamborghini Diablo SuperVeloce	1	\N
214	Lamborghini Gallardo E-Gear (pre-facelift, 2003, 500 PS)	1	\N
215	Lamborghini Gallardo LP560-4 (2008, 560 PS)	1	\N
216	Lamborghini Gallardo LP570-4 Superleggera	1	\N
217	Lamborghini Gallardo SE (2006, 520 PS)	1	\N
218	Lamborghini Gallardo Spyder (2007, 520 PS)	1	\N
219	Lamborghini Gallardo Superleggera LP570-4	1	\N
220	Lamborghini Huracan LP610-4	1	\N
221	Lamborghini Huracan Performante LP640-4 (2017)	1	\N
222	Lamborghini Huracan Performante LP640-4 (2018, N/A 5.2, 640 PS)	1	\N
223	Lamborghini Murcielago	1	\N
224	Lamborghini Murcielago LP640	1	\N
225	Lamborghini Murcielago SuperVeloce LP670-4	1	\N
226	Lexus IS-F	1	\N
227	Lexus LFA	1	\N
228	Lexus LFA Nurburgring Package	1	\N
229	Lotus Esprit Sport 350	1	\N
230	Lotus Evora 400(2016, 3.5 S/C, 406 PS)	1	\N
231	Lotus Exige (Mk1, 2000, 179 PS)	1	\N
232	Lotus Exige (Mk2, N/A 1.8, 192 PS)	1	\N
233	Lotus Exige Cup 380 (2017)	1	\N
234	Lotus Exige S	1	\N
235	Maserati 3200 GT	1	\N
236	Maserati Coupe Cambiocorsa	1	\N
237	Maserati GranSport	1	\N
238	Maserati GranTurismo MC Stradale (M145, 2012, N/A 4.7, 450 PS)	1	\N
239	Maserati MC12	1	\N
240	Mazda MAZDASPEED3 (Mazda3 MPS)	1	\N
241	McLaren 600LT	1	\N
242	McLaren 650S Spider	1	\N
243	McLaren 720S	1	\N
244	McLaren MP4-12C	1	\N
245	Mercedes-AMG A45 S 4MATIC+ (W177)	1	\N
246	Mercedes-AMG C63 S Coupe (W205, facelift, 2019, 4.0 BT, 510 PS)	1	\N
247	Mercedes-AMG CLA45s 4MATIC+ (C118, 2022)	1	\N
248	Mercedes-AMG E63 S 4MATIC+ Estate (W213, 2017, 612 PS)	1	\N
249	Mercedes-AMG GT Black Series	1	\N
250	Mercedes-AMG GT63s 4MATIC+ (X290, 2018)	1	\N
251	Mercedes-AMG GT63s 4MATIC+ (X290, 2021)	1	\N
252	Mercedes-AMG GT63s E-Performance (X290, pre-facelift, 2022, 4.0 TT + 1E-motor, 843 PS)	1	\N
253	Mercedes-AMG GTR (2017)	1	\N
254	Mercedes-AMG GTR Pro	1	\N
255	Mercedes-AMG GTS (pre-facelift, 2016, 510 PS)	1	\N
256	Mercedes-AMG One	1	\N
257	Mercedes-Benz A45 AMG 4MATIC (W176, facelift)	1	\N
258	Mercedes-Benz A45 AMG 4MATIC (W176, pre-facelift)	1	\N
259	Mercedes-Benz AMG GTS (pre-facelift, 2015, 510 PS)	1	\N
260	Mercedes-Benz C32 AMG (W203)	1	\N
261	Mercedes-Benz C43 AMG (W202)	1	\N
262	Mercedes-Benz C55 AMG (W203)	1	\N
263	Mercedes-Benz C63 AMG (W204)	1	\N
264	Mercedes-Benz C63 AMG Coupe Black Series	1	\N
265	Mercedes-Benz C63 AMG Coupe Performance Package (W204)	1	\N
266	Mercedes-Benz CLK DTM AMG (W209, 2004, 582 PS)	1	\N
267	Mercedes-Benz CLK DTM AMG (W209, 2006, 582 PS)	1	\N
268	Mercedes-Benz CLK430 Coupe (W208)	1	\N
269	Mercedes-Benz CLK55 AMG (W208)	1	\N
270	Mercedes-Benz CLK63 AMG Black Series	1	\N
271	Mercedes-Benz CLK63 Black Series	1	\N
272	Mercedes-Benz CLS63 AMG (W218, facelift, 2013)	1	\N
273	Mercedes-Benz CLS63 AMG Performance Package (W218, pre-facelift, 2011)	1	\N
274	Mercedes-Benz E63 AMG (W212, pre-facelift, 2010, N/A 6.2, 525 PS)	1	\N
275	Mercedes-Benz E63 AMG S 4MATIC (W212R, second facelift, 2013, B/T 5.5, 585 PS)	1	\N
276	Mercedes-Benz G55 AMG (W463)	1	\N
277	Mercedes-Benz GLC63s AMG 4MATIC+ (X253)	1	\N
278	Mercedes-Benz SL500 (R230, pre-facelift, 2001, 306 PS)	1	\N
279	Mercedes-Benz SL55 AMG (R230, 2002, 476 PS)	1	\N
280	Mercedes-Benz SL55 AMG (R230, 2003, 500 PS)	1	\N
281	Mercedes-Benz SL55 AMG (R230, 2nd facelift, 2007, 517 PS)	1	\N
282	Mercedes-Benz SL65 AMG (R230, pre-facelift, 2005)	1	\N
283	Mercedes-Benz SL65 AMG Black Series	1	\N
284	Mercedes-Benz SLK230 Kompressor AMG (R170, 1997, 193 PS)	1	\N
285	Mercedes-Benz SLK32 AMG (R170)	1	\N
286	Mercedes-Benz SLK55 AMG (R171)	1	\N
287	Mercedes-Benz SLK55 AMG Black Series	1	\N
288	Mercedes-Benz SLR McLaren	1	\N
289	Mercedes-Benz SLS AMG	1	\N
290	Mercedes-Benz SLS AMG Black Series	1	\N
291	Mercedes-Benz SLS AMG Coupe Electric Drive (2013, 751 PS)	1	\N
292	Mini Cooper S JCW (F55/F56/F57, 2015, 2.0 T, 231 PS)	1	\N
293	Mini Cooper S JCW (R50/R53, S/C 1.6, 200 PS)	1	\N
294	Mini Cooper S JCW (R56/R57, 2009, 1.6 T, 211 PS)	1	\N
295	Mini Cooper S JCW GP (Mk3, F56, 2020, 2.0 T, 306 PS)	1	\N
296	Mini John Cooper Works Pro (F56, 2017, 2.0 T, 231 PS)	1	\N
297	Mitsubishi Carisma GT Evo VI (Mk6, 1999, 280 PS)	1	\N
298	Mitsubishi Carisma GT Evo VII (Mk7, 2002, 280 PS)	1	\N
299	Mitsubishi Lancer Evolution VIII MR GSR	1	\N
300	Morgan Aero 8 (Series 1, pre-facelift, 2003, 286 PS)	1	\N
301	Nissan 350Z	1	\N
302	Nissan GT-R	1	\N
303	Nissan GT-R (2009)	1	\N
304	Nissan GT-R (2011)	1	\N
305	Nissan GT-R (R35)	1	\N
306	Nissan Skyline GT-R R32	1	\N
307	Nissan Skyline GT-R R33	1	\N
308	Opel Astra OPC (J, P10, 2012, 2.0 T, 280 PS)	1	\N
309	Opel Corsa 1.6 Turbo OPC	1	\N
310	Opel Corsa B	1	\N
311	Opel Corsa OPC	1	\N
312	Opel Corsa OPC (E, X15, 2015, 1.6 T , 207 PS)	1	\N
313	Opel Speedster Turbo (2004, 200 PS)	1	\N
314	Pagani Zonda F	1	\N
315	Pagani Zonda F Clubsport	1	\N
316	Pagani Zonda F Clubsport (2005)	1	\N
317	Pagani Zonda S 7.3 (2002)	1	\N
318	Porsche 718 Cayman S (982)	1	\N
319	Porsche 911 Carrera (993)	1	\N
320	Porsche 911 Carrera (996.1, pre-facelift, 1998, 300 PS)	1	\N
321	Porsche 911 Carrera (996.2, facelift, 2001, 320 PS)	1	\N
322	Porsche 911 Carrera 4 (996.1, 2001, 300 PS)	1	\N
323	Porsche 911 Carrera GTS (991.2)	1	\N
324	Porsche 911 Carrera RS (964)	1	\N
325	Porsche 911 Carrera S (991.1, pre-facelift, 2011, N/A 3.8, 400 PS)	1	\N
326	Porsche 911 Carrera S (991.1, pre-facelift, 2012, N/A 3.8, 400 PS)	1	\N
327	Porsche 911 Carrera S (991.2)	1	\N
328	Porsche 911 Carrera S (992)	1	\N
329	Porsche 911 Carrera S (996)	1	\N
330	Porsche 911 Carrera S (997.1, 2005, N/A 3.8, 355 PS)	1	\N
331	Porsche 911 Carrera S (997.2, 2009)	1	\N
332	Porsche 911 Dakar (992, 2023, 3.0 TT, 480 PS)	1	\N
334	Porsche 911 GT2 RS MR (991.2) by Manthey Racing	2	\N
335	Porsche 911 GT2 (996.1, 2001, 462 PS)	1	\N
336	Porsche 911 GT2 (997, 2007)	1	\N
337	Porsche 911 GT2 (997.1, pre-facelift, 2007, 3.6 TT, 530 PS)	1	\N
338	Porsche 911 GT2 RS (991.2)	1	\N
339	Porsche 911 GT2 RS (991.2, 2018, 3.8 TT, 700 PS)	1	\N
340	Porsche 911 GT2 RS (997.2)	1	\N
341	Porsche 911 GT2 RS Manthey Performance Kit (991.2)	1	\N
342	Porsche 911 GT3 (991.1, pre-facelift, 2013, N/A 3.8, 475 PS)	1	\N
343	Porsche 911 GT3 (991.2)	1	\N
344	Porsche 911 GT3 (991.2, facelift, 2017, N/A 4.0, 500 PS)	1	\N
345	Porsche 911 GT3 (992.1, 2022)	1	\N
346	Porsche 911 GT3 (992.1, pre-facelift, 2021, N/A 4.0, 510 PS)	1	\N
347	Porsche 911 GT3 (996)	1	\N
348	Porsche 911 GT3 (996.1, pre-facelift, 1999, 360 PS)	1	\N
349	Porsche 911 GT3 (997.1)	1	\N
350	Porsche 911 GT3 (997.1, pre-facelift, N/A 3.6, 415 PS)	1	\N
351	Porsche 911 GT3 (997.2)	1	\N
352	Porsche 911 GT3 Manthey Performance Kit (992.1, 2023, N/A 4.0, 510 PS)	1	\N
353	Porsche 911 GT3 RS (991.1, pre-facelift, 2015, N/A 4.0, 500 PS)	1	\N
354	Porsche 911 GT3 RS (991.2)	1	\N
355	Porsche 911 GT3 RS (991.2, facelift, 2018, N/A 4.0, 520 PS)	1	\N
356	Porsche 911 GT3 RS (992.1)	1	\N
357	Porsche 911 GT3 RS (996)	1	\N
358	Porsche 911 GT3 RS (997.1)	1	\N
359	Porsche 911 GT3 RS (997.2, 2010)	1	\N
360	Porsche 911 GT3 RS 4.0 (997)	1	\N
361	Porsche 911 GT3 RS 4.0 (997.2, facelift, 2011, N/A 4.0, 500 PS)	1	\N
362	Porsche 911 Turbo (996, 2000, 3.6 TT, 420 PS)	1	\N
363	Porsche 911 Turbo (997.1, pre-facelift, 2007, 3.6 TT, 480 PS)	1	\N
364	Porsche 911 Turbo (997.2, facelift, 2011, 3.8 TT, 500 PS)	1	\N
365	Porsche 911 Turbo 3.3	1	\N
366	Porsche 911 Turbo Cabrio (997.1, pre-facelift, 2007, 480 PS)	1	\N
367	Porsche 911 Turbo S (991.1, pre-facelift, 2014, 3.8 TT, 560 PS)	1	\N
368	Porsche 911 Turbo S (991.2, facelift, 2018, 3.8 TT, 580 PS)	1	\N
369	Porsche 911 Turbo S (992.1, pre-facelift, 2021, 3.7 TT, 650 PS)	1	\N
370	Porsche 911 Turbo S (997.2, facelift, 2010, 3.8 TT, 530 PS)	1	\N
371	Porsche 911 Turbo S (997.2, facelift, 2011, 3.8 TT, 530 PS)	1	\N
372	Porsche 918 Spyder	1	\N
373	Porsche Boxster S (981.1, pre-facelift, 2012, N/A 3.4, 315 PS)	1	\N
374	Porsche Boxster S (986.1, pre-facelift, 1999, 252 PS)	1	\N
375	Porsche Boxster S (987.1, pre-facelift, 2006, 282 PS)	1	\N
376	Porsche Boxster S (987.2, facelift 2009)	1	\N
377	Porsche Boxter (986.1, pre-facelift, 1997, 2.5, 204 PS)	1	\N
378	Porsche Boxter (986.2, facelift, 2003, 2.7, 228 PS)	1	\N
379	Porsche Boxter Spyder (981, 2015, N/A 3.8, 375 PS)	1	\N
380	Porsche Carrera 4S PDK (997)	1	\N
381	Porsche Carrera GT (2006, 612 PS)	1	\N
382	Porsche Carrera GT (980)	1	\N
383	Porsche Cayenne Turbo GT (Mk3, PO536 / 9YA, pre-facelift, 2021, 4.0 TT, 640 PS)	1	\N
384	Porsche Cayenne Turbo S (Type 9PA (957), 2009, facelift, 4.8-l, 550 PS))	1	\N
385	Porsche Cayman GT4 (718, 2020, N/A 4.0, 420 PS)	1	\N
386	Porsche Cayman GT4 (981, 2015, N/A 3.8, 385 PS)	1	\N
387	Porsche Cayman GT4 RS (718, 2022, N/A 4.0, 500 PS)	1	\N
388	Porsche Cayman GT4 RS (982)	1	\N
389	Porsche Cayman GT4 RS Manthey Performance Kit (982)	1	\N
390	Porsche Cayman R (987.2)	1	\N
391	Porsche Cayman S (981.1, 2013, PDK, N/A 3.4, 325 PS)	1	\N
392	Porsche Cayman S (987.1, pre-facelift, 2006, 295 PS)	1	\N
393	Porsche Cayman S (987.2, facelift 2009)	1	\N
394	Porsche Panamera Turbo (2020)	1	\N
395	Porsche Panamera Turbo (970, pre-facelift, 2009, 4.8 TT, 500 PS)	1	\N
396	Porsche Panamera Turbo S (970, pre-facelift, 2012, 4.8 TT, 550 PS)	1	\N
397	Porsche Taycan Turbo	1	\N
398	Porsche Taycan Turbo S (2023)	1	\N
399	Radical SR8	1	\N
400	Radical SR8 LM	1	\N
401	Range Rover Sport Supercharged (2010)	1	\N
402	Renault Clio IV RS 1.6 16V Turbo EDC (Mk4, 2013)	1	\N
403	Renault Clio R.S. 220 Trophy (Mk4, 1-st facelift, 1.6 T, 220 PS)	1	\N
404	Renault Clio V6	1	\N
405	Renault Megane II Trophy "Sport Auto" Edition (Mk2, 2005, 225 PS)	1	\N
406	Renault Megane III RS (Mk III, 2011, 250 PS)	1	\N
407	Renault Megane III RS 275 Trophy-R	1	\N
408	Renault Megane IV RS Trophy-R	1	\N
409	Renault Megane IV RS Trophy-R (No. 25 of 500)	1	\N
410	Renault Megane IV RS (Mk IV, 2019, 280 PS)	1	\N
411	Renault Megane RenaultSport 265 Trophy	1	\N
412	Renault Megane RS R26.R	1	\N
413	Rimac Nevera	1	\N
414	Ruf Rt 12	1	\N
415	Seat Leon Cupra (Mk3, 5F, 2015, 2.0 T, 280 PS)	1	\N
416	SEAT Leon Cupra R Mk1	1	\N
417	SEAT Leon Mk3 Cupra	1	\N
418	Subaru BRZ Final Edition (Mk1, ZN6/ZC6, 2020, N/A 2.0, 200 PS)	1	\N
419	Subaru Impreza GT Turbo (GC8G (Mk1,) 2000, 218 PS))	1	\N
420	Subaru Impreza WRX STi (GD, 2004, 265 PS)	1	\N
421	Subaru WRX STi (Mk4, VA, facelift, 2015, 2.5 T, 300 PS)	1	\N
422	Subaru WRX STi Spec-C	1	\N
423	Tesla Model S Plaid	1	\N
424	Toyota GR Supra (A90/J29)	1	\N
425	Toyota GR Yaris (Mk4, XP210, 2021, 1.5 T, 261 PS)	1	\N
426	Toyota GR86 (2023)	1	\N
427	Toyota GT86 (Mk1, ZN6/ZC6, 2012, N/A 2.0, 200 PS)	1	\N
428	Toyota Yaris GRMN (Mk3, XP13, 2019, S/C 1.8, 212 PS)	1	\N
429	Volkswagen Golf GTI Clubsport S	1	\N
430	Volkswagen Golf IV GTI "25 Jähre GTI" (Mk4, 2002, 1.8T, 180 PS)	1	\N
431	Volkswagen Golf IV R32 (Mk4, 2003)	1	\N
432	Volkswagen Golf IV V6 4motion (Mk4, 2.8, 204 PS)	1	\N
433	Volkswagen Golf V GTI DSG (Mk5, 2005, 200 PS)	1	\N
434	Volkswagen Golf V R32 (Mk5, 2006)	1	\N
435	Volkswagen Golf VI GTI "35 Jähre GTI" (Mk6, 2011, 2.0 T, 235 PS)	1	\N
436	Volkswagen Golf VI R (Mk6, 2010)	1	\N
437	Volkswagen Golf VII GTI Clubsport (Mk7, 2016, 2.0 T, 265 PS)	1	\N
438	Volkswagen Golf VII GTI Clubsport S (Mk7, 2016, 2.0 T, 310 PS)	1	\N
439	Volkswagen Golf VII GTI Performance (Mk7, pre-facelift, 2013, 2.0 T, 230 PS)	1	\N
440	Volkswagen Golf VII R (Mk7, 1st faselift, 2018, 310 PS)	1	\N
441	Volkswagen Golf VII R (Mk7, pre-facelift, 2.0 T, 300 PS)	1	\N
442	Volkswagen Golf VIII GTI Clubsport "45 Jähre GTI" (Mk8, 2021, 2.0 T, 300 PS)	1	\N
443	Volkswagen Golf VIII R "20 Years" (Mk8, 333 PS, 2023)	1	\N
444	Volkswagen Golf VIII R (Mk8, 2020, 320 PS)	1	\N
445	Volkswagen Golf VIII R (Mk8, 2022, 320 PS)	1	\N
446	Volkswagen Golf VIII R 333 "20 Years" (Mk8, 333 PS, 2022)	1	\N
447	Volkswagen Lupo GTI	1	\N
448	Volkswagen Polo GTI (Mk4)	1	\N
449	Volkswagen Scirocco 2.0 TSI	1	\N
450	VW Golf VII GTI TCR (Mk7, 2-nd facelift, 2019, 2.0 T 290 PS)	1	\N
451	Wiesmann GT MF5	1	\N
\.


--
-- Data for Name: drivers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drivers (driver_id, driver_firstname, driver_lastname, driver_login) FROM stdin;
1	Aaron	Link	\N
2	Adam	Dean	\N
3	Akira	Iida	\N
4	Andreas	Simonsen	\N
5	Benjamin	Leuchter	\N
6	Benny	Leuchter	\N
7	Bernd	Schneider	\N
8	Bernt Bråten	Andersen	\N
9	Bill	Wise	\N
10	Christian	Gebhardt	\N
11	Christopher	Haase	\N
12	Daniel	Schwerfeld	\N
13	Demian	Schaffert	\N
14	Dierk	Möller-Sonntag	\N
15	Dirk	Schoysman	\N
16	Dmitry	Sokolov	\N
17	Dominik	Farnbacher	\N
18	Drew	Cattell	\N
19	Fabio	Francia	\N
20	Florian	Gruber	\N
21	Frank	Stippler	\N
22	Fredrik	Sørlie	\N
23	Gerd	Stegmaier	\N
24	Giorgio	Sanna	\N
25	Hans-Joachim	Stuck	\N
26	Herbert	Schürg	\N
27	Horst	von Saurma	\N
28	Jim	Mero	\N
29	Jochen	Krumbach	\N
30	John	Heinricy	\N
31	John	Nielsen	\N
32	Jordi	Gene	\N
33	Jörg	Bergmeister	\N
34	Jörg	Müller	\N
35	Jörg	Weidinger	\N
36	Kenny	Bräck	\N
37	Kevin	Estre	\N
38	Klaus	Ludwig	\N
39	Lance David	Arnold	\N
40	Lars	Kern	\N
41	Laurent	Hurgon	\N
42	Loris	Bicocchi	\N
43	Manuel	Reuter	\N
44	Marc	Basseng	\N
45	Marc	Lieb	\N
46	Marco	Mapelli	\N
47	Marcus	Schurig	\N
48	Mark	Ticehurst	\N
49	Markus	Hofbauer	\N
50	Markus	Oestreich	\N
51	Maro	Engel	\N
52	Martin	Kodrić	\N
53	Michael	Düchting	\N
54	Michael	Krumm	\N
55	Michael	Vergers	\N
56	Motoharu	Kurosawa	\N
57	Nestor	Girolami	\N
58	Nick	Tandy	\N
59	Øistein	Helland	\N
60	Oliver	Gavin	\N
61	Patrick	Bernhard	\N
62	Patrick	Simon	\N
63	Paul	Wijgaertz	\N
64	Peter	Dumbreck	\N
65	Prinz Leopold	von Bayern	\N
66	Raffaele	de Simone	\N
67	Ralf	Kelleners	\N
68	Richard	Göransson	\N
69	Richie	Stanaway	\N
70	Rob	Trubiani	\N
71	Robert	Nearn	\N
72	Romain	Dumas	\N
73	Sabine	Schmitz	\N
74	Sascha	Bert	\N
75	Steven	Stephan	\N
76	Thed	Björk	\N
77	Thomas	Jäger	\N
78	Timo	Bernhard	\N
79	Timo	Glock	\N
80	Tom	Coronel	\N
81	Tom	Kristensen	\N
82	Tom	Schwister	\N
83	Tommi	Mäkinenn	\N
84	Toshio	Suzuki	\N
85	Vincent	Bayle	\N
86	Vincent	Radermecker	\N
87	Walter	Röhrl	\N
88	Wolfgang	Kaufmann	\N
89	Test_1	Driver_1	postgres
90	Jeremy	Clarkson	stig
\.


--
-- Data for Name: lap_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lap_session (session_id, track_conf_id, lap_time, car_id, driver_id, date, session_note) FROM stdin;
1	1	00:09:12	194	73	2004-11-21	Jeremy Clarkson was set a challenge to get a Jaguar S-Type 2.7 Diesel round the ring in under 10 minutes, and after getting shown around and getting advice from Sabine Schmitz, and quite a few attempts, he managed a 9:59. Sabine completed the lap in the same car as Clarkson on her first try in 9:12
2	3	00:05:19.546	206	78	2018-06-29	Modified LMP1-h (Le Mans prototype). 720 PS (530 kW; 710 hp) + 440 PS (324 kW; 434 hp) / 849 kg (1,872 lb) dry
4	3	00:06:45.9	201	64	2017-05-12	1,360 PS (1,000 kW; 1,341 hp) / 1,735 kg (3,825 lb)
5	3	00:06:47.5	203	44	2010-06-29	750 PS (552 kW; 740 hp) / 1,070 kg (2,360 lb) Dry
7	3	00:07:05.12	201	64	2016-10-14	1,360 PS (1,000 kW; 1,341 hp) / 1,735 kg (3,825 lb)
8	3	00:07:20.143	196	76	2019-08-23	528 hp (394 kW) / 1,287 kg (2,837 lb)
9	3	00:07:22	200	58	2012-09-04	205 PS (151 kW; 202 hp) / 465 kg (1,025 lb)
10	3	00:07:22.329	211	29	2012-10-02	Toyota Motorsport GmbH conducted test. 469 hp (350 kW)
11	3	00:07:49	210	26	1997-01-01	606 bhp (452 kW; 614 PS)
12	3	00:07:50	190	25	2000-01-01	Evo (08/2005). BMW M70 S70B56 engine from a V12 LMR. 700 bhp (522 kW; 710 PS), 531 lb/ft (720 N/m)
13	3	00:07:55	207	83	2010-04-16	Subaru conducted test. MY2011 prototype with non-production upgrades and modifications. (Subaru EJ207 engine from a 2010 JDM Subaru Impreza WRX STi R205 with larger turbo. 320 bhp (239 kW; 324 PS)
14	3	00:08:42.72	192	67	2011-09-10	300 kW (402 hp) / 1,720 kg (3,790 lb) Dry
15	3	00:09:52	199	77	2010-04-01	This was the first time under ten minutes recorded by an electric car.
16	3	00:07:05.298	413	52	2023-08-18	Official Nurburgring record attempt by Rimac. Michelin Cup 2 R. Independent timing and series-production state verified by T/V S/D. 7:00.928 on the 20,600 m lap.
17	3	00:07:23.164	176	86	2019-07-01	Jaguar conducted test, Michelin Pilot Sport Cup 2 R tyres, two-seat Track Package.
18	3	00:07:29.81	394	40	2020-07-24	Porsche Conducted Test. Michelin Pilot Sport Cup 2
19	3	00:07:33.35	398	40	2022-04-11	Porsche conducted test. Equipped with Tequipment performance kit and PDCC. Pirelli P Zero Corsa tyres. Added roll cage and racing seats.
20	3	00:07:35.06	75	35	2022-05-12	Record for the fastest lap for a wagon.Official Nurburgring record attempt by BMW.
21	3	00:07:38.85	227	74	2010-11-01	Auto Bild Sportscars (11/2010), supercomparo (LFA vs 458 vs SLS AMG vs GT-R vs LP570-4 vs Weismann GT) test conducted on the long 20.8 km configuration of Nurburgring
22	3	00:07:42.253	24	21	2019-09-13	Audi conducted test, SUV lap time record (before Porsche Cayenne GT record), Pirelli P Zero.
23	3	00:07:47.31	446	5	2022-09-21	Volkswagen conducted test, the fastest Golf R of all times, R-Performance Package, R-Performance Torque Vectoring. Bridgestone tyres. Video confirmed
24	3	00:08:01.84	218	88	2007-05-01	6-speed E-Gear automatic.
25	3	00:08:16.52	91	88	2007-05-01	7-speed SMG-III automatic.
26	3	00:08:40.3	46	81	2006-03-01	6-speed Tiptronic automatic.
27	1	00:08:43.3	416	59	2010-08-07	\N
28	1	00:09:09	447	12	2002-09-29	\N
29	1	00:09:12	310	75	2020-06-24	\N
30	3	00:07:25.231	209	82	2023-06-02	\N
31	3	00:08:56.81	191	15	2009-10-13	\N
32	3	00:11:25.5	276	88	2007-06-29	\N
33	3	00:07:32.92	134	74	2010-10-01	\N
34	3	00:07:35.579	423	4	2021-09-09	\N
35	3	00:07:39.49	381	87	2006-03-01	\N
36	3	00:07:40.76	219	74	2010-11-01	\N
37	3	00:07:40.89	21	74	2011-09-01	\N
38	3	00:07:41.23	370	74	2010-11-01	\N
39	3	00:07:41.5	117	74	2009-08-01	\N
40	3	00:07:43.65	302	74	2010-11-01	\N
41	3	00:07:44.42	289	74	2010-11-01	\N
42	3	00:07:52.39	451	74	2010-10-01	\N
43	3	00:07:56.5	267	38	2006-03-01	\N
44	3	00:07:56.65	217	81	2006-03-01	\N
45	3	00:08:07.76	93	65	2006-03-01	\N
46	3	00:08:11.1	218	14	2007-01-01	\N
47	3	00:08:12.8	366	14	2007-01-01	\N
48	3	00:08:34.6	91	14	2007-01-01	\N
49	3	00:08:36.1	281	14	2007-01-01	\N
50	3	00:09:46.2	448	88	2007-06-29	\N
51	2	00:07:46	195	31	1991-01-01	\N
52	2	00:06:48.28	400	55	2009-08-19	\N
53	2	00:06:52.54	249	10	2021-07-07	\N
54	2	00:06:54.99	356	10	2022-10-19	\N
55	2	00:06:55	399	55	2005-09-28	\N
56	2	00:06:58.28	339	10	2018-04-17	\N
57	2	00:06:58.7	130	10	2023-06-07	\N
58	2	00:06:59.42	352	10	2023-02-08	\N
59	2	00:07:34	21	27	2010-12-01	\N
60	2	00:07:34	180	27	2005-10-17	\N
61	2	00:07:34	228	27	2012-02-01	\N
62	2	00:07:34	304	27	2010-10-01	\N
63	2	00:07:34	367	27	2014-02-01	\N
64	2	00:07:34.39	70	10	2023-10-19	\N
65	2	00:07:34.92	360	74	2011-09-01	\N
66	2	00:07:35	242	27	2015-01-01	\N
67	2	00:07:35	259	27	2015-01-02	\N
68	2	00:07:35	290	27	2013-01-01	\N
69	2	00:07:35	414	27	2008-01-01	\N
70	2	00:07:04.74	346	10	2021-05-05	\N
71	2	00:07:05.41	355	10	2018-04-18	\N
72	2	00:07:06.6	254	10	2019-05-22	\N
73	2	00:07:07.99	222	10	2018-11-09	\N
74	2	00:07:08.34	243	10	2018-06-28	\N
75	2	00:07:08.82	241	10	2019-06-06	\N
76	2	00:07:10.92	253	10	2016-11-04	\N
77	2	00:07:11.57	158	20	2009-08-13	\N
78	2	00:07:14.89	129	53	2006-01-01	\N
79	2	00:07:15	185	27	2015-02-01	\N
80	2	00:08:42	231	27	2000-01-01	\N
81	2	00:08:43	171	16	2011-07-01	\N
82	2	00:08:43.6	418	10	2020-11-19	\N
83	2	00:08:45	427	27	2013-01-01	\N
84	2	00:08:47	163	27	2001-01-01	\N
85	2	00:08:47	449	8	2009-11-15	\N
86	2	00:08:47.99	311	43	2007-01-01	\N
87	2	00:08:49	178	27	1998-01-01	\N
88	2	00:08:49	404	27	2001-01-01	\N
89	2	00:08:49	434	27	2006-01-01	\N
90	2	00:08:50	49	27	1998-01-01	\N
91	2	00:08:50	67	27	2010-01-01	\N
92	2	00:08:51	1	27	2002-01-01	\N
93	2	00:08:51	261	27	1998-01-01	\N
94	2	00:08:52	268	27	1998-01-01	\N
95	2	00:08:53	433	27	2005-01-01	\N
96	2	00:08:54	309	27	2008-01-01	\N
97	2	00:08:54	377	27	1997-01-01	\N
98	2	00:08:54	430	27	2002-01-01	\N
99	2	00:08:55	293	27	2004-01-01	\N
100	2	00:08:55	401	63	2009-01-01	\N
101	2	00:08:59	402	27	2013-01-01	\N
102	2	00:09:02	111	30	2007-10-01	\N
103	2	00:09:07	284	27	1997-01-01	\N
104	2	00:09:09	147	27	2009-01-01	\N
105	2	00:09:09	432	27	2000-01-01	\N
106	2	00:07:44	317	27	2002-01-01	\N
107	2	00:07:44	325	27	2011-01-01	\N
108	2	00:07:44	371	27	2011-01-02	\N
109	2	00:07:44.13	246	10	2019-01-01	\N
110	2	00:07:45	22	27	2013-01-01	\N
111	2	00:07:45	270	7	2007-05-01	\N
112	2	00:07:45.19	248	10	2017-09-22	\N
113	2	00:07:45.34	247	10	2022-02-02	\N
114	2	00:07:45.59	175	10	2024-01-18	\N
115	2	00:07:46	216	27	2007-01-01	\N
116	2	00:07:46	264	27	2011-01-01	\N
117	2	00:07:46	335	27	2001-01-01	\N
118	2	00:07:46.7	318	10	2016-09-01	\N
119	2	00:07:47	139	27	2007-01-01	\N
120	2	00:07:47	224	27	2007-01-02	\N
121	2	00:07:47	357	27	2004-01-01	\N
122	2	00:07:47	364	27	2011-01-01	\N
123	2	00:07:47	451	27	2010-07-01	\N
124	2	00:07:48	74	27	2010-01-01	\N
125	2	00:07:48	349	27	2006-01-01	\N
126	2	00:07:48	358	27	2007-01-01	\N
127	2	00:07:48.13	233	10	2017-07-27	\N
128	2	00:07:48.4	42	10	2017-05-17	\N
129	2	00:07:48.8	245	10	2019-10-24	\N
130	2	00:07:49	54	27	2012-01-01	\N
131	2	00:07:49	120	27	2007-06-22	\N
132	2	00:07:16.15	387	10	2022-05-09	\N
133	2	00:07:17.08	80	10	2022-10-12	\N
134	2	00:07:17.11	368	10	2017-08-24	\N
135	2	00:07:17.3	369	10	2021-01-30	\N
136	2	00:08:35	292	10	2015-01-01	\N
137	2	00:08:35	294	27	2009-01-01	\N
138	2	00:08:36	50	27	1999-01-01	\N
139	2	00:08:36	378	27	2003-01-01	\N
140	2	00:08:37	235	27	2000-01-01	\N
141	2	00:08:37	260	27	2001-01-01	\N
142	2	00:08:37	419	27	2000-01-01	\N
143	2	00:08:37	431	27	2003-01-01	\N
144	2	00:08:38	164	27	1997-01-01	\N
145	2	00:08:38	278	27	2001-01-02	\N
146	2	00:08:38	405	27	2005-01-01	\N
147	2	00:08:38	435	27	2011-01-01	\N
148	2	00:08:39	170	27	2000-01-01	\N
149	2	00:08:39	240	48	2007-01-01	\N
150	2	00:08:39	300	27	2003-03-01	\N
151	2	00:08:40	41	27	2007-01-01	\N
152	2	00:08:40	114	27	1997-01-01	\N
153	2	00:08:40	312	10	2015-01-01	\N
154	2	00:08:41	10	27	1999-01-01	\N
155	2	00:08:41	35	27	2014-01-01	\N
156	2	00:08:41	36	27	1999-01-01	\N
157	2	00:08:42	37	27	1998-01-01	\N
158	2	00:07:42.39	386	10	2015-04-01	\N
159	2	00:07:42.659	7	10	2022-10-01	\N
160	2	00:07:42.99	64	10	2020-08-12	\N
161	2	00:07:43	357	87	2004-10-01	\N
162	2	00:07:43.92	15	10	2019-08-14	\N
163	2	00:07:44	20	27	2009-01-01	\N
164	2	00:08:18	102	27	2000-01-01	\N
165	2	00:08:18	115	27	2003-01-01	\N
166	2	00:08:18	144	27	1997-01-01	\N
167	2	00:08:18	155	10	2020-01-01	\N
168	2	00:08:18	226	27	2009-01-01	\N
169	2	00:08:18	237	27	2005-01-01	\N
170	2	00:08:18	376	27	2009-01-01	\N
171	2	00:08:19.47	159	70	2013-04-01	\N
172	2	00:08:20	27	27	2011-01-01	\N
173	2	00:08:20	33	27	2002-01-01	\N
174	2	00:08:20	174	10	2018-01-01	\N
175	2	00:08:20	308	27	2012-01-01	\N
176	2	00:08:22	68	27	2000-01-01	\N
177	2	00:08:22	97	27	1998-01-01	\N
178	2	00:08:22	262	27	2004-01-01	\N
179	2	00:08:22.33	149	10	2022-01-01	\N
180	2	00:08:22.38	306	56	1989-01-01	\N
181	2	00:08:22.7	153	10	2021-01-01	\N
182	2	00:08:23	9	27	2003-01-01	\N
183	2	00:08:23	322	27	2001-01-01	\N
184	2	00:07:13	372	27	2014-06-01	\N
185	2	00:07:00.03	136	10	2019-05-16	\N
186	2	00:07:32	23	10	2015-01-01	\N
187	2	00:07:32	342	27	2013-11-01	\N
188	2	00:07:32	385	10	2020-01-01	\N
189	2	00:07:32.4	382	27	2003-01-01	\N
190	2	00:07:32.79	94	10	2020-06-09	\N
191	2	00:07:33	143	27	2014-09-01	\N
192	2	00:07:33	314	27	2006-01-01	\N
193	2	00:07:33	337	27	2007-01-01	\N
194	2	00:07:33	359	27	2010-01-01	\N
195	2	00:07:33.55	181	44	2008-08-01	\N
196	2	00:07:33.67	327	10	2016-05-01	\N
197	2	00:08:25	234	27	2008-01-01	\N
198	2	00:08:25	297	27	1999-01-02	\N
199	2	00:08:25	298	27	2002-01-01	\N
200	2	00:08:25	392	27	2006-01-02	\N
201	2	00:08:26	39	27	2008-01-01	\N
202	2	00:08:26	48	27	2006-01-01	\N
203	2	00:08:26	151	27	2009-01-01	\N
204	2	00:08:26	285	27	2001-01-01	\N
205	2	00:08:26	301	27	2003-01-01	\N
206	2	00:08:27.27	426	10	2019-01-01	\N
207	2	00:08:28	84	27	1999-01-01	\N
208	2	00:08:28	148	10	2020-01-01	\N
209	2	00:08:28	296	10	2017-01-01	\N
210	2	00:08:28	319	27	1997-01-01	\N
211	2	00:08:28	421	10	2015-01-01	\N
212	2	00:08:29	38	27	2003-01-01	\N
213	2	00:08:29	45	27	2008-01-01	\N
214	2	00:08:29	269	27	2000-01-01	\N
215	2	00:08:29	406	27	2011-01-01	\N
216	2	00:08:29	439	27	2013-01-01	\N
217	2	00:08:30	236	27	2002-01-01	\N
218	2	00:08:32	98	27	1997-01-01	\N
219	2	00:08:32	99	27	2006-01-01	\N
220	2	00:08:32	101	27	2003-01-01	\N
221	2	00:08:32	149	10	2022-01-01	\N
222	2	00:08:32	232	27	2004-01-01	\N
223	2	00:08:32	374	27	1999-01-01	\N
224	2	00:08:33.6	172	10	2021-09-01	\N
225	2	00:08:33.99	384	62	2009-10-02	\N
226	2	00:08:34	96	27	2001-01-01	\N
227	2	00:08:34	313	27	2004-01-01	\N
228	2	00:08:34	436	27	2010-01-01	\N
229	2	00:08:23	403	10	2016-01-01	\N
230	2	00:08:23.12	324	10	2019-01-01	\N
231	2	00:08:24	95	27	2009-01-01	\N
232	2	00:08:24	286	27	2005-01-01	\N
233	2	00:08:24	420	27	2004-01-01	\N
234	2	00:08:25	29	27	2000-01-01	\N
235	2	00:08:25	105	27	1999-01-01	\N
236	2	00:08:17	13	27	2003-01-01	\N
237	2	00:08:17	320	27	1998-01-01	\N
238	2	00:08:17	321	27	2001-01-01	\N
239	2	00:08:17	393	27	2009-01-01	\N
240	2	00:08:15	47	27	2011-01-01	\N
241	2	00:08:15	57	27	2005-01-01	\N
242	2	00:08:15	112	27	2005-01-02	\N
243	2	00:08:15	160	10	2016-01-01	\N
244	2	00:08:15.1	441	27	2014-01-01	\N
245	2	00:08:16	11	27	2004-01-01	\N
246	2	00:08:16	44	10	2015-01-01	\N
247	2	00:08:16	65	10	2015-01-01	\N
248	2	00:08:16.15	165	56	1990-01-01	\N
249	2	00:08:12	410	10	2019-01-01	\N
250	2	00:08:13	85	27	2004-01-01	\N
251	2	00:08:13	127	27	2007-01-01	\N
252	2	00:08:13	229	27	1999-01-01	\N
253	2	00:08:13	263	27	2008-01-01	\N
254	2	00:08:14	8	27	2010-01-01	\N
255	2	00:08:14	52	27	2014-01-01	\N
256	2	00:08:14	53	27	2008-01-01	\N
257	2	00:08:14	238	27	2012-01-01	\N
258	2	00:08:14	282	27	2005-01-01	\N
259	2	00:08:14	287	27	2007-01-01	\N
260	2	00:08:14	415	27	2015-01-01	\N
261	2	00:08:14.93	425	10	2021-04-07	\N
262	2	00:08:10	274	27	2010-01-01	\N
263	2	00:08:10	390	27	2011-01-01	\N
264	2	00:08:08.73	365	56	1991-01-01	\N
265	2	00:08:09	28	27	2006-01-01	\N
266	2	00:08:09	43	27	2010-01-01	\N
267	2	00:08:09	92	27	2005-01-01	\N
268	2	00:08:09	132	27	1999-01-01	\N
269	2	00:08:09	169	27	2002-01-01	\N
270	2	00:08:09	213	27	1997-01-01	\N
271	2	00:08:10	56	27	2008-01-01	\N
272	2	00:08:10	122	27	1997-01-01	\N
273	2	00:08:10	128	27	2001-01-01	\N
274	2	00:08:10	182	27	2010-01-01	\N
275	2	00:08:07	137	27	1998-01-01	\N
276	2	00:08:07	156	27	2015-01-01	\N
277	2	00:08:07	437	10	2016-01-01	\N
278	2	00:08:04.52	380	74	2008-10-27	\N
279	2	00:08:04.92	450	10	2019-07-03	\N
280	2	00:08:05	34	27	2014-01-01	\N
281	2	00:08:05	69	27	2007-12-01	\N
282	2	00:08:05	86	27	2012-01-01	\N
283	2	00:08:05	138	27	2002-01-01	\N
284	2	00:08:05	271	27	2007-01-01	\N
285	2	00:08:05	330	27	2005-01-01	\N
286	2	00:08:05	391	27	2013-01-01	\N
287	2	00:08:05.19	173	10	2021-12-08	\N
288	2	00:08:06	280	27	2003-01-01	\N
289	2	00:08:06.01	422	56	2004-01-01	\N
290	2	00:08:06.29	150	10	2017-01-01	\N
291	2	00:08:44.66	428	10	2019-04-09	\N
292	2	00:08:00	55	10	2017-01-01	\N
293	2	00:08:01	61	10	2016-01-01	\N
294	2	00:08:01	161	10	2018-01-01	\N
295	2	00:08:01	265	27	2013-03-01	\N
296	2	00:08:01.72	307	56	1995-01-01	\N
297	2	00:08:01.9	19	74	2008-10-27	\N
298	2	00:08:02	12	27	2009-01-01	\N
299	2	00:08:02	445	10	2022-01-01	\N
300	2	00:08:02.66	442	10	2021-10-06	\N
301	2	00:08:03	16	27	2005-01-01	\N
302	2	00:08:03	179	27	2012-01-01	\N
303	2	00:08:03	273	27	2011-05-10	\N
304	2	00:08:03	348	27	1999-01-01	\N
305	2	00:08:03.33	5	10	2019-05-15	\N
306	2	00:08:03.86	167	56	1992-01-01	\N
307	2	00:08:03.86	295	10	2020-07-14	\N
308	2	00:08:04	18	27	2007-01-01	\N
309	2	00:08:04	212	27	2000-01-01	\N
310	2	00:08:04	257	10	2016-02-01	\N
311	2	00:08:04	373	27	2012-01-01	\N
312	2	00:08:04	440	27	2018-06-27	\N
313	2	00:07:58.52	30	10	2018-07-12	\N
314	2	00:07:58.59	66	10	2022-01-01	\N
315	2	00:07:58.99	123	10	2023-01-01	\N
316	2	00:07:59	32	27	2012-06-01	\N
317	2	00:07:59	230	10	2016-01-01	\N
318	2	00:07:59	272	27	2013-07-01	\N
319	2	00:07:59	329	87	2004-01-01	\N
320	2	00:07:55	106	71	2000-01-01	\N
321	2	00:07:55	145	27	2005-01-01	\N
322	2	00:07:55	275	27	2013-09-01	\N
323	2	00:07:55.12	409	10	2019-01-01	\N
324	2	00:07:55.409	100	10	2018-09-12	\N
325	2	00:07:56	131	27	2004-01-01	\N
326	2	00:07:56	141	27	2010-01-01	\N
327	2	00:07:56	362	27	2000-01-01	\N
328	2	00:07:56	395	87	2009-01-01	\N
329	2	00:07:56.1	6	10	2020-01-01	\N
330	2	00:07:56.73	168	56	2002-01-01	\N
331	2	00:07:57	438	10	2016-01-01	\N
332	2	00:07:58	60	35	2015-12-01	\N
333	2	00:07:58.29	157	10	2021-11-03	\N
334	2	00:07:13.9	121	10	2017-04-24	\N
335	2	00:07:18	344	10	2017-04-28	\N
336	2	00:07:18.1	129	53	2004-10-24	\N
337	2	00:07:21	135	27	2016-08-01	\N
338	2	00:07:21.63	135	10	2016-11-01	\N
339	2	00:07:52	14	27	2014-01-01	\N
340	2	00:07:52	76	27	2014-01-01	\N
341	2	00:07:52	154	27	2006-01-01	\N
342	2	00:07:52	214	27	2003-01-01	\N
343	2	00:07:52	215	27	2008-01-01	\N
344	2	00:07:52	288	38	2004-01-01	\N
345	2	00:07:52	379	10	2015-01-01	\N
346	2	00:07:52	396	27	2012-01-01	\N
347	2	00:07:52.11	58	10	2023-01-12	\N
348	2	00:07:52.17	424	10	2019-08-22	\N
349	2	00:07:52.36	63	10	2018-09-12	\N
350	2	00:07:53.26	51	10	2020-12-17	\N
351	2	00:07:53.69	443	10	2023-01-01	\N
352	2	00:07:54	88	27	2014-01-01	\N
353	2	00:07:54	266	47	2005-02-01	\N
354	2	00:07:54	347	27	2003-01-01	\N
355	2	00:07:54	363	27	2007-01-01	\N
356	2	00:07:51	283	27	2009-01-01	\N
357	2	00:07:51	444	23	2020-01-01	\N
358	2	00:07:50	17	10	2017-02-01	\N
359	2	00:07:50	73	27	2003-01-01	\N
360	2	00:07:50	223	27	2002-01-01	\N
361	2	00:07:50	331	27	2008-01-01	\N
362	2	00:07:42	79	10	2017-01-01	\N
363	2	00:07:42	225	27	2010-01-01	\N
364	2	00:07:42	350	87	2006-01-01	\N
365	2	00:07:40	288	38	2004-01-01	\N
366	2	00:07:40	289	27	2010-01-01	\N
367	2	00:07:40	351	27	2009-01-01	\N
368	2	00:07:38	117	27	2009-10-01	\N
369	2	00:07:38	133	27	2010-01-01	\N
370	2	00:07:38	219	27	2011-01-01	\N
371	2	00:07:38	227	27	2010-09-01	\N
372	2	00:07:38	302	27	2009-01-01	\N
373	2	00:07:38.92	87	10	2018-04-12	\N
374	2	00:07:39	146	27	2008-01-01	\N
375	2	00:07:39.35	31	10	2023-07-12	\N
376	2	00:07:39.4	332	10	2023-08-14	\N
377	2	00:07:37.66	26	10	2022-01-01	\N
378	2	00:07:23.77	323	10	2017-05-01	\N
379	2	00:07:24	158	27	2010-11-01	\N
380	2	00:07:24	340	27	2010-01-01	\N
381	2	00:07:24.29	239	44	2008-08-01	\N
382	2	00:07:24.44	315	44	2008-08-01	\N
383	2	00:07:25	184	27	2012-01-01	\N
384	2	00:07:25.21	142	44	2008-08-01	\N
385	2	00:07:27.48	140	10	2018-06-20	\N
386	2	00:07:28	220	10	2016-07-01	\N
387	2	00:07:28	244	27	2011-01-01	\N
388	2	00:07:30	361	27	2011-01-01	\N
389	2	00:07:30.41	328	10	2019-01-01	\N
390	2	00:07:30.79	77	10	2021-04-15	\N
391	2	00:07:28	382	87	2004-07-02	\N
392	2	00:07:28.71	382	44	2008-08-01	\N
393	2	00:07:29.57	90	10	2021-06-02	\N
394	2	00:07:35.9	89	10	2019-04-17	\N
395	2	00:07:36	166	10	2017-03-01	\N
396	2	00:07:36	255	10	2016-01-01	\N
397	2	00:07:36	305	27	2011-01-01	\N
398	2	00:07:37	83	10	2016-10-01	\N
399	2	00:06:40.33	334	40	2018-10-25	OEM deletion of audio and communication system, KW Competition 3-way race suspension, larger wing and dive planes, Porsche Motorsport bucket seat and harness on drivers side. Porsche conducted test. 6:44.749 on the 20,832 m lap. 700 PS (515 kW; 690 hp) / 1,470 kg (3,240 lb)
400	2	00:06:43.22	197	36	2017-04-27	1,000 PS (735 kW; 986 hp)
401	2	00:06:57.578	208	69	2017-07-21	Custom-built race car by Prodrive. 600 bhp (447 kW; 608 PS)
402	2	00:07:08.679	202	54	2013-09-30	Nissan conducted test. 255/40RF-20 run-flat Dunlop SP Sport Maxx GT 600 DSST. Pre-production Nismo "N Attack Package" (including removal of rear seats, alterations of front seats, engine, powertrain, suspension, brakes, aerodynamic parts). six-point harness and carbon fibre bonnet gurney making the car not road legal. 600 PS (441 kW; 592 hp)
403	2	00:07:09.59	205	10	2017-01-01	500 PS (368 kW; 493 hp) / 1,420 kg (3,130 lb)
404	2	00:07:15.63	204	62	2005-08-04	Vehicle was tuned to produce 670 bhp and 880Nm Torque.
405	2	00:07:22.8	188	68	2007-11-11	Time was set on a non-exclusive public track day with other cars present. Car has been modified by Loaded. 540 PS (397 kW; 533 hp) / 1,385 kg (3,053 lb)
406	2	00:07:29.5	189	34	2018-08-22	700 bhp (522 kW; 710 PS)
407	2	00:08:19.8	187	50	2017-01-01	Bodykit with wing, 21" wheels, wider tyres, lowered suspension. 170 kW (231 PS; 228 hp) + 96 kW (131 PS; 129 hp) / 1,560 kg (3,440 lb)
408	2	00:06:30.705	256	51	2022-10-28	Official Nurburgring record attempt by Mercedes-AMG. Timing and vehicle condition verified by a notary. Michelin Pilot Sport Cup 2 R tyres. 6:35.183 on the 20,832 m lap.
409	2	00:06:38.835	341	40	2021-06-14	Official Nurburgring record attempt by Porsche. Timing and vehicle condition verified by a notary. Michelin Pilot Sport Cup 2 R tyres, OEM Manthey Performance Kit. 6:43.300 on the 20,832 m lap.
410	2	00:06:43.616	249	51	2020-11-04	Official Nurburgring record attempt by Mercedes. Timing and vehicle condition verified by a notary. OEM Michelin Pilot Sport Cup 2 R MO tyres. 6:48.047 on the 20,832 m lap.
411	2	00:06:44.848	356	33	2022-10-05	Porsche conducted test, full roll cage, Michelin Pilot Sport Cup 2 R tyres. 6:49.328 on the 20,832 m lap. Timing and vehicle condition verified by a notary.
412	2	00:06:44.97	186	46	2018-07-26	Lamborghini conducted test, full roll cage, Pirelli P Zero Trofeo R.
413	2	00:06:47.25	338	40	2017-09-20	Porsche conducted test. OEM Michelin Pilot Sport Cup 2 N2, OEM "Weissach Package", OEM (deletion of audio and communication system, Porsche Motorsport bucket seat and harness on drivers side.
414	2	00:06:52.01	221	46	2016-10-05	Lamborghini conducted test, full roll cage, Pirelli Trofeo R.
415	2	00:06:55.34	345	40	2020-09-15	Porsche conducted test. Michelin Pilot Sport Cup 2 R. 6:59.927 on the 20,832 m lap.
416	2	00:06:56.4	354	37	2018-04-16	Porsche conducted test. OEM Michelin Pilot Sport Cup 2 R N0, OEM "Weissach Package", OEM (deletion of audio and communication system, Porsche Motorsport bucket seat and harness on drivers side.
417	2	00:06:57	372	45	2013-09-04	Porsche conducted test, observed by Sport Auto. "Weissach Package", Michelin Pilot Sport
418	2	00:06:58.092	389	33	2023-07-13	Porsche conducted test. OEM Michelin Pilot Sport Cup 2 R, OEM "Manthey Performance Kit". (Ambient temperature of 18 °C (64 °F). The lap time was certified by a notary. 7:03.121 on the 20,832 m lap.
419	2	00:06:59.73	185	46	2015-05-18	Lamborghini conducted test, full roll cage, Pirelli P Zero Corsa.
420	2	00:07:01.3	126	39	2017-09-01	OEM "GTS-R Commemorative Edition", "Extreme Aero Package", Kumho Ecsta V720 ACR. (Privately funded and observed by Road & Track. Third attempt, testing ended by tyre failure resulting in crash.)
421	2	00:07:04.511	388	33	2021-09-17	Porsche conducted test. OEM Michelin Pilot Sport Cup 2 R, OEM deletion of audio and (communication system, bucket seat and harness on drivers side. 7:09.300 on the 20,832 m lap.
422	2	00:07:04.632	254	51	2018-11-01	Mercedes-Benz conducted test (11/2018). Michelin Pilot Sport Cup 2 ZP. Ambient temperature of (12 °C (54 °F). Vehicle in accordance with regulations. Timed by wige SolutionS.
423	2	00:07:12.13	125	17	2011-09-14	SRT, Viper Club of America and ViperExchange conducted test. Michelin Pilot Sport Cup.
424	2	00:07:12.7	343	40	2017-05-04	Porsche conducted test. Michelin Pilot Sport Cup 2, PDK, carbon ceramic brakes, OEM deletion (of audio and communication system, "Clubsport Package", Porsche Motorsport bucket seat and harness on drivers side.
425	2	00:07:28	353	10	2015-01-01	Michelin Pilot Sport Cup 2
426	2	00:07:28.02	252	10	2022-09-01	Michelin Pilot Sport Cup 2
427	2	00:07:24.22	304	84	2010-10-01	Nissan conducted test. Video confirmed. Done on semi-wet (damp) condition
428	2	00:07:25.41	250	13	2018-10-15	Mercedes-AMG conducted test. 7:30.11 on the 20,832 m lap
429	2	00:07:25.67	290	49	2013-08-01	Mercedes-AMG conducted test
430	2	00:07:25.72	183	11	2012-01-01	KTM conducted test, Michelin Pilot Sport Cup
431	2	00:07:26.4	118	28	2008-06-27	General Motors conducted test, Michelin Pilot Sport 2
432	2	00:07:26.7	303	84	2009-04-23	Nissan Motors conducted test, optional tyres. Best Motoring (08/2009)
433	2	00:07:27.82	316	44	2007-09-01	Pagani conducted test
434	2	00:07:18	340	79	2010-01-01	Porsche conducted test, Michelin Pilot Sport Cup N2
435	2	00:07:19.63	119	28	2011-06-09	General Motors conducted test. Base car, OEM Michelin Pilot Sport Cup ZP option
436	2	00:07:22.1	124	80	2008-08-18	Chrysler and Motor Trend conducted test. Michelin Pilot Sport Cup
437	2	00:07:22.68	116	28	2011-06-23	General Motors conducted test. Z07 package, OEM Michelin Pilot Sport Cup ZP option
438	2	00:07:23.009	251	13	2020-11-10	Mercedes-Benz conducted test, Michelin Pilot Sport Cup 2 tires and AMG Aerodynamics Package. (Timed by wige Solutions. 7:27.800 on the 20,832 m lap
439	2	00:07:29.03	303	84	2008-04-17	Nissan Motors conducted test
440	2	00:07:29.6	109	18	2016-10-24	Goodyear Eagle F1
441	2	00:07:29.9	113	60	2019-07-01	General Motors conducted test. Z51 performance package
442	2	00:07:31	336	87	2007-01-01	Porsche conducted test
512	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
443	2	00:07:33.95	383	40	2021-06-14	Official Nurburgring record attempt by Porsche. Timing and vehicle condition verified by a notary. Pirelli P Zero Corsa. Set a SUV record. 7:38.925 on the 20,832 m lap
444	2	00:07:37.9	326	79	2012-08-28	Porsche conducted test, PDK transmission
445	2	00:07:39.691	162	57	2023-03-24	Honda conducted test, non-factory optioned aftermarket Michelin Pilot Sport Cup 2 Connect. Current FWD car record holder. 7:44.881 on the 20,832 m lap
446	2	00:07:40	224	24	2007-01-01	Official Lamborghini lap time according to Auto Bild Sportscars (01/2007), Pirelli P Zero Corsa
447	2	00:07:40.1	408	41	2019-04-05	Renault Sport conducted test, Bridgestone Potenza S007. 7:45.389 on the 20,832 m lap. FWD car record holder (before 2023 Civic Type R)
448	2	00:07:42.34	397	40	2019-08-01	Porsche conducted test, pre-production model
449	2	00:07:44	103	42	1993-01-01	Bugatti conducted test with test driver Loris Bicocchi
450	2	00:07:49.369	277	49	2018-11-22	Mercedes-Benz conducted test, officially measured and notarised record lap time as the fastest series-production SUV (before Audi RS Q8 lap time record)
451	2	00:07:50.23	291	49	2013-06-03	Mercedes-Benz conducted test. 7:56.234 on the 20,832 m lap. Small-scale production car (9 examples were produced). The fastest lap on electric supercar (before NIO EP9 lap record)
452	2	00:07:54.36	407	41	2014-06-16	Test realised by Renault Sport
453	2	00:07:58.4	417	32	2014-03-01	SEAT conducted test
454	2	00:07:59.32	104	30	2008-05-09	General Motors conducted test
455	2	00:07:59.887	307	15	1996-01-01	Nissan conducted test, roll cage, controversial
456	2	00:08:06.56	165	22	2016-09-01	BTG, Kumho HU36, D2 coilovers
457	2	00:08:07.97	411	41	2011-06-17	Renault Sport conducted test, Bridgestone RE 050A (235/35 R19)
458	2	00:08:10	258	27	2014-03-01	Pre-facelift model with 360 PS, Dunlop SportMaxx RT
459	2	00:08:12	279	27	2002-01-01	Pirelli P Zero Rosso, 476 PS version, standard speed limiter to 250 km/h
460	2	00:08:14.98	299	56	2003-01-01	Best Motoring conducted test
461	2	00:08:16.9	412	85	2008-06-23	Renault Sport conducted test
462	2	00:08:23	375	27	2006-01-01	Michelin Pilot Sport 2 N1, manual, Sport Chrono, PASM
463	2	00:08:25	177	27	2006-01-01	Dunlop SP Sportmaxx, six-speed automatic
464	2	00:08:35	152	61	2005-01-01	Factory claimed
465	2	00:07:32	3	19	2016-09-01	Alfa Romeo Giulia Quadrifoglio with automatic transmission
466	2	00:07:51.7	4	19	2017-01-01	Alfa Romeo conducted test. Pirelli tyre. Equipped with OEM optional racing seat, harness and carbon-ceramic brakes. Equipped with roll cage
467	2	00:08:04.4	2	27	2013-09-12	Alfa Romeo conducted test. Pirelli P Zero Trofeo
468	2	00:07:23.975	72	35	2023-08-31	BMW conducted test, 7:28.760 on 20.832 m configuration of track. Michelin Pilot Sport Cup 2
469	2	00:07:13.497	81	35	2023-09-01	BMW conducted test, updated second chance lap record for BMW M4 CSL. 7:18.137 on 20.832 m (configuration of track. Michelin Pilot Sport Cup 2 R
470	2	00:07:14.64	228	3	2011-08-31	Lexus conducted test. OEM "Nurburgring Package", Bridgestone Potenza RE070, additional roll cage
471	2	00:07:15.677	80	35	2022-04-12	Fastest lap time ever for a series-produced BMW car. 7:20.207 on the 20,832 m lap
472	2	00:07:16.04	110	9	2017-01-01	General Motors conducted test, OEM Goodyear Eagle F1 Supercar 3R
473	2	00:07:27.88	82	35	2015-09-01	Michelin Pilot Sport Cup 2
474	2	00:07:28.57	78	10	2021-09-22	Michelin Pilot Sport Cup 2
475	2	00:07:33.906	62	35	2023-08-30	BMW conducted test, 7:38.706 on 20.832 m configuration of track. Michelin Pilot Sport Cup 2
476	2	00:07:35.522	25	21	2021-06-14	Official Nurburgring record attempt by Audi. Timing and vehicle condition verified by a notary. Pirelli P Zero Trofeo R. 7:40.748 on the 20,832 m lap. Lap record for compact cars
477	2	00:07:37.4	107	2	2013-10-01	General Motors conducted test, Pirelli P Zero Trofeo R
478	2	00:07:41.27	108	1	2011-10-01	General Motors conducted test
479	2	00:07:49.21	429	6	2016-04-20	Volkswagen conducted test, special Nurburgring set-up. FWD car record, video confirmed
480	2	00:08:18	59	27	2012-01-01	Michelin Pilot Super Sport, manual, Adaptive M suspension
481	2	00:08:35	71	27	1997-01-01	Michelin MXX3, S50B32 engine, SMG I automatic
482	2	00:08:42	40	27	1998-01-01	225 PS version
489	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
490	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
491	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
492	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
493	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
494	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
495	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
497	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
499	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
501	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
503	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
504	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
505	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
506	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
507	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
508	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
509	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
510	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
511	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
513	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
514	3	00:00:09	105	90	2024-03-18	Clarcson WPF test
515	2	00:01:40	180	90	2024-03-19	\N
516	2	01:10:40	180	90	2024-03-19	\N
517	2	00:09:00	90	90	2024-03-09	\N
518	2	00:09:00	90	90	2024-03-08	\N
519	3	00:00:10	13	90	2024-03-15	
520	1	00:12:00	14	90	2024-03-03	
521	3	00:12:00	7	90	2024-03-22	\N
522	3	00:12:00	7	90	2024-03-22	\N
523	1	00:07:12	133	90	2024-03-19	\N
525	3	00:09:09.009	14	90	2024-03-31	update test
\.


--
-- Data for Name: track_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.track_configuration (conf_id, length, description) FROM stdin;
1	19100	Bridge to gantry
2	20600	Standart lap
3	20832	Full lap
\.


--
-- Name: car_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.car_type_id_seq', 2, true);


--
-- Name: cars_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cars_car_id_seq', 451, true);


--
-- Name: drivers_driver_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.drivers_driver_id_seq', 90, true);


--
-- Name: lap_session_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lap_session_session_id_seq', 525, true);


--
-- Name: track_configuration_conf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.track_configuration_conf_id_seq', 3, true);


--
-- Name: cars constr_unique_car; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT constr_unique_car UNIQUE (car_name);


--
-- Name: drivers constr_unique_driver_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT constr_unique_driver_name UNIQUE (driver_firstname, driver_lastname);


--
-- Name: drivers drivers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (driver_id);


--
-- Name: lap_session lap_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap_session
    ADD CONSTRAINT lap_session_pkey PRIMARY KEY (session_id);


--
-- Name: cars pk_car_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT pk_car_id PRIMARY KEY (car_id);


--
-- Name: car_type pk_car_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_type
    ADD CONSTRAINT pk_car_type PRIMARY KEY (id);


--
-- Name: track_configuration track_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.track_configuration
    ADD CONSTRAINT track_configuration_pkey PRIMARY KEY (conf_id);


--
-- Name: lap_session fk_car_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap_session
    ADD CONSTRAINT fk_car_id FOREIGN KEY (car_id) REFERENCES public.cars(car_id) NOT VALID;


--
-- Name: cars fk_car_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT fk_car_type_id FOREIGN KEY (car_type_id) REFERENCES public.car_type(id);


--
-- Name: lap_session fk_driver_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap_session
    ADD CONSTRAINT fk_driver_id FOREIGN KEY (driver_id) REFERENCES public.drivers(driver_id) NOT VALID;


--
-- Name: lap_session fk_track_conf_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lap_session
    ADD CONSTRAINT fk_track_conf_id FOREIGN KEY (track_conf_id) REFERENCES public.track_configuration(conf_id) NOT VALID;


--
-- Name: FUNCTION func_create_session(conf_id smallint, _time interval, car_id integer, driver_id integer, _date date, note character varying); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.func_create_session(conf_id smallint, _time interval, car_id integer, driver_id integer, _date date, note character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION public.func_create_session(conf_id smallint, _time interval, car_id integer, driver_id integer, _date date, note character varying) TO nurnburg_driver;


--
-- Name: FUNCTION func_update_session(_sess_id bigint, conf_id smallint, _time interval, _car_id integer, _date date, note character varying); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.func_update_session(_sess_id bigint, conf_id smallint, _time interval, _car_id integer, _date date, note character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION public.func_update_session(_sess_id bigint, conf_id smallint, _time interval, _car_id integer, _date date, note character varying) TO nurnburg_driver;


--
-- Name: PROCEDURE my_sessions(IN _login character varying); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON PROCEDURE public.my_sessions(IN _login character varying) TO nurnburg_driver;


--
-- Name: PROCEDURE proc_delete_session(IN _id bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON PROCEDURE public.proc_delete_session(IN _id bigint) TO nurnburg_driver;


--
-- Name: TABLE cars; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cars TO nurnburg_driver;


--
-- Name: TABLE all_cars; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.all_cars TO nurnburg_driver;


--
-- Name: TABLE car_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.car_type TO nurnburg_driver;


--
-- Name: TABLE drivers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.drivers TO nurnburg_driver;


--
-- Name: TABLE lap_session; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.lap_session TO nurnburg_driver;


--
-- Name: TABLE track_configuration; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.track_configuration TO nurnburg_driver;


--
-- Name: TABLE all_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.all_sessions TO nurnburg_driver;


--
-- Name: TABLE compact_all_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.compact_all_sessions TO nurnburg_driver;


--
-- Name: TABLE get_length; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.get_length TO nurnburg_driver;


--
-- Name: TABLE top_100_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.top_100_sessions TO nurnburg_driver;


--
-- Name: TABLE your_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.your_sessions TO nurnburg_driver;


--
-- PostgreSQL database dump complete
--

