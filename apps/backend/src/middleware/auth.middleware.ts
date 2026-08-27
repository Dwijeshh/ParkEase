import { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";

export type UserRole = "ADMIN" | "USER" | "CUSTOMER" | "SECURITY";

export type AuthTokenPayload = JwtPayload & {
  userId: string;
  role: string;
  name?: string;
  email?: string;
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
  const secret = process.env.JWT_SECRET || "default_jwt_secret";

  try {
    const payload = jwt.verify(token, secret);

    if (
      typeof payload !== "object" ||
      !payload ||
      (!("userId" in payload) && !("id" in payload))
    ) {
      return res.status(401).json({
        success: false,
        error: {
          code: "INVALID_TOKEN",
          message: "Invalid authentication token"
        }
      });
    }

    const normalizedPayload: AuthTokenPayload = {
      ...(payload as object),
      userId: String((payload as any).userId || (payload as any).id),
      role: String((payload as any).role || "USER"),
    };

    req.auth = normalizedPayload;
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
  const role = req.auth?.role?.toUpperCase();
  if (role !== "ADMIN") {
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
