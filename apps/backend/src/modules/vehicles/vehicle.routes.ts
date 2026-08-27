import { Router } from "express";
import { requireAdmin, requireAuth } from "../../middleware/auth.middleware";
import {
  createVehicle,
  deleteVehicle,
  getVehicleById,
  getVehicles,
  updateVehicle,
} from "./vehicle.controller";

const router = Router();

router.get("/", requireAuth, getVehicles);
router.get("/:id", requireAuth, getVehicleById);
router.post("/", requireAuth, createVehicle);
router.put("/:id", requireAuth, updateVehicle);
router.delete("/:id", requireAuth, requireAdmin, deleteVehicle);

export default router;
