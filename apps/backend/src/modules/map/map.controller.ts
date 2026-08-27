import { Request, Response } from "express";
import { query } from "../../config/database";

export async function getMapNodes(_req: Request, res: Response) {
  try {
    const result = await query(
      "SELECT node_id, node_type, x_coordinate, y_coordinate FROM map_nodes ORDER BY node_id ASC"
    );

    const nodes = result.rows.map(row => ({
      id: row.node_id,
      nodeId: row.node_id,
      nodeType: row.node_type,
      xCoordinate: Number(row.x_coordinate),
      yCoordinate: Number(row.y_coordinate)
    }));

    return res.json({ success: true, data: nodes });
  } catch (error) {
    console.error("Failed to fetch map nodes:", error);
    return res.status(500).json({
      success: false,
      error: { code: "MAP_NODES_FETCH_FAILED", message: "Failed to fetch map nodes" }
    });
  }
}

export async function getMapEdges(_req: Request, res: Response) {
  try {
    const result = await query(
      "SELECT edge_id, from_node, to_node, distance FROM map_edges ORDER BY edge_id ASC"
    );

    const edges = result.rows.map(row => ({
      id: row.edge_id,
      edgeId: row.edge_id,
      fromNode: row.from_node,
      toNode: row.to_node,
      distance: Number(row.distance)
    }));

    return res.json({ success: true, data: edges });
  } catch (error) {
    console.error("Failed to fetch map edges:", error);
    return res.status(500).json({
      success: false,
      error: { code: "MAP_EDGES_FETCH_FAILED", message: "Failed to fetch map edges" }
    });
  }
}

export async function getMallDistances(_req: Request, res: Response) {
  try {
    const result = await query(
      "SELECT parking_node_id, mall_entrance_id, distance FROM parking_mall_distance ORDER BY parking_node_id, mall_entrance_id"
    );

    const distances = result.rows.map(row => ({
      parkingNodeId: row.parking_node_id,
      mallEntranceId: row.mall_entrance_id,
      distance: Number(row.distance)
    }));

    return res.json({ success: true, data: distances });
  } catch (error) {
    console.error("Failed to fetch mall distances:", error);
    return res.status(500).json({
      success: false,
      error: { code: "MALL_DISTANCES_FETCH_FAILED", message: "Failed to fetch mall distances" }
    });
  }
}

export async function getEntryRoute(req: Request, res: Response) {
  const { parkingNodeId } = req.params;

  try {
    const result = await query(
      "SELECT parking_node_id, source_node_id, total_distance, route_nodes FROM parking_routes WHERE parking_node_id = $1",
      [parkingNodeId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "ROUTE_NOT_FOUND", message: "Route to specified parking node not found" }
      });
    }

    const route = result.rows[0];
    const nodeIds: number[] = route.route_nodes;

    // Fetch coordinates for all nodes along the path
    const nodeDetails = await query(
      "SELECT node_id, node_type, x_coordinate, y_coordinate FROM map_nodes WHERE node_id = ANY($1::int[])",
      [nodeIds]
    );

    const nodeMap = new Map(nodeDetails.rows.map(n => [n.node_id, n]));
    const pathNodes = nodeIds.map(id => nodeMap.get(id)).filter(Boolean);

    return res.json({
      success: true,
      data: {
        parkingNodeId: route.parking_node_id,
        sourceNodeId: route.source_node_id,
        totalDistance: Number(route.total_distance),
        routeNodes: nodeIds,
        path: pathNodes.map(n => ({
          nodeId: n.node_id,
          nodeType: n.node_type,
          x: Number(n.x_coordinate),
          y: Number(n.y_coordinate)
        }))
      }
    });
  } catch (error) {
    console.error("Failed to fetch entry route:", error);
    return res.status(500).json({
      success: false,
      error: { code: "ROUTE_FETCH_FAILED", message: "Failed to fetch entry route" }
    });
  }
}

export async function getExitRoute(req: Request, res: Response) {
  const { parkingNodeId } = req.params;

  try {
    const result = await query(
      "SELECT parking_node_id, destination_node_id, total_distance, route_nodes FROM parking_exit_routes WHERE parking_node_id = $1",
      [parkingNodeId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "ROUTE_NOT_FOUND", message: "Exit route from specified parking node not found" }
      });
    }

    const route = result.rows[0];
    const nodeIds: number[] = route.route_nodes;

    const nodeDetails = await query(
      "SELECT node_id, node_type, x_coordinate, y_coordinate FROM map_nodes WHERE node_id = ANY($1::int[])",
      [nodeIds]
    );

    const nodeMap = new Map(nodeDetails.rows.map(n => [n.node_id, n]));
    const pathNodes = nodeIds.map(id => nodeMap.get(id)).filter(Boolean);

    return res.json({
      success: true,
      data: {
        parkingNodeId: route.parking_node_id,
        destinationNodeId: route.destination_node_id,
        totalDistance: Number(route.total_distance),
        routeNodes: nodeIds,
        path: pathNodes.map(n => ({
          nodeId: n.node_id,
          nodeType: n.node_type,
          x: Number(n.x_coordinate),
          y: Number(n.y_coordinate)
        }))
      }
    });
  } catch (error) {
    console.error("Failed to fetch exit route:", error);
    return res.status(500).json({
      success: false,
      error: { code: "EXIT_ROUTE_FETCH_FAILED", message: "Failed to fetch exit route" }
    });
  }
}

export async function getNearestSlot(req: Request, res: Response) {
  const { entranceId, mallEntranceId, vehicleType, type } = req.query;
  const mallId = Number(mallEntranceId || entranceId || 1);
  const vType = (vehicleType || type || "Car").toString();

  try {
    const result = await query(
      `SELECT
        pmd.parking_node_id,
        pmd.mall_entrance_id,
        pmd.distance AS mall_distance,
        COALESCE(pr.total_distance, 0) AS entry_drive_distance,
        mn.x_coordinate,
        mn.y_coordinate,
        ps.slot_id,
        ps.slot_number,
        ps.slot_type,
        ps.status
       FROM parking_mall_distance pmd
       JOIN map_nodes mn ON pmd.parking_node_id = mn.node_id
       LEFT JOIN parking_routes pr ON pmd.parking_node_id = pr.parking_node_id
       LEFT JOIN parking_slots ps ON ps.slot_type = $2 AND ps.status = 'VACANT'
       WHERE pmd.mall_entrance_id = $1
       ORDER BY pmd.distance ASC
       LIMIT 1`,
      [mallId, vType]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "NO_VACANT_SLOTS", message: "No vacant slot available for requested destination" }
      });
    }

    const row = result.rows[0];
    return res.json({
      success: true,
      data: {
        parkingNodeId: row.parking_node_id,
        mallEntranceId: row.mall_entrance_id,
        distanceToMall: Number(row.mall_distance),
        entryDriveDistance: Number(row.entry_drive_distance),
        slotId: row.slot_id?.toString() || null,
        slotNumber: row.slot_number || null,
        slotType: row.slot_type || vType,
        status: row.status || "VACANT",
        coordinates: {
          x: Number(row.x_coordinate),
          y: Number(row.y_coordinate)
        }
      }
    });
  } catch (error) {
    console.error("Failed to find nearest slot:", error);
    return res.status(500).json({
      success: false,
      error: { code: "NEAREST_SLOT_FAILED", message: "Failed to find nearest slot" }
    });
  }
}

export async function precomputeMapRoutes(_req: Request, res: Response) {
  try {
    await query("SELECT precompute_parking_routes(6)");
    await query("SELECT precompute_parking_exit_routes(7)");

    return res.json({
      success: true,
      message: "Parking entry and exit routes precomputed successfully via Dijkstra"
    });
  } catch (error) {
    console.error("Failed to precompute routes:", error);
    return res.status(500).json({
      success: false,
      error: { code: "PRECOMPUTE_FAILED", message: "Failed to precompute routes" }
    });
  }
}
