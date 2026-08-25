import { Router } from "express";
import { requireAdmin, requireAuth } from "../../middleware/auth.middleware";
import { getUsers } from "./user.controller";

const router = Router();

router.get("/", requireAuth, requireAdmin, getUsers);

export default router;
