--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: AlertSeverity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AlertSeverity" AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH'
);


ALTER TYPE public."AlertSeverity" OWNER TO postgres;

--
-- Name: AlertStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AlertStatus" AS ENUM (
    'NEW',
    'ACKNOWLEDGED',
    'RESOLVED',
    'DISMISSED'
);


ALTER TYPE public."AlertStatus" OWNER TO postgres;

--
-- Name: AlertType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."AlertType" AS ENUM (
    'RESERVED_SLOT_CONFLICT',
    'WRONG_VEHICLE_TYPE',
    'UNKNOWN_OCCUPANCY',
    'NO_COMPATIBLE_SLOT'
);


ALTER TYPE public."AlertType" OWNER TO postgres;

--
-- Name: ReservationStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ReservationStatus" AS ENUM (
    'ACTIVE',
    'CANCELLED',
    'COMPLETED',
    'EXPIRED'
);


ALTER TYPE public."ReservationStatus" OWNER TO postgres;

--
-- Name: SessionStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SessionStatus" AS ENUM (
    'ACTIVE',
    'COMPLETED'
);


ALTER TYPE public."SessionStatus" OWNER TO postgres;

--
-- Name: SlotStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SlotStatus" AS ENUM (
    'AVAILABLE',
    'RESERVED',
    'OCCUPIED',
    'MAINTENANCE'
);


ALTER TYPE public."SlotStatus" OWNER TO postgres;

--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."UserRole" AS ENUM (
    'CUSTOMER',
    'SECURITY',
    'ADMIN'
);


ALTER TYPE public."UserRole" OWNER TO postgres;

--
-- Name: VehicleType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."VehicleType" AS ENUM (
    'CAR',
    'BIKE'
);


ALTER TYPE public."VehicleType" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Facility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Facility" (
    id text NOT NULL,
    name text NOT NULL,
    address text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Facility" OWNER TO postgres;

--
-- Name: ParkingAlert; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ParkingAlert" (
    id text NOT NULL,
    type public."AlertType" NOT NULL,
    severity public."AlertSeverity" NOT NULL,
    status public."AlertStatus" DEFAULT 'NEW'::public."AlertStatus" NOT NULL,
    message text NOT NULL,
    "expectedVehicleType" public."VehicleType",
    "detectedVehicleType" public."VehicleType",
    "userId" text,
    "vehicleId" text,
    "slotId" text,
    "reservationId" text,
    "acknowledgedBy" text,
    "acknowledgedAt" timestamp(3) without time zone,
    "resolvedBy" text,
    "resolvedAt" timestamp(3) without time zone,
    "resolutionNote" text,
    "evidenceImageUrl" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ParkingAlert" OWNER TO postgres;

--
-- Name: ParkingSession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ParkingSession" (
    id text NOT NULL,
    "vehicleId" text NOT NULL,
    "slotId" text NOT NULL,
    "reservationId" text NOT NULL,
    status public."SessionStatus" DEFAULT 'ACTIVE'::public."SessionStatus" NOT NULL,
    "startedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "endedAt" timestamp(3) without time zone
);


ALTER TABLE public."ParkingSession" OWNER TO postgres;

--
-- Name: ParkingSlot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ParkingSlot" (
    id text NOT NULL,
    code text NOT NULL,
    "vehicleType" public."VehicleType" NOT NULL,
    status public."SlotStatus" DEFAULT 'AVAILABLE'::public."SlotStatus" NOT NULL,
    "facilityId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ParkingSlot" OWNER TO postgres;

--
-- Name: Reservation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Reservation" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "vehicleId" text NOT NULL,
    "slotId" text NOT NULL,
    status public."ReservationStatus" DEFAULT 'ACTIVE'::public."ReservationStatus" NOT NULL,
    "startsAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "expiresAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Reservation" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role public."UserRole" DEFAULT 'CUSTOMER'::public."UserRole" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: Vehicle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Vehicle" (
    id text NOT NULL,
    "registrationNumber" text NOT NULL,
    type public."VehicleType" NOT NULL,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Vehicle" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Data for Name: Facility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Facility" (id, name, address, "createdAt") FROM stdin;
cmt4od8990003vgislbrjc133	Test Parking Facility	Test Address	2026-08-22 17:51:30.574
cmt5oxozs0003vguk04zjmues	Test Parking Facility	Test Address	2026-08-23 10:55:11.56
cmt5ozjlu0003vgrc1epo7fsn	Test Parking Facility	Test Address	2026-08-23 10:56:37.891
cmt5p7gie0003vgn0z7zmzus7	No Compatible Slot Facility	Test Address	2026-08-23 11:02:47.127
cmt7kusgm0003vg2giznni2sf	Test Parking Facility	Test Address	2026-08-24 18:36:29.975
cmt7l0hwe0003vgd85z6ge6sl	Test Parking Facility	Test Address	2026-08-24 18:40:56.223
cmt7l6hxx0003vg8gif9n5wdc	Test Parking Facility	Test Address	2026-08-24 18:45:36.214
cmt7l7q200003vgssgazicydr	Test Parking Facility	Test Address	2026-08-24 18:46:33.385
cmt7lmhgs0003vgn49j505abs	Test Parking Facility	Test Address	2026-08-24 18:58:02.092
cmt8op9gd0003vgscrr3q1kl4	Test Parking Facility	Test Address	2026-08-25 13:11:56.701
cmt8ordyi0003vgi82arlnuvq	Test Parking Facility	Test Address	2026-08-25 13:13:35.85
cmt8ovzcv0003vg2032anmd0s	Test Parking Facility	Test Address	2026-08-25 13:17:10.208
cmt8r4k8w0003vgh0n7bbyciu	Test Parking Facility	Test Address	2026-08-25 14:19:49.761
cmt8rkobi0003vg4onio88vhe	Test Parking Facility	Test Address	2026-08-25 14:32:21.535
cmt8rr2w70003vg9k17njfnkm	Test Parking Facility	Test Address	2026-08-25 14:37:20.36
\.


--
-- Data for Name: ParkingAlert; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ParkingAlert" (id, type, severity, status, message, "expectedVehicleType", "detectedVehicleType", "userId", "vehicleId", "slotId", "reservationId", "acknowledgedBy", "acknowledgedAt", "resolvedBy", "resolvedAt", "resolutionNote", "evidenceImageUrl", "createdAt", "updatedAt") FROM stdin;
cmt4k0ax40000vg78cnvolc7d	RESERVED_SLOT_CONFLICT	HIGH	RESOLVED	Wrong vehicle detected in another user reserved slot	BIKE	CAR	\N	\N	\N	\N	\N	2026-08-22 15:52:09.469	\N	2026-08-22 17:05:04.125	Security verified the vehicle and reassigned the slot.	\N	2026-08-22 15:49:29.028	2026-08-22 17:05:04.127
cmt5p8tku0001vg7sly7pwhyz	NO_COMPATIBLE_SLOT	HIGH	RESOLVED	Wrong vehicle detected and no compatible replacement slot is available.	CAR	BIKE	cmt5p7gi60000vgn0gh855m22	cmt5p7gib0002vgn07lclucm8	cmt5p7gig0005vgn008pqqzg8	cmt5p7gik0007vgn0r8dw7h7j	\N	2026-08-24 15:31:29.392	\N	2026-08-24 15:31:53.265	Admin reviewed the vehicle mismatch.	\N	2026-08-23 11:03:50.719	2026-08-24 15:31:53.267
\.


--
-- Data for Name: ParkingSession; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ParkingSession" (id, "vehicleId", "slotId", "reservationId", status, "startedAt", "endedAt") FROM stdin;
\.


--
-- Data for Name: ParkingSlot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ParkingSlot" (id, code, "vehicleType", status, "facilityId", "createdAt", "updatedAt") FROM stdin;
cmt4od89b0005vgisk11yvj0q	CAR-1787421090575	CAR	AVAILABLE	cmt4od8990003vgislbrjc133	2026-08-22 17:51:30.576	2026-08-22 18:10:10.793
cmt4od89f0007vgisiax5xj6u	BIKE-1787421090578	BIKE	RESERVED	cmt4od8990003vgislbrjc133	2026-08-22 17:51:30.579	2026-08-22 18:10:10.794
cmt5oxozv0005vguk3epby6oy	CAR-1787482511562	CAR	RESERVED	cmt5oxozs0003vguk04zjmues	2026-08-23 10:55:11.563	2026-08-23 10:55:11.563
cmt5oxozz0007vgukpb7ipucd	BIKE-1787482511566	BIKE	AVAILABLE	cmt5oxozs0003vguk04zjmues	2026-08-23 10:55:11.567	2026-08-23 10:55:11.567
cmt5ozjlw0005vgrc9h8j88mm	CAR-1787482597890	CAR	AVAILABLE	cmt5ozjlu0003vgrc1epo7fsn	2026-08-23 10:56:37.892	2026-08-23 10:58:06.982
cmt5ozjly0007vgrc9mrtgz2e	BIKE-1787482597893	BIKE	RESERVED	cmt5ozjlu0003vgrc1epo7fsn	2026-08-23 10:56:37.894	2026-08-23 10:58:06.987
cmt5p7gig0005vgn008pqqzg8	CAR-1787482967127	CAR	RESERVED	cmt5p7gie0003vgn0z7zmzus7	2026-08-23 11:02:47.128	2026-08-23 11:02:47.128
cmt7kusgo0005vg2g7mh9u0er	CAR-1787596589976	CAR	RESERVED	cmt7kusgm0003vg2giznni2sf	2026-08-24 18:36:29.977	2026-08-24 18:36:29.977
cmt7kusgr0007vg2gd9laxczu	BIKE-1787596589979	BIKE	AVAILABLE	cmt7kusgm0003vg2giznni2sf	2026-08-24 18:36:29.98	2026-08-24 18:36:29.98
cmt7l0hwg0005vgd83pdxsxif	CAR-1787596856223	CAR	RESERVED	cmt7l0hwe0003vgd85z6ge6sl	2026-08-24 18:40:56.224	2026-08-24 18:40:56.224
cmt7l0hwi0007vgd83otlmage	BIKE-1787596856225	BIKE	AVAILABLE	cmt7l0hwe0003vgd85z6ge6sl	2026-08-24 18:40:56.226	2026-08-24 18:40:56.226
cmt7l6hxz0005vg8gu2squ8kq	CAR-1787597136214	CAR	RESERVED	cmt7l6hxx0003vg8gif9n5wdc	2026-08-24 18:45:36.215	2026-08-24 18:45:36.215
cmt7l6hy10007vg8grt38f8i0	BIKE-1787597136216	BIKE	AVAILABLE	cmt7l6hxx0003vg8gif9n5wdc	2026-08-24 18:45:36.218	2026-08-24 18:45:36.218
cmt7l7q220005vgss3ftgtjvz	CAR-1787597193385	CAR	RESERVED	cmt7l7q200003vgssgazicydr	2026-08-24 18:46:33.386	2026-08-24 18:46:33.386
cmt7l7q240007vgss62gtv8tc	BIKE-1787597193388	BIKE	AVAILABLE	cmt7l7q200003vgssgazicydr	2026-08-24 18:46:33.389	2026-08-24 18:46:33.389
cmt7lmhgt0005vgn46a8860dq	CAR-1787597882093	CAR	RESERVED	cmt7lmhgs0003vgn49j505abs	2026-08-24 18:58:02.094	2026-08-24 18:58:02.094
cmt7lmhgx0007vgn4s1nf4wbe	BIKE-1787597882096	BIKE	AVAILABLE	cmt7lmhgs0003vgn49j505abs	2026-08-24 18:58:02.097	2026-08-24 18:58:02.097
cmt8op9gf0005vgscup2ls51i	CAR-1787663516703	CAR	RESERVED	cmt8op9gd0003vgscrr3q1kl4	2026-08-25 13:11:56.704	2026-08-25 13:11:56.704
cmt8op9gi0007vgscj4llfug1	BIKE-1787663516706	BIKE	AVAILABLE	cmt8op9gd0003vgscrr3q1kl4	2026-08-25 13:11:56.707	2026-08-25 13:11:56.707
cmt8ordyj0005vgi853b4cyvy	CAR-1787663615851	CAR	RESERVED	cmt8ordyi0003vgi82arlnuvq	2026-08-25 13:13:35.852	2026-08-25 13:13:35.852
cmt8ordym0007vgi8aivjsomi	BIKE-1787663615853	BIKE	AVAILABLE	cmt8ordyi0003vgi82arlnuvq	2026-08-25 13:13:35.854	2026-08-25 13:13:35.854
cmt8ovzcw0005vg20175hx0q1	CAR-1787663830208	CAR	RESERVED	cmt8ovzcv0003vg2032anmd0s	2026-08-25 13:17:10.209	2026-08-25 13:17:10.209
cmt8ovzcy0007vg209vskt9rc	BIKE-1787663830210	BIKE	AVAILABLE	cmt8ovzcv0003vg2032anmd0s	2026-08-25 13:17:10.211	2026-08-25 13:17:10.211
cmt8r4k8y0005vgh0ed1q9bp1	CAR-1787667589762	CAR	RESERVED	cmt8r4k8w0003vgh0n7bbyciu	2026-08-25 14:19:49.763	2026-08-25 14:19:49.763
cmt8r4k910007vgh0w5ooqutg	BIKE-1787667589764	BIKE	AVAILABLE	cmt8r4k8w0003vgh0n7bbyciu	2026-08-25 14:19:49.765	2026-08-25 14:19:49.765
cmt8rkobl0005vg4oo443a2em	CAR-1787668341536	CAR	RESERVED	cmt8rkobi0003vg4onio88vhe	2026-08-25 14:32:21.537	2026-08-25 14:32:21.537
cmt8rkobo0007vg4oiwdlxnz9	BIKE-1787668341539	BIKE	AVAILABLE	cmt8rkobi0003vg4onio88vhe	2026-08-25 14:32:21.54	2026-08-25 14:32:21.54
cmt8rr2w90005vg9kic483uag	CAR-1787668640359	CAR	RESERVED	cmt8rr2w70003vg9k17njfnkm	2026-08-25 14:37:20.361	2026-08-25 14:37:20.361
cmt8rr2wc0007vg9kl03pduc4	BIKE-1787668640362	BIKE	AVAILABLE	cmt8rr2w70003vg9k17njfnkm	2026-08-25 14:37:20.364	2026-08-25 14:37:20.364
\.


--
-- Data for Name: Reservation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Reservation" (id, "userId", "vehicleId", "slotId", status, "startsAt", "expiresAt", "createdAt") FROM stdin;
cmt4od89g0009vgis6596zgb3	cmt4od88y0000vgisdo70hfqk	cmt4od8950002vgisjclnzphg	cmt4od89f0007vgisiax5xj6u	ACTIVE	2026-08-22 17:51:30.58	\N	2026-08-22 17:51:30.58
cmt5oxozz0009vgukbrsj36vn	cmt5oxoxx0000vgukdmqrryli	cmt5oxoz80002vgukqml2acxz	cmt5oxozv0005vguk3epby6oy	ACTIVE	2026-08-23 10:55:11.568	\N	2026-08-23 10:55:11.568
cmt5ozjly0009vgrcb5iu1t2j	cmt5ozjll0000vgrckna0wj8d	cmt5ozjlr0002vgrcyk415577	cmt5ozjly0007vgrc9mrtgz2e	ACTIVE	2026-08-23 10:56:37.895	\N	2026-08-23 10:56:37.895
cmt5p7gik0007vgn0r8dw7h7j	cmt5p7gi60000vgn0gh855m22	cmt5p7gib0002vgn07lclucm8	cmt5p7gig0005vgn008pqqzg8	ACTIVE	2026-08-23 11:02:47.133	\N	2026-08-23 11:02:47.133
cmt7kusgt0009vg2g14pytq2z	cmt7kusfw0000vg2gb25xnlke	cmt7kusgh0002vg2gzq5ry63z	cmt7kusgo0005vg2g7mh9u0er	ACTIVE	2026-08-24 18:36:29.981	\N	2026-08-24 18:36:29.981
cmt7l0hwj0009vgd88iju9k96	cmt7l0hw30000vgd8puz58w7t	cmt7l0hwa0002vgd8asawjl9z	cmt7l0hwg0005vgd83pdxsxif	ACTIVE	2026-08-24 18:40:56.227	\N	2026-08-24 18:40:56.227
cmt7l6hy20009vg8gsupri1as	cmt7l6hxp0000vg8gkrxtxq8u	cmt7l6hxu0002vg8gnvix2isl	cmt7l6hxz0005vg8gu2squ8kq	ACTIVE	2026-08-24 18:45:36.218	\N	2026-08-24 18:45:36.218
cmt7l7q250009vgss49sjjdrw	cmt7l7q1s0000vgssd9rj5iod	cmt7l7q1x0002vgss4ph83quz	cmt7l7q220005vgss3ftgtjvz	ACTIVE	2026-08-24 18:46:33.39	\N	2026-08-24 18:46:33.39
cmt7lmhgy0009vgn4m60dvng9	cmt7lmhgj0000vgn4f5cc29u2	cmt7lmhgo0002vgn4du2z563c	cmt7lmhgt0005vgn46a8860dq	ACTIVE	2026-08-24 18:58:02.099	\N	2026-08-24 18:58:02.099
cmt8op9gk0009vgscetl3w08c	cmt8op9fn0000vgsckxm3s1ex	cmt8op9g70002vgsc46jjb60a	cmt8op9gf0005vgscup2ls51i	ACTIVE	2026-08-25 13:11:56.708	\N	2026-08-25 13:11:56.708
cmt8ordyn0009vgi89h1gi6pm	cmt8ordya0000vgi8027r0vr0	cmt8ordyf0002vgi8779bmpke	cmt8ordyj0005vgi853b4cyvy	ACTIVE	2026-08-25 13:13:35.855	\N	2026-08-25 13:13:35.855
cmt8ovzcz0009vg20v4uaeujj	cmt8ovzcm0000vg20mx8vac52	cmt8ovzcs0002vg200jwer0an	cmt8ovzcw0005vg20175hx0q1	ACTIVE	2026-08-25 13:17:10.212	\N	2026-08-25 13:17:10.212
cmt8r4k920009vgh08nnrtjvb	cmt8r4k860000vgh03lxgg499	cmt8r4k8s0002vgh0e93jhclj	cmt8r4k8y0005vgh0ed1q9bp1	ACTIVE	2026-08-25 14:19:49.767	\N	2026-08-25 14:19:49.767
cmt8rkobp0009vg4otvc04e8g	cmt8rkob80000vg4owfsrqu5z	cmt8rkobf0002vg4on5c0saj8	cmt8rkobl0005vg4oo443a2em	ACTIVE	2026-08-25 14:32:21.541	\N	2026-08-25 14:32:21.541
cmt8rr2wd0009vg9kqr6qmhbn	cmt8rr2vx0000vg9ks3syx9r3	cmt8rr2w30002vg9kq356rdqb	cmt8rr2w90005vg9kic483uag	ACTIVE	2026-08-25 14:37:20.365	\N	2026-08-25 14:37:20.365
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, name, email, password, role, "createdAt", "updatedAt") FROM stdin;
cmt4od88y0000vgisdo70hfqk	Test Customer	test-1787421090503@parkease.local	test-password	CUSTOMER	2026-08-22 17:51:30.563	2026-08-22 17:51:30.563
cmt5oxoxx0000vgukdmqrryli	Test Customer	test-1787482511433@parkease.local	test-password	CUSTOMER	2026-08-23 10:55:11.492	2026-08-23 10:55:11.492
cmt5ozjll0000vgrckna0wj8d	Test Customer	test-1787482597821@parkease.local	test-password	CUSTOMER	2026-08-23 10:56:37.881	2026-08-23 10:56:37.881
cmt5p7gi60000vgn0gh855m22	No Slot Test Customer	noslot-1787482967057@parkease.local	test-password	CUSTOMER	2026-08-23 11:02:47.118	2026-08-23 11:02:47.118
cmt7kusfw0000vg2gb25xnlke	Test Customer	test-1787596589824@parkease.local	$2b$10$0Hl6vVX/UuxYaQjO6lg0bem5RuE.6trf5KOAOFZT89num2.bzSr3u	CUSTOMER	2026-08-24 18:36:29.947	2026-08-24 18:36:29.947
cmt7l0hw30000vgd8puz58w7t	Test Customer	test-1787596856081@parkease.local	$2b$10$zk2PauTVIYAq4Tk.I7BYcegN/KND8FRXs/DHfXL8lHMH7YgBM6262	CUSTOMER	2026-08-24 18:40:56.212	2026-08-24 18:40:56.212
cmt7l6hxp0000vg8gkrxtxq8u	Test Customer	test-1787597136099@parkease.local	$2b$10$jYRa17uMnLJpAu72cRC9cOuc5b2LlzvfKtl8IK.GADrfQsOyjfyK6	CUSTOMER	2026-08-24 18:45:36.206	2026-08-24 18:45:36.206
cmt7l7q1s0000vgssd9rj5iod	Test Administrator	admin-1787597193261@parkease.local	$2b$10$cXlnY5v5QdG2i5d/Qw4tGeN.iPWLMJgG.JftKajnTX6W2GxHDvKx6	CUSTOMER	2026-08-24 18:46:33.377	2026-08-24 18:46:33.377
cmt7lmhgj0000vgn4f5cc29u2	Test Administrator	admin-1787597881968@parkease.local	$2b$10$3tmZlAdN8IaatGwwRHJP3.7gMLzqLcuf.JuIiLoLqO1.Xgo7O3dEa	ADMIN	2026-08-24 18:58:02.084	2026-08-24 18:58:02.084
cmt8op9fn0000vgsckxm3s1ex	Test Customer	test-1787663516622@parkease.local	test-password	CUSTOMER	2026-08-25 13:11:56.675	2026-08-25 13:11:56.675
cmt8ordya0000vgi8027r0vr0	Test Customer	test-1787663615796@parkease.local	test-password	CUSTOMER	2026-08-25 13:13:35.842	2026-08-25 13:13:35.842
cmt8ovzcm0000vg20mx8vac52	Test Administrator	admin-1787663829966@parkease.local	$2b$10$Slg1kc5cyInt/fFikw65B.W.UrTrfUH5GnrxME8BQD8e7IR2w29GW	ADMIN	2026-08-25 13:17:10.199	2026-08-25 13:17:10.199
cmt8r4k860000vgh03lxgg499	Test Administrator	admin-1787667589620@parkease.local	$2b$10$6dTCmMBkZDVjMhi2dc934eWL40kAlYZrvikN1UY2/qW1Zs4UIQi1m	ADMIN	2026-08-25 14:19:49.732	2026-08-25 14:19:49.732
cmt8rkob80000vg4owfsrqu5z	Test Administrator	admin-1787668341418@parkease.local	$2b$10$3sdg4/8HWaX/eDMJwdMTB.AyueoJ.XudmhaJGtNSkjbZ8xDh98ogi	ADMIN	2026-08-25 14:32:21.525	2026-08-25 14:32:21.525
cmt8rr2vx0000vg9ks3syx9r3	Test Administrator	admin-1787668640213@parkease.local	$2b$10$kcg2L9oRR4HFJEtZ9Gz/a.cLBvaP2x2AmtzVtmCl7KzR2O3QRSh4O	ADMIN	2026-08-25 14:37:20.35	2026-08-25 14:37:20.35
\.


--
-- Data for Name: Vehicle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Vehicle" (id, "registrationNumber", type, "userId", "createdAt") FROM stdin;
cmt4od8950002vgisjclnzphg	TEST-1787421090567	CAR	cmt4od88y0000vgisdo70hfqk	2026-08-22 17:51:30.568
cmt5oxoz80002vgukqml2acxz	TEST-1787482511538	CAR	cmt5oxoxx0000vgukdmqrryli	2026-08-23 10:55:11.54
cmt5ozjlr0002vgrcyk415577	TEST-1787482597885	CAR	cmt5ozjll0000vgrckna0wj8d	2026-08-23 10:56:37.887
cmt5p7gib0002vgn07lclucm8	NOSLOT-1787482967122	CAR	cmt5p7gi60000vgn0gh855m22	2026-08-23 11:02:47.123
cmt7kusgh0002vg2gzq5ry63z	TEST-1787596589968	CAR	cmt7kusfw0000vg2gb25xnlke	2026-08-24 18:36:29.969
cmt7l0hwa0002vgd8asawjl9z	TEST-1787596856217	CAR	cmt7l0hw30000vgd8puz58w7t	2026-08-24 18:40:56.218
cmt7l6hxu0002vg8gnvix2isl	TEST-1787597136210	CAR	cmt7l6hxp0000vg8gkrxtxq8u	2026-08-24 18:45:36.211
cmt7l7q1x0002vgss4ph83quz	TEST-1787597193380	CAR	cmt7l7q1s0000vgssd9rj5iod	2026-08-24 18:46:33.382
cmt7lmhgo0002vgn4du2z563c	TEST-1787597882087	CAR	cmt7lmhgj0000vgn4f5cc29u2	2026-08-24 18:58:02.088
cmt8op9g70002vgsc46jjb60a	TEST-1787663516693	CAR	cmt8op9fn0000vgsckxm3s1ex	2026-08-25 13:11:56.694
cmt8ordyf0002vgi8779bmpke	TEST-1787663615846	CAR	cmt8ordya0000vgi8027r0vr0	2026-08-25 13:13:35.847
cmt8ovzcs0002vg200jwer0an	TEST-1787663830204	CAR	cmt8ovzcm0000vg20mx8vac52	2026-08-25 13:17:10.204
cmt8r4k8s0002vgh0e93jhclj	TEST-1787667589754	CAR	cmt8r4k860000vgh03lxgg499	2026-08-25 14:19:49.755
cmt8rkobf0002vg4on5c0saj8	TEST-1787668341530	CAR	cmt8rkob80000vg4owfsrqu5z	2026-08-25 14:32:21.531
cmt8rr2w30002vg9kq356rdqb	TEST-1787668640353	CAR	cmt8rr2vx0000vg9ks3syx9r3	2026-08-25 14:37:20.356
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
83c00a95-d4ac-4718-b29f-ce54ac63d4a9	d12c57b73be8d24e011ec6b8ce05b307a6f040472e00f0ded6f961caee741977	2026-08-22 20:55:08.191491+05:30	20260822152508_init	\N	\N	2026-08-22 20:55:08.139785+05:30	1
\.


--
-- Name: Facility Facility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Facility"
    ADD CONSTRAINT "Facility_pkey" PRIMARY KEY (id);


--
-- Name: ParkingAlert ParkingAlert_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingAlert"
    ADD CONSTRAINT "ParkingAlert_pkey" PRIMARY KEY (id);


--
-- Name: ParkingSession ParkingSession_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingSession"
    ADD CONSTRAINT "ParkingSession_pkey" PRIMARY KEY (id);


--
-- Name: ParkingSlot ParkingSlot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingSlot"
    ADD CONSTRAINT "ParkingSlot_pkey" PRIMARY KEY (id);


--
-- Name: Reservation Reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservation"
    ADD CONSTRAINT "Reservation_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Vehicle Vehicle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vehicle"
    ADD CONSTRAINT "Vehicle_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: ParkingAlert_createdAt_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ParkingAlert_createdAt_idx" ON public."ParkingAlert" USING btree ("createdAt");


--
-- Name: ParkingAlert_severity_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ParkingAlert_severity_idx" ON public."ParkingAlert" USING btree (severity);


--
-- Name: ParkingAlert_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "ParkingAlert_status_idx" ON public."ParkingAlert" USING btree (status);


--
-- Name: ParkingSession_reservationId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "ParkingSession_reservationId_key" ON public."ParkingSession" USING btree ("reservationId");


--
-- Name: ParkingSlot_facilityId_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "ParkingSlot_facilityId_code_key" ON public."ParkingSlot" USING btree ("facilityId", code);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: Vehicle_registrationNumber_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Vehicle_registrationNumber_key" ON public."Vehicle" USING btree ("registrationNumber");


--
-- Name: ParkingAlert ParkingAlert_reservationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingAlert"
    ADD CONSTRAINT "ParkingAlert_reservationId_fkey" FOREIGN KEY ("reservationId") REFERENCES public."Reservation"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ParkingAlert ParkingAlert_slotId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingAlert"
    ADD CONSTRAINT "ParkingAlert_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES public."ParkingSlot"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ParkingAlert ParkingAlert_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingAlert"
    ADD CONSTRAINT "ParkingAlert_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ParkingAlert ParkingAlert_vehicleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingAlert"
    ADD CONSTRAINT "ParkingAlert_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES public."Vehicle"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ParkingSession ParkingSession_reservationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingSession"
    ADD CONSTRAINT "ParkingSession_reservationId_fkey" FOREIGN KEY ("reservationId") REFERENCES public."Reservation"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ParkingSession ParkingSession_slotId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingSession"
    ADD CONSTRAINT "ParkingSession_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES public."ParkingSlot"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ParkingSession ParkingSession_vehicleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingSession"
    ADD CONSTRAINT "ParkingSession_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES public."Vehicle"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ParkingSlot ParkingSlot_facilityId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ParkingSlot"
    ADD CONSTRAINT "ParkingSlot_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES public."Facility"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Reservation Reservation_slotId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservation"
    ADD CONSTRAINT "Reservation_slotId_fkey" FOREIGN KEY ("slotId") REFERENCES public."ParkingSlot"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Reservation Reservation_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservation"
    ADD CONSTRAINT "Reservation_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Reservation Reservation_vehicleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Reservation"
    ADD CONSTRAINT "Reservation_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES public."Vehicle"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Vehicle Vehicle_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vehicle"
    ADD CONSTRAINT "Vehicle_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

