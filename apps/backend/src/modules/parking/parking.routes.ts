import { Router } from "express";
import { requireAuth } from "../../middleware/auth.middleware";
import {
  assignSlot,
  getAvailableSlots,
  getParkingLots,
  getParkingSlots,
  getSlotById,
  releaseSlot,
  updateSlotStatus,
} from "./parking.controller";

const router = Router();

router.get("/lots", requireAuth, getParkingLots);
router.get("/slots", requireAuth, getParkingSlots);
router.get("/available", requireAuth, getAvailableSlots);
router.get("/slots/:id", requireAuth, getSlotById);
router.put("/slots/:id", requireAuth, updateSlotStatus);
router.post("/assign", requireAuth, assignSlot);
router.post("/release", requireAuth, releaseSlot);
router.delete("/slots/:id", requireAuth, releaseSlot);

export default router;
