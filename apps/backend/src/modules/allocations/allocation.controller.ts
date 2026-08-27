import { Request, Response } from "express";
import { pool, query } from "../../config/database";

export async function getAllocations(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        a.allocation_id,
        a.user_id,
        u.name AS user_name,
        u.email AS user_email,
        a.vehicle_id,
        v.registration_number,
        v.vehicle_type,
        a.slot_id,
        s.slot_number,
        s.slot_type,
        a.allocated_at,
        a.released_at,
        a.status
      FROM parking_allocations a
      JOIN users u ON a.user_id = u.user_id
      JOIN vehicles v ON a.vehicle_id = v.vehicle_id
      JOIN parking_slots s ON a.slot_id = s.slot_id
      ORDER BY a.allocated_at DESC
    `);

    const allocations = result.rows.map(row => ({
      id: row.allocation_id.toString(),
      allocationId: row.allocation_id.toString(),
      userId: row.user_id.toString(),
      userName: row.user_name,
      userEmail: row.user_email,
      vehicleId: row.vehicle_id.toString(),
      vehicleNumber: row.registration_number,
      vehicleType: row.vehicle_type,
      slotId: row.slot_id.toString(),
      slotNumber: row.slot_number,
      slotType: row.slot_type,
      allocatedAt: row.allocated_at,
      releasedAt: row.released_at,
      status: row.status
    }));

    return res.json({ success: true, data: allocations });
  } catch (error) {
    console.error("Failed to fetch allocations:", error);
    return res.status(500).json({
      success: false,
      error: { code: "ALLOCATIONS_FETCH_FAILED", message: "Failed to fetch allocations" }
    });
  }
}

export async function getActiveAllocations(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        a.allocation_id,
        a.user_id,
        u.name AS user_name,
        u.email AS user_email,
        a.vehicle_id,
        v.registration_number,
        v.vehicle_type,
        a.slot_id,
        s.slot_number,
        s.slot_type,
        a.allocated_at,
        a.status
      FROM parking_allocations a
      JOIN users u ON a.user_id = u.user_id
      JOIN vehicles v ON a.vehicle_id = v.vehicle_id
      JOIN parking_slots s ON a.slot_id = s.slot_id
      WHERE a.status = 'ACTIVE'
      ORDER BY a.allocated_at DESC
    `);

    const allocations = result.rows.map(row => ({
      id: row.allocation_id.toString(),
      allocationId: row.allocation_id.toString(),
      userId: row.user_id.toString(),
      userName: row.user_name,
      userEmail: row.user_email,
      vehicleId: row.vehicle_id.toString(),
      vehicleNumber: row.registration_number,
      vehicleType: row.vehicle_type,
      slotId: row.slot_id.toString(),
      slotNumber: row.slot_number,
      slotType: row.slot_type,
      allocatedAt: row.allocated_at,
      status: row.status
    }));

    return res.json({ success: true, data: allocations });
  } catch (error) {
    console.error("Failed to fetch active allocations:", error);
    return res.status(500).json({
      success: false,
      error: { code: "ACTIVE_ALLOCATIONS_FAILED", message: "Failed to fetch active allocations" }
    });
  }
}

export async function createAllocation(req: Request, res: Response) {
  const { userId, vehicleId, slotId } = req.body;
  const uId = userId || req.auth?.userId;

  if (!uId || !vehicleId || !slotId) {
    return res.status(400).json({
      success: false,
      error: { code: "MISSING_PARAMS", message: "userId, vehicleId, and slotId are required" }
    });
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // Check slot
    const slotRes = await client.query(
      "SELECT slot_id, slot_number, status FROM parking_slots WHERE slot_id::text = $1 OR slot_number = $1 FOR UPDATE",
      [slotId.toString()]
    );
    if (slotRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ success: false, error: { code: "SLOT_NOT_FOUND", message: "Slot not found" } });
    }
    const slot = slotRes.rows[0];

    // Check vehicle
    const vehicleRes = await client.query(
      "SELECT vehicle_id, registration_number FROM vehicles WHERE vehicle_id::text = $1 OR registration_number = $1",
      [vehicleId.toString()]
    );
    if (vehicleRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ success: false, error: { code: "VEHICLE_NOT_FOUND", message: "Vehicle not found" } });
    }
    const vehicle = vehicleRes.rows[0];

    const allocRes = await client.query(
      `INSERT INTO parking_allocations (user_id, vehicle_id, slot_id, allocated_at, status)
       VALUES ($1, $2, $3, NOW(), 'ACTIVE')
       RETURNING allocation_id, user_id, vehicle_id, slot_id, allocated_at, status`,
      [uId, vehicle.vehicle_id, slot.slot_id]
    );

    await client.query("UPDATE parking_slots SET status = 'ENGAGED' WHERE slot_id = $1", [slot.slot_id]);
    await client.query("UPDATE users SET parking_status = 'PARKED' WHERE user_id = $1", [uId]);

    await client.query("COMMIT");

    const created = allocRes.rows[0];
    return res.status(201).json({
      success: true,
      data: {
        id: created.allocation_id.toString(),
        userId: created.user_id.toString(),
        vehicleId: created.vehicle_id.toString(),
        slotId: created.slot_id.toString(),
        allocatedAt: created.allocated_at,
        status: created.status
      }
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Create allocation error:", error);
    return res.status(500).json({
      success: false,
      error: { code: "ALLOCATION_CREATE_FAILED", message: "Failed to create allocation" }
    });
  } finally {
    client.release();
  }
}

export async function releaseAllocation(req: Request, res: Response) {
  const { id } = req.params;

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const allocRes = await client.query(
      "SELECT allocation_id, user_id, slot_id, status FROM parking_allocations WHERE allocation_id = $1 FOR UPDATE",
      [id]
    );

    if (allocRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        success: false,
        error: { code: "ALLOCATION_NOT_FOUND", message: "Allocation not found" }
      });
    }

    const alloc = allocRes.rows[0];
    const releasedAt = new Date();

    await client.query(
      "UPDATE parking_allocations SET status = 'RELEASED', released_at = $1 WHERE allocation_id = $2",
      [releasedAt, alloc.allocation_id]
    );

    await client.query(
      "UPDATE parking_slots SET status = 'VACANT' WHERE slot_id = $1",
      [alloc.slot_id]
    );

    await client.query(
      "UPDATE users SET parking_status = 'NOT_PARKED' WHERE user_id = $1",
      [alloc.user_id]
    );

    await client.query("COMMIT");

    return res.json({
      success: true,
      message: "Allocation released successfully",
      data: {
        allocationId: alloc.allocation_id.toString(),
        releasedAt
      }
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Release allocation error:", error);
    return res.status(500).json({
      success: false,
      error: { code: "RELEASE_ALLOCATION_FAILED", message: "Failed to release allocation" }
    });
  } finally {
    client.release();
  }
}
