import {
  PrismaClient,
  UserRole,
  VehicleType,
  SlotStatus,
  ReservationStatus
} from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.create({
    data: {
      name: "No Slot Test Customer",
      email: `noslot-${Date.now()}@parkease.local`,
      password: "test-password",
      role: UserRole.CUSTOMER
    }
  });

  const vehicle = await prisma.vehicle.create({
    data: {
      registrationNumber: `NOSLOT-${Date.now()}`,
      type: VehicleType.CAR,
      userId: user.id
    }
  });

  const facility = await prisma.facility.create({
    data: {
      name: "No Compatible Slot Facility",
      address: "Test Address"
    }
  });

  const carSlot = await prisma.parkingSlot.create({
    data: {
      code: `CAR-${Date.now()}`,
      vehicleType: VehicleType.CAR,
      status: SlotStatus.RESERVED,
      facilityId: facility.id
    }
  });

  const reservation = await prisma.reservation.create({
    data: {
      userId: user.id,
      vehicleId: vehicle.id,
      slotId: carSlot.id,
      status: ReservationStatus.ACTIVE
    }
  });

  console.log("\nNo-compatible-slot test data created:");
  console.log(`reservationId: ${reservation.id}`);
  console.log(`facilityId: ${facility.id} (has no BIKE slots)`);

  console.log("\nTest command:");
  console.log(
    `curl -i -X POST http://localhost:3000/api/v1/validation/vehicle -H "Content-Type: application/json" -d '{"reservationId":"${reservation.id}","detectedVehicleType":"BIKE"}'`
  );
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });