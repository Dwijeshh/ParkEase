import { Router } from "express";
import {
  acknowledgeAlert,
  createAlert,
  getAlerts,
  resolveAlert
} from "./alert.controller";

const router = Router();

router.get("/", getAlerts);
router.post("/", createAlert);
router.patch("/:id/acknowledge", acknowledgeAlert);
router.patch("/:id/resolve", resolveAlert);

export default router;