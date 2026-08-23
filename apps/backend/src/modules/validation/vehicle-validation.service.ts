import {
  AlertSeverity,
  AlertType,
  ReservationStatus,
  SlotStatus,
  VehicleType
} from "@prisma/client";
import { prisma } from "../../config/prisma";

type ValidateVehicleInput = {
  reservationId: string;
  detectedVehicleType: VehicleType;
  detectedVehicleId?: string;
};

const safeUser = {
  select: {
    id: true,
    name: true,
    email: true,
    role: true,
    createdAt: true,
    updatedAt: true
  }
};

export async function validateVehicleAtReservedSlot(
  input: ValidateVehicleInput
) {
  return prisma.$transaction(async (tx) => {
    const reservation = await tx.reservation.findUnique({
      where: {
        id: input.reservationId
      },
      include: {
        user: safeUser,
        vehicle: true,
        slot: true
      }
    });

    if (!reservation || reservation.status !== ReservationStatus.ACTIVE) {
      throw new Error("Active reservation not found");
    }

    if (reservation.slot.vehicleType === input.detectedVehicleType) {
      return {
        action: "ACCEPTED" as const,
        reservation,
        replacementSlot: null,
        alert: null
      };
    }

    const replacementSlot = await tx.parkingSlot.findFirst({
      where: {
        facilityId: reservation.slot.facilityId,
        vehicleType: input.detectedVehicleType,
        status: SlotStatus.AVAILABLE,
        id: {
          not: reservation.slotId
        }
      },
      orderBy: {
        code: "asc"
      }
    });

    if (!replacementSlot) {
      const alert = await tx.parkingAlert.create({
        data: {
          type: AlertType.NO_COMPATIBLE_SLOT,
          severity: AlertSeverity.HIGH,
          message:
            "Wrong vehicle detected and no compatible replacement slot is available.",
          expectedVehicleType: reservation.slot.vehicleType,
          detectedVehicleType: input.detectedVehicleType,
          userId: reservation.userId,
          vehicleId: input.detectedVehicleId ?? reservation.vehicleId,
          slotId: reservation.slotId,
          reservationId: reservation.id
        }
      });

      return {
        action: "ALERT_CREATED" as const,
        reservation,
        replacementSlot: null,
        alert
      };
    }

    await tx.parkingSlot.update({
      where: {
        id: reservation.slotId
      },
      data: {
        status: SlotStatus.AVAILABLE
      }
    });

    const updatedReplacementSlot = await tx.parkingSlot.update({
      where: {
        id: replacementSlot.id
      },
      data: {
        status: SlotStatus.RESERVED
      }
    });

    const updatedReservation = await tx.reservation.update({
      where: {
        id: reservation.id
      },
      data: {
        slotId: replacementSlot.id
      },
      include: {
        user: safeUser,
        vehicle: true,
        slot: true
      }
    });

    return {
      action: "REASSIGNED" as const,
      reservation: updatedReservation,
      replacementSlot: updatedReplacementSlot,
      alert: null
    };
  });
}