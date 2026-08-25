import { Request, Response } from "express";
import { prisma } from "../../config/prisma";

export async function getParkingSlots(_req: Request, res: Response) {
  try {
    const slots = await prisma.parkingSlot.findMany({
      orderBy: [{ facilityId: "asc" }, { code: "asc" }]
    });

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

export async function getAvailableSlots(_req: Request, res: Response) {
  try {
    const slots = await prisma.parkingSlot.findMany({
      where: { status: "AVAILABLE" },
      orderBy: [{ facilityId: "asc" }, { code: "asc" }]
    });

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
