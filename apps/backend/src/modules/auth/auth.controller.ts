import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { prisma } from "../../config/prisma";

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1)
});

function createToken(userId: string, role: string) {
  const secret = process.env.JWT_SECRET;

  if (!secret) {
    throw new Error("JWT_SECRET is not configured");
  }

  return jwt.sign(
    {
      userId,
      role
    },
    secret,
    {
      expiresIn: "8h"
    }
  );
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

  try {
    const user = await prisma.user.findUnique({
      where: {
        email: parsed.data.email.toLowerCase()
      }
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        error: {
          code: "INVALID_CREDENTIALS",
          message: "Invalid email or password"
        }
      });
    }

    const passwordMatches = await bcrypt.compare(
      parsed.data.password,
      user.password
    );

    if (!passwordMatches) {
      return res.status(401).json({
        success: false,
        error: {
          code: "INVALID_CREDENTIALS",
          message: "Invalid email or password"
        }
      });
    }

    const token = createToken(user.id, user.role);

    return res.json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        }
      }
    });
  } catch (error) {
    console.error("Login failed:", error);

    return res.status(500).json({
      success: false,
      error: {
        code: "LOGIN_FAILED",
        message: "Login failed"
      }
    });
  }
}
