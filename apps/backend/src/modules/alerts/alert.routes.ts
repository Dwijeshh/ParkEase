import { Router } from "express";
import {
  acknowledgeAlert,
  createAlert,
  getAlerts,
  resolveAlert
} from "./alert.controller";
import {
  requireAdmin,
  requireAuth
} from "../../middleware/auth.middleware";

const router = Router();

router.get("/", requireAuth, requireAdmin, getAlerts);
router.post("/", requireAuth, requireAdmin, createAlert);

router.patch(
  "/:id/acknowledge",
  requireAuth,
  requireAdmin,
  acknowledgeAlert
);

router.patch(
  "/:id/resolve",
  requireAuth,
  requireAdmin,
  resolveAlert
);

export default router;
