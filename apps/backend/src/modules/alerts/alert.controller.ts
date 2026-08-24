import { Request, Response } from "express";
import {
  AlertSeverity,
  AlertStatus,
  AlertType,
  Prisma,
  VehicleType
} from "@prisma/client";
import { prisma } from "../../config/prisma";

type AlertParams = {
  id: string;
};

type CreateAlertBody = {
  type: AlertType;
  severity: AlertSeverity;
  message: string;
  expectedVehicleType?: VehicleType;
  detectedVehicleType?: VehicleType;
  userId?: string;
  vehicleId?: string;
  slotId?: string;
  reservationId?: string;
  evidenceImageUrl?: string;
};

type ResolveAlertBody = {
  resolutionNote?: string;
};

export async function getAlerts(_req: Request, res: Response) {
  try {
    const alerts = await prisma.parkingAlert.findMany({
      orderBy: {
        createdAt: "desc"
      }
    });

    return res.json({
      success: true,
      data: alerts
    });
  } catch (error) {
    console.error("Failed to fetch alerts:", error);
    return res.status(500).json({
      success: false,
      error: {
        code: "ALERTS_FETCH_FAILED",
        message: "Failed to fetch alerts"
       }
     });
  }
}

export async function createAlert(
  req: Request<{}, {}, CreateAlertBody>,
  res: Response
) {
  try {
    const {
      type,
      severity,
      message,
      expectedVehicleType,
      detectedVehicleType,
      userId,
      vehicleId,
      slotId,
      reservationId,
      evidenceImageUrl
    } = req.body;

    if (!type || !severity || !message) {
      res.status(400).json({
        message: "type, severity, and message are required"
      });
      return;
    }

    const alert = await prisma.parkingAlert.create({
      data: {
        type,
        severity,
        message,
        expectedVehicleType,
        detectedVehicleType,
        userId,
        vehicleId,
        slotId,
        reservationId,
        evidenceImageUrl
      }
    });

    res.status(201).json(alert);
  } catch (error) {
    console.error("Failed to create alert:", error);
    res.status(500).json({
      message: "Failed to create alert"
    });
  }
}

export async function acknowledgeAlert(
  req: Request<AlertParams>,
  res: Response
) {
  try {
    const { id } = req.params;

    const alert = await prisma.parkingAlert.update({
      where: { id },
      data: {
        status: AlertStatus.ACKNOWLEDGED,
        acknowledgedAt: new Date()
      }
    });

    res.json(alert);
  } catch (error) {
    console.error("Failed to acknowledge alert:", error);
    res.status(404).json({
      message: "Alert not found"
    });
  }
}

export async function resolveAlert(
  req: Request<AlertParams, {}, ResolveAlertBody>,
  res: Response
) {
  try {
    const { id } = req.params;
    const { resolutionNote } = req.body;

    const alert = await prisma.parkingAlert.update({
      where: { id },
      data: {
        status: AlertStatus.RESOLVED,
        resolvedAt: new Date(),
        resolutionNote
      }
    });

    res.json(alert);
  } catch (error) {
    console.error("Failed to resolve alert:", error);
    res.status(404).json({
      message: "Alert not found"
    });
  }
}
