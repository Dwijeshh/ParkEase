import { Router } from "express";
import { requireAdmin, requireAuth } from "../../middleware/auth.middleware";
import {
  createUser,
  deleteUser,
  getUserById,
  getUsers,
  updateUser,
} from "./user.controller";

const router = Router();

router.get("/", requireAuth, requireAdmin, getUsers);
router.get("/:id", requireAuth, getUserById);
router.post("/", requireAuth, requireAdmin, createUser);
router.put("/:id", requireAuth, updateUser);
router.delete("/:id", requireAuth, requireAdmin, deleteUser);

export default router;
