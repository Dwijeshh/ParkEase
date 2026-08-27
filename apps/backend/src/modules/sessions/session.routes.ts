import { Router } from "express";
import { requireAuth } from "../../middleware/auth.middleware";
import {
  endSession,
  getActiveSessions,
  getSessionById,
  getSessions,
  startSession,
} from "./session.controller";

const router = Router();

router.get("/", requireAuth, getSessions);
router.get("/active", requireAuth, getActiveSessions);
router.get("/:id", requireAuth, getSessionById);
router.post("/", requireAuth, startSession);
router.put("/:id/end", requireAuth, endSession);

export default router;
