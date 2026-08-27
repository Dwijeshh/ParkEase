import { Router } from "express";
import { requireAuth } from "../../middleware/auth.middleware";
import {
  createAllocation,
  getActiveAllocations,
  getAllocations,
  releaseAllocation,
} from "./allocation.controller";

const router = Router();

router.get("/", requireAuth, getAllocations);
router.get("/active", requireAuth, getActiveAllocations);
router.post("/", requireAuth, createAllocation);
router.put("/:id/release", requireAuth, releaseAllocation);

export default router;
