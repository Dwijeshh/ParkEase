import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { query } from "../../config/database";

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1)
});

const registerSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  phone: z.string().optional(),
  password: z.string().min(3)
});

function createToken(userId: string, role: string, name?: string, email?: string) {
  const secret = process.env.JWT_SECRET || "default_jwt_secret";

  return jwt.sign(
    {
      userId,
      role,
      name,
      email
    },
    secret,
    {
      expiresIn: "8h"
    }
  );
}

async function verifyPassword(inputPassword: string, storedHash: string): Promise<boolean> {
  if (inputPassword === storedHash) {
    return true;
  }
  try {
    return await bcrypt.compare(inputPassword, storedHash);
  } catch {
    return false;
  }
}

export async function login(req: Request, res: Response) {
  const parsed = loginSchema.safeParse(req.body);

  if (!parsed.success) {
    return res.status(400).json({
      success: false,
      error: {
        code: "INVALID_LOGIN_INPUT",
        message: "A valid email and password are required"
      }
    });
  }

  const emailLower = parsed.data.email.toLowerCase().trim();
  const inputPassword = parsed.data.password;

  try {
    // 1. Check admins table first
    const adminResult = await query(
      "SELECT admin_id, name, email, password_hash FROM admins WHERE LOWER(email) = $1 LIMIT 1",
      [emailLower]
    );

    if (adminResult.rows.length > 0) {
      const admin = adminResult.rows[0];
      const match = await verifyPassword(inputPassword, admin.password_hash);
      if (match) {
        const token = createToken(admin.admin_id.toString(), "ADMIN", admin.name, admin.email);
        const userInfo = {
          id: admin.admin_id.toString(),
          name: admin.name,
          email: admin.email,
          role: "ADMIN"
        };

        return res.json({
          success: true,
          token,
          user: userInfo,
          data: {
            token,
            user: userInfo
          }
        });
      }
    }

    // 2. Check users table
    const userResult = await query(
      "SELECT user_id, name, email, phone, password_hash, parking_status FROM users WHERE LOWER(email) = $1 LIMIT 1",
      [emailLower]
    );

    if (userResult.rows.length > 0) {
      const user = userResult.rows[0];
      const match = await verifyPassword(inputPassword, user.password_hash);
      if (match) {
        const token = createToken(user.user_id.toString(), "USER", user.name, user.email);
        const userInfo = {
          id: user.user_id.toString(),
          name: user.name,
          email: user.email,
          phone: user.phone,
          parking_status: user.parking_status,
          role: "USER"
        };

        return res.json({
          success: true,
          token,
          user: userInfo,
          data: {
            token,
            user: userInfo
          }
        });
      }
    }

    const accountExists = adminResult.rows.length > 0 || userResult.rows.length > 0;
    if (accountExists) {
      return res.status(401).json({
        success: false,
        error: {
          code: "INCORRECT_PASSWORD",
          message: "Incorrect password. Please try again."
        }
      });
    }

    return res.status(404).json({
      success: false,
      error: {
        code: "USER_NOT_FOUND",
        message: "No account found with this email. Please register."
      }
    });
  } catch (error) {
    console.error("Login failed:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "LOGIN_FAILED",
        message: "Login failed due to a server error"
      }
    });
  }
}

export async function register(req: Request, res: Response) {
  const parsed = registerSchema.safeParse(req.body);

  if (!parsed.success) {
    return res.status(400).json({
      success: false,
      error: {
        code: "INVALID_REGISTER_INPUT",
        message: "Invalid registration parameters",
        details: parsed.error.issues
      }
    });
  }

  const { name, email, phone, password } = parsed.data;
  const licensePlate = (req.body.licensePlate || req.body.license_plate || "").toString().trim().toUpperCase();
  const vehicleType = (req.body.vehicleType || req.body.vehicle_type || "Car").toString();
  const emailLower = email.toLowerCase().trim();

  try {
    const existing = await query(
      "SELECT user_id FROM users WHERE LOWER(email) = $1",
      [emailLower]
    );

    if (existing.rows.length > 0) {
      return res.status(409).json({
        success: false,
        error: {
          code: "EMAIL_ALREADY_EXISTS",
          message: "A user with this email already exists"
        }
      });
    }

    const saltRounds = 10;
    const passwordHash = await bcrypt.hash(password, saltRounds);

    const result = await query(
      `INSERT INTO users (name, email, phone, password_hash, parking_status)
       VALUES ($1, $2, $3, $4, 'NOT_PARKED')
       RETURNING user_id, name, email, phone, created_at, parking_status`,
      [name, emailLower, phone || null, passwordHash]
    );

    const newUser = result.rows[0];

    // Auto-create a default Car vehicle for the new user
    const regNumber = licensePlate || (`MH12CAR${newUser.user_id}`);
    let vehicleInfo: Record<string, string | null> = { registration_number: regNumber, vehicle_type: vehicleType };
    try {
      const vehicleResult = await query(
        `INSERT INTO vehicles (registration_number, vehicle_type)
         VALUES ($1, $2)
         RETURNING vehicle_id, registration_number, vehicle_type`,
        [regNumber, vehicleType]
      );
      if (vehicleResult.rows.length > 0) {
        vehicleInfo = vehicleResult.rows[0];
      }
    } catch (vehicleErr) {
      console.warn("Vehicle creation during register failed:", vehicleErr);
    }

    const token = createToken(newUser.user_id.toString(), "USER", newUser.name, newUser.email);

    const userInfo = {
      id: newUser.user_id.toString(),
      name: newUser.name,
      email: newUser.email,
      phone: newUser.phone,
      parking_status: newUser.parking_status,
      role: "USER",
      vehicle: vehicleInfo
    };

    return res.status(201).json({
      success: true,
      token,
      user: userInfo,
      data: {
        token,
        user: userInfo
      }
    });
  } catch (error) {
    console.error("Registration failed:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "REGISTRATION_FAILED",
        message: "Failed to register user"
      }
    });
  }
}

export async function getCurrentUser(req: Request, res: Response) {
  const auth = req.auth;
  if (!auth) {
    return res.status(401).json({ success: false, error: { code: "UNAUTHORIZED", message: "Not authenticated" } });
  }

  try {
    if (auth.role === "ADMIN") {
      const result = await query("SELECT admin_id, name, email, created_at FROM admins WHERE admin_id = $1", [auth.userId]);
      if (result.rows.length === 0) {
        return res.status(404).json({ success: false, error: { code: "NOT_FOUND", message: "Admin not found" } });
      }
      return res.json({
        success: true,
        data: {
          id: result.rows[0].admin_id.toString(),
          name: result.rows[0].name,
          email: result.rows[0].email,
          role: "ADMIN"
        }
      });
    } else {
      const result = await query(
        "SELECT user_id, name, email, phone, created_at, parking_status FROM users WHERE user_id = $1",
        [auth.userId]
      );
      if (result.rows.length === 0) {
        return res.status(404).json({ success: false, error: { code: "NOT_FOUND", message: "User not found" } });
      }
      return res.json({
        success: true,
        data: {
          id: result.rows[0].user_id.toString(),
          name: result.rows[0].name,
          email: result.rows[0].email,
          phone: result.rows[0].phone,
          parking_status: result.rows[0].parking_status,
          role: "USER"
        }
      });
    }
  } catch (error) {
    console.error("Get current user error:", error);
    return res.status(500).json({ success: false, error: { code: "FETCH_ME_FAILED", message: "Failed to fetch user profile" } });
  }
}
