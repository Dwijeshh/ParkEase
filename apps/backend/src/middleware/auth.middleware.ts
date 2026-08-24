import { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
import { UserRole } from "@prisma/client";

type AuthTokenPayload = JwtPayload & {
  userId: string;
  role: UserRole;
};

declare global {
  namespace Express {
    interface Request {
      auth?: AuthTokenPayload;
    }
  }
}

export function requireAuth(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const header = req.header("Authorization");

  if (!header?.startsWith("Bearer ")) {
    return res.status(401).json({
      success: false,
      error: {
        code: "AUTH_REQUIRED",
        message: "Authentication required"
      }
    });
  }

  const token = header.slice("Bearer ".length).trim();
  const secret = process.env.JWT_SECRET;

  if (!secret) {
    console.error("JWT_SECRET is not configured");

    return res.status(500).json({
      success: false,
      error: {
        code: "AUTH_CONFIG_ERROR",
        message: "Authentication is not configured"
      }
    });
  }

  try {
    const payload = jwt.verify(token, secret);

    if (
      typeof payload !== "object" ||
      typeof payload.userId !== "string" ||
      typeof payload.role !== "string"
    ) {
      return res.status(401).json({
        success: false,
        error: {
          code: "INVALID_TOKEN",
          message: "Invalid authentication token"
        }
      });
    }

    req.auth = payload as AuthTokenPayload;
    return next();
  } catch {
    return res.status(401).json({
      success: false,
      error: {
        code: "INVALID_TOKEN",
        message: "Invalid or expired authentication token"
      }
    });
  }
}

export function requireAdmin(
  req: Request,
  res: Response,
  next: NextFunction
) {
  if (req.auth?.role !== UserRole.ADMIN) {
    return res.status(403).json({
      success: false,
      error: {
        code: "ADMIN_REQUIRED",
        message: "Administrator access required"
      }
    });
  }

  return next();
}
