import { Request, Response } from "express";
import { VehicleType } from "@prisma/client";
import { validateVehicleAtReservedSlot } from "./vehicle-validation.service";

type ValidateVehicleBody = {
  reservationId: string;
  detectedVehicleType: VehicleType;
  detectedVehicleId?: string;
};

export async function validateVehicle(
  req: Request<{}, {}, ValidateVehicleBody>,
  res: Response
) {
  try {
    console.log("Validation content type:", req.headers["content-type"]);
    console.log("Validation body:", req.body);
    const {
      reservationId,
      detectedVehicleType,
      detectedVehicleId
    } = req.body ?? {};

    if (!reservationId || !detectedVehicleType) {
      res.status(400).json({
        message: "reservationId and detectedVehicleType are required"
      });
      return;
    }

    if (!Object.values(VehicleType).includes(detectedVehicleType)) {
      res.status(400).json({
        message: "detectedVehicleType must be CAR or BIKE"
      });
      return;
    }

    const result = await validateVehicleAtReservedSlot({
      reservationId,
      detectedVehicleType,
      detectedVehicleId
    });

    res.json(result);
  } catch (error) {
    if (
      error instanceof Error &&
      error.message === "Active reservation not found"
    ) {
      res.status(404).json({
        message: error.message
      });
      return;
    }

    console.error("Failed to validate vehicle:", error);
    res.status(500).json({
      message: "Failed to validate vehicle"
    });
  }
}