import { Request, Response } from "express";
import bcrypt from "bcrypt";
import { query } from "../../config/database";

export async function getUsers(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        u.user_id,
        u.name,
        u.email,
        u.phone,
        u.parking_status,
        u.created_at,
        v.vehicle_id,
        v.registration_number,
        v.vehicle_type,
        s.slot_number
      FROM users u
      LEFT JOIN parking_allocations a ON u.user_id = a.user_id AND a.status = 'ACTIVE'
      LEFT JOIN vehicles v ON a.vehicle_id = v.vehicle_id
      LEFT JOIN parking_slots s ON a.slot_id = s.slot_id
      ORDER BY u.user_id ASC
    `);

    const users = result.rows.map((row) => ({
      id: row.user_id.toString(),
      user_id: row.user_id.toString(),
      name: row.name,
      email: row.email,
      phone: row.phone || "",
      parking_status: row.parking_status,
      status: row.parking_status === "PARKED" ? "Parked" : "Active",
      created_at: row.created_at,
      vehicle: row.registration_number ? {
        id: row.vehicle_id?.toString(),
        registration_number: row.registration_number,
        vehicle_type: row.vehicle_type,
      } : null,
      slot: row.slot_number || null,
    }));

    return res.json({
      success: true,
      data: users,
    });
  } catch (error) {
    console.error("Failed to fetch users:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "USERS_FETCH_FAILED",
        message: "Failed to fetch users",
      },
    });
  }
}

export async function getUserById(req: Request, res: Response) {
  const { id } = req.params;

  try {
    const userResult = await query(
      `SELECT user_id, name, email, phone, parking_status, created_at
       FROM users WHERE user_id = $1`,
      [id]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "USER_NOT_FOUND", message: "User not found" }
      });
    }

    const user = userResult.rows[0];

    // Fetch allocations & sessions
    const allocResult = await query(
      `SELECT
        a.allocation_id,
        a.allocated_at,
        a.released_at,
        a.status,
        s.slot_number,
        s.slot_type,
        v.registration_number,
        v.vehicle_type
       FROM parking_allocations a
       JOIN parking_slots s ON a.slot_id = s.slot_id
       JOIN vehicles v ON a.vehicle_id = v.vehicle_id
       WHERE a.user_id = $1
       ORDER BY a.allocated_at DESC`,
      [id]
    );

    return res.json({
      success: true,
      data: {
        id: user.user_id.toString(),
        name: user.name,
        email: user.email,
        phone: user.phone || "",
        parking_status: user.parking_status,
        created_at: user.created_at,
        allocations: allocResult.rows.map(a => ({
          id: a.allocation_id.toString(),
          slot_number: a.slot_number,
          slot_type: a.slot_type,
          registration_number: a.registration_number,
          vehicle_type: a.vehicle_type,
          allocated_at: a.allocated_at,
          released_at: a.released_at,
          status: a.status
        }))
      }
    });
  } catch (error) {
    console.error("Failed to fetch user by id:", error);
    return res.status(500).json({
      success: false,
      error: { code: "USER_FETCH_FAILED", message: "Failed to fetch user" }
    });
  }
}

export async function createUser(req: Request, res: Response) {
  const { name, email, phone, password } = req.body;

  if (!name || !email) {
    return res.status(400).json({
      success: false,
      error: { code: "MISSING_FIELDS", message: "Name and email are required" }
    });
  }

  try {
    const passwordHash = await bcrypt.hash(password || "123", 10);
    const result = await query(
      `INSERT INTO users (name, email, phone, password_hash, parking_status)
       VALUES ($1, $2, $3, $4, 'NOT_PARKED')
       RETURNING user_id, name, email, phone, created_at, parking_status`,
      [name, email.toLowerCase().trim(), phone || null, passwordHash]
    );

    const user = result.rows[0];
    return res.status(201).json({
      success: true,
      data: {
        id: user.user_id.toString(),
        name: user.name,
        email: user.email,
        phone: user.phone,
        parking_status: user.parking_status,
        created_at: user.created_at,
      }
    });
  } catch (error: any) {
    if (error.code === "23505") {
      return res.status(409).json({
        success: false,
        error: { code: "DUPLICATE_EMAIL", message: "Email already in use" }
      });
    }
    console.error("Failed to create user:", error);
    return res.status(500).json({
      success: false,
      error: { code: "USER_CREATE_FAILED", message: "Failed to create user" }
    });
  }
}

export async function updateUser(req: Request, res: Response) {
  const { id } = req.params;
  const { name, email, phone, parking_status } = req.body;

  try {
    const result = await query(
      `UPDATE users
       SET name = COALESCE($1, name),
           email = COALESCE($2, email),
           phone = COALESCE($3, phone),
           parking_status = COALESCE($4, parking_status)
       WHERE user_id = $5
       RETURNING user_id, name, email, phone, created_at, parking_status`,
      [name, email ? email.toLowerCase().trim() : null, phone, parking_status, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "USER_NOT_FOUND", message: "User not found" }
      });
    }

    const user = result.rows[0];
    return res.json({
      success: true,
      data: {
        id: user.user_id.toString(),
        name: user.name,
        email: user.email,
        phone: user.phone,
        parking_status: user.parking_status,
        created_at: user.created_at,
      }
    });
  } catch (error) {
    console.error("Failed to update user:", error);
    return res.status(500).json({
      success: false,
      error: { code: "USER_UPDATE_FAILED", message: "Failed to update user" }
    });
  }
}

export async function deleteUser(req: Request, res: Response) {
  const { id } = req.params;

  try {
    const result = await query("DELETE FROM users WHERE user_id = $1 RETURNING user_id", [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { code: "USER_NOT_FOUND", message: "User not found" }
      });
    }

    return res.json({
      success: true,
      message: "User deleted successfully"
    });
  } catch (error) {
    console.error("Failed to delete user:", error);
    return res.status(500).json({
      success: false,
      error: { code: "USER_DELETE_FAILED", message: "Failed to delete user" }
    });
  }
}
