import { Request, Response } from "express";
import { prisma } from "../../config/prisma";

export async function getUsers(_req: Request, res: Response) {
  try {
    const users = await prisma.user.findMany({
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
        createdAt: true,
        updatedAt: true
      },
      orderBy: { createdAt: "desc" }
    });

    return res.json({ success: true, data: users });
  } catch (error) {
    console.error("Failed to fetch users:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "USERS_FETCH_FAILED",
        message: "Failed to fetch users"
      }
    });
  }
}
