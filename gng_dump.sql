--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Ubuntu 10.23-0ubuntu0.18.04.2+esm1)
-- Dumped by pg_dump version 14.10 (Ubuntu 14.10-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

--
-- Name: campaign_participants; Type: TABLE; Schema: public; Owner: c370_s141
--

CREATE TABLE public.campaign_participants (
    campaignid integer NOT NULL,
    participantid integer NOT NULL,
    role character varying(50)
);


ALTER TABLE public.campaign_participants OWNER TO c370_s141;

--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: c370_s141
--

CREATE TABLE public.campaigns (
    campaignid integer NOT NULL,
    campaignname character varying(255),
    startdate date,
    enddate date,
    location character varying(255),
    description text,
    record text
);


ALTER TABLE public.campaigns OWNER TO c370_s141;

--
-- Name: campaigns_campaignid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s141
--

CREATE SEQUENCE public.campaigns_campaignid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.campaigns_campaignid_seq OWNER TO c370_s141;

--
-- Name: campaigns_campaignid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s141
--

ALTER SEQUENCE public.campaigns_campaignid_seq OWNED BY public.campaigns.campaignid;


--
-- Name: donors; Type: TABLE; Schema: public; Owner: c370_s141
--

CREATE TABLE public.donors (
    donorid integer NOT NULL,
    name character varying(100),
    email character varying(255),
    phone character varying(20)
);


ALTER TABLE public.donors OWNER TO c370_s141;

--
-- Name: donors_donorid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s141
--

CREATE SEQUENCE public.donors_donorid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donors_donorid_seq OWNER TO c370_s141;

--
-- Name: donors_donorid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s141
--

ALTER SEQUENCE public.donors_donorid_seq OWNED BY public.donors.donorid;


--
-- Name: fundflow; Type: TABLE; Schema: public; Owner: c370_s141
--

CREATE TABLE public.fundflow (
    transactionid integer NOT NULL,
    transactiondate timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    description text,
    type character varying(50),
    amount numeric(10,2),
    donorid integer,
    campaignid integer,
    currentbalance numeric(10,2)
);


ALTER TABLE public.fundflow OWNER TO c370_s141;

--
-- Name: fundflow_transactionid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s141
--

CREATE SEQUENCE public.fundflow_transactionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fundflow_transactionid_seq OWNER TO c370_s141;

--
-- Name: fundflow_transactionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s141
--

ALTER SEQUENCE public.fundflow_transactionid_seq OWNED BY public.fundflow.transactionid;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: c370_s141
--

CREATE TABLE public.participants (
    participantid integer NOT NULL,
    name character varying(100),
    tier integer,
    email character varying(255),
    phone character varying(20),
    record text
);


ALTER TABLE public.participants OWNER TO c370_s141;

--
-- Name: participants_participantid_seq; Type: SEQUENCE; Schema: public; Owner: c370_s141
--

CREATE SEQUENCE public.participants_participantid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participants_participantid_seq OWNER TO c370_s141;

--
-- Name: participants_participantid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: c370_s141
--

ALTER SEQUENCE public.participants_participantid_seq OWNED BY public.participants.participantid;


--
-- Name: view1; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view1 AS
 SELECT campaigns.campaignname,
    campaigns.startdate
   FROM public.campaigns
  WHERE (campaigns.startdate IN ( SELECT campaigns_1.startdate
           FROM public.campaigns campaigns_1
          ORDER BY campaigns_1.startdate DESC
         LIMIT 2));


ALTER TABLE public.view1 OWNER TO c370_s141;

--
-- Name: view10; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view10 AS
 SELECT p.name AS volunteer_name,
    count(cp.campaignid) AS num_campaigns_participated
   FROM (public.participants p
     JOIN public.campaign_participants cp ON ((p.participantid = cp.participantid)))
  GROUP BY p.name
  ORDER BY (count(cp.campaignid)) DESC
 LIMIT 3;


ALTER TABLE public.view10 OWNER TO c370_s141;

--
-- Name: view2; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view2 AS
 SELECT donors.name,
    count(*) AS num_donations
   FROM (public.donors
     JOIN public.fundflow ON ((donors.donorid = fundflow.donorid)))
  WHERE ((fundflow.type)::text = 'donation'::text)
  GROUP BY donors.name
  ORDER BY (count(*)) DESC
 LIMIT 3;


ALTER TABLE public.view2 OWNER TO c370_s141;

--
-- Name: view3; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view3 AS
 SELECT c.campaignname,
    abs(sum(ff.amount)) AS total_expense
   FROM (public.campaigns c
     JOIN public.fundflow ff ON ((c.campaignid = ff.campaignid)))
  WHERE ((ff.type)::text = 'expense'::text)
  GROUP BY c.campaignname;


ALTER TABLE public.view3 OWNER TO c370_s141;

--
-- Name: view4; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view4 AS
 SELECT p.name
   FROM (public.participants p
     JOIN public.campaign_participants cp ON ((p.participantid = cp.participantid)))
  GROUP BY p.name
 HAVING (count(cp.campaignid) > 2);


ALTER TABLE public.view4 OWNER TO c370_s141;

--
-- Name: view5; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view5 AS
SELECT
    NULL::integer AS campaignid,
    NULL::character varying(255) AS campaignname,
    NULL::bigint AS num_participants;


ALTER TABLE public.view5 OWNER TO c370_s141;

--
-- Name: website; Type: TABLE; Schema: public; Owner: c370_s141
--

CREATE TABLE public.website (
    campaignid integer,
    phase character varying(100),
    pushoutdate date,
    description text
);


ALTER TABLE public.website OWNER TO c370_s141;

--
-- Name: view6; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view6 AS
 SELECT w.campaignid,
    c.startdate,
    c.campaignname,
    w.phase
   FROM (public.website w
     JOIN public.campaigns c ON ((w.campaignid = c.campaignid)))
  WHERE ((w.phase)::text = 'upcoming'::text);


ALTER TABLE public.view6 OWNER TO c370_s141;

--
-- Name: view7; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view7 AS
 SELECT c.campaignid,
    c.campaignname,
    p.participantid,
    p.name AS participant_name
   FROM ((public.campaigns c
     JOIN public.campaign_participants cp ON ((c.campaignid = cp.campaignid)))
     JOIN public.participants p ON ((cp.participantid = p.participantid)));


ALTER TABLE public.view7 OWNER TO c370_s141;

--
-- Name: view8; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view8 AS
 SELECT c.campaignid,
    c.campaignname,
    c.startdate,
    c.enddate,
    c.location,
    c.description,
    c.record
   FROM public.campaigns c
  WHERE (EXISTS ( SELECT 1
           FROM public.campaign_participants cp
          WHERE (cp.campaignid = c.campaignid)
          GROUP BY cp.campaignid
         HAVING (count(*) > 5)))
  ORDER BY c.campaignid;


ALTER TABLE public.view8 OWNER TO c370_s141;

--
-- Name: view9; Type: VIEW; Schema: public; Owner: c370_s141
--

CREATE VIEW public.view9 AS
 SELECT d.name,
    sum(ff.amount) AS total_donation_amount
   FROM (public.donors d
     JOIN public.fundflow ff ON ((d.donorid = ff.donorid)))
  WHERE ((ff.type)::text = 'donation'::text)
  GROUP BY d.name
  ORDER BY (sum(ff.amount)) DESC
 LIMIT 3;


ALTER TABLE public.view9 OWNER TO c370_s141;

--
-- Name: campaigns campaignid; Type: DEFAULT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN campaignid SET DEFAULT nextval('public.campaigns_campaignid_seq'::regclass);


--
-- Name: donors donorid; Type: DEFAULT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.donors ALTER COLUMN donorid SET DEFAULT nextval('public.donors_donorid_seq'::regclass);


--
-- Name: fundflow transactionid; Type: DEFAULT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.fundflow ALTER COLUMN transactionid SET DEFAULT nextval('public.fundflow_transactionid_seq'::regclass);


--
-- Name: participants participantid; Type: DEFAULT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.participants ALTER COLUMN participantid SET DEFAULT nextval('public.participants_participantid_seq'::regclass);


--
-- Data for Name: campaign_participants; Type: TABLE DATA; Schema: public; Owner: c370_s141
--

COPY public.campaign_participants (campaignid, participantid, role) FROM stdin;
1	1	organizer
1	2	organizer
1	4	participant
1	5	participant
1	7	participant
1	10	participant
2	1	organizer
2	2	participant
2	4	organizer
2	5	participant
2	7	participant
2	10	participant
2	11	participant
3	11	organizer
3	16	participant
3	4	organizer
3	5	participant
3	7	participant
3	10	participant
3	17	participant
3	19	participant
4	12	organizer
4	29	organizer
4	8	participant
4	27	participant
4	16	participant
4	3	participant
5	1	organizer
5	2	organizer
5	4	participant
6	13	participant
6	9	participant
6	28	participant
6	17	participant
6	3	organizer
7	30	participant
7	26	participant
7	19	organizer
7	9	participant
7	6	participant
8	1	organizer
8	2	organizer
8	3	participant
8	4	participant
9	19	organizer
9	22	organizer
9	11	organizer
9	4	participant
9	27	participant
9	20	participant
9	29	participant
10	7	organizer
10	18	organizer
10	14	organizer
10	25	participant
10	1	participant
10	10	participant
10	22	participant
11	30	organizer
11	26	organizer
11	19	participant
11	9	participant
11	6	participant
11	13	participant
11	28	participant
11	17	participant
11	3	participant
12	5	organizer
12	24	organizer
12	11	organizer
12	19	participant
12	23	participant
12	15	participant
12	30	participant
13	12	organizer
13	29	organizer
13	8	participant
13	27	participant
13	16	participant
13	3	participant
14	9	organizer
14	28	organizer
14	3	organizer
14	20	participant
14	5	participant
14	14	participant
14	16	participant
15	19	organizer
15	22	organizer
15	11	organizer
15	4	participant
15	27	participant
15	20	participant
15	29	participant
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: c370_s141
--

COPY public.campaigns (campaignid, campaignname, startdate, enddate, location, description, record) FROM stdin;
1	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
2	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
3	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
4	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
6	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
7	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
8	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
9	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
10	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
11	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
12	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
13	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
14	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
15	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
16	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
17	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
18	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
19	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
20	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	\N
21	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
22	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
23	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
24	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
25	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
26	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
27	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
28	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
29	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
30	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
31	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
32	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
33	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
34	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
35	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	\N
36	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
37	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
38	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
39	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
40	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
41	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
42	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
43	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
44	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
45	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
46	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
47	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
48	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
49	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
50	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	\N
51	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
52	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
53	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
54	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
55	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
56	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
57	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
58	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
59	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
60	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
61	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
62	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
63	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
64	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
65	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	\N
66	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
67	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
68	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
69	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
70	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
71	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
72	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
73	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
74	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
75	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
76	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
77	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
78	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
79	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
80	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	\N
81	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
82	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
83	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
84	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
85	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
86	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
87	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
88	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
89	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
90	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
91	Nature Conservation Conference	2023-02-01	2023-03-15	Port Hardy	Engage in discussions on nature conservation and ecosystem protection strategies for Vancouver Island.	\N
92	Clean Energy Symposium	2023-03-05	2023-04-15	Sidney	Join experts and activists to discuss the transition to clean energy and combat climate change on Vancouver Island.	\N
93	Waste Reduction Workshop	2023-04-20	2023-05-31	Qualicum Beach	Learn practical tips for reducing waste and minimizing your ecological footprint.	\N
94	Eco-friendly Transportation Expo	2023-05-15	2023-06-30	Campbell River	Explore sustainable transportation options and reduce carbon emissions in our communities.	\N
95	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	\N
96	Plastic Pollution Cleanup	2023-07-01	2023-08-15	Parksville	Join us in cleaning up plastic pollution from our beaches and oceans to protect marine wildlife.	\N
97	Urban Green Spaces Initiative	2023-08-20	2023-09-30	Duncan	Support the creation and maintenance of urban green spaces to improve air quality and enhance biodiversity.	\N
98	Sustainable Fishing Seminar	2023-09-15	2023-10-30	Port Alberni	Learn about sustainable fishing practices and their importance for preserving fish populations.	\N
99	Climate Change Awareness Walk	2023-10-01	2023-11-15	Victoria	Join us for a walk to raise awareness about the impacts of climate change on Vancouver Island.	\N
100	Beach Conservation Drive	2023-11-10	2023-12-25	Nanaimo	Participate in our efforts to conserve coastal ecosystems and protect marine life.	\N
101	Save the Trees	2024-04-15	2024-05-30	Langford	Join us in our efforts to protect the local forests and promote sustainable logging practices.	\N
102	Urban Garden Project	2024-06-01	2024-07-31	Nanaimo	Get involved in our community garden project and learn about the benefits of urban agriculture.	\N
103	Clean Beach Initiative	2024-07-01	2024-08-15	Victoria	Help us keep our beaches clean and raise awareness about the importance of marine conservation.	\N
104	Wildlife Habitat Restoration	2024-08-01	2024-09-30	Victoria	Join us in restoring local wildlife habitats and protecting endangered species in our region.	\N
105	Pollution Awareness Campaign	2024-09-15	2024-10-31	Sidney	Spread awareness about air and water pollution in our city and encourage environmentally-friendly practices.	\N
5	Native Plant Restoration Project	2023-06-10	2023-07-25	Courtenay	Help restore native plant habitats and promote biodiversity conservation on Vancouver Island.	testing 222
\.


--
-- Data for Name: donors; Type: TABLE DATA; Schema: public; Owner: c370_s141
--

COPY public.donors (donorid, name, email, phone) FROM stdin;
1	John Doe	john@example.com	+1 (555) 123-4567
2	Jane Smith	jane@example.com	+1 (555) 987-6543
3	Michael Johnson	michael@example.com	+1 (555) 111-2222
4	Emily Brown	emily@example.com	+1 (555) 333-4444
5	David Wilson	david@example.com	+1 (555) 555-6666
6	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
7	Robert Martinez	robert@example.com	+1 (555) 999-0000
8	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
9	William Thomas	william@example.com	+1 (555) 444-5555
10	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
11	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
12	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
13	Mark Young	mark@example.com	+1 (555) 222-3333
14	Karen Scott	karen@example.com	+1 (555) 444-5555
15	Christopher Green	christopher@example.com	+1 (555) 666-7777
16	John Doe	john@example.com	+1 (555) 123-4567
17	Jane Smith	jane@example.com	+1 (555) 987-6543
18	Michael Johnson	michael@example.com	+1 (555) 111-2222
19	Emily Brown	emily@example.com	+1 (555) 333-4444
20	David Wilson	david@example.com	+1 (555) 555-6666
21	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
22	Robert Martinez	robert@example.com	+1 (555) 999-0000
23	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
24	William Thomas	william@example.com	+1 (555) 444-5555
25	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
26	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
27	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
28	Mark Young	mark@example.com	+1 (555) 222-3333
29	Karen Scott	karen@example.com	+1 (555) 444-5555
30	Christopher Green	christopher@example.com	+1 (555) 666-7777
31	John Doe	john@example.com	+1 (555) 123-4567
32	Jane Smith	jane@example.com	+1 (555) 987-6543
33	Michael Johnson	michael@example.com	+1 (555) 111-2222
34	Emily Brown	emily@example.com	+1 (555) 333-4444
35	David Wilson	david@example.com	+1 (555) 555-6666
36	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
37	Robert Martinez	robert@example.com	+1 (555) 999-0000
38	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
39	William Thomas	william@example.com	+1 (555) 444-5555
40	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
41	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
42	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
43	Mark Young	mark@example.com	+1 (555) 222-3333
44	Karen Scott	karen@example.com	+1 (555) 444-5555
45	Christopher Green	christopher@example.com	+1 (555) 666-7777
46	John Doe	john@example.com	+1 (555) 123-4567
47	Jane Smith	jane@example.com	+1 (555) 987-6543
48	Michael Johnson	michael@example.com	+1 (555) 111-2222
49	Emily Brown	emily@example.com	+1 (555) 333-4444
50	David Wilson	david@example.com	+1 (555) 555-6666
51	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
52	Robert Martinez	robert@example.com	+1 (555) 999-0000
53	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
54	William Thomas	william@example.com	+1 (555) 444-5555
55	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
56	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
57	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
58	Mark Young	mark@example.com	+1 (555) 222-3333
59	Karen Scott	karen@example.com	+1 (555) 444-5555
60	Christopher Green	christopher@example.com	+1 (555) 666-7777
61	John Doe	john@example.com	+1 (555) 123-4567
62	Jane Smith	jane@example.com	+1 (555) 987-6543
63	Michael Johnson	michael@example.com	+1 (555) 111-2222
64	Emily Brown	emily@example.com	+1 (555) 333-4444
65	David Wilson	david@example.com	+1 (555) 555-6666
66	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
67	Robert Martinez	robert@example.com	+1 (555) 999-0000
68	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
69	William Thomas	william@example.com	+1 (555) 444-5555
70	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
71	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
72	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
73	Mark Young	mark@example.com	+1 (555) 222-3333
74	Karen Scott	karen@example.com	+1 (555) 444-5555
75	Christopher Green	christopher@example.com	+1 (555) 666-7777
76	John Doe	john@example.com	+1 (555) 123-4567
77	Jane Smith	jane@example.com	+1 (555) 987-6543
78	Michael Johnson	michael@example.com	+1 (555) 111-2222
79	Emily Brown	emily@example.com	+1 (555) 333-4444
80	David Wilson	david@example.com	+1 (555) 555-6666
81	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
82	Robert Martinez	robert@example.com	+1 (555) 999-0000
83	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
84	William Thomas	william@example.com	+1 (555) 444-5555
85	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
86	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
87	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
88	Mark Young	mark@example.com	+1 (555) 222-3333
89	Karen Scott	karen@example.com	+1 (555) 444-5555
90	Christopher Green	christopher@example.com	+1 (555) 666-7777
91	John Doe	john@example.com	+1 (555) 123-4567
92	Jane Smith	jane@example.com	+1 (555) 987-6543
93	Michael Johnson	michael@example.com	+1 (555) 111-2222
94	Emily Brown	emily@example.com	+1 (555) 333-4444
95	David Wilson	david@example.com	+1 (555) 555-6666
96	Sarah Taylor	sarah@example.com	+1 (555) 777-8888
97	Robert Martinez	robert@example.com	+1 (555) 999-0000
98	Jessica Anderson	jessica@example.com	+1 (555) 222-3333
99	William Thomas	william@example.com	+1 (555) 444-5555
100	Jennifer Garcia	jennifer@example.com	+1 (555) 666-7777
101	Daniel Hernandez	daniel@example.com	+1 (555) 888-9999
102	Lisa Lopez	lisa@example.com	+1 (555) 000-1111
103	Mark Young	mark@example.com	+1 (555) 222-3333
104	Karen Scott	karen@example.com	+1 (555) 444-5555
105	Christopher Green	christopher@example.com	+1 (555) 666-7777
\.


--
-- Data for Name: fundflow; Type: TABLE DATA; Schema: public; Owner: c370_s141
--

COPY public.fundflow (transactionid, transactiondate, description, type, amount, donorid, campaignid, currentbalance) FROM stdin;
431	2023-02-01 09:23:45	Nature Conservation Conference Brochures	expense	-130.00	\N	1	2570.00
432	2023-03-05 09:23:45	Clean Energy Symposium Brochures	expense	-125.00	\N	2	1445.00
433	2023-04-20 09:23:45	Waste Reduction Workshop Posters	expense	-75.00	\N	3	4070.00
434	2023-05-15 09:23:45	Eco-friendly Transportation Expo Posters	expense	-105.00	\N	4	2665.00
435	2023-06-10 09:23:45	Native Plant Restoration Project Posters	expense	-95.00	\N	5	2070.00
436	2023-07-01 09:23:45	Plastic Pollution Cleanup Posters	expense	-85.00	\N	6	2985.00
437	2023-08-20 09:23:45	Urban Green Spaces Initiative Posters	expense	-60.00	\N	7	4160.00
438	2023-09-15 09:23:45	Sustainable Fishing Seminar Brochures	expense	-95.00	\N	8	2590.00
439	2023-10-01 09:23:45	Climate Change Awareness Walk Placards	expense	-70.00	\N	9	2520.00
440	2023-11-10 09:23:45	Beach Conservation Drive Posters	expense	-80.00	\N	10	1680.00
441	2023-01-02 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	4500.00
442	2023-01-02 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	3500.00
443	2023-02-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	2570.00
444	2023-02-01 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	2070.00
445	2023-03-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	1570.00
446	2023-03-05 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	445.00
447	2023-04-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	1645.00
448	2023-04-20 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	3070.00
449	2023-05-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	2570.00
450	2023-05-15 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	1665.00
451	2023-06-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	1465.00
452	2023-06-10 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	1070.00
453	2023-07-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	2985.00
454	2023-07-01 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	4005.00
455	2023-08-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	3520.00
456	2023-08-20 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	3160.00
457	2023-09-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	2185.00
458	2023-09-15 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	1590.00
459	2023-10-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	2520.00
460	2023-10-01 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	1750.00
461	2023-11-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	1260.00
462	2023-11-10 14:52:30	employee expense	Fixed expenses	-1000.00	\N	\N	680.00
463	2023-12-01 09:23:45	office rent	Fixed expenses	-1000.00	\N	\N	-300.00
464	2023-01-01 07:36:21	\N	donation	3000.00	1	\N	3000.00
465	2023-01-01 11:20:55	\N	donation	2000.00	2	\N	5000.00
466	2023-01-01 13:27:59	\N	donation	500.00	3	\N	5500.00
467	2023-02-01 07:36:21	\N	donation	200.00	4	\N	3700.00
468	2023-02-01 11:20:55	\N	donation	500.00	3	\N	3070.00
469	2023-03-01 07:36:21	\N	donation	500.00	3	\N	2570.00
470	2023-03-15 13:27:59	\N	donation	2000.00	5	\N	2445.00
471	2023-04-01 07:36:21	\N	donation	200.00	4	\N	2645.00
472	2023-04-01 11:20:55	\N	donation	500.00	3	\N	2145.00
473	2023-04-01 13:27:59	\N	donation	2000.00	2	\N	4145.00
474	2023-05-01 07:36:21	\N	donation	500.00	3	\N	3570.00
475	2023-05-01 11:20:55	\N	donation	200.00	4	\N	2770.00
476	2023-06-01 07:36:21	\N	donation	800.00	5	\N	2465.00
477	2023-06-01 11:20:55	\N	donation	200.00	4	\N	1665.00
478	2023-06-01 13:27:59	\N	donation	500.00	3	\N	2165.00
479	2023-07-01 07:36:21	\N	donation	3000.00	1	\N	4070.00
480	2023-07-01 11:20:55	\N	donation	2000.00	2	\N	4985.00
481	2023-07-01 13:27:59	\N	donation	20.00	6	\N	5005.00
482	2023-07-01 17:58:17	\N	donation	500.00	3	\N	4505.00
483	2023-08-01 07:36:21	\N	donation	15.00	7	\N	4520.00
484	2023-08-01 11:20:55	\N	donation	200.00	4	\N	3720.00
485	2023-08-01 13:27:59	\N	donation	500.00	3	\N	4220.00
486	2023-09-01 07:36:21	\N	donation	25.00	8	\N	3185.00
487	2023-09-01 11:20:55	\N	donation	500.00	3	\N	2685.00
488	2023-10-01 07:36:21	\N	donation	2000.00	2	\N	3590.00
489	2023-10-01 11:20:55	\N	donation	200.00	4	\N	2720.00
490	2023-10-01 13:27:59	\N	donation	30.00	9	\N	2750.00
491	2023-10-01 17:58:17	\N	donation	500.00	3	\N	2250.00
492	2023-11-01 07:36:21	\N	donation	10.00	10	\N	2260.00
493	2023-11-01 11:20:55	\N	donation	500.00	3	\N	1760.00
494	2023-12-01 07:36:21	\N	donation	20.00	11	\N	700.00
495	2023-12-01 11:20:55	\N	donation	500.00	3	\N	200.00
496	2023-12-01 13:27:59	\N	donation	200.00	4	\N	400.00
497	2024-01-01 07:36:21	\N	donation	3000.00	1	\N	3400.00
498	2024-01-01 11:20:55	\N	donation	500.00	3	\N	3900.00
499	2024-01-01 13:27:59	\N	donation	15.00	12	\N	3915.00
500	2024-02-01 07:36:21	\N	donation	25.00	13	\N	3940.00
501	2024-02-01 11:20:55	\N	donation	200.00	4	\N	4140.00
502	2024-02-01 13:27:59	\N	donation	500.00	3	\N	4640.00
503	2024-03-01 07:36:21	\N	donation	500.00	3	\N	5140.00
504	2024-03-01 11:20:55	\N	donation	30.00	14	\N	5170.00
505	2024-03-02 13:27:59	\N	donation	10.00	6	\N	5180.00
506	2024-03-03 17:58:17	\N	donation	15.00	7	\N	5195.00
507	2024-03-04 17:58:17	\N	donation	20.00	8	\N	5215.00
508	2024-03-09 17:58:17	\N	donation	45.00	13	\N	5260.00
509	2024-03-10 17:58:17	\N	donation	50.00	14	\N	5310.00
510	2024-03-11 17:58:17	\N	donation	55.00	15	\N	5365.00
\.


--
-- Data for Name: participants; Type: TABLE DATA; Schema: public; Owner: c370_s141
--

COPY public.participants (participantid, name, tier, email, phone, record) FROM stdin;
1	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
92	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
4	David Wilson	0	david@example.com	+1 (555) 333-4444	testing111
95	David Wilson	0	david@example.com	+1 (555) 333-4444	\N
9	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
100	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
15	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
106	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
22	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
113	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
152	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
155	David Wilson	0	david@example.com	+1 (555) 333-4444	\N
160	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
166	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
173	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
32	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
35	David Wilson	0	david@example.com	+1 (555) 333-4444	\N
122	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
40	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
125	David Wilson	0	david@example.com	+1 (555) 333-4444	\N
46	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
130	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
53	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
136	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
143	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
62	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
65	David Wilson	0	david@example.com	+1 (555) 333-4444	\N
70	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
76	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
83	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
182	Alice Johnson	0	alice@example.com	+1 (555) 123-4567	\N
185	David Wilson	0	david@example.com	+1 (555) 333-4444	\N
190	Isaac Rodriguez	3	isaac@example.com	+1 (555) 444-5555	\N
196	Olivia Martin	3	olivia@example.com	+1 (555) 666-7777	\N
203	Xavier Garcia	3	xavier@example.com	+1 (555) 999-0000	\N
153	Bob Smith	2	bob@example.com	+1 (555) 987-6543	\N
154	Charlie Brown	2	charlie@example.com	+1 (555) 111-2222	\N
156	Emma Davis	2	emma@example.com	+1 (555) 555-6666	\N
157	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
158	Grace Lee	2	grace@example.com	+1 (555) 999-0000	\N
159	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
161	Jessica Martinez	2	jessica@example.com	+1 (555) 666-7777	\N
162	Kevin Adams	2	kevin@example.com	+1 (555) 888-9999	\N
163	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
164	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
165	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
167	Paul Walker	2	paul@example.com	+1 (555) 777-8888	\N
168	Rachel Green	2	rachel@example.com	+1 (555) 999-0000	\N
169	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
170	Tina Turner	2	tina@example.com	+1 (555) 333-4444	\N
171	Victor Lee	2	victor@example.com	+1 (555) 555-6666	\N
172	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
174	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
175	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
176	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
177	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
178	Catherine White	2	catherine@example.com	+1 (555) 999-0000	\N
179	Daniel Adams	2	daniel@example.com	+1 (555) 111-2222	\N
180	Elizabeth Johnson	2	elizabeth@example.com	+1 (555) 333-4444	\N
181	Frederick Lee	2	frederick@example.com	+1 (555) 555-6666	\N
93	Bob Smith	2	bob@example.com	+1 (555) 987-6543	\N
94	Charlie Brown	2	charlie@example.com	+1 (555) 111-2222	\N
96	Emma Davis	2	emma@example.com	+1 (555) 555-6666	\N
97	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
98	Grace Lee	2	grace@example.com	+1 (555) 999-0000	\N
99	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
101	Jessica Martinez	2	jessica@example.com	+1 (555) 666-7777	\N
102	Kevin Adams	2	kevin@example.com	+1 (555) 888-9999	\N
103	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
104	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
105	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
107	Paul Walker	2	paul@example.com	+1 (555) 777-8888	\N
108	Rachel Green	2	rachel@example.com	+1 (555) 999-0000	\N
109	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
110	Tina Turner	2	tina@example.com	+1 (555) 333-4444	\N
111	Victor Lee	2	victor@example.com	+1 (555) 555-6666	\N
112	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
114	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
115	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
116	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
117	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
118	Catherine White	2	catherine@example.com	+1 (555) 999-0000	\N
119	Daniel Adams	2	daniel@example.com	+1 (555) 111-2222	\N
120	Elizabeth Johnson	2	elizabeth@example.com	+1 (555) 333-4444	\N
121	Frederick Lee	2	frederick@example.com	+1 (555) 555-6666	\N
123	Bob Smith	2	bob@example.com	+1 (555) 987-6543	\N
124	Charlie Brown	2	charlie@example.com	+1 (555) 111-2222	\N
126	Emma Davis	2	emma@example.com	+1 (555) 555-6666	\N
127	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
128	Grace Lee	2	grace@example.com	+1 (555) 999-0000	\N
129	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
131	Jessica Martinez	2	jessica@example.com	+1 (555) 666-7777	\N
132	Kevin Adams	2	kevin@example.com	+1 (555) 888-9999	\N
133	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
134	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
135	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
137	Paul Walker	2	paul@example.com	+1 (555) 777-8888	\N
138	Rachel Green	2	rachel@example.com	+1 (555) 999-0000	\N
139	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
140	Tina Turner	2	tina@example.com	+1 (555) 333-4444	\N
141	Victor Lee	2	victor@example.com	+1 (555) 555-6666	\N
142	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
144	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
145	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
146	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
147	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
148	Catherine White	2	catherine@example.com	+1 (555) 999-0000	\N
149	Daniel Adams	2	daniel@example.com	+1 (555) 111-2222	\N
150	Elizabeth Johnson	2	elizabeth@example.com	+1 (555) 333-4444	\N
151	Frederick Lee	2	frederick@example.com	+1 (555) 555-6666	\N
2	Bob Smith	1	bob@example.com	+1 (555) 987-6543	\N
3	Charlie Brown	1	charlie@example.com	+1 (555) 111-2222	\N
5	Emma Davis	1	emma@example.com	+1 (555) 555-6666	\N
6	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
7	Grace Lee	1	grace@example.com	+1 (555) 999-0000	\N
8	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
10	Jessica Martinez	1	jessica@example.com	+1 (555) 666-7777	\N
11	Kevin Adams	1	kevin@example.com	+1 (555) 888-9999	\N
12	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
13	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
14	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
16	Paul Walker	1	paul@example.com	+1 (555) 777-8888	\N
17	Rachel Green	1	rachel@example.com	+1 (555) 999-0000	\N
18	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
19	Tina Turner	1	tina@example.com	+1 (555) 333-4444	\N
20	Victor Lee	1	victor@example.com	+1 (555) 555-6666	\N
21	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
23	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
24	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
25	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
33	Bob Smith	2	bob@example.com	+1 (555) 987-6543	\N
26	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
27	Catherine White	1	catherine@example.com	+1 (555) 999-0000	\N
28	Daniel Adams	1	daniel@example.com	+1 (555) 111-2222	\N
29	Elizabeth Johnson	1	elizabeth@example.com	+1 (555) 333-4444	\N
30	Frederick Lee	1	frederick@example.com	+1 (555) 555-6666	\N
31	Hannah Wang	2	hannahwang@example.com	+1(234)567-8910	\N
34	Charlie Brown	2	charlie@example.com	+1 (555) 111-2222	\N
36	Emma Davis	2	emma@example.com	+1 (555) 555-6666	\N
37	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
38	Grace Lee	2	grace@example.com	+1 (555) 999-0000	\N
39	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
41	Jessica Martinez	2	jessica@example.com	+1 (555) 666-7777	\N
42	Kevin Adams	2	kevin@example.com	+1 (555) 888-9999	\N
43	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
44	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
45	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
47	Paul Walker	2	paul@example.com	+1 (555) 777-8888	\N
48	Rachel Green	2	rachel@example.com	+1 (555) 999-0000	\N
49	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
50	Tina Turner	2	tina@example.com	+1 (555) 333-4444	\N
51	Victor Lee	2	victor@example.com	+1 (555) 555-6666	\N
52	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
54	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
55	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
56	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
57	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
58	Catherine White	2	catherine@example.com	+1 (555) 999-0000	\N
59	Daniel Adams	2	daniel@example.com	+1 (555) 111-2222	\N
60	Elizabeth Johnson	2	elizabeth@example.com	+1 (555) 333-4444	\N
61	Frederick Lee	2	frederick@example.com	+1 (555) 555-6666	\N
63	Bob Smith	2	bob@example.com	+1 (555) 987-6543	\N
64	Charlie Brown	2	charlie@example.com	+1 (555) 111-2222	\N
66	Emma Davis	2	emma@example.com	+1 (555) 555-6666	\N
67	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
68	Grace Lee	2	grace@example.com	+1 (555) 999-0000	\N
69	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
71	Jessica Martinez	2	jessica@example.com	+1 (555) 666-7777	\N
72	Kevin Adams	2	kevin@example.com	+1 (555) 888-9999	\N
73	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
74	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
75	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
77	Paul Walker	2	paul@example.com	+1 (555) 777-8888	\N
78	Rachel Green	2	rachel@example.com	+1 (555) 999-0000	\N
79	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
80	Tina Turner	2	tina@example.com	+1 (555) 333-4444	\N
81	Victor Lee	2	victor@example.com	+1 (555) 555-6666	\N
82	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
84	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
85	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
86	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
87	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
88	Catherine White	2	catherine@example.com	+1 (555) 999-0000	\N
89	Daniel Adams	2	daniel@example.com	+1 (555) 111-2222	\N
90	Elizabeth Johnson	2	elizabeth@example.com	+1 (555) 333-4444	\N
91	Frederick Lee	2	frederick@example.com	+1 (555) 555-6666	\N
183	Bob Smith	2	bob@example.com	+1 (555) 987-6543	\N
184	Charlie Brown	2	charlie@example.com	+1 (555) 111-2222	\N
186	Emma Davis	2	emma@example.com	+1 (555) 555-6666	\N
187	Frank Thomas	2	frank@example.com	+1 (555) 777-8888	\N
188	Grace Lee	2	grace@example.com	+1 (555) 999-0000	\N
189	Hannah Taylor	2	hannah@example.com	+1 (555) 222-3333	\N
191	Jessica Martinez	2	jessica@example.com	+1 (555) 666-7777	\N
192	Kevin Adams	2	kevin@example.com	+1 (555) 888-9999	\N
193	Linda White	2	linda@example.com	+1 (555) 000-1111	\N
194	Mike Harris	2	mike@example.com	+1 (555) 222-3333	\N
195	Nancy Clark	2	nancy@example.com	+1 (555) 444-5555	\N
197	Paul Walker	2	paul@example.com	+1 (555) 777-8888	\N
198	Rachel Green	2	rachel@example.com	+1 (555) 999-0000	\N
199	Samuel Adams	2	samuel@example.com	+1 (555) 111-2222	\N
200	Tina Turner	2	tina@example.com	+1 (555) 333-4444	\N
201	Victor Lee	2	victor@example.com	+1 (555) 555-6666	\N
202	Wendy Brown	2	wendy@example.com	+1 (555) 777-8888	\N
204	Yolanda Martinez	2	yolanda@example.com	+1 (555) 111-2222	\N
205	Zachary Taylor	2	zachary@example.com	+1 (555) 333-4444	\N
206	Abigail Hernandez	2	abigail@example.com	+1 (555) 555-6666	\N
207	Benjamin Scott	2	benjamin@example.com	+1 (555) 777-8888	\N
208	Catherine White	2	catherine@example.com	+1 (555) 999-0000	\N
209	Daniel Adams	2	daniel@example.com	+1 (555) 111-2222	\N
210	Elizabeth Johnson	2	elizabeth@example.com	+1 (555) 333-4444	\N
211	Frederick Lee	2	frederick@example.com	+1 (555) 555-6666	\N
\.


--
-- Data for Name: website; Type: TABLE DATA; Schema: public; Owner: c370_s141
--

COPY public.website (campaignid, phase, pushoutdate, description) FROM stdin;
11	upcoming	2024-03-15	\N
12	upcoming	2024-05-01	ready to push
13	upcoming	2024-06-01	description not finished yet
14	upcoming	2024-07-01	need image
15	upcoming	2024-08-15	tbd...
1	finished	2023-01-01	\N
2	finished	2023-02-01	\N
3	finished	2023-03-20	\N
4	finished	2023-04-15	\N
5	finished	2023-05-10	\N
6	finished	2023-06-05	\N
7	finished	2023-06-20	\N
8	finished	2023-07-20	\N
9	finished	2023-08-20	\N
10	finished	2023-09-20	\N
\.


--
-- Name: campaigns_campaignid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s141
--

SELECT pg_catalog.setval('public.campaigns_campaignid_seq', 105, true);


--
-- Name: donors_donorid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s141
--

SELECT pg_catalog.setval('public.donors_donorid_seq', 105, true);


--
-- Name: fundflow_transactionid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s141
--

SELECT pg_catalog.setval('public.fundflow_transactionid_seq', 510, true);


--
-- Name: participants_participantid_seq; Type: SEQUENCE SET; Schema: public; Owner: c370_s141
--

SELECT pg_catalog.setval('public.participants_participantid_seq', 211, true);


--
-- Name: campaign_participants campaign_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.campaign_participants
    ADD CONSTRAINT campaign_participants_pkey PRIMARY KEY (campaignid, participantid);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (campaignid);


--
-- Name: donors donors_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.donors
    ADD CONSTRAINT donors_pkey PRIMARY KEY (donorid);


--
-- Name: fundflow fundflow_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.fundflow
    ADD CONSTRAINT fundflow_pkey PRIMARY KEY (transactionid);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (participantid);


--
-- Name: view5 _RETURN; Type: RULE; Schema: public; Owner: c370_s141
--

CREATE OR REPLACE VIEW public.view5 AS
 SELECT c.campaignid,
    c.campaignname,
    count(cp.participantid) AS num_participants
   FROM (public.campaigns c
     LEFT JOIN public.campaign_participants cp ON ((c.campaignid = cp.campaignid)))
  GROUP BY c.campaignid
  ORDER BY c.campaignid;


--
-- Name: campaign_participants campaign_participants_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.campaign_participants
    ADD CONSTRAINT campaign_participants_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: campaign_participants campaign_participants_participantid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.campaign_participants
    ADD CONSTRAINT campaign_participants_participantid_fkey FOREIGN KEY (participantid) REFERENCES public.participants(participantid);


--
-- Name: fundflow fundflow_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.fundflow
    ADD CONSTRAINT fundflow_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- Name: fundflow fundflow_donorid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.fundflow
    ADD CONSTRAINT fundflow_donorid_fkey FOREIGN KEY (donorid) REFERENCES public.donors(donorid);


--
-- Name: website website_campaignid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: c370_s141
--

ALTER TABLE ONLY public.website
    ADD CONSTRAINT website_campaignid_fkey FOREIGN KEY (campaignid) REFERENCES public.campaigns(campaignid);


--
-- PostgreSQL database dump complete
--

