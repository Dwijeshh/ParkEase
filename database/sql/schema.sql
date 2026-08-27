-- =========================================================
-- PARKEASE SMART PARKING DATABASE SCHEMA & SEED DATA
-- =========================================================

-- =========================================================
-- 1. MAP NODES
-- =========================================================
DROP TABLE IF EXISTS map_nodes CASCADE;
CREATE TABLE map_nodes (
    node_id SERIAL PRIMARY KEY,
    node_type VARCHAR(20) NOT NULL
        CHECK (node_type IN ('ENTRY', 'EXIT', 'JUNCTION', 'PARKING','MALL_ENTRY')),
    x_coordinate DOUBLE PRECISION NOT NULL,
    y_coordinate DOUBLE PRECISION NOT NULL
);

-- Mall Entrance
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('MALL_ENTRY', 412, 157);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('MALL_ENTRY', 412, 324);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('MALL_ENTRY', 412, 492);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('MALL_ENTRY', 412, 685);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('MALL_ENTRY', 412, 836);

-- Parking Entrance and Exit
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('ENTRY', 865, 40);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('EXIT', 1150, 950);

-- Critical junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 180); -- Entrance junction
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 180); -- A Row junction left
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 180); -- A Row junction Right
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 745); -- A Column junction left
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 745); -- A Column junction right
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 745); -- Exit Junction

-- A05 to A01 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 725, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 675, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 625, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 510, 180);

-- A05 to A01 parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 725, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 675, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 565, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 510, 135);

-- A07 to A10 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 980, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1034, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1089, 180);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1138, 180);

-- A07 to A10 parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 980, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1034, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1089, 135);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1138, 135);

-- C01 to C10 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 683);

-- C01 to C10 Parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 625, 683);

-- B01 to B13 Junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 223);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 247);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 281);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 358);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 386);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 412);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 471);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 534);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 561);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 592);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 613);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 651);

-- B01 to B13 Parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 223);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 247);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 281);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 358);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 386);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 412);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 471);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 534);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 561);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 592);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 613);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 485, 651);

-- E02 to E13 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 520, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 565, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 617, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 665, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 717, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 763, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 855, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 900, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 950, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 998, 745);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1049, 745);

-- E02 to E13 parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 520, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 565, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 617, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 665, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 717, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 763, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 855, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 900, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 950, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 998, 825);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1049, 825);

-- C11 to C20 and C21 to C30 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 865, 683);

-- C11 to C20 Parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 800, 683);

-- C21 to C30 Parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 920, 683);

-- D01 to D12 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 225);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 265);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 312);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 356);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 402);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 446);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 490);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 533);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 577);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 621);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 664);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 707);

-- D01 to D12 Parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 225);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 265);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 312);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 356);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 402);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 446);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 490);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 533);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 577);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 621);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 664);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1235, 707);

-- C31 to C40 junctions
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('JUNCTION', 1145, 683);

-- C31 to C40 Parkings
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 315);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 357);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 398);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 438);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 479);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 520);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 559);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 603);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 640);
INSERT INTO map_nodes (node_type, x_coordinate, y_coordinate)
VALUES ('PARKING', 1090, 683);

-- =========================================================
-- 2. MAP EDGES & TRIGGER
-- =========================================================
DROP TABLE IF EXISTS map_edges CASCADE;
CREATE TABLE map_edges (
    edge_id SERIAL PRIMARY KEY,
    from_node INTEGER NOT NULL REFERENCES map_nodes(node_id),
    to_node INTEGER NOT NULL REFERENCES map_nodes(node_id),
    distance DOUBLE PRECISION NOT NULL
);

CREATE OR REPLACE FUNCTION calculate_edge_distance()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT SQRT(
        POWER(n2.x_coordinate - n1.x_coordinate, 2) +
        POWER(n2.y_coordinate - n1.y_coordinate, 2)
    )
    INTO NEW.distance
    FROM map_nodes n1
    JOIN map_nodes n2
        ON n2.node_id = NEW.to_node
    WHERE n1.node_id = NEW.from_node;

    RETURN NEW;
END;
$$;

CREATE TRIGGER edge_distance_trigger
BEFORE INSERT OR UPDATE ON map_edges
FOR EACH ROW
EXECUTE FUNCTION calculate_edge_distance();

-- Entrance to entrance joint
INSERT INTO map_edges (from_node, to_node)
VALUES (6, 8);

-- Exit joint to Exit
INSERT INTO map_edges (from_node, to_node)
VALUES (12, 7);

-- A05 to A01 junctions
INSERT INTO map_edges (from_node, to_node)
VALUES (8, 14), (14, 15), (15, 16), (16, 17), (17, 18), (18, 17);

-- Junction to parking
INSERT INTO map_edges (from_node, to_node)
VALUES
(23, 18), (18, 23),
(22, 17), (17, 22),
(21, 16), (16, 21),
(20, 15), (15, 20),
(19, 14), (14, 19);

-- Left column
INSERT INTO map_edges (from_node, to_node)
VALUES
(17, 52), (52, 53), (53, 54), (54, 32), (32, 33), (33, 55), (55, 56), (56, 34), (34, 57), (57, 58), (58, 35), (35, 59), (59, 36),
(36, 37), (37, 60), (60, 38), (38, 61), (61, 62), (62, 39), (39, 63), (63, 40), (40, 64), (64, 41), (41, 79);

-- Left line B and C parkings
INSERT INTO map_edges (from_node, to_node)
VALUES
(65, 52), (52, 65), (66, 53), (53, 66), (67, 54), (54, 67), (32, 42), (42, 32), (68, 55), (55, 68), (33, 43), (43, 33), (56, 69), (69, 56),
(34, 44), (44, 34), (57, 70), (70, 57), (71, 58), (58, 71), (35, 45), (45, 35), (59, 72), (72, 59), (36, 46), (46, 36), (37, 47), (47, 37),
(73, 60), (60, 73), (38, 48), (48, 38), (61, 74), (74, 61), (62, 75), (75, 62), (39, 49), (49, 39), (63, 76), (76, 63), (40, 50), (50, 40),
(64, 77), (77, 64), (41, 51), (51, 41);

-- Bottom row link
INSERT INTO map_edges (from_node, to_node)
VALUES
(78, 79), (79, 78), (79, 80), (80, 81), (81, 82), (82, 83), (83, 84), (84, 13), (13, 85), (85, 86), (86, 87), (87, 88), (88, 12);

-- E parking and joints
INSERT INTO map_edges (from_node, to_node)
VALUES
(78, 89), (89, 78), (79, 90), (90, 79), (80, 91), (91, 80), (81, 92), (92, 81), (82, 93), (93, 82),
(83, 94), (94, 83), (84, 95), (95, 84), (85, 96), (96, 85), (86, 97), (97, 86), (87, 98), (98, 87),
(88, 99), (99, 88);

-- Middle vertical line
INSERT INTO map_edges (from_node, to_node)
VALUES
(8, 100), (100, 101), (101, 102), (102, 103), (103, 104), (104, 105),
(105, 106), (106, 107), (107, 108), (108, 109), (109, 13);

-- Middle junctions and parkings
INSERT INTO map_edges (from_node, to_node)
VALUES
(100, 110), (110, 100), (100, 120), (120, 100),
(101, 111), (111, 101), (101, 121), (121, 101),
(102, 112), (112, 102), (102, 122), (122, 102),
(103, 113), (113, 103), (103, 123), (123, 103),
(104, 114), (114, 104), (104, 124), (124, 104),
(105, 115), (115, 105), (105, 125), (125, 105),
(106, 116), (116, 106), (106, 126), (126, 106),
(107, 117), (117, 107), (107, 127), (127, 107),
(108, 118), (118, 108), (108, 128), (128, 108),
(109, 119), (119, 109), (109, 129), (129, 109);

-- Right horizontal line
INSERT INTO map_edges (from_node, to_node)
VALUES
(12, 141), (141, 163), (163, 140), (140, 162), (162, 139), (139, 161), (161, 138), (138, 160), (160, 137), (137, 159), (159, 136), (136, 158),
(158, 135), (135, 157), (157, 134), (134, 156), (156, 155), (155, 133), (133, 154), (154, 132), (132, 131), (131, 130), (130, 10);

-- Right side parking and junctions
INSERT INTO map_edges (from_node, to_node)
VALUES
(141, 153), (153, 141), (163, 173), (173, 163), (140, 152), (152, 140), (162, 172), (172, 162),
(139, 151), (151, 139), (161, 171), (171, 161), (138, 150), (150, 138), (160, 170), (170, 160),
(137, 149), (149, 137), (159, 169), (169, 159), (136, 148), (148, 136), (158, 168), (168, 158),
(135, 147), (147, 135), (157, 167), (167, 157), (134, 146), (146, 134), (156, 166), (166, 156),
(133, 145), (145, 133), (155, 165), (165, 155), (154, 164), (164, 154), (132, 144), (144, 132),
(131, 143), (143, 131), (130, 142), (142, 130);

-- Right side junctions of entrance A
INSERT INTO map_edges (from_node, to_node)
VALUES
(10, 27), (27, 26), (26, 25), (25, 24), (24, 8);

-- Right side parkings of entrance A
INSERT INTO map_edges (from_node, to_node)
VALUES
(27, 31), (31, 27), (26, 30), (30, 26), (25, 29), (29, 25), (25, 24), (24, 28), (28, 24);

-- =========================================================
-- 3. PARKING MALL DISTANCE
-- =========================================================
DROP TABLE IF EXISTS parking_mall_distance CASCADE;
CREATE TABLE parking_mall_distance (
    parking_node_id INTEGER NOT NULL
        REFERENCES map_nodes(node_id),
    mall_entrance_id INTEGER NOT NULL
        REFERENCES map_nodes(node_id),
    distance DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (parking_node_id, mall_entrance_id)
);

INSERT INTO parking_mall_distance
    (parking_node_id, mall_entrance_id, distance)
SELECT
    p.node_id,
    m.node_id,
    SQRT(
        POWER(p.x_coordinate - m.x_coordinate, 2) +
        POWER(p.y_coordinate - m.y_coordinate, 2)
    )
FROM map_nodes p
CROSS JOIN map_nodes m
WHERE p.node_type = 'PARKING'
  AND m.node_id IN (1, 2, 3, 4, 5);

-- =========================================================
-- 4. PARKING ROUTES (DIJKSTRA PRECOMPUTATION)
-- =========================================================
DROP TABLE IF EXISTS parking_routes CASCADE;
CREATE TABLE parking_routes (
    parking_node_id INTEGER PRIMARY KEY
        REFERENCES map_nodes(node_id),
    source_node_id INTEGER NOT NULL
        REFERENCES map_nodes(node_id),
    total_distance DOUBLE PRECISION NOT NULL,
    route_nodes INTEGER[] NOT NULL
);

CREATE OR REPLACE FUNCTION precompute_parking_routes(
    start_node INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    current_node INTEGER;
    next_node INTEGER;
    edge_distance DOUBLE PRECISION;
    new_distance DOUBLE PRECISION;
    min_distance DOUBLE PRECISION;
    path INTEGER[];
BEGIN
    CREATE TEMP TABLE dijkstra_state (
        node_id INTEGER PRIMARY KEY,
        distance DOUBLE PRECISION,
        previous_node INTEGER,
        visited BOOLEAN DEFAULT FALSE
    ) ON COMMIT DROP;

    INSERT INTO dijkstra_state (node_id, distance, previous_node)
    SELECT
        node_id,
        CASE
            WHEN node_id = start_node THEN 0
            ELSE 'Infinity'::DOUBLE PRECISION
        END,
        NULL
    FROM map_nodes;

    LOOP
        SELECT node_id, distance
        INTO current_node, min_distance
        FROM dijkstra_state
        WHERE visited = FALSE
        ORDER BY distance
        LIMIT 1;

        IF current_node IS NULL
           OR min_distance = 'Infinity'::DOUBLE PRECISION THEN
            EXIT;
        END IF;

        UPDATE dijkstra_state
        SET visited = TRUE
        WHERE node_id = current_node;

        FOR next_node, edge_distance IN
            SELECT
                e.to_node,
                e.distance
            FROM map_edges e
            WHERE e.from_node = current_node
        LOOP
            new_distance := min_distance + edge_distance;

            UPDATE dijkstra_state
            SET
                distance = new_distance,
                previous_node = current_node
            WHERE node_id = next_node
              AND visited = FALSE
              AND new_distance < distance;
        END LOOP;
    END LOOP;

    FOR current_node IN
        SELECT node_id
        FROM map_nodes
        WHERE node_type = 'PARKING'
    LOOP
        IF (
            SELECT distance
            FROM dijkstra_state
            WHERE node_id = current_node
        ) = 'Infinity'::DOUBLE PRECISION THEN
            CONTINUE;
        END IF;

        path := ARRAY[current_node];
        next_node := current_node;

        LOOP
            SELECT previous_node
            INTO next_node
            FROM dijkstra_state
            WHERE node_id = next_node;

            EXIT WHEN next_node IS NULL;
            path := next_node || path;
        END LOOP;

        INSERT INTO parking_routes (
            parking_node_id,
            source_node_id,
            total_distance,
            route_nodes
        )
        SELECT
            current_node,
            start_node,
            distance,
            path
        FROM dijkstra_state
        WHERE node_id = current_node
        ON CONFLICT (parking_node_id)
        DO UPDATE SET
            source_node_id = EXCLUDED.source_node_id,
            total_distance = EXCLUDED.total_distance,
            route_nodes = EXCLUDED.route_nodes;
    END LOOP;
END;
$$;

SELECT precompute_parking_routes(6);

-- =========================================================
-- 5. PARKING EXIT ROUTES (DIJKSTRA BACKWARDS)
-- =========================================================
DROP TABLE IF EXISTS parking_exit_routes CASCADE;
CREATE TABLE parking_exit_routes (
    parking_node_id INTEGER PRIMARY KEY
        REFERENCES map_nodes(node_id),
    destination_node_id INTEGER NOT NULL
        REFERENCES map_nodes(node_id),
    total_distance DOUBLE PRECISION NOT NULL,
    route_nodes INTEGER[] NOT NULL
);

CREATE OR REPLACE FUNCTION precompute_parking_exit_routes(
    exit_node INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    current_node INTEGER;
    route_next_node INTEGER;
    edge_distance DOUBLE PRECISION;
    new_distance DOUBLE PRECISION;
    min_distance DOUBLE PRECISION;
    path INTEGER[];
BEGIN
    CREATE TEMP TABLE dijkstra_exit_state (
        node_id INTEGER PRIMARY KEY,
        distance DOUBLE PRECISION,
        next_node INTEGER,
        visited BOOLEAN DEFAULT FALSE
    ) ON COMMIT DROP;

    INSERT INTO dijkstra_exit_state (
        node_id,
        distance,
        next_node
    )
    SELECT
        node_id,
        CASE
            WHEN node_id = exit_node THEN 0
            ELSE 'Infinity'::DOUBLE PRECISION
        END,
        NULL
    FROM map_nodes;

    LOOP
        SELECT ds.node_id, ds.distance
        INTO current_node, min_distance
        FROM dijkstra_exit_state AS ds
        WHERE ds.visited = FALSE
        ORDER BY ds.distance
        LIMIT 1;

        IF current_node IS NULL
           OR min_distance = 'Infinity'::DOUBLE PRECISION THEN
            EXIT;
        END IF;

        UPDATE dijkstra_exit_state AS ds
        SET visited = TRUE
        WHERE ds.node_id = current_node;

        FOR route_next_node, edge_distance IN
            SELECT
                e.from_node,
                e.distance
            FROM map_edges AS e
            WHERE e.to_node = current_node
        LOOP
            new_distance := min_distance + edge_distance;

            UPDATE dijkstra_exit_state AS ds
            SET
                distance = new_distance,
                next_node = current_node
            WHERE ds.node_id = route_next_node
              AND ds.visited = FALSE
              AND new_distance < ds.distance;
        END LOOP;
    END LOOP;

    FOR current_node IN
        SELECT mn.node_id
        FROM map_nodes AS mn
        WHERE mn.node_type = 'PARKING'
    LOOP
        IF (
            SELECT ds.distance
            FROM dijkstra_exit_state AS ds
            WHERE ds.node_id = current_node
        ) = 'Infinity'::DOUBLE PRECISION THEN
            CONTINUE;
        END IF;

        path := ARRAY[current_node];
        route_next_node := current_node;

        LOOP
            SELECT ds.next_node
            INTO route_next_node
            FROM dijkstra_exit_state AS ds
            WHERE ds.node_id = route_next_node;

            EXIT WHEN route_next_node IS NULL;
            path := path || route_next_node;
        END LOOP;

        INSERT INTO parking_exit_routes (
            parking_node_id,
            destination_node_id,
            total_distance,
            route_nodes
        )
        SELECT
            current_node,
            exit_node,
            ds.distance,
            path
        FROM dijkstra_exit_state AS ds
        WHERE ds.node_id = current_node
        ON CONFLICT (parking_node_id)
        DO UPDATE SET
            destination_node_id = EXCLUDED.destination_node_id,
            total_distance = EXCLUDED.total_distance,
            route_nodes = EXCLUDED.route_nodes;
    END LOOP;
END;
$$;

SELECT precompute_parking_exit_routes(7);

-- =========================================================
-- 6. USERS
-- =========================================================
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
    user_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parking_status VARCHAR(20) NOT NULL DEFAULT 'NOT_PARKED',
    CHECK (parking_status IN ('PARKED', 'NOT_PARKED'))
);

INSERT INTO users
(user_id, name, email, phone, password_hash, parking_status)
VALUES
(1,  'Aditya',        'aditya@gmail.com',        '9876543210', '123', 'PARKED'),
(2,  'Rahul Sharma',  'rahul@gmail.com',         '9876543211', '123', 'PARKED'),
(3,  'Priya Singh',   'priya@gmail.com',         '9876543212', '123', 'PARKED'),
(4,  'Arjun Mehta',   'arjun@gmail.com',         '9876543213', '123', 'PARKED'),
(5,  'Rohan Patel',   'rohan@gmail.com',         '9876543214', '123', 'PARKED'),
(6,  'Sneha Verma',   'sneha@gmail.com',         '9876543215', '123', 'PARKED'),
(7,  'Karan Shah',    'karan@gmail.com',         '9876543216', '123', 'PARKED'),
(8,  'Ananya Rao',    'ananya@gmail.com',        '9876543217', '123', 'PARKED'),
(9,  'Vikram Joshi',  'vikram@gmail.com',        '9876543218', '123', 'PARKED'),
(10, 'Neha Kapoor',   'neha@gmail.com',          '9876543219', '123', 'PARKED'),
(11, 'Amit Desai',    'amit@gmail.com',          '9876543220', '123', 'PARKED'),
(12, 'Pooja Nair',    'pooja@gmail.com',         '9876543221', '123', 'NOT_PARKED'),
(13, 'Sahil Gupta',   'sahil@gmail.com',         '9876543222', '123', 'NOT_PARKED'),
(14, 'Meera Iyer',    'meera@gmail.com',         '9876543223', '123', 'NOT_PARKED'),
(15, 'Dev Malhotra',  'dev@gmail.com',           '9876543224', '123', 'NOT_PARKED');

-- =========================================================
-- 7. ADMINS
-- =========================================================
DROP TABLE IF EXISTS admins CASCADE;
CREATE TABLE admins (
    admin_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO admins
(admin_id, name, email, password_hash)
VALUES
(1, 'admin1', 'admin@parking.com', '123'),
(2, 'admin2', 'system@parking.com', '123');

-- =========================================================
-- 8. VEHICLES
-- =========================================================
DROP TABLE IF EXISTS vehicles CASCADE;
CREATE TABLE vehicles (
    vehicle_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    vehicle_type VARCHAR(20) NOT NULL
        CHECK (vehicle_type IN ('Car', 'Bike'))
);

INSERT INTO vehicles
(vehicle_id, registration_number, vehicle_type)
VALUES
(1,  'MH12AB1234', 'Car'),
(2,  'MH14CD5678', 'Car'),
(3,  'MH12EF9012', 'Bike'),
(4,  'MH14GH3456', 'Car'),
(5,  'MH12IJ7890', 'Car'),
(6,  'MH14KL1234', 'Bike'),
(7,  'MH12MN5678', 'Car'),
(8,  'MH14OP9012', 'Car'),
(9,  'MH12QR3456', 'Car'),
(10, 'MH14ST7890', 'Bike'),
(11, 'MH12UV1234', 'Car'),
(12, 'MH14WX5678', 'Car'),
(13, 'MH12YZ9012', 'Car'),
(14, 'MH14AA3456', 'Bike'),
(15, 'MH12BB7890', 'Car');

-- =========================================================
-- 9. PARKING LOTS
-- =========================================================
DROP TABLE IF EXISTS parking_lots CASCADE;
CREATE TABLE parking_lots (
    lot_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,
    total_slots INTEGER NOT NULL
        CHECK (total_slots >= 0),
    base_fee NUMERIC(10,2) DEFAULT 0
        CHECK (base_fee >= 0)
);

INSERT INTO parking_lots
(lot_id, name, location, total_slots, base_fee)
VALUES
(1, 'Mall1', 'Udipi', 85, 30.00);

-- =========================================================
-- 10. PARKING SLOTS
-- =========================================================
DROP TABLE IF EXISTS parking_slots CASCADE;
CREATE TABLE parking_slots (
    slot_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    lot_id BIGINT NOT NULL,
    slot_number VARCHAR(20) NOT NULL,
    slot_type VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'VACANT'
        CHECK (
            status IN (
                'VACANT',
                'ENGAGED',
                'WAITING'
            )
        ),
    CONSTRAINT fk_slot_lot
        FOREIGN KEY (lot_id)
        REFERENCES parking_lots(lot_id)
        ON DELETE CASCADE,
    CONSTRAINT unique_slot_number_per_lot
        UNIQUE (lot_id, slot_number)
);

INSERT INTO parking_slots
(lot_id, slot_number, slot_type, status)
VALUES
-- A SLOTS - CAR
(1, 'A01', 'Car', 'ENGAGED'),
(1, 'A02', 'Car', 'ENGAGED'),
(1, 'A03', 'Car', 'VACANT'),
(1, 'A04', 'Car', 'VACANT'),
(1, 'A05', 'Car', 'VACANT'),
(1, 'A07', 'Car', 'VACANT'),
(1, 'A08', 'Car', 'VACANT'),
(1, 'A09', 'Car', 'VACANT'),
(1, 'A10', 'Car', 'VACANT'),

-- B SLOTS - BIKE
(1, 'B01', 'Bike', 'VACANT'),
(1, 'B02', 'Bike', 'ENGAGED'),
(1, 'B03', 'Bike', 'ENGAGED'),
(1, 'B04', 'Bike', 'VACANT'),
(1, 'B05', 'Bike', 'VACANT'),
(1, 'B06', 'Bike', 'VACANT'),
(1, 'B07', 'Bike', 'VACANT'),
(1, 'B08', 'Bike', 'VACANT'),
(1, 'B09', 'Bike', 'WAITING'),
(1, 'B10', 'Bike', 'VACANT'),
(1, 'B11', 'Bike', 'VACANT'),
(1, 'B12', 'Bike', 'VACANT'),
(1, 'B13', 'Bike', 'ENGAGED'),

-- C SLOTS - CAR
(1, 'C01', 'Car', 'ENGAGED'),
(1, 'C02', 'Car', 'VACANT'),
(1, 'C03', 'Car', 'ENGAGED'),
(1, 'C04', 'Car', 'VACANT'),
(1, 'C05', 'Car', 'WAITING'),
(1, 'C06', 'Car', 'VACANT'),
(1, 'C07', 'Car', 'VACANT'),
(1, 'C08', 'Car', 'VACANT'),
(1, 'C09', 'Car', 'ENGAGED'),
(1, 'C10', 'Car', 'ENGAGED'),
(1, 'C11', 'Car', 'VACANT'),
(1, 'C12', 'Car', 'VACANT'),
(1, 'C13', 'Car', 'VACANT'),
(1, 'C14', 'Car', 'VACANT'),
(1, 'C15', 'Car', 'VACANT'),
(1, 'C16', 'Car', 'VACANT'),
(1, 'C17', 'Car', 'VACANT'),
(1, 'C18', 'Car', 'VACANT'),
(1, 'C19', 'Car', 'VACANT'),
(1, 'C20', 'Car', 'VACANT'),
(1, 'C21', 'Car', 'VACANT'),
(1, 'C22', 'Car', 'VACANT'),
(1, 'C23', 'Car', 'VACANT'),
(1, 'C24', 'Car', 'VACANT'),
(1, 'C25', 'Car', 'VACANT'),
(1, 'C26', 'Car', 'VACANT'),
(1, 'C27', 'Car', 'VACANT'),
(1, 'C28', 'Car', 'VACANT'),
(1, 'C29', 'Car', 'VACANT'),
(1, 'C30', 'Car', 'VACANT'),
(1, 'C31', 'Car', 'VACANT'),
(1, 'C32', 'Car', 'VACANT'),
(1, 'C33', 'Car', 'VACANT'),
(1, 'C34', 'Car', 'VACANT'),
(1, 'C35', 'Car', 'VACANT'),
(1, 'C36', 'Car', 'VACANT'),
(1, 'C37', 'Car', 'VACANT'),
(1, 'C38', 'Car', 'VACANT'),
(1, 'C39', 'Car', 'VACANT'),
(1, 'C40', 'Car', 'VACANT'),

-- D SLOTS - CAR
(1, 'D01', 'Car', 'VACANT'),
(1, 'D02', 'Car', 'VACANT'),
(1, 'D03', 'Car', 'VACANT'),
(1, 'D04', 'Car', 'VACANT'),
(1, 'D05', 'Car', 'VACANT'),
(1, 'D06', 'Car', 'VACANT'),
(1, 'D07', 'Car', 'VACANT'),
(1, 'D08', 'Car', 'VACANT'),
(1, 'D09', 'Car', 'VACANT'),
(1, 'D10', 'Car', 'VACANT'),
(1, 'D11', 'Car', 'VACANT'),
(1, 'D12', 'Car', 'VACANT'),

-- E SLOTS - CAR
(1, 'E02', 'Car', 'ENGAGED'),
(1, 'E03', 'Car', 'ENGAGED'),
(1, 'E04', 'Car', 'VACANT'),
(1, 'E05', 'Car', 'VACANT'),
(1, 'E06', 'Car', 'VACANT'),
(1, 'E07', 'Car', 'VACANT'),
(1, 'E08', 'Car', 'VACANT'),
(1, 'E09', 'Car', 'VACANT'),
(1, 'E10', 'Car', 'VACANT'),
(1, 'E12', 'Car', 'VACANT'),
(1, 'E13', 'Car', 'VACANT');

-- =========================================================
-- 11. PARKING ALLOCATIONS
-- =========================================================
DROP TABLE IF EXISTS parking_allocations CASCADE;
CREATE TABLE parking_allocations (
    allocation_id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    vehicle_id BIGINT NOT NULL,
    slot_id BIGINT NOT NULL,
    allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    released_at TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (
            status IN (
                'ACTIVE'
            )
        ),
    CONSTRAINT fk_allocation_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),
    CONSTRAINT fk_allocation_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id),
    CONSTRAINT fk_allocation_slot
        FOREIGN KEY (slot_id)
        REFERENCES parking_slots(slot_id)
);

INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (1, 1, 1, (SELECT slot_id FROM parking_slots WHERE slot_number = 'A01'), '2026-08-25 08:15:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (2, 2, 2, (SELECT slot_id FROM parking_slots WHERE slot_number = 'A02'), '2026-08-25 08:27:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (3, 3, 3, (SELECT slot_id FROM parking_slots WHERE slot_number = 'B02'), '2026-08-25 08:35:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (4, 6, 6, (SELECT slot_id FROM parking_slots WHERE slot_number = 'B03'), '2026-08-25 08:42:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (5, 4, 4, (SELECT slot_id FROM parking_slots WHERE slot_number = 'C01'), '2026-08-25 08:48:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (6, 5, 5, (SELECT slot_id FROM parking_slots WHERE slot_number = 'C03'), '2026-08-25 08:55:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (7, 7, 7, (SELECT slot_id FROM parking_slots WHERE slot_number = 'C09'), '2026-08-25 09:03:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (8, 8, 8, (SELECT slot_id FROM parking_slots WHERE slot_number = 'C10'), '2026-08-25 09:11:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (9, 9, 9, (SELECT slot_id FROM parking_slots WHERE slot_number = 'E02'), '2026-08-25 09:18:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (10, 10, 10, (SELECT slot_id FROM parking_slots WHERE slot_number = 'B13'), '2026-08-25 09:26:00', NULL, 'ACTIVE');
INSERT INTO parking_allocations (allocation_id, user_id, vehicle_id, slot_id, allocated_at, released_at, status) VALUES (11, 11, 11, (SELECT slot_id FROM parking_slots WHERE slot_number = 'E03'), '2026-08-25 09:34:00', NULL, 'ACTIVE');

-- =========================================================
-- 12. PARKING SESSIONS
-- =========================================================
DROP TABLE IF EXISTS parking_sessions CASCADE;
CREATE TABLE parking_sessions (
    session_id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    vehicle_id BIGINT NOT NULL,
    entry_time TIMESTAMP NOT NULL,
    exit_time TIMESTAMP NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_session_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),
    CONSTRAINT fk_session_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id),
    CONSTRAINT chk_session_time
        CHECK (exit_time > entry_time),
    CONSTRAINT chk_session_amount
        CHECK (amount >= 0)
);

INSERT INTO parking_sessions
(session_id, user_id, vehicle_id, entry_time, exit_time, amount)
VALUES
(1,  1,  1,  '2026-08-25 08:15:00', '2026-08-25 11:30:00', 97.50),
(2,  2,  2,  '2026-08-25 08:27:00', '2026-08-25 12:15:00', 112.50),
(3,  3,  3,  '2026-08-25 08:35:00', '2026-08-25 10:05:00', 45.00),
(4,  6,  6,  '2026-08-25 08:42:00', '2026-08-25 11:42:00', 90.00),
(5,  4,  4,  '2026-08-25 08:48:00', '2026-08-25 13:20:00', 136.00),
(6,  5,  5,  '2026-08-25 08:55:00', '2026-08-25 12:30:00', 107.50),
(7,  7,  7,  '2026-08-25 09:03:00', '2026-08-25 14:10:00', 153.50),
(8,  8,  8,  '2026-08-25 09:11:00', '2026-08-25 13:45:00', 137.00),
(9,  9,  9,  '2026-08-25 09:18:00', '2026-08-25 15:00:00', 171.00),
(10, 10, 10, '2026-08-25 09:26:00', '2026-08-25 12:50:00', 102.00),
(11, 11, 11, '2026-08-25 09:34:00', '2026-08-25 14:25:00', 145.50),
(12, 12, 12, '2026-08-24 08:15:00', '2026-08-24 11:45:00', 105.00),
(13, 13, 13, '2026-08-24 09:20:00', '2026-08-24 13:30:00', 125.00),
(14, 14, 14, '2026-08-24 10:00:00', '2026-08-24 15:15:00', 157.50),
(15, 15, 15, '2026-08-24 11:15:00', '2026-08-24 17:00:00', 172.50);

ALTER TABLE parking_sessions
ADD CONSTRAINT fk_session_allocation
FOREIGN KEY (session_id)
REFERENCES parking_allocations(allocation_id)
ON DELETE CASCADE
NOT VALID;

-- =========================================================
-- 13. INDEXES
-- =========================================================
-- Parking slots
CREATE INDEX IF NOT EXISTS idx_parking_slots_lot_id
ON parking_slots(lot_id);

-- Parking allocations
CREATE INDEX IF NOT EXISTS idx_allocations_user_id
ON parking_allocations(user_id);

CREATE INDEX IF NOT EXISTS idx_allocations_vehicle_id
ON parking_allocations(vehicle_id);

CREATE INDEX IF NOT EXISTS idx_allocations_slot_id
ON parking_allocations(slot_id);

-- Parking sessions
CREATE INDEX IF NOT EXISTS idx_sessions_user_id
ON parking_sessions(user_id);

CREATE INDEX IF NOT EXISTS idx_sessions_vehicle_id
ON parking_sessions(vehicle_id);

-- =========================================================
-- 14. SYNC IDENTITY SEQUENCES
-- =========================================================
SELECT setval(pg_get_serial_sequence('users', 'user_id'), COALESCE((SELECT MAX(user_id) FROM users), 1));
SELECT setval(pg_get_serial_sequence('vehicles', 'vehicle_id'), COALESCE((SELECT MAX(vehicle_id) FROM vehicles), 1));
SELECT setval(pg_get_serial_sequence('admins', 'admin_id'), COALESCE((SELECT MAX(admin_id) FROM admins), 1));
SELECT setval(pg_get_serial_sequence('parking_slots', 'slot_id'), COALESCE((SELECT MAX(slot_id) FROM parking_slots), 1));
SELECT setval(pg_get_serial_sequence('parking_allocations', 'allocation_id'), COALESCE((SELECT MAX(allocation_id) FROM parking_allocations), 1));
