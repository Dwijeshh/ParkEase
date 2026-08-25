import bcrypt from "bcrypt";
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
      name: "Test Administrator",
      email: `admin-${Date.now()}@parkease.local`,
      password: await bcrypt.hash("test-password", 10),
      role: UserRole.ADMIN,
    }
  });

  const vehicle = await prisma.vehicle.create({
    data: {
      registrationNumber: `TEST-${Date.now()}`,
      type: VehicleType.CAR,
      userId: user.id
    }
  });

  const facility = await prisma.facility.create({
    data: {
      name: "Test Parking Facility",
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

  const bikeSlot = await prisma.parkingSlot.create({
    data: {
      code: `BIKE-${Date.now()}`,
      vehicleType: VehicleType.BIKE,
      status: SlotStatus.AVAILABLE,
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

console.log(`Login email: ${user.email}`);
console.log("Login password: test-password");
console.log(`Login role: ${user.role}`);
  console.log("\nTest data created successfully:");
  console.log(`userId: ${user.id}`);
  console.log(`vehicleId: ${vehicle.id}`);
  console.log(`facilityId: ${facility.id}`);
  console.log(`reservedCarSlotId: ${carSlot.id}`);
  console.log(`availableBikeSlotId: ${bikeSlot.id}`);
  console.log(`reservationId: ${reservation.id}`);

  console.log("\nMatching vehicle test:");
  console.log(
    `curl -i -X POST http://localhost:3000/api/v1/validation/vehicle -H "Content-Type: application/json" -d '{"reservationId":"${reservation.id}","detectedVehicleType":"CAR"}'`
  );

  console.log("\nWrong vehicle reassignment test:");
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
