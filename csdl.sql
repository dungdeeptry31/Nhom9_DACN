-- =======================================================
-- HỆ THỐNG QUẢN LÝ TRUNG TÂM HỌC THÊM EDUCENTER
-- FILE: csdl.sql (CẤU TRÚC CƠ SỞ DỮ LIỆU)
-- Tương thích: MySQL 8.0+
-- =======================================================

CREATE DATABASE IF NOT EXISTS `educenter_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `educenter_db`;

-- Xóa các bảng cũ theo thứ tự khóa ngoại (nếu đã tồn tại)
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `tuition`;
DROP TABLE IF EXISTS `grades`;
DROP TABLE IF EXISTS `attendance`;
DROP TABLE IF EXISTS `schedules`;
DROP TABLE IF EXISTS `registrations`;
DROP TABLE IF EXISTS `class_students`;
DROP TABLE IF EXISTS `classes`;
DROP TABLE IF EXISTS `rooms`;
DROP TABLE IF EXISTS `subjects`;
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `teachers`;
DROP TABLE IF EXISTS `parents`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;

-- =======================================================
-- 1. BẢNG roles (Vai trò người dùng)
-- =======================================================
CREATE TABLE `roles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 2. BẢNG users (Tài khoản người dùng)
-- =======================================================
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `full_name` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) NULL,
    `address` VARCHAR(255) NULL,
    `role_id` INT NOT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 3. BẢNG parents (Hồ sơ phụ huynh)
-- =======================================================
CREATE TABLE `parents` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `occupation` VARCHAR(100) NULL,
    `note` VARCHAR(500) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_parents_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 4. BẢNG teachers (Hồ sơ giáo viên)
-- =======================================================
CREATE TABLE `teachers` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `specialization` VARCHAR(100) NULL,
    `degree` VARCHAR(100) NULL,
    `experience` VARCHAR(255) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_teachers_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 5. BẢNG students (Hồ sơ học sinh)
-- =======================================================
CREATE TABLE `students` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100) NOT NULL,
    `date_of_birth` DATE NULL,
    `gender` VARCHAR(10) NULL,
    `phone` VARCHAR(20) NULL,
    `school` VARCHAR(100) NULL,
    `grade_level` VARCHAR(20) NULL,
    `parent_id` BIGINT NOT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_students_parents` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 6. BẢNG subjects (Môn học)
-- =======================================================
CREATE TABLE `subjects` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(500) NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 7. BẢNG rooms (Phòng học)
-- =======================================================
CREATE TABLE `rooms` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `capacity` INT NOT NULL,
    `location` VARCHAR(100) NULL,
    `description` VARCHAR(500) NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 8. BẢNG classes (Lớp học)
-- =======================================================
CREATE TABLE `classes` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `subject_id` BIGINT NOT NULL,
    `teacher_id` BIGINT NOT NULL,
    `max_students` INT NOT NULL,
    `tuition_fee` DECIMAL(12,2) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `start_date` DATE NULL,
    `end_date` DATE NULL,
    `description` VARCHAR(500) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_classes_subjects` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_classes_teachers` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 9. BẢNG class_students (Học sinh trong lớp - Bảng trung gian N-N)
-- =======================================================
CREATE TABLE `class_students` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `class_id` BIGINT NOT NULL,
    `student_id` BIGINT NOT NULL,
    `enrolled_date` DATE NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT `uk_class_student` UNIQUE (`class_id`, `student_id`),
    CONSTRAINT `fk_class_students_classes` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_class_students_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 10. BẢNG registrations (Đơn đăng ký học)
-- =======================================================
CREATE TABLE `registrations` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `parent_id` BIGINT NOT NULL,
    `student_id` BIGINT NOT NULL,
    `class_id` BIGINT NOT NULL,
    `registration_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    `note` VARCHAR(500) NULL,
    `admin_note` VARCHAR(500) NULL,
    `processed_by` BIGINT NULL,
    `processed_date` TIMESTAMP NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_registrations_parents` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_registrations_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_registrations_classes` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_registrations_admin` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 11. BẢNG schedules (Lịch học / Thời khóa biểu)
-- =======================================================
CREATE TABLE `schedules` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `class_id` BIGINT NOT NULL,
    `room_id` BIGINT NOT NULL,
    `day_of_week` INT NOT NULL, -- 2: Thứ 2, 3: Thứ 3, ..., 8: Chủ nhật
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_schedules_classes` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_schedules_rooms` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 12. BẢNG attendance (Điểm danh học sinh)
-- =======================================================
CREATE TABLE `attendance` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `class_id` BIGINT NOT NULL,
    `student_id` BIGINT NOT NULL,
    `attendance_date` DATE NOT NULL,
    `status` VARCHAR(20) NOT NULL, -- PRESENT / ABSENT / EXCUSED
    `note` VARCHAR(500) NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `uk_attendance` UNIQUE (`class_id`, `student_id`, `attendance_date`),
    CONSTRAINT `fk_attendance_classes` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_attendance_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_attendance_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 13. BẢNG grades (Bảng điểm kết quả học tập)
-- =======================================================
CREATE TABLE `grades` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `class_id` BIGINT NOT NULL,
    `student_id` BIGINT NOT NULL,
    `test_score` DECIMAL(4,2) NULL,
    `midterm_score` DECIMAL(4,2) NULL,
    `final_score` DECIMAL(4,2) NULL,
    `average_score` DECIMAL(4,2) NULL,
    `note` VARCHAR(500) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `uk_grade_class_student` UNIQUE (`class_id`, `student_id`),
    CONSTRAINT `fk_grades_classes` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_grades_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    CONSTRAINT `chk_test_score` CHECK (`test_score` IS NULL OR (`test_score` >= 0 AND `test_score` <= 10)),
    CONSTRAINT `chk_midterm_score` CHECK (`midterm_score` IS NULL OR (`midterm_score` >= 0 AND `midterm_score` <= 10)),
    CONSTRAINT `chk_final_score` CHECK (`final_score` IS NULL OR (`final_score` >= 0 AND `final_score` <= 10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 14. BẢNG tuition (Khoản học phí cần nộp)
-- =======================================================
CREATE TABLE `tuition` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `student_id` BIGINT NOT NULL,
    `class_id` BIGINT NOT NULL,
    `amount` DECIMAL(12,2) NOT NULL,
    `due_date` DATE NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'UNPAID', -- UNPAID / PAID / PROCESSING
    `description` VARCHAR(500) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_tuition_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_tuition_classes` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================
-- 15. BẢNG payments (Giao dịch thanh toán học phí)
-- =======================================================
CREATE TABLE `payments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `tuition_id` BIGINT NOT NULL,
    `amount` DECIMAL(12,2) NOT NULL,
    `payment_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `payment_method` VARCHAR(50) NOT NULL DEFAULT 'VNPAY', -- VNPAY / CASH / TRANSFER
    `transaction_code` VARCHAR(100) NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING', -- PENDING / SUCCESS / FAILED
    `vnpay_response_code` VARCHAR(10) NULL,
    `note` VARCHAR(500) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_payments_tuition` FOREIGN KEY (`tuition_id`) REFERENCES `tuition` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
