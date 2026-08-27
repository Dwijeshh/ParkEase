import { Request, Response } from "express";
import { query } from "../../config/database";

export async function getVehicles(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        v.vehicle_id,
        v.registration_number,
        v.vehicle_type,
        a.allocation_id,
        a.user_id,
        u.name AS owner_name,
        u.email AS owner_email,
        s.slot_id,
        s.slot_number,
        a.status AS allocation_status
      FROM vehicles v
      LEFT JOIN parking_allocations a ON v.vehicle_id = a.vehicle_id AND a.status = 'ACTIVE'
      LEFT JOIN users u ON a.user_id = u.user_id
      LEFT JOIN parking_slots s ON a.slot_id = s.slot_id
      ORDER BY v.vehicle_id ASC
    `);

    const vehicles = result.rows.map((row) => ({
      id: row.vehicle_id.toString(),
      vehicle_id: row.vehicle_id.toString(),
      number: row.registration_number,
      registration_number: row.registration_number,
      type: row.vehicle_type,
      vehicle_type: row.vehicle_type,
      ownerId: row.user_id ? row.user_id.toString() : "",
      owner: row.owner_name || "Unassigned",
      ownerEmail: row.owner_email || "",
      slot: row.slot_number || "",
      slotId: row.slot_id ? row.slot_id.toString() : "",
      status: row.allocation_status === "ACTIVE" ? "Parked" : "Outside"
    }));

    return res.json({
      success: true,
      data: vehicles
    });
  } catch (error) {
    console.error("Failed to fetch vehicles:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "VEHICLES_FETCH_FAILED",
        message: "Failed to fetch vehicles"
      }
    });
  }
}

export async function getVehicleById(req: Request, res: Response) {
  const { id } = req.params;

  try {
    const result = await query(
      "SELECT vehicle_id, registration_number, vehicle_type FROM vehicles WHERE vehicle_id = $1",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "VEHICLE_NOT_FOUND", message: "Vehicle not found" }
      });
    }

    const vehicle = result.rows[0];

    const historyResult = await query(
      `SELECT
        a.allocation_id,
        a.allocated_at,
        a.released_at,
        a.status,
        s.slot_number,
        u.name as user_name
       FROM parking_allocations a
       JOIN parking_slots s ON a.slot_id = s.slot_id
       JOIN users u ON a.user_id = u.user_id
       WHERE a.vehicle_id = $1
       ORDER BY a.allocated_at DESC`,
      [id]
    );

    return res.json({
      success: true,
      data: {
        id: vehicle.vehicle_id.toString(),
        registration_number: vehicle.registration_number,
        vehicle_type: vehicle.vehicle_type,
        history: historyResult.rows.map(h => ({
          id: h.allocation_id.toString(),
          slot: h.slot_number,
          user: h.user_name,
          allocated_at: h.allocated_at,
          released_at: h.released_at,
          status: h.status
        }))
      }
    });
  } catch (error) {
    console.error("Failed to fetch vehicle:", error);
    return res.status(500).json({
      success: false,
      error: { code: "VEHICLE_FETCH_FAILED", message: "Failed to fetch vehicle" }
    });
  }
}

export async function createVehicle(req: Request, res: Response) {
  const { registration_number, number, vehicle_type, type } = req.body;
  const regNumber = (registration_number || number || "").trim().toUpperCase();
  const vType = (vehicle_type || type || "Car").trim();

  if (!regNumber) {
    return res.status(400).json({
      success: false,
      error: { code: "MISSING_REG_NUMBER", message: "Registration number is required" }
    });
  }

  if (!["Car", "Bike"].includes(vType)) {
    return res.status(400).json({
      success: false,
      error: { code: "INVALID_VEHICLE_TYPE", message: "Vehicle type must be 'Car' or 'Bike'" }
    });
  }

  try {
    const result = await query(
      `INSERT INTO vehicles (registration_number, vehicle_type)
       VALUES ($1, $2)
       RETURNING vehicle_id, registration_number, vehicle_type`,
      [regNumber, vType]
    );

    const created = result.rows[0];
    return res.status(201).json({
      success: true,
      data: {
        id: created.vehicle_id.toString(),
        registration_number: created.registration_number,
        vehicle_type: created.vehicle_type
      }
    });
  } catch (error: any) {
    if (error.code === "23505") {
      return res.status(409).json({
        success: false,
        error: { code: "DUPLICATE_VEHICLE", message: "Registration number already exists" }
      });
    }
    console.error("Failed to create vehicle:", error);
    return res.status(500).json({
      success: false,
      error: { code: "VEHICLE_CREATE_FAILED", message: "Failed to create vehicle" }
    });
  }
}

export async function updateVehicle(req: Request, res: Response) {
  const { id } = req.params;
  const { registration_number, number, vehicle_type, type } = req.body;
  const regNumber = (registration_number || number)?.trim()?.toUpperCase() || null;
  const vType = (vehicle_type || type)?.trim() || null;

  try {
    const result = await query(
      `UPDATE vehicles
       SET registration_number = COALESCE($1, registration_number),
           vehicle_type = COALESCE($2, vehicle_type)
       WHERE vehicle_id = $3
       RETURNING vehicle_id, registration_number, vehicle_type`,
      [regNumber, vType, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "VEHICLE_NOT_FOUND", message: "Vehicle not found" }
      });
    }

    const updated = result.rows[0];
    return res.json({
      success: true,
      data: {
        id: updated.vehicle_id.toString(),
        registration_number: updated.registration_number,
        vehicle_type: updated.vehicle_type
      }
    });
  } catch (error) {
    console.error("Failed to update vehicle:", error);
    return res.status(500).json({
      success: false,
      error: { code: "VEHICLE_UPDATE_FAILED", message: "Failed to update vehicle" }
    });
  }
}

export async function deleteVehicle(req: Request, res: Response) {
  const { id } = req.params;

  try {
    const result = await query("DELETE FROM vehicles WHERE vehicle_id = $1 RETURNING vehicle_id", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "VEHICLE_NOT_FOUND", message: "Vehicle not found" }
      });
    }

    return res.json({
      success: true,
      message: "Vehicle deleted successfully"
    });
  } catch (error) {
    console.error("Failed to delete vehicle:", error);
    return res.status(500).json({
      success: false,
      error: { code: "VEHICLE_DELETE_FAILED", message: "Failed to delete vehicle" }
    });
  }
}
