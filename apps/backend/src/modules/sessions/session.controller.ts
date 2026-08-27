import { Request, Response } from "express";
import { pool, query } from "../../config/database";

function formatDuration(entryTime: Date, exitTime: Date): string {
  const diffMs = Math.max(0, exitTime.getTime() - entryTime.getTime());
  const totalMinutes = Math.floor(diffMs / (1000 * 60));
  const hours = Math.floor(totalMinutes / 60);
  const minutes = totalMinutes % 60;
  if (hours === 0) return `${minutes}m`;
  return `${hours}h ${minutes}m`;
}

export async function getSessions(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        s.session_id,
        s.user_id,
        u.name AS user_name,
        s.vehicle_id,
        v.registration_number,
        s.entry_time,
        s.exit_time,
        s.amount,
        ps.slot_id,
        ps.slot_number
      FROM parking_sessions s
      JOIN users u ON s.user_id = u.user_id
      JOIN vehicles v ON s.vehicle_id = v.vehicle_id
      LEFT JOIN parking_allocations a ON s.session_id = a.allocation_id
      LEFT JOIN parking_slots ps ON a.slot_id = ps.slot_id
      ORDER BY s.entry_time DESC
    `);

    const sessions = result.rows.map((row) => {
      const entry = new Date(row.entry_time);
      const exit = row.exit_time ? new Date(row.exit_time) : null;
      const isCompleted = exit !== null;

      return {
        id: row.session_id.toString(),
        sessionId: row.session_id.toString(),
        vehicleId: row.vehicle_id.toString(),
        vehicle: row.registration_number,
        userId: row.user_id.toString(),
        user: row.user_name,
        slotId: row.slot_id ? row.slot_id.toString() : "",
        slot: row.slot_number || "A01",
        entry: entry.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
        entryTime: row.entry_time,
        exit: exit ? exit.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }) : "-",
        exitTime: row.exit_time,
        duration: exit ? formatDuration(entry, exit) : formatDuration(entry, new Date()),
        status: isCompleted ? "Completed" : "Active",
        amount: Number(row.amount)
      };
    });

    return res.json({ success: true, data: sessions });
  } catch (error) {
    console.error("Failed to fetch sessions:", error);
    return res.status(500).json({
      success: false,
      error: { code: "SESSIONS_FETCH_FAILED", message: "Failed to fetch sessions" }
    });
  }
}

export async function getActiveSessions(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        a.allocation_id,
        a.user_id,
        u.name AS user_name,
        a.vehicle_id,
        v.registration_number,
        a.slot_id,
        s.slot_number,
        a.allocated_at
      FROM parking_allocations a
      JOIN users u ON a.user_id = u.user_id
      JOIN vehicles v ON a.vehicle_id = v.vehicle_id
      JOIN parking_slots s ON a.slot_id = s.slot_id
      WHERE a.status = 'ACTIVE'
      ORDER BY a.allocated_at DESC
    `);

    const activeSessions = result.rows.map((row) => {
      const entry = new Date(row.allocated_at);
      return {
        id: row.allocation_id.toString(),
        vehicleId: row.vehicle_id.toString(),
        vehicle: row.registration_number,
        userId: row.user_id.toString(),
        user: row.user_name,
        slotId: row.slot_id.toString(),
        slot: row.slot_number,
        entry: entry.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
        entryTime: row.allocated_at,
        duration: formatDuration(entry, new Date()),
        status: "Active"
      };
    });

    return res.json({ success: true, data: activeSessions });
  } catch (error) {
    console.error("Failed to fetch active sessions:", error);
    return res.status(500).json({
      success: false,
      error: { code: "ACTIVE_SESSIONS_FETCH_FAILED", message: "Failed to fetch active sessions" }
    });
  }
}

export async function getSessionById(req: Request, res: Response) {
  const { id } = req.params;

  try {
    const result = await query(
      `SELECT
        s.session_id,
        s.user_id,
        u.name AS user_name,
        s.vehicle_id,
        v.registration_number,
        s.entry_time,
        s.exit_time,
        s.amount,
        ps.slot_id,
        ps.slot_number
       FROM parking_sessions s
       JOIN users u ON s.user_id = u.user_id
       JOIN vehicles v ON s.vehicle_id = v.vehicle_id
       LEFT JOIN parking_allocations a ON s.session_id = a.allocation_id
       LEFT JOIN parking_slots ps ON a.slot_id = ps.slot_id
       WHERE s.session_id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "SESSION_NOT_FOUND", message: "Parking session not found" }
      });
    }

    const row = result.rows[0];
    const entry = new Date(row.entry_time);
    const exit = row.exit_time ? new Date(row.exit_time) : null;

    return res.json({
      success: true,
      data: {
        id: row.session_id.toString(),
        vehicleId: row.vehicle_id.toString(),
        vehicle: row.registration_number,
        userId: row.user_id.toString(),
        user: row.user_name,
        slotId: row.slot_id ? row.slot_id.toString() : "",
        slot: row.slot_number || "",
        entryTime: row.entry_time,
        exitTime: row.exit_time,
        duration: exit ? formatDuration(entry, exit) : formatDuration(entry, new Date()),
        amount: Number(row.amount),
        status: exit ? "Completed" : "Active"
      }
    });
  } catch (error) {
    console.error("Failed to fetch session:", error);
    return res.status(500).json({
      success: false,
      error: { code: "SESSION_FETCH_FAILED", message: "Failed to fetch session" }
    });
  }
}

export async function startSession(req: Request, res: Response) {
  const { vehicleId, slotId, userId, vehicle_id, slot_id, user_id } = req.body;
  const vId = vehicleId || vehicle_id;
  const sId = slotId || slot_id;
  const uId = userId || user_id || req.auth?.userId || "1";

  if (!vId || !sId) {
    return res.status(400).json({
      success: false,
      error: { code: "MISSING_PARAMS", message: "vehicleId and slotId are required" }
    });
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // Check slot
    const slotRes = await client.query(
      "SELECT slot_id, slot_number FROM parking_slots WHERE slot_id::text = $1 OR slot_number = $1 FOR UPDATE",
      [sId.toString()]
    );
    if (slotRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ success: false, error: { code: "SLOT_NOT_FOUND", message: "Slot not found" } });
    }
    const slot = slotRes.rows[0];

    // Check vehicle
    const vehicleRes = await client.query(
      "SELECT vehicle_id, registration_number FROM vehicles WHERE vehicle_id::text = $1 OR registration_number = $1",
      [vId.toString()]
    );
    if (vehicleRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({ success: false, error: { code: "VEHICLE_NOT_FOUND", message: "Vehicle not found" } });
    }
    const vehicle = vehicleRes.rows[0];

    // Create allocation
    const allocRes = await client.query(
      `INSERT INTO parking_allocations (user_id, vehicle_id, slot_id, allocated_at, status)
       VALUES ($1, $2, $3, NOW(), 'ACTIVE')
       RETURNING allocation_id, allocated_at`,
      [uId, vehicle.vehicle_id, slot.slot_id]
    );
    const allocation = allocRes.rows[0];

    // Update slot & user
    await client.query("UPDATE parking_slots SET status = 'ENGAGED' WHERE slot_id = $1", [slot.slot_id]);
    await client.query("UPDATE users SET parking_status = 'PARKED' WHERE user_id = $1", [uId]);

    await client.query("COMMIT");

    return res.status(201).json({
      success: true,
      data: {
        sessionId: allocation.allocation_id.toString(),
        allocationId: allocation.allocation_id.toString(),
        vehicleId: vehicle.vehicle_id.toString(),
        slotId: slot.slot_id.toString(),
        userId: uId.toString(),
        entryTime: allocation.allocated_at,
        status: "Active"
      }
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Start session error:", error);
    return res.status(500).json({
      success: false,
      error: { code: "START_SESSION_FAILED", message: "Failed to start parking session" }
    });
  } finally {
    client.release();
  }
}

export async function endSession(req: Request, res: Response) {
  const { id } = req.params;

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // Look for active allocation or existing session
    const allocRes = await client.query(
      `SELECT a.allocation_id, a.user_id, a.vehicle_id, a.slot_id, a.allocated_at,
              l.base_fee, s.slot_number
       FROM parking_allocations a
       JOIN parking_slots s ON a.slot_id = s.slot_id
       JOIN parking_lots l ON s.lot_id = l.lot_id
       WHERE a.allocation_id = $1
       FOR UPDATE`,
      [id]
    );

    if (allocRes.rows.length === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        success: false,
        error: { code: "SESSION_NOT_FOUND", message: "Active allocation or session not found" }
      });
    }

    const alloc = allocRes.rows[0];
    const exitTime = new Date();
    const entryTime = new Date(alloc.allocated_at);
    const durationHours = Math.max(1, (exitTime.getTime() - entryTime.getTime()) / (1000 * 60 * 60));
    const baseFee = Number(alloc.base_fee) || 30.00;
    const amount = Number((durationHours * baseFee).toFixed(2));

    // Release allocation
    await client.query(
      "UPDATE parking_allocations SET status = 'RELEASED', released_at = $1 WHERE allocation_id = $2",
      [exitTime, alloc.allocation_id]
    );

    // Free slot
    await client.query(
      "UPDATE parking_slots SET status = 'VACANT' WHERE slot_id = $1",
      [alloc.slot_id]
    );

    // Update user status
    await client.query(
      "UPDATE users SET parking_status = 'NOT_PARKED' WHERE user_id = $1",
      [alloc.user_id]
    );

    // Insert or update session
    const sessionRes = await client.query(
      `INSERT INTO parking_sessions (session_id, user_id, vehicle_id, entry_time, exit_time, amount)
       VALUES ($1, $2, $3, $4, $5, $6)
       ON CONFLICT (session_id)
       DO UPDATE SET exit_time = EXCLUDED.exit_time, amount = EXCLUDED.amount
       RETURNING session_id, user_id, vehicle_id, entry_time, exit_time, amount`,
      [alloc.allocation_id, alloc.user_id, alloc.vehicle_id, entryTime, exitTime, amount]
    );

    await client.query("COMMIT");

    const session = sessionRes.rows[0];
    return res.json({
      success: true,
      data: {
        sessionId: session.session_id.toString(),
        userId: session.user_id.toString(),
        vehicleId: session.vehicle_id.toString(),
        entryTime: session.entry_time,
        exitTime: session.exit_time,
        amount: Number(session.amount),
        duration: formatDuration(entryTime, exitTime),
        status: "Completed"
      }
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("End session error:", error);
    return res.status(500).json({
      success: false,
      error: { code: "END_SESSION_FAILED", message: "Failed to end parking session" }
    });
  } finally {
    client.release();
  }
}
