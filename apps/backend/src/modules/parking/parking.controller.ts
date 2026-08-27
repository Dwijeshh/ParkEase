import { Request, Response } from "express";
import { pool, query } from "../../config/database";

export async function getParkingLots(_req: Request, res: Response) {
  try {
    const result = await query(
      "SELECT lot_id, name, location, total_slots, base_fee FROM parking_lots ORDER BY lot_id ASC"
    );

    const lots = result.rows.map(lot => ({
      id: lot.lot_id.toString(),
      name: lot.name,
      location: lot.location,
      total_slots: Number(lot.total_slots),
      base_fee: Number(lot.base_fee)
    }));

    return res.json({ success: true, data: lots });
  } catch (error) {
    console.error("Failed to fetch parking lots:", error);
    return res.status(500).json({
      success: false,
      error: { code: "PARKING_LOTS_FETCH_FAILED", message: "Failed to fetch parking lots" }
    });
  }
}

export async function getParkingSlots(req: Request, res: Response) {
  const { type, status } = req.query;

  try {
    let sql = `
      SELECT
        s.slot_id,
        s.lot_id,
        s.slot_number,
        s.slot_type,
        s.status,
        a.allocation_id,
        a.user_id,
        u.name AS user_name,
        v.vehicle_id,
        v.registration_number
      FROM parking_slots s
      LEFT JOIN parking_allocations a ON s.slot_id = a.slot_id AND a.status = 'ACTIVE'
      LEFT JOIN users u ON a.user_id = u.user_id
      LEFT JOIN vehicles v ON a.vehicle_id = v.vehicle_id
      WHERE 1=1
    `;
    const params: any[] = [];

    if (type) {
      params.push(type);
      sql += ` AND s.slot_type = $${params.length}`;
    }

    if (status) {
      params.push(status);
      sql += ` AND s.status = $${params.length}`;
    }

    sql += " ORDER BY s.slot_number ASC";

    const result = await query(sql, params);

    const slots = result.rows.map((row) => ({
      id: row.slot_id.toString(),
      slot_id: row.slot_id.toString(),
      code: row.slot_number,
      slot_number: row.slot_number,
      slot_type: row.slot_type,
      status: row.status,
      lot_id: row.lot_id.toString(),
      vehicleId: row.vehicle_id ? row.vehicle_id.toString() : "",
      vehicle: row.registration_number || "",
      userId: row.user_id ? row.user_id.toString() : "",
      user: row.user_name || "",
      allocationId: row.allocation_id ? row.allocation_id.toString() : ""
    }));

    return res.json({ success: true, data: slots });
  } catch (error) {
    console.error("Failed to fetch parking slots:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "PARKING_SLOTS_FETCH_FAILED",
        message: "Failed to fetch parking slots"
      }
    });
  }
}

export async function getAvailableSlots(req: Request, res: Response) {
  const { type } = req.query;

  try {
    let sql = `
      SELECT
        slot_id,
        lot_id,
        slot_number,
        slot_type,
        status
      FROM parking_slots
      WHERE status = 'VACANT'
    `;
    const params: any[] = [];

    if (type) {
      params.push(type);
      sql += ` AND slot_type = $${params.length}`;
    }

    sql += " ORDER BY slot_number ASC";

    const result = await query(sql, params);

    const slots = result.rows.map((row) => ({
      id: row.slot_id.toString(),
      slot_id: row.slot_id.toString(),
      code: row.slot_number,
      slot_number: row.slot_number,
      slot_type: row.slot_type,
      status: row.status,
      lot_id: row.lot_id.toString()
    }));

    return res.json({ success: true, data: slots });
  } catch (error) {
    console.error("Failed to fetch available parking slots:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "AVAILABLE_SLOTS_FETCH_FAILED",
        message: "Failed to fetch available parking slots"
      }
    });
  }
}

export async function getSlotById(req: Request, res: Response) {
  const { id } = req.params;

  try {
    const result = await query(
      `SELECT
        s.slot_id,
        s.lot_id,
        s.slot_number,
        s.slot_type,
        s.status,
        a.allocation_id,
        a.user_id,
        u.name as user_name,
        v.vehicle_id,
        v.registration_number
       FROM parking_slots s
       LEFT JOIN parking_allocations a ON s.slot_id = a.slot_id AND a.status = 'ACTIVE'
       LEFT JOIN users u ON a.user_id = u.user_id
       LEFT JOIN vehicles v ON a.vehicle_id = v.vehicle_id
       WHERE s.slot_id::text = $1 OR s.slot_number = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "SLOT_NOT_FOUND", message: "Parking slot not found" }
      });
    }

    const row = result.rows[0];
    return res.json({
      success: true,
      data: {
        id: row.slot_id.toString(),
        slot_id: row.slot_id.toString(),
        code: row.slot_number,
        slot_number: row.slot_number,
        slot_type: row.slot_type,
        status: row.status,
        lot_id: row.lot_id.toString(),
        vehicleId: row.vehicle_id ? row.vehicle_id.toString() : "",
        vehicle: row.registration_number || "",
        userId: row.user_id ? row.user_id.toString() : "",
        user: row.user_name || "",
        allocationId: row.allocation_id ? row.allocation_id.toString() : ""
      }
    });
  } catch (error) {
    console.error("Failed to fetch slot:", error);
    return res.status(500).json({
      success: false,
      error: { code: "SLOT_FETCH_FAILED", message: "Failed to fetch slot" }
    });
  }
}

export async function updateSlotStatus(req: Request, res: Response) {
  const { id } = req.params;
  const { status } = req.body;

  const validStatuses = ["VACANT", "ENGAGED", "WAITING", "Available", "Occupied", "Waiting"];
  if (!status || !validStatuses.includes(status)) {
    return res.status(400).json({
      success: false,
      error: { code: "INVALID_STATUS", message: "Status must be VACANT, ENGAGED, or WAITING" }
    });
  }

  let dbStatus = status.toUpperCase();
  if (dbStatus === "AVAILABLE") dbStatus = "VACANT";
  if (dbStatus === "OCCUPIED") dbStatus = "ENGAGED";

  try {
    const result = await query(
      `UPDATE parking_slots
       SET status = $1
       WHERE slot_id::text = $2 OR slot_number = $2
       RETURNING slot_id, lot_id, slot_number, slot_type, status`,
      [dbStatus, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "SLOT_NOT_FOUND", message: "Slot not found" }
      });
    }

    const updated = result.rows[0];
    return res.json({
      success: true,
      data: {
        id: updated.slot_id.toString(),
        slot_number: updated.slot_number,
        slot_type: updated.slot_type,
        status: updated.status
      }
    });
  } catch (error) {
    console.error("Failed to update slot status:", error);
    return res.status(500).json({
      success: false,
      error: { code: "SLOT_UPDATE_FAILED", message: "Failed to update slot status" }
    });
  }
}

export async function assignSlot(req: Request, res: Response) {
  const { vehicleId, slotId, userId, vehicle_id, slot_id, user_id } = req.body;
  const vId = vehicleId || vehicle_id;
  const sId = slotId || slot_id;
  let uId = userId || user_id || req.auth?.userId;

  if (!vId || !sId) {
    return res.status(400).json({
      success: false,
      error: { code: "MISSING_PARAMS", message: "vehicleId and slotId are required" }
    });
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // If uId is missing, try to find default or user 1
    if (!uId) {
      uId = "1";
    }

    // Check slot existence and status
    const slotRes = await client.query(
      "SELECT slot_id, slot_number, slot_type, status FROM parking_slots WHERE slot_id::text = $1 OR slot_number = $1 FOR UPDATE",
      [sId.toString()]
    );

    if (slotRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        success: false,
        error: { code: "SLOT_NOT_FOUND", message: "Parking slot not found" }
      });
    }

    const slot = slotRes.rows[0];

    // Check vehicle existence
    const vehicleRes = await client.query(
      "SELECT vehicle_id, registration_number, vehicle_type FROM vehicles WHERE vehicle_id::text = $1 OR registration_number = $1",
      [vId.toString()]
    );

    if (vehicleRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        success: false,
        error: { code: "VEHICLE_NOT_FOUND", message: "Vehicle not found" }
      });
    }

    const vehicle = vehicleRes.rows[0];

    // Insert allocation
    const allocRes = await client.query(
      `INSERT INTO parking_allocations (user_id, vehicle_id, slot_id, allocated_at, status)
       VALUES ($1, $2, $3, NOW(), 'ACTIVE')
       RETURNING allocation_id, user_id, vehicle_id, slot_id, allocated_at, status`,
      [uId, vehicle.vehicle_id, slot.slot_id]
    );

    // Update slot status to ENGAGED
    await client.query(
      "UPDATE parking_slots SET status = 'ENGAGED' WHERE slot_id = $1",
      [slot.slot_id]
    );

    // Update user parking status to PARKED
    await client.query(
      "UPDATE users SET parking_status = 'PARKED' WHERE user_id = $1",
      [uId]
    );

    await client.query("COMMIT");

    const allocation = allocRes.rows[0];
    return res.status(201).json({
      success: true,
      data: {
        allocationId: allocation.allocation_id.toString(),
        slotId: slot.slot_id.toString(),
        slotNumber: slot.slot_number,
        vehicleId: vehicle.vehicle_id.toString(),
        registrationNumber: vehicle.registration_number,
        userId: uId.toString(),
        allocatedAt: allocation.allocated_at,
        status: allocation.status
      }
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Assign slot error:", error);
    return res.status(500).json({
      success: false,
      error: { code: "ASSIGN_SLOT_FAILED", message: "Failed to assign parking slot" }
    });
  } finally {
    client.release();
  }
}

export async function releaseSlot(req: Request, res: Response) {
  const { id } = req.params;
  const slotIdentifier = id || req.body.slotId || req.body.slot_id;

  if (!slotIdentifier) {
    return res.status(400).json({
      success: false,
      error: { code: "MISSING_SLOT", message: "Slot ID is required" }
    });
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const slotRes = await client.query(
      "SELECT slot_id, slot_number FROM parking_slots WHERE slot_id::text = $1 OR slot_number = $1 FOR UPDATE",
      [slotIdentifier.toString()]
    );

    if (slotRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        success: false,
        error: { code: "SLOT_NOT_FOUND", message: "Slot not found" }
      });
    }

    const slot = slotRes.rows[0];

    // Find active allocation
    const allocRes = await client.query(
      "SELECT allocation_id, user_id, vehicle_id FROM parking_allocations WHERE slot_id = $1 AND status = 'ACTIVE' ORDER BY allocated_at DESC LIMIT 1 FOR UPDATE",
      [slot.slot_id]
    );

    if (allocRes.rows.length > 0) {
      const allocation = allocRes.rows[0];
      await client.query(
        "UPDATE parking_allocations SET status = 'RELEASED', released_at = NOW() WHERE allocation_id = $1",
        [allocation.allocation_id]
      );
      await client.query(
        "UPDATE users SET parking_status = 'NOT_PARKED' WHERE user_id = $1",
        [allocation.user_id]
      );
    }

    // Set slot to VACANT
    await client.query(
      "UPDATE parking_slots SET status = 'VACANT' WHERE slot_id = $1",
      [slot.slot_id]
    );

    await client.query("COMMIT");

    return res.json({
      success: true,
      message: `Slot ${slot.slot_number} has been released and is now VACANT.`
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Release slot error:", error);
    return res.status(500).json({
      success: false,
      error: { code: "RELEASE_SLOT_FAILED", message: "Failed to release slot" }
    });
  } finally {
    client.release();
  }
}
