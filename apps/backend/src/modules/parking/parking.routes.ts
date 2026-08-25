import { Router } from "express";
import { requireAdmin, requireAuth } from "../../middleware/auth.middleware";
import { getAvailableSlots, getParkingSlots } from "./parking.controller";

const router = Router();

router.get("/slots", requireAuth, requireAdmin, getParkingSlots);
router.get("/available", requireAuth, requireAdmin, getAvailableSlots);

export default router;
